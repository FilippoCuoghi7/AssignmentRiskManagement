function [r, delta_t] = compute_fwd_rates(ref_date, maturity_dates, dates, zero_rates)
% COMPUTE_FWD_RATES Computes the continuously compounded forward interest
% rates for each specific time segment of a derivative
% by bootstrapping and interpolating a zero-coupon yield curve.
%
% INPUTS:
%   ref_date       : The valuation date / start date (scalar datenum). 
%   maturity_dates : A vector of adjusted payment/maturity dates for the derivative
%                    (datetime array).
%   dates          : Dates obtained from the bootstrap.
%   zero_rates     : Zero rates obtained by the bootstrap corresponding to 'dates'.
%
% OUTPUTS:
%   r              : A column vector of continuously compounded forward rates.
%                    The first rate spans from ref_date to maturity_dates(1).
%                    Subsequent rates span from maturity_dates(i-1) to maturity_dates(i).

% Force column vectors 
maturity_dates = maturity_dates(:);

% Extract node maturities in years (ACT/365) from the evaluation date
T_target = yearfrac(ref_date, maturity_dates, 3);
T_nodes = yearfrac(ref_date, dates(2:end), 3);

% Compute continuously compounded zero rates at the curve nodes
z_nodes = zero_rates(2:end);

% Interpolate the zero rates for our exact target maturities
z_interp = interp1(T_nodes, z_nodes, T_target, 'linear', 'extrap');

% Compute discount factors for the target maturity dates
discounts = exp(-z_interp .* T_target);

% Add the discount factor for t=0 (which is exactly 1) to the top of the array.
discounts_full = [1; discounts(:)];

% Compute Forward Discount Factors: DF(t_{i-1}, t_i) = DF(0, t_i) / DF(0, t_{i-1})
fwd_discounts = discounts_full(2:end) ./ discounts_full(1:end-1);

% Compute exact time fraction for each specific forward period
delta_t = zeros(size(T_target));
delta_t(1) = yearfrac(ref_date, maturity_dates(1), 3);
delta_t(2:end) = yearfrac(maturity_dates(1:end-1), maturity_dates(2:end), 3);

% Compute continuously compounded forward rates
r = -log(fwd_discounts) ./ delta_t;

end