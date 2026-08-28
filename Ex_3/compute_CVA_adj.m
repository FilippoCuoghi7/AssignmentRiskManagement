function CVA = compute_CVA_adj(mat_dates, capletValues, dates, discounts, M)
% COMPUTE_CVA_ADJ Calculates the exact Credit Value Adjustment (CVA) for a 
% portfolio of non-negative payoffs using the analytical Tower Property shortcut.
%
% INPUTS:
%   mat_dates    : Array of maturity/payment dates for the caplets 
%   capletValues : Array of the present values of each individual caplet
%   dates        : Market yield curve dates
%   discounts    : Market yield curve discount factors
%   M            : Notional amount of the contract
%
% OUTPUT:
%   CVA          : The total Credit Value Adjustment

% Bootstrap the Survival Probabilities from CDS Spreads
spreadsCDS = [29, 34, 37, 39, 40]' / 10000; 
flag = 0; 
recovery = 0.4;
tenors_in_years = year(mat_dates) - year(dates(1));
[~, survProbs, ~] = bootstrapCDS(dates, discounts, tenors_in_years, spreadsCDS, flag, recovery);

% Calculate Cumulative Default Probabilities for each payment date
% (survProbs must be a column vector)
prob_default_cumulative = 1 - survProbs(:);

% Calculate CVA per unit of notional (closed formula)
capletValues = capletValues(:); % Ensure column vector
CVA_perUnit = sum(capletValues .* prob_default_cumulative);

% Total CVA Calculation
CVA = (1 - recovery) * M * CVA_perUnit;

end