function printExercise4Report(label, rec, Ku, Kd, rho, pd, dates, discounts, ...
    refDate, interpDate, I_checkpoints)
% PRINTEXERCISE4REPORT Prints LHP price and KL-vs-LHP convergence table
% for a given CDO tranche.
%
% INPUTS:
%   label         : String describing the tranche
%   rec,Ku,Kd,rho,pd,dates,discounts,refDate,interpDate : same as plot_prices
%   I_checkpoints : Vector of obligor counts at which to report the KL price

fprintf('\n');
fprintf('============================================================\n');
fprintf('  EXERCISE 4: CDO TRANCHE PRICING -- %s\n', upper(label));
fprintf('============================================================\n');

lhp_price = compute_LHP_price(rec, Ku, Kd, rho, pd, dates, discounts, refDate, interpDate);
fprintf('LHP limit price           : %14.3f %%\n', 100*lhp_price);
fprintf('------------------------------------------------------------\n');

n = numel(I_checkpoints);
KL_price   = zeros(n,1);
RelError   = zeros(n,1);

for k = 1:n
    Ik = I_checkpoints(k);
    if Kd == 0
        KL_price(k) = compute_KL_price_EquityTranche(Ik, rec, Ku, rho, pd, dates, ...
            discounts, refDate, interpDate);
    else
        KL_price(k) = compute_KL_price(Ik, rec, Ku, Kd, rho, pd, dates, ...
            discounts, refDate, interpDate);
    end
    RelError(k) = abs(KL_price(k) - lhp_price) / lhp_price;
end

I_col          = I_checkpoints(:);
KLPrice_pct    = 100 * KL_price;
RelError_pct   = 100 * RelError;

convTable = table(I_col, KLPrice_pct, RelError_pct, ...
    'VariableNames', {'NumObligors', 'KL_Price_pct', 'RelError_pct'});
disp(convTable);

fprintf('============================================================\n\n');

end