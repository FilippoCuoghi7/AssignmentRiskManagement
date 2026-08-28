function printExercise1aReport(details_HS, details_BS)
% PRINTEXERCISE1AREPORT Prints a formatted risk measurement report for Ex 1.a.
%
% INPUTS:
%   details_HS: Struct containing VaR/ES outputs, plausibility check, and 
%               parameters for Historical Simulation.
%   details_BS: Struct containing VaR/ES outputs and parameters for Bootstrap.

% Removes leading and trailing blank spaces from strings or character vectors
cleanShares = strtrim(details_HS.sharesList);

fprintf('\n');
fprintf('============================================================\n');
fprintf('    EXERCISE 1.a: HISTORICAL SIMULATION & BOOTSTRAP VaR\n');
fprintf('============================================================\n');
fprintf('Portfolio Value           : EUR %15.2f\n', details_HS.portfolioValue);
fprintf('Confidence Level (alpha)  : %15.2f %%\n', details_HS.alpha * 100);
fprintf('Time Horizon              : %15d Day(s)\n', details_HS.horizon);
fprintf('Bootstrap Simulations     : %15d\n', details_BS.num_simulations);
fprintf('------------------------------------------------------------\n');
fprintf('Plausibility Check VaR    : EUR %15.2f\n', details_HS.VaR_check);
fprintf('------------------------------------------------------------\n');
fprintf('--- Historical Simulation (HS) ---\n');
fprintf('Value at Risk (VaR)       : EUR %15.2f\n', details_HS.VaR);
fprintf('Expected Shortfall (ES)   : EUR %15.2f\n', details_HS.ES);
fprintf('\n--- Statistical Bootstrap (BS) ---\n');
fprintf('Value at Risk (VaR)       : EUR %15.2f\n', details_BS.VaR);
fprintf('Expected Shortfall (ES)   : EUR %15.2f\n', details_BS.ES);
fprintf('============================================================\n\n');

% Asset details table
fprintf('PORTFOLIO ASSET DETAILS\n');
fprintf('------------------------------------------------------------\n');
detailTable = table( ...
    cleanShares, ...
    details_HS.weights, ...
    'VariableNames', {'Asset', 'Weight'});
disp(detailTable);

fprintf('\n');

end