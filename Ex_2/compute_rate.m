function rate = compute_rate(dates, zero_rates, TTMinDays)
% COMPUTE_RATE Extracts the interpolated zero rate for a specific maturity
% by shifting the evaluation horizon to the start of the bootstrap curve.
%
% INPUTS:
%   dates      : Dates obtained from the bootstrap.
%   zero_rates : Zero rates obtained by the bootstrap corresponding to 'dates'.
%   TTMinDays  : The Time to Maturity of the option in exact days.
%
% OUTPUTS:
%   rate      : The interpolated continuous zero rate.

% Convert the datetime array to standard double numbers
dates = datenum(dates);

% Map the Time to Maturity onto the start of the curve
target_curve_date = dates(1) + TTMinDays;

% Interpolate the rate safely (both X and Xq are now doubles)
rate = interp1(dates, zero_rates, target_curve_date, 'linear', 'extrap');

end
