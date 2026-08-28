function printExercise3Report(details)
% PRINTEXERCISE3REPORT Prints a formatted report for Exercise 3.
%
% INPUT:
%   details: Struct containing the Cliquet caplet schedule/values, the
%            theoretical price, the CVA and the counterparty-risk-adjusted
%            price.

fprintf('\n');
fprintf('============================================================\n');
fprintf('  EXERCISE 3: CLIQUET PRICING UNDER COUNTERPARTY RISK\n');
fprintf('============================================================\n');
fprintf('Reference Date            : %15s\n', datestr(details.ref_date, 'dd-mmm-yyyy'));
fprintf('Notional                  : EUR %15.2f\n', details.Notional);
fprintf('------------------------------------------------------------\n');
fprintf('Theoretical Price (TP)    : EUR %15.2f\n', details.TP);
fprintf('CVA                       : EUR %15.2f\n', details.CVA);
fprintf('Risk-Adjusted Price       : EUR %15.2f\n', details.Correct_Price);
fprintf('CVA as %% of TP            : %14.2f %%\n', 100*details.CVA/details.TP);
fprintf('============================================================\n\n');

% Caplet-by-caplet detail table
fprintf('CAPLET DETAILS (per unit notional)\n');
fprintf('------------------------------------------------------------\n');

n = numel(details.Caplets);
Period      = (1:n)';
PaymentDate = cellstr(datestr(details.maturity_dates, 'dd-mmm-yyyy'));
FwdRate_pct = 100 * details.fwd_rates(:);
DeltaT      = details.delta_t(:);
CapletValue = details.Caplets(:);

capletTable = table( ...
    Period, PaymentDate, FwdRate_pct, DeltaT, CapletValue, ...
    'VariableNames', {'Period', 'PaymentDate', 'FwdRate_pct', 'DeltaT', 'CapletValue'});
disp(capletTable);

fprintf('\n');

end