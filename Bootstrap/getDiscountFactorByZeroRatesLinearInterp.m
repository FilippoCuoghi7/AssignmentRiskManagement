function df = getDiscountFactorByZeroRatesLinearInterp(refDate, interpDate, dates, discount_factors)
% GETDISCOUNTFACTORBYZERORATESLINEARINTERP calculates the discount factor
% for a specific target date (interpDate) by performing linear interpolation
% on the continuously compounded zero-coupon spot rates.
%
%   Input arguments:
%     refDate : Reference date (Settlement Date) of the curve.
%     interpDate : Target date for which the discount factor is required.
%     dates : Vector of dates corresponding to the discount factors (including refDate).
%     discount_factors : Vector of discount factors (DF) at the curve nodes.
%
%   Output arguments:
%     df : Interpolated discount factor for the target date.

% Extract node maturities in years (ACT/365)
T_nodes = yearfrac(refDate, dates(2:end), 3);

% Compute continuously compounded zero rates at the curve nodes
z_nodes = fromDiscountFactorsToZeroRates(refDate, dates, discount_factors);

% Compute maturity for the target interpolation date
T_target = yearfrac(refDate, interpDate, 3);

% Perform linear interpolation on zero rates (with extrapolation enabled)
z_interp = interp1(T_nodes, z_nodes, T_target, 'linear', 'extrap');

% Reconvert the interpolated zero rate back into a discount factor
df = exp(-z_interp .* T_target);
end