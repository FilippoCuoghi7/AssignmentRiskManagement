function printExercise1bReport(details_WHS)
% PRINTEXERCISE1BREPORT Prints a formatted risk measurement report for Ex 1.b.
%
% INPUTS:
%   details_WHS: Struct containing VaR/ES outputs, plausibility check, and 
%                parameters for Weighted Historical Simulation.

% Removes leading and trailing blank spaces from strings or character vectors
cleanShares = strtrim(details_WHS.sharesList);

fprintf('\n');
fprintf('============================================================\n');
fprintf('    EXERCISE 1.b: WEIGHTED HISTORICAL SIMULATION VaR\n');
fprintf('============================================================\n');
fprintf('Portfolio Value           : EUR %15.2f\n', details_WHS.portfolioValue);
fprintf('Confidence Level (alpha)  : %15.2f %%\n', details_WHS.alpha * 100);
fprintf('Time Horizon              : %15d Day(s)\n', details_WHS.horizon);
fprintf('Decay Factor (lambda)     : %15.4f\n', details_WHS.lambda);
fprintf('------------------------------------------------------------\n');
fprintf('Plausibility Check VaR    : EUR %15.2f\n', details_WHS.VaR_check);
fprintf('------------------------------------------------------------\n');
fprintf('Value at Risk (VaR)       : EUR %15.2f\n', details_WHS.VaR);
fprintf('Expected Shortfall (ES)   : EUR %15.2f\n', details_WHS.ES);
fprintf('============================================================\n\n');

% Asset details table
fprintf('PORTFOLIO ASSET DETAILS\n');
fprintf('------------------------------------------------------------\n');
detailTable = table( ...
    cleanShares, ...
    details_WHS.weights, ...
    'VariableNames', {'Asset', 'Weight'});
disp(detailTable);

fprintf('\n');

end