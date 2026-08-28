function printExercise1cReport(details_PCA)
% PRINTEXERCISE1CREPORT Prints a formatted risk measurement report for Ex 1.c.
%
% INPUTS:
%   details_PCA: Struct containing VaR outputs, plausibility check, errors, 
%                and parameters for PCA.

fprintf('\n');
fprintf('============================================================\n');
fprintf('    EXERCISE 1.c: GAUSSIAN PARAMETRIC PCA VaR ANALYSIS\n');
fprintf('============================================================\n');
fprintf('Portfolio Value           : EUR %15.2f\n', details_PCA.portfolioValue);
fprintf('Confidence Level (alpha)  : %15.2f %%\n', details_PCA.alpha * 100);
fprintf('Time Horizon              : %15d Day(s)\n', details_PCA.horizon);
fprintf('Total Number of Assets    : %15d\n', details_PCA.numberAssets);
fprintf('------------------------------------------------------------\n');
fprintf('Full Gaussian VaR         : EUR %15.2f\n', details_PCA.VaR_Full);
fprintf('Plausibility Check VaR    : EUR %15.2f\n', details_PCA.VaR_check);
fprintf('------------------------------------------------------------\n');
fprintf('Components for <= 5%% Error: %15d\n', details_PCA.n_PCA_5);
fprintf('Components for <= 1%% Error: %15d\n', details_PCA.n_PCA_1);
fprintf('============================================================\n\n');

fprintf('PCA ERROR DECAY (First 5 Components)\n');
fprintf('------------------------------------------------------------\n');

max_print = min(5, details_PCA.numberAssets);
n_array = (1:max_print)';
VaR_array = details_PCA.VaR_PCA_array(1:max_print);
Error_pct = details_PCA.relative_errors(1:max_print) * 100;

decayTable = table( ...
    n_array, ...
    VaR_array, ...
    Error_pct, ...
    'VariableNames', {'Components', 'VaR_Approximation', 'RelativeError_pct'});
disp(decayTable);

fprintf('\n');

end