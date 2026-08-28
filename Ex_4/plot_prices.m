function plot_prices(Imin,Imax, rec, Ku, Kd, rho, pd, dates, discounts, refDate, interpDate)
% PLOT_PRICES Plots CDO tranche prices across different
% portfolio sizes (I) comparing Exact, KL, and LHP models.
%
% INPUTS:
%   Imin     - The minimum number of obligors in the credit portfolio.
%   Imax     - The maximum number of obligors in the credit portfolio.
%   rec      - The average recovery rate upon defaults.
%   Ku       - The detachment point (upper bound) of the specific CDO tranche.
%   Kd       - The attachment point (lower bound) of the specific CDO tranche.
%   rho      - The correlation
%   pd       - The unconditional, individual probability of default for the assets.
%   dates      - An array of numerical dates representing the maturity pillars
%                of the market yield curve.
%   discounts  - An array of discount factors corresponding to the yield curve 'dates'.
%   refDate    - The current valuation date (settlement date).
%   interpDate - The maturity date of the tranche (when the payoff occurs).

% Create the logarithmic grid for I (it works better than 'linspace')
num_points = 100;

% Generate 'num_points' points logarithmically spaced, round them to integers,
% and remove any duplicates.
I_grid = unique(round(logspace(log10(Imin), log10(Imax), num_points)));

% Preallocate the array of LHP solutions with NaNs
prices_LHP = NaN(size(I_grid));

% The LHP assumes an infinite portfolio, so it does not depend on 'I'.
lhp_scalar_price = compute_LHP_price(rec, Ku, Kd, rho, pd, dates, discounts, refDate, interpDate);
prices_LHP(:) = lhp_scalar_price; % Fill the whole array with this one price

% Compute KL Approximation (handles massive I without crashing)
if (Kd == 0)
    prices_KL = arrayfun(@(I) compute_KL_price_EquityTranche(I, rec, Ku, rho, pd, dates, discounts, refDate, interpDate), I_grid);
else
    prices_KL = arrayfun(@(I) compute_KL_price(I, rec, Ku, Kd, rho, pd, dates, discounts, refDate, interpDate), I_grid);
end

% Preallocate the array of exact solutions with NaNs
prices_exact = NaN(size(I_grid));

% Escalate warnings to errors
oldWarnState = warning('error', 'MATLAB:nchoosek:LargeCoefficient');

for k = 1:length(I_grid)
    I = I_grid(k);

    try
        % Attempt to compute the exact price
        prices_exact(k) = compute_exact_price(I, rec, Ku, Kd, rho, pd, dates, discounts, refDate, interpDate);

    catch ME
        % If it hits the nchoosek warning (now an error), it stops the
        % entire loop immediately.
        fprintf('Exact model hit compute limit at I = %d\n', I);

        % Do not evaluate any more 'I' values.
        break;
    end
end

% Put the warning state back to normal
warning(oldWarnState);


% Plot (multiply by 100 so that we have percentages)
figure;
hold on;

% KL Approximation (Red dashed line with square markers)
semilogx(I_grid, prices_KL * 100, 'r--s', 'LineWidth', 1.5, 'MarkerSize', 4);

% Exact Solution (Blue solid line with circle markers)
semilogx(I_grid, prices_exact * 100, 'b-o', 'LineWidth', 1.5, 'MarkerSize', 4, 'MarkerFaceColor', 'b');

% LHP Limit (Thick black solid line)
semilogx(I_grid, prices_LHP * 100, 'k-', 'LineWidth', 2);

title(sprintf('CDO Tranche Price [%.0f%% - %.0f%%] vs. Portfolio Size', Kd*100, Ku*100));
xlabel('Number of Obligors (I) - Log Scale');
ylabel('Price (% of Face Value)');

xlim([min(I_grid), max(I_grid)]);

legend('KL Approximation', 'Exact Solution', 'LHP Limit', 'Location', 'best');
grid on;
box on;

% Force the horizontal axis to scale logarithmically instead of linearly.
set(gca, 'XScale', 'log');
xticks(10.^[1:5]); % Places tick marks evenly at 10, 100, 1000, 10000, 100000.

hold off;

end