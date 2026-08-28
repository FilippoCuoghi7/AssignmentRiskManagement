function outDate = businessDateOffsetTarget(baseDate, yearOffset, monthOffset, dayOffset, convention)
% BUSINESSDATEOFFSETTARGET
% Applies year/month/day offsets to a base date and then adjusts it
% according to a TARGET business-day convention.
%
% INPUTS
%   baseDate    : scalar datetime
%   yearOffset  : integer number of years to add
%   monthOffset : integer number of months to add
%   dayOffset   : integer number of days to add
%   convention  : 'following' or 'modifiedfollowing'
%
% EXAMPLE
%   d = datetime(2024,1,31);
%   out = businessDateOffsetTarget(d, 0, 1, 0);

    if nargin < 2, yearOffset = 0; end
    if nargin < 3, monthOffset = 0; end
    if nargin < 4, dayOffset = 0; end

    if ~isa(baseDate, 'datetime') || ~isscalar(baseDate)
        error('baseDate must be a scalar datetime.');
    end

    % Extract date components
    y = year(baseDate);
    m = month(baseDate);
    d = day(baseDate);

    % Apply year and month offsets
    totalMonths = m + monthOffset - 1;
    y = y + yearOffset + floor(totalMonths / 12);
    m = mod(totalMonths, 12) + 1;

    % If the original day is invalid in the target month,
    % clamp it to the last valid day of that month
    lastDay = eomday(y, m);
    d = min(d, lastDay);

    % Build the shifted date before business-day adjustment
    adjustedDate = datetime(y, m, d) + caldays(dayOffset);

    % Adjust using the TARGET calendar
    outDate = adjustTargetBusinessDay(adjustedDate, convention);
end

