function [ES, VaR, details] = BootstrapMeasures(alpha, weights, portfolioValue, ...
    riskMeasureTimeIntervalInDays, returns, num_simulations)
% BOOTSTRAPMEASURES Computes the Value at Risk (VaR) and Expected Shortfall (ES)
% of a portfolio using the Statistical Bootstrap method.
%
% INPUTS:
%   alpha:                         The confidence level for the risk measures.
%   weights:                       A vector of portfolio weights.
%   portfolioValue:                The total current monetary value of the portfolio.
%   riskMeasureTimeIntervalInDays: The time horizon for the risk measures in days.
%   returns:                       A matrix of historical daily log returns.
%   num_simulations:               The number of bootstrap iterations to run.
%
% OUTPUTS:
%   ES:                            The Expected Shortfall.
%   VaR:                           The Value at Risk.
%   details:                       Struct containing variables for reporting.

% Ensure weights is a column vector
w = weights(:);
num_days = size(returns, 1);

% Sample an integer number between 1 and num_days, num_simulation times
random_indices = randi(num_days, num_simulations, 1);

boot_returns = returns(random_indices, :);

% Value the loss distribution on the simulated set
Ptf_simulations = portfolioValue * (exp(boot_returns) * w);

% Calculate and order losses and determine the index
Losses = -(Ptf_simulations - portfolioValue);
Losses_ordered = sort(Losses, 'descend');
index_VaR = floor(num_simulations * (1 - alpha));

% Safety check
if index_VaR < 1
    index_VaR = 1;
end

% Extract and store the 1-day VaR and ES
VaR_1day = Losses_ordered(index_VaR);
ES_1day  = mean(Losses_ordered(1:index_VaR));

% Adjust with the scaling factor for the horizon
VaR = VaR_1day * sqrt(riskMeasureTimeIntervalInDays);
ES  = ES_1day  * sqrt(riskMeasureTimeIntervalInDays);

% Package the details struct
details = struct();

details.alpha = alpha;
details.portfolioValue = portfolioValue;
details.horizon = riskMeasureTimeIntervalInDays;
details.weights = w;
details.num_simulations = num_simulations;
details.VaR_1day = VaR_1day;
details.ES_1day = ES_1day;
details.VaR = VaR;
details.ES = ES;

end