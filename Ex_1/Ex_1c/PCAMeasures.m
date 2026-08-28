function [ES, VaR, details] = PCAMeasures(alpha, numberOfPrincipalComponents, ...
    weights, portfolioValue, riskMeasureTimeIntervalInDays, returns)
% PCAMEASURES Computes the Value at Risk (VaR) and Expected Shortfall (ES)
% of a portfolio using the Gaussian parametric Principal Component Analysis (PCA) approach.
%
% INPUTS:
%   alpha:                         The confidence level for the risk measures.
%   numberOfPrincipalComponents:   The integer number of principal components (n)
%                                  to retain for the reduced model.
%   weights:                       A vector of portfolio weights corresponding 
%                                  to each asset in the returns matrix.
%   portfolioValue:                The total current monetary value of the portfolio.
%   riskMeasureTimeIntervalInDays: The time horizon for the risk measures in days.
%                                  Used to scale the mean and variance.
%   returns:                       A matrix of historical daily log returns where columns
%                                  represent assets and rows represent time steps.
%
% OUTPUTS:
%   ES:                            The Expected Shortfall at the specified confidence level and time horizon.
%   VaR:                           The Value at Risk at the specified confidence level and time horizon.
%   details:                       A struct containing intermediate variables for debugging or reporting.

n = numberOfPrincipalComponents;

% weights is a column vector
w = weights(:);

% Calculate daily mean vector and covariance matrix from historical returns
mu = mean(returns)';
Sigma = cov(returns);

% Apply PCA to Sigma to extract eigenvectors (principal components) and eigenvalues (variances)
[eigenvec, Lambda_vec] = pcacov(Sigma);

% Project weights and means onto the principal components
hat_omega = eigenvec' * w;
hat_mu = eigenvec' * mu;

% Calculate reduced daily variance and mean for the whole ptf
var_red_daily = sum((hat_omega(1:n).^2) .* Lambda_vec(1:n));
mu_red_daily = sum(hat_omega(1:n) .* hat_mu(1:n));

% Scale them to the specified time horizon
mu_ptf_horizon = mu_red_daily * riskMeasureTimeIntervalInDays;
var_ptf_horizon = var_red_daily * riskMeasureTimeIntervalInDays;

sigma_ptf_horizon = sqrt(var_ptf_horizon);

% Calculate the Z-score for the given confidence level alpha
z_alpha = norminv(alpha);

% Compute Value at Risk (VaR)
VaR = portfolioValue * (-mu_ptf_horizon + z_alpha * sigma_ptf_horizon);

% Compute Expected Shortfall (ES)
pdf_z = normpdf(z_alpha);
ES = portfolioValue * (-mu_ptf_horizon + sigma_ptf_horizon * (pdf_z / (1 - alpha)));

% Package all intermediate steps into the details struct
details = struct();

details.alpha = alpha;
details.num_components = n;
details.portfolioValue = portfolioValue;
details.horizon = riskMeasureTimeIntervalInDays;
details.eigenvalues = Lambda_vec;
details.projected_weights = hat_omega;
details.mu_red_daily = mu_red_daily;
details.var_red_daily = var_red_daily;
details.sigma_ptf_horizon = sigma_ptf_horizon;
details.mu_ptf_horizon = mu_ptf_horizon;
details.VaR = VaR;
details.ES = ES;

end