function [ES, VaR, details] = WHSMeasures(alpha, lambda, weights, ...
    portfolioValue, riskMeasureTimeIntervalInDays, returns)
% WHSMEASURES Computes the Value at Risk (VaR) and Expected Shortfall (ES)
% of a portfolio using the Weighted Historical Simulation approach.
%
% INPUTS:
%   alpha:                         The confidence level for the risk measures.
%   lambda:                        Constant used to scale the weights.
%   weights:                       A vector of portfolio weights corresponding to
%                                  each asset in the returns matrix.
%   portfolioValue:                The total current monetary value of the portfolio.
%   riskMeasureTimeIntervalInDays: The time horizon for the risk measures in days.
%                                  Used to scale the final 1-day VaR/ES.
%   returns:                       A matrix of historical daily log returns where 
%                                  columns represent assets and rows represent time steps.
%
% OUTPUTS:
%   ES:                            The Expected Shortfall at the specified confidence level
%                                  and time horizon.
%   VaR:                           The Value at Risk at the specified confidence level
%                                  and time horizon.
%   details:                       A struct containing intermediate variables for debugging
%                                  or reporting.

% Ensure weights is a column vector
w = weights(:);

% Preallocate the matrix for speed
num_days = size(returns, 1);
%num_assets = length(w);
%AssetsSimulations = zeros(num_days, num_assets);

% Simulate portfolio values exactly using matrix multiplication
Ptf_simulations = portfolioValue * (exp(returns) * w);

% Calculate Losses (Current Value - Simulated Value)
% This ensures that a drop in portfolio value yields a positive loss number
Losses = - (Ptf_simulations - portfolioValue);

% Order losses from worst (largest positive number) to best
[Losses_ordered, sort_indices] = sort(Losses, 'descend');

% Compute the Scenario Weights and sort them using those exact same indices
% This attaches the correct chronological probability to each specific loss
C = (1-lambda)/(1- lambda^num_days);
Ws = C * (lambda .^ ((num_days - 1):-1:0))';

Ws_ordered = Ws(sort_indices);

% Extract the VaR index using cumulative sum
cumulative_weights = cumsum(Ws_ordered);

% Find the first index at which the cumulative scenario weight reaches/exceeds
% the tail probability budget (1 - alpha)
idx = find(cumulative_weights >= (1 - alpha), 1, 'first');

% Per the lecture definition, i* is the largest index whose cumulative weight
% is still <= 1 - alpha (i.e. the last scenario still fully inside the tail
% budget): step back one position from the crossing point
if idx > 1
    index_VaR = idx - 1;
else
    % Edge case
    index_VaR = 1;
end

% Safety check: ensure index is at least 1
if index_VaR < 1
    index_VaR = 1;
end

% Extract 1-day VaR and ES
VaR_1day = Losses_ordered(index_VaR);

% In WHS, ES is the sum of (tail losses * tail weights) divided by the sum of tail weights
tail_losses = Losses_ordered(1:index_VaR);
tail_weights = Ws_ordered(1:index_VaR);

ES_1day = sum(tail_losses .* tail_weights) / sum(tail_weights);

% Scale to the required time horizon 
VaR = VaR_1day * sqrt(riskMeasureTimeIntervalInDays);
ES = ES_1day * sqrt(riskMeasureTimeIntervalInDays); 

% If we wanted to compute the exact ES and not an approximation (the
% theoric we have seen at lecture):
%
% w_before = cumulative_weights(index_VaR -1);
% w_at_VaR = (1 - alpha) - w_before;
%
% if index_VaR == 1
%     ES = VaR;
% else
%    numerator = sum(Ws_ordered(1:idxVaR-1) .* Losses_ordered(1:idxVaR-1)) ...
%                + w_at_VaR * Losses_ordered(index_VaR);
%    ES = numerator / (1 - alpha);
% end

% details struct
details = struct();

details.alpha = alpha;
details.lambda = lambda;
details.portfolioValue = portfolioValue;
details.horizon = riskMeasureTimeIntervalInDays;
details.weights = w;
details.VaR_1day = VaR_1day;
details.ES_1day = ES_1day;
details.VaR = VaR;
details.ES = ES;
details.normaliz_factor = C;
details.index_VaR = index_VaR;
details.tail_weights = tail_weights;

end 