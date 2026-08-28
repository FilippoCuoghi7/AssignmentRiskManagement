function VaR = PlausibilityCheckVaR(alpha, weights, portfolioValue, ...
    riskMeasureTimeIntervalInDays, returns)
% PLAUSIBILITYCHECKVAR Computes a baseline VaR using the Correlation Aggregation
% (Marginal VaR) method to validate more complex empirical models.
%
% INPUTS:
%   alpha:                         The confidence level for the risk measure.
%   weights:                       A vector of portfolio weights.
%   portfolioValue:                The total current monetary value of the portfolio.
%   riskMeasureTimeIntervalInDays: The time horizon for the VaR in days.
%   returns:                       A matrix of historical daily log returns
%                                  (days = rows, assets = columns).
%
% OUTPUTS:
%   VaR:                           The aggregated, plausibility-check Value at Risk.

% weights is a column vector
w = weights(:);

% Compute the correlation matrix of the risk factors
C = corr(returns);

% Find the lower and upper empirical percentiles for each asset
l = prctile(returns, 100 * (1 - alpha))';
u = prctile(returns, 100 * alpha)';

% Compute the daily Signed VaR
sVaR_daily = portfolioValue .* w .* (abs(l) + abs(u)) / 2;

% Scale the individual Signed VaRs to the requested time horizon
sVaR_horiz = sVaR_daily * sqrt(riskMeasureTimeIntervalInDays);

% Aggregate the total Portfolio VaR using the correlation matrix
VaR = sqrt(sVaR_horiz' * C * sVaR_horiz);

end