function resultsTable = printCDSBootstrapReport(datesCDS, spreadsCDS, ...
    survProbs_approx, int_approx, ...
    survProbs_exact, int_exact, ...
    survProbs_JT, int_JT)
%PRINTCDSBOOTSTRAPREPORT Print a formatted report of CDS bootstrap results.
%   This helper prints survival probabilities and hazard rates obtained
%   under the Approximate, Exact, and Jarrow-Turnbull methods.
%
%   Inputs
%   ------
%   datesCDS : double column/vector
%       CDS maturities in years.
%
%   spreadsCDS : double column/vector
%       CDS market spreads in decimal form.
%
%   survProbs_approx, survProbs_exact, survProbs_JT : double column/vector
%       Survival probabilities from the three bootstrap methods.
%
%   int_approx, int_exact, int_JT : double column/vector
%       Piecewise-constant hazard rates from the three bootstrap methods.
%
%   Output
%   ------
%   resultsTable : table
%       Summary table containing all bootstrap outputs.

    datesCDS = datesCDS(:);
    spreadsCDS = spreadsCDS(:);

    survProbs_approx = survProbs_approx(:);
    int_approx = int_approx(:);

    survProbs_exact = survProbs_exact(:);
    int_exact = int_exact(:);

    survProbs_JT = survProbs_JT(:);
    int_JT = int_JT(:);

    spreads_bps = spreadsCDS * 1e4;
    int_approx_bps = int_approx * 1e4;
    int_exact_bps  = int_exact  * 1e4;
    int_JT_bps     = int_JT     * 1e4;

    resultsTable = table( ...
        datesCDS, ...
        spreads_bps, ...
        survProbs_approx, ...
        int_approx_bps, ...
        survProbs_exact, ...
        int_exact_bps, ...
        survProbs_JT, ...
        int_JT_bps, ...
        'VariableNames', { ...
            'MaturityYears', ...
            'MarketSpread_bps', ...
            'Survival_Approx', ...
            'Intensity_Approx_bps', ...
            'Survival_Exact', ...
            'Intensity_Exact_bps', ...
            'Survival_JT', ...
            'Intensity_JT_bps'});

    fprintf('\n');
    fprintf('=================================================================================================================\n');
    fprintf('                                         CDS BOOTSTRAP REPORT\n');
    fprintf('=================================================================================================================\n');
    fprintf('All survival probabilities are unitless. Hazard rates / intensities are shown in basis points.\n');
    fprintf('-----------------------------------------------------------------------------------------------------------------\n');

    disp(resultsTable);

    fprintf('-----------------------------------------------------------------------------------------------------------------\n');
    fprintf('Last maturity summary:\n');
    fprintf('  Approximate     -> Survival = %.6f, Intensity = %.2f bps\n', ...
        survProbs_approx(end), int_approx_bps(end));
    fprintf('  Exact           -> Survival = %.6f, Intensity = %.2f bps\n', ...
        survProbs_exact(end), int_exact_bps(end));
    fprintf('  Jarrow-Turnbull -> Survival = %.6f, Intensity = %.2f bps\n', ...
        survProbs_JT(end), int_JT_bps(end));
    fprintf('=================================================================================================================\n\n');
end