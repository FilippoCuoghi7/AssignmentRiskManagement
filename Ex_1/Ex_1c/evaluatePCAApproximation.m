function [n_PCA_5, n_PCA_1, details_PCA] = evaluatePCAApproximation(alpha, ...
    weights, portfolioValue, horizon, returns)
% EVALUATEPCAAPPROXIMATION Computes Full VaR, PCA approximations, and error thresholds.
%
% INPUTS:
%   alpha:          Confidence level
%   weights:        Asset weights vector
%   portfolioValue: Total portfolio value
%   horizon:        Risk measure time interval in days
%   returns:        Historical log returns matrix
%
% OUTPUTS:
%   n_PCA_5:        Minimum number of principal components for < 5% error
%   n_PCA_1:        Minimum number of principal components for < 1% error
%   details_PCA:    Struct containing all intermediate calculations for reporting

numberAssets = length(weights);

% Exact VaR (Full Gaussian)
[~, VaR_Full, ~] = AnalyticNormalMeasures(alpha, weights, portfolioValue, horizon, returns);

% Extract the PCA VaRs 
% Not very efficient: we are performing a PCA many times --> the best way
% to handle it would be to  pull the PCA calculation out of the function, 
% run it just once in the main script, and only loop the part of the code
% that sums up the top N eigenvalues.
[~, VaR_cell] = arrayfun(@(n) PCAMeasures(alpha, n, weights, portfolioValue, horizon, returns), ...
    (1:numberAssets)', 'UniformOutput', false);
VaR_PCA = cell2mat(VaR_cell);

% Vectorize the error calculation (Absolute relative error)
relative_errors = abs((VaR_Full - VaR_PCA) / VaR_Full);

% Find the minimum components to cross the thresholds
n_PCA_5 = find(relative_errors <= 0.05, 1, 'first');
n_PCA_1 = find(relative_errors <= 0.01, 1, 'first');

% 5. Package all parameters and results into the details struct
details_PCA = struct();

details_PCA.alpha = alpha;
details_PCA.portfolioValue = portfolioValue;
details_PCA.horizon = horizon;
details_PCA.numberAssets = numberAssets;
details_PCA.VaR_Full = VaR_Full;
details_PCA.VaR_PCA_array = VaR_PCA;
details_PCA.relative_errors = relative_errors;
details_PCA.n_PCA_5 = n_PCA_5;
details_PCA.n_PCA_1 = n_PCA_1;

end