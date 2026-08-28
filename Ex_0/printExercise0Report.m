function printExercise0Report(details)
% PRINTEXERCISE0REPORT Prints a formatted risk measurement report for Ex 0.
%
% INPUT:
%   details: Struct containing all VaR/ES outputs and portfolio parameters

% removes leading and trailing blank spaces from strings or character vectors.
cleanShares = strtrim(details.sharesList);

fprintf('\n');
fprintf('============================================================\n');
fprintf('           EXERCISE 0: VARIANCE-COVARIANCE VaR & ES\n');
fprintf('============================================================\n');
fprintf('Portfolio Value           : EUR %15.2f\n', details.portfolioValue);
fprintf('Confidence Level (alpha)  : %15.2f %%\n', details.alpha * 100);
fprintf('Time Horizon              : %15d Day(s)\n', details.horizon);
fprintf('------------------------------------------------------------\n');
fprintf('Value at Risk (VaR)       : EUR %15.2f\n', details.VaR_alpha);
fprintf('Expected Shortfall (ES)   : EUR %15.2f\n', details.ES_alpha);
fprintf('============================================================\n\n');

% Asset details table
fprintf('PORTFOLIO ASSET DETAILS\n');
fprintf('------------------------------------------------------------\n');
detailTable = table( ...
    cleanShares, ...
    details.weights, ...
    details.mu_d, ...
    'VariableNames', {'Asset', 'Weight', 'DailyMeanReturn'});
disp(detailTable);

% Covariance matrix table
fprintf('\nDAILY COVARIANCE MATRIX\n');
fprintf('------------------------------------------------------------\n');
covTable = array2table(details.Sigma_d, ...
    'VariableNames', cleanShares, ...
    'RowNames', cleanShares);
disp(covTable);

fprintf('\n');
end