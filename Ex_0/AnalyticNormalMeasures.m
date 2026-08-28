function [ES, VaR, details] = AnalyticNormalMeasures(alpha, weights, ...
    portfolioValue, riskMeasureTimeIntervalInDays, returns)
% ANALYTICNORMALMEASURES Computes the Value at Risk (VaR) and Expected
% Shortfall (ES) of a portfolio assuming returns follow a normal distribution.
%
% INPUTS:
%   alpha:                         The confidence level for the risk measures.
%   weights:                       A vector of portfolio weights corresponding
%                                  to each asset in the returns matrix.
%   portfolioValue:                The total current monetary value of the portfolio.
%   riskMeasureTimeIntervalInDays: The time horizon for the risk measures in days. 
%                                  Used to scale daily returns and volatility.
%   returns:                       A matrix of historical daily returns where 
%                                  columns represent assets and rows represent time steps.
%
%
% OUTPUTS:
%   ES:                            The Expected Shortfall at the specified confidence
%                                  level and time horizon.
%   VaR:                           The Value at Risk at the specified confidence
%                                  level and time horizon.

% Ensure weights is a vector
w = weights(:);

% Calculate daily mean returns and covariance matrix.
mu_daily = mean(returns,1)';
Sigma_daily = cov(returns);

% Scale mean and covariance to the specified time interval
mu_horizon = mu_daily .* riskMeasureTimeIntervalInDays;
Sigma_horizon = Sigma_daily .* riskMeasureTimeIntervalInDays;

% Calculate portfolio expected return and standard deviation over the horizon
mu_ptf = w' * mu_horizon;
sigma_ptf = sqrt(w' * Sigma_horizon * w);

% Calculate the Z-score for the given confidence level alpha
z_alpha = norminv(alpha);

% Compute Value at Risk (VaR)
VaR = portfolioValue * (-mu_ptf + z_alpha * sigma_ptf);

% Compute Expected Shortfall (ES)
pdf_z = normpdf(z_alpha);
ES = portfolioValue * (-mu_ptf + sigma_ptf * (pdf_z / (1 - alpha)));

details = struct();

details.alpha = alpha;
details.portfolioValue = portfolioValue;
details.horizon = riskMeasureTimeIntervalInDays;
details.weights = w;
details.mu_d = mu_daily;
details.mu_horiz = mu_horizon;
details.Sigma_d = Sigma_daily;
details.Sigma_horiz = Sigma_horizon;
details.z_alpha = z_alpha;
details.VaR_alpha = VaR;
details.pdf_z = pdf_z;
details.ES_alpha = ES;

end


