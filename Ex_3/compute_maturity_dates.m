function mat = compute_maturity_dates(ref_date, T, t, convention)
% COMPUTE_MATURITY_DATES Generates a schedule of maturity dates for a
% derivative, adjusted for business days.
%
% INPUTS:
%   ref_date   : The starting date (datenum scalar)
%   T          : Total maturity of the option in years
%   t          : Time step between payoffs in years
%   convention : String, 'modifiedfollowing' or 'following

% Implicit Convention
if nargin < 4
    convention = 'modifiedfollowing';
end


% Calculate total number of payoffs
n = round(T / t);

% Preallocate the datetime array (empty datetime array)
mat = NaT(n, 1);

% ref_date must be of type datetime
ref_date = datetime(ref_date, 'ConvertFrom', 'datenum');

% Loop through each payment period
for i = 1:n
    % Convert the elapsed time into total months to avoid fractional years.
    months_to_add = round(i * t * 12);

    mat(i) = businessDateOffsetTarget(ref_date, 0, months_to_add, 0, convention);
end

end