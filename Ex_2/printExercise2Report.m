function printExercise2Report(details_FullMC, details_DeltaNorm)
% PRINTEXERCISE2REPORT Prints a formatted risk measurement report for Ex 2.
%
% INPUTS:
%   details_FullMC    : Struct containing all Full MC parameters and outputs.
%   details_DeltaNorm : Struct containing all Delta-Normal parameters and outputs.

fprintf('\n');
fprintf('============================================================\n');
fprintf('      EXERCISE 2: NON-LINEAR PORTFOLIO VaR COMPARISON\n');
fprintf('============================================================\n');
fprintf('Portfolio Value (V0)      : EUR %15.2f\n', details_FullMC.V0);
fprintf('Confidence Level (alpha)  : %15.2f %%\n', details_FullMC.alpha * 100);
fprintf('Time Horizon              : %15d Day(s)\n', details_FullMC.horizon);
fprintf('Total Scenarios Run       : %15d\n', details_FullMC.numScenarios);
fprintf('------------------------------------------------------------\n');
fprintf('--- Full Monte-Carlo (Full Valuation) ---\n');
fprintf('Value at Risk (VaR)       : EUR %15.2f\n', details_FullMC.VaR);
fprintf('\n--- Delta-Normal Approximation ---\n');
fprintf('Value at Risk (VaR)       : EUR %15.2f\n', details_DeltaNorm.VaR);

% Add the analytical insight comparing the two methods
diff = details_DeltaNorm.VaR - details_FullMC.VaR;
fprintf('------------------------------------------------------------\n');
if diff > 0
    fprintf('Insight: Delta method OVERESTIMATES risk by EUR %.2f\n', diff);
    fprintf('         (It ignores the protective convexity of the Puts)\n');
else
    fprintf('Insight: Delta method UNDERESTIMATES risk by EUR %.2f\n', abs(diff));
end
fprintf('============================================================\n\n');

% Portfolio & Pricing Details Table
fprintf('PORTFOLIO PRICING & GREEKS DETAILS\n');
fprintf('------------------------------------------------------------\n');

% Constructing arrays for the table
Metric = { ...
    'Current Stock Price (S0)'; ...
    'Current Put Price (P0)'; ...
    'Put Option Delta'; ...
    'Put Option Gamma'; ...
    'Total Portfolio Delta' ...
    };

Value = [ ...
    details_FullMC.S0; ...
    details_FullMC.P0; ...
    details_DeltaNorm.delta_P0; ...
    details_DeltaNorm.gamma_P0; ...
    details_DeltaNorm.delta_V0 ...
    ];

% Create and display the table
detailTable = table(Metric, Value, 'VariableNames', {'Metric', 'Value'});
disp(detailTable);

fprintf('\n');

end