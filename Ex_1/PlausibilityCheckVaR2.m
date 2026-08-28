function VaR = PlausibilityCheckVaR2(alpha, weights, portfolioValue, ...
    riskMeasureTimeIntervalInDays, returns)
% Plausibility check for VaR: simple univariate Gaussian on portfolio returns
%
% INPUTS:
% - alpha:                          confidence level
% - weights:                        column vector of portfolio weights (N x 1)
% - portfolioValue:                 total portfolio notional value (scalar)
% - riskMeasureTimeIntervalInDays:  risk horizon in days
% - returns:                        matrix of daily log-returns (T x N)
%
% OUTPUT:
% - VaR: Value at Risk (positive = loss)
%
% METHOD:
%   Compute portfolio returns directly as r_ptf = returns * weights,
%   then fit a univariate Gaussian (ignoring cross-correlations details)
%   and compute VaR.  Mean is set to zero for conservatism (common in practice).

% Calculate the actual portfolio returns
r_ptf = returns * weights;

% Check the "Driftless" assumption
emp_mean = mean(r_ptf);
fprintf('Empirical Daily Mean: %f (Should be very close to 0)\n', emp_mean);

% The Descriptive Proof: Skewness & Kurtosis
% A perfect Gaussian has Skewness = 0 and Kurtosis = 3.
emp_skew = skewness(r_ptf);
emp_kurt = kurtosis(r_ptf); 
fprintf('Empirical Skewness: %f (Gaussian = 0)\n', emp_skew);
fprintf('Empirical Kurtosis: %f (Gaussian = 3)\n', emp_kurt);

% The Statistical Proof: Jarque-Bera Test
% This formally tests if the data is normal. A p-value < 0.05 means it is NOT normal.
[h, pValue, jbStat, critValue] = jbtest(r_ptf);
fprintf('Jarque-Bera p-value: %f\n', pValue);
if h == 1
    fprintf('Result: REJECT normality (The Gaussian approximation is invalid).\n');
else
    fprintf('Result: FAIL TO REJECT normality (The Gaussian approximation might be valid).\n');
end

% The Visual Proof: Q-Q Plot
% If the data is Gaussian, the points will form a perfectly straight line.
figure;
qqplot(r_ptf);
title('Q-Q Plot of Portfolio Returns vs. Normal Distribution');
         

sig_ptf = std(r_ptf);               

h     = riskMeasureTimeIntervalInDays;
sig_h = sig_ptf * sqrt(h);

VaR = portfolioValue * sig_h * norminv(alpha);

end
