function [ES, VaR, details] = HSMeasures(alpha, weights, portfolioValue, ...
    riskMeasureTimeIntervalInDays, returns)
% HSMEASURES Computes the Value at Risk (VaR) and Expected Shortfall (ES)
% of a portfolio using the Historical Simulation approach.
%
% INPUTS:
%   alpha:                         The confidence level for the risk measures.
%   weights:                       A vector of portfolio weights corresponding 
%                                  to each asset in the returns matrix.
%   portfolioValue:                The total current monetary value of the portfolio.
%   riskMeasureTimeIntervalInDays: The time horizon for the risk measures in days. 
%                                  Used to scale the final 1-day VaR/ES.
%   returns:                       A matrix of historical daily log returns where
%                                  columns represent assets and rows represent time steps.
%
% OUTPUTS:
%   ES:                            The Expected Shortfall at the specified confidence 
%                                  level and time horizon.
%   VaR:                           The Value at Risk at the specified confidence level
%                                  and time horizon.
%   details:                       A struct containing intermediate variables for 
%                                  debugging or reporting.

% Ensure weights is a column vector
w = weights(:);

% Preallocate the matrix for speed
num_days = size(returns, 1);
%num_assets = length(w);
%AssetsSimulations = zeros(num_days, num_assets);

% Simulate portfolio values exactly using matrix multiplication
Ptf_simulations = portfolioValue * (exp(returns) * w);

% Calculate Losses (Current Value - Simulated Value)
Losses = - (Ptf_simulations - portfolioValue);

% Order losses from worst (largest positive number) to best
Losses_ordered = sort(Losses, 'descend');

% Determine the VaR Index
index_VaR = floor(num_days * (1 - alpha));

% Safety check: ensure index is at least 1
if index_VaR < 1
    index_VaR = 1;
end

% Extract 1-day VaR and ES
VaR_1day = Losses_ordered(index_VaR);

ES_1day = mean(Losses_ordered(1:index_VaR));

% Scale to the required time horizon
VaR = VaR_1day * sqrt(riskMeasureTimeIntervalInDays);
ES = ES_1day * sqrt(riskMeasureTimeIntervalInDays);

% Package the details struct
details = struct();
details.alpha = alpha;
details.portfolioValue = portfolioValue;
details.horizon = riskMeasureTimeIntervalInDays;
details.weights = w;
details.VaR_1day = VaR_1day;
details.ES_1day = ES_1day;
details.VaR = VaR;
details.ES = ES;

end