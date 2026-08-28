function plotCDSBootstrapResults(datesCDS, ...
    survProbs_approx, int_approx, ...
    survProbs_exact, int_exact, ...
    survProbs_JT, int_JT)
%PLOTCDSBOOTSTRAPRESULTS Plot CDS bootstrap survival probabilities and intensities.
%   This helper generates two figures:
%       1) Survival probability curves
%       2) Piecewise hazard-rate / intensity curves in basis points
%
%   Inputs
%   ------
%   datesCDS : double column/vector
%       CDS maturities in years.
%
%   survProbs_approx, survProbs_exact, survProbs_JT : double column/vector
%       Survival probabilities from the three bootstrap methods.
%
%   int_approx, int_exact, int_JT : double column/vector
%       Piecewise-constant hazard rates from the three bootstrap methods.

    datesCDS = datesCDS(:);

    survProbs_approx = survProbs_approx(:);
    survProbs_exact  = survProbs_exact(:);
    survProbs_JT     = survProbs_JT(:);

    int_approx = int_approx(:) * 1e4;
    int_exact  = int_exact(:)  * 1e4;
    int_JT     = int_JT(:)     * 1e4;

    % Survival probabilities
    figure;
    plot(datesCDS, survProbs_approx, '-o', 'LineWidth', 1.5, 'MarkerSize', 6);
    hold on;
    plot(datesCDS, survProbs_exact,  '-s', 'LineWidth', 1.5, 'MarkerSize', 6);
    plot(datesCDS, survProbs_JT,     '-^', 'LineWidth', 1.5, 'MarkerSize', 6, ...
        'Color', [0 0.6 0]);
    hold off;
    grid on;
    xlabel('Maturity (years)');
    ylabel('Survival probability');
    title('CDS Bootstrap - Survival Probabilities');
    legend('Approximate', 'Exact', 'Jarrow-Turnbull', 'Location', 'best');

    % Intensities
    figure;
    stairs(datesCDS, int_approx, 'LineWidth', 1.5);
    hold on;
    stairs(datesCDS, int_exact,  'LineWidth', 1.5);
    stairs(datesCDS, int_JT,     'LineWidth', 1.5, 'Color', [0 0.6 0]);
    hold off;
    grid on;
    xlabel('Maturity (years)');
    ylabel('Intensity (bps)');
    title('CDS Bootstrap - Piecewise Hazard Rates');
    legend('Approximate', 'Exact', 'Jarrow-Turnbull', 'Location', 'best');
end