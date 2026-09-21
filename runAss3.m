% runAssignment03
% AY2025-2026

close all; clear; clc;
format long;
projectRoot = fileparts(which('runAss3.m'));
addpath(genpath(projectRoot));

% Seed fixed
rng(42);

% Settings
formatDate='dd/mm/yyyy';

% File name
inputFile = 'sx5e_historical_data.xlsx';

%% Exercise 0

% Input parameters
alpha0 = 0.95; 
refDate0 = '24-Jul-2010';
NumberOfYears0 = 2; 
timeWindow0 = 12*NumberOfYears0;
sharesList_ex0 = cellstr(['Inditex'; 'BASF   '; 'LVMH   ']);
numberAssets_ex0 = size(sharesList_ex0,1);
weights=(1/numberAssets_ex0)*ones(numberAssets_ex0,1);

[tSelected, returnsSelected, shareData] = returnsOfInterest(inputFile, refDate0, ...
    timeWindow0, sharesList_ex0, formatDate);

portfolioValue = 10000000;
riskMeasureTimeIntervalInDays = 1;

% Compute Risk Measurements
[ES_95, VaR_95, details_ex0] = AnalyticNormalMeasures(alpha0, weights, ...
    portfolioValue, riskMeasureTimeIntervalInDays, returnsSelected);
details_ex0.sharesList = sharesList_ex0;

printExercise0Report(details_ex0);

%% Exercise 1

% Input parameters
refDate1 = '24-Jul-2010';
NumberOfYears1 =2;
timeWindow1 = 12*NumberOfYears1;
end_date1 = '24-Jul-2012';
alpha1 = 0.99;

% a)

sharesList_ex1_a = cellstr(['ENI       '; 'Telefonica'; 'EON       '; 'Daimler   ']);
numberAssets_ex1_a = size(sharesList_ex1_a,1);
num_shares_1a = [18000, 25000, 15000, 9000];
[portfolioValue1_a, weights1_a] = compute_ptf_value(shareData, sharesList_ex1_a, ...
    num_shares_1a, end_date1);
[~, returnsSelected_ex1_a, ~] = returnsOfInterest(inputFile, refDate1, timeWindow1, ...
    sharesList_ex1_a, formatDate);
riskMeasureTimeIntervalInDays_1a = 1;

% compute VaR and ES with HS.
tic;
[ES_HS_99_1a, VaR_HS_99_1a, details_HS_1a] = HSMeasures(alpha1, weights1_a, ...
    portfolioValue1_a, riskMeasureTimeIntervalInDays_1a, returnsSelected_ex1_a);
time_HS = toc;

details_HS_1a.sharesList = sharesList_ex1_a;
details_HS_1a.VaR_check = PlausibilityCheckVaR(alpha1, weights1_a, portfolioValue1_a, ...
    riskMeasureTimeIntervalInDays_1a, returnsSelected_ex1_a);

% compute VaR and ES with Bootstrap.
num_simulations = 200;

tic;
[ES_BS_99_1a, VaR_BS_99_1a, details_BS_1a] = BootstrapMeasures(alpha1, weights1_a, ...
    portfolioValue1_a, riskMeasureTimeIntervalInDays_1a, returnsSelected_ex1_a, num_simulations);
time_BS = toc;

details_BS_1a.sharesList = sharesList_ex1_a;

printExercise1aReport(details_HS_1a, details_BS_1a);

fprintf('\n--- Execution Time Comparison ---\n');
fprintf('Historical Simulation: %.6f seconds\n', time_HS);
fprintf('Bootstrap (%d sims):   %.6f seconds\n\n', num_simulations, time_BS);

% b)

sharesList_ex1_b = cellstr(['Vivendi   '; 'AXA       '; 'ENEL      '; 'Volkswagen'; 'Schneider ']);
numberAssets_ex1_b = size(sharesList_ex1_b,1);
weights_1b = (1/numberAssets_ex1_b)*ones(numberAssets_ex1_b,1);
lambda = 0.98;
portfolioValue1_b = 1e7; 
[~, returnsSelected_ex1_b, ~] = returnsOfInterest(inputFile, refDate1, timeWindow1, ...
    sharesList_ex1_b, formatDate);
riskMeasureTimeIntervalInDays_1b = 1;

% compute VaR and ES with WHS.
[ES_WHS_99_1b, VaR_WHS_99_1b, details_WHS_1b] = WHSMeasures(alpha1, lambda, weights_1b, ...
    portfolioValue1_b, riskMeasureTimeIntervalInDays_1b, returnsSelected_ex1_b);
details_WHS_1b.sharesList = sharesList_ex1_b;
details_WHS_1b.VaR_check = PlausibilityCheckVaR(alpha1, weights_1b, portfolioValue1_b, ...
    riskMeasureTimeIntervalInDays_1b, returnsSelected_ex1_b);

printExercise1bReport(details_WHS_1b);

% c)

sharesList_ex1_c = extractUnderlyings('underlyingCode.m', 25);
numberAssets_ex1_c = size(sharesList_ex1_c,1);
weights_1c = (1/numberAssets_ex1_c)*ones(numberAssets_ex1_c,1);
portfolioValue1_c = 15000000;
[~, returnsSelected_ex1_c, ~] = returnsOfInterest(inputFile, refDate1, timeWindow1, ...
    sharesList_ex1_c, formatDate);
riskMeasureTimeIntervalInDays_1c = 10;

% Evaluate PCA Approximations and get thresholds
[n_PCA_5, n_PCA_1, details_PCA_1c] = evaluatePCAApproximation(alpha1, weights_1c, ...
    portfolioValue1_c, riskMeasureTimeIntervalInDays_1c, returnsSelected_ex1_c);
details_PCA_1c.VaR_check = PlausibilityCheckVaR(alpha1, weights_1c, portfolioValue1_c, ...
    riskMeasureTimeIntervalInDays_1c, returnsSelected_ex1_c);

printExercise1cReport(details_PCA_1c);

% Plausibility Check 
Pl_VaR2_Analytical_1a = PlausibilityCheckVaR2(alpha1, weights1_a, portfolioValue1_a, ...
    riskMeasureTimeIntervalInDays_1a, returnsSelected_ex1_a);
fprintf('Plausibility Check 2 (Univariate Gaussian) VaR - Portfolio 1a: EUR %.2f\n\n', Pl_VaR2_Analytical_1a);
Pl_VaR2_Analytical_1b = PlausibilityCheckVaR2(alpha1, weights_1b, portfolioValue1_b, ...
    riskMeasureTimeIntervalInDays_1b, returnsSelected_ex1_b);
fprintf('Plausibility Check 2 (Univariate Gaussian) VaR - Portfolio 1b: EUR %.2f\n\n', Pl_VaR2_Analytical_1b);
Pl_VaR2_Analytical_1c = PlausibilityCheckVaR2(alpha1, weights_1c, portfolioValue1_c, ...
    riskMeasureTimeIntervalInDays_1c, returnsSelected_ex1_c);
fprintf('Plausibility Check 2 (Univariate Gaussian) VaR - Portfolio 1c: EUR %.2f\n\n', Pl_VaR2_Analytical_1c);

%% Exercise 2

M = 1164000;
ref_date2 = datetime('15-Feb-2010');
ref_date2 = adjustTargetBusinessDay(ref_date2, 'modifiedfollowing');
end_date2 = datetime('18-Apr-2010');
end_date2 = adjustTargetBusinessDay(end_date2, 'modifiedfollowing');
assetName = 'Generali';
[n, stockPrice] = compute_num_shares(shareData, ref_date2, assetName, M);
TTMinDays = daysact(ref_date2, end_date2);
TTMinYears = TTMinDays / 365;
alpha2 = 0.99;

NumberOfYears2 =2;
timeWindow2 = 12*NumberOfYears2;
histWindowStart_ex2 = dateAddMonth(datenum(ref_date2), -timeWindow2);
[~, returnsSelected_ex2, ~] = returnsOfInterest(inputFile, histWindowStart_ex2, ...
    timeWindow2, assetName, formatDate);

q = 0.051;
strike = 28.5;
vol = 0.223;
[datesSet, ratesSet] = readExcelData('MktData_CurveBootstrap.xls', formatDate);

[dates, discounts, zeroRates] = bootstrap(datesSet, ratesSet); 

rate = compute_rate(dates, zeroRates, TTMinDays);
riskMeasureTimeIntervalInDays_ex2 = 1;

% 1-d/99% Full MonteCarlo VaR
[VaR_FullMC, details_FullMC] = FullMonteCarloVaR(alpha2, n, n, stockPrice, strike, ...
    rate, q, vol, TTMinYears, riskMeasureTimeIntervalInDays_ex2, returnsSelected_ex2);

% 1-d/99% Delta-Normal Approx VaR
[VaR_DeltaNorm, details_DeltaNorm] = DeltaNormalVaR(alpha2, n, n, stockPrice, strike, ...
    rate, q, vol, TTMinYears, riskMeasureTimeIntervalInDays_ex2, returnsSelected_ex2);

printExercise2Report(details_FullMC, details_DeltaNorm);

%% Plot of Delta and Delta_Gamma_Theta w.r.t. the Exact B&S (we use an ATM case in order to see the differences better)

PlotApproximationErrors(strike, strike, rate, q, vol, TTMinYears)

PlotDeltaGammaApproximation(strike, strike, rate, q, vol, TTMinYears)

%% Exercise 3

ref_date3 = datesSet.settlement; % (datenum) as always we consider 19 Feb 2008 and not 15 Feb 2008 as reference date.
assetName = 'ISP';
Notional = 45*1e6;
maturity = 5;                   % maturity of the Cliquet option (in years)
t = 1;                          % time-step for payoffs (in years)

strike = 1;
stock = 1;
q = 0; 
sigma = 0.19;

maturity_dates = compute_maturity_dates(ref_date3, maturity, t); % datetime

[r, delta_t] = compute_fwd_rates(ref_date3, maturity_dates, dates, zeroRates);

% Theoretical Price
[Caplets,TP] = compute_theoretical_price(Notional, ref_date3, maturity_dates, stock, strike, r, q, sigma, delta_t);

% Correct Price (with the adjustment of the CVA term)
CVA = compute_CVA_adj(maturity_dates, Caplets, dates, discounts, Notional);
Correct_Price = TP - CVA;

details_ex3 = struct();
details_ex3.ref_date       = ref_date3;
details_ex3.maturity_dates = maturity_dates;
details_ex3.fwd_rates      = r;
details_ex3.delta_t        = delta_t;
details_ex3.Caplets        = Caplets;
details_ex3.Notional       = Notional;
details_ex3.TP             = TP;
details_ex3.CVA            = CVA;
details_ex3.Correct_Price  = Correct_Price;

printExercise3Report(details_ex3);

%% Exercise 4

% a)

ref_date = datesSet.settlement; % (datenum) as always we consider 19 Feb 2008 and not 15 Feb 2008 as reference date.
refDate4 = datetime(ref_date, 'ConvertFrom', 'datenum');
N_rp = 1e9;
PD = 0.05;
rho = 0.4;
recovery = 0.2;
Kd = 0.05;
Ku = 0.09;
I = 400;
T = 3;
maturity4 = refDate4 + calyears(3);
maturity4 = adjustTargetBusinessDay(maturity4, 'modifiedfollowing');

I_min = 10;
I_max = 2*1e4;

I_checkpoints = [50, 100, 400, 1000, 5000, 20000];

% a)
plot_prices(I_min,I_max, recovery, Ku, Kd, rho, PD, dates, discounts, refDate4, maturity4);
printExercise4Report('Mezzanine [5%-9%]', recovery, Ku, Kd, rho, PD, dates, discounts, ...
    refDate4, maturity4, I_checkpoints);

% b)
Ku_ET = 0.05;
Kd_ET = 0;

plot_prices(I_min,I_max, recovery, Ku_ET, Kd_ET, rho, PD, dates, discounts, refDate4, maturity4);
printExercise4Report('Equity [0%-5%]', recovery, Ku_ET, Kd_ET, rho, PD, dates, discounts, ...
    refDate4, maturity4, I_checkpoints);









