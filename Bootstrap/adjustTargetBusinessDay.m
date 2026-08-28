function outDate = adjustTargetBusinessDay(inDate, convention)
% ADJUSTTARGETBUSINESSDAY Adjusts a date according to TARGET business-day convention.
%
% INPUTS
%   inDate      : scalar datetime
%   convention  : 'following' or 'modifiedfollowing'
%
% OUTPUT
%   outDate     : adjusted scalar datetime

    if nargin < 2
        convention = 'following';
    end

    if ~isa(inDate, 'datetime') || ~isscalar(inDate)
        error('inDate must be a scalar datetime.');
    end

    convention = lower(string(convention));

    switch convention
        case "following"
            outDate = inDate;
            while ~isTargetBusinessDay(outDate)
                outDate = outDate + caldays(1);
            end

        case "modifiedfollowing"
            outDate = inDate;
            while ~isTargetBusinessDay(outDate)
                outDate = outDate + caldays(1);
            end

            if month(outDate) ~= month(inDate)
                outDate = inDate;
                while ~isTargetBusinessDay(outDate)
                    outDate = outDate - caldays(1);
                end
            end

        otherwise
            error('Unsupported convention. Use ''following'' or ''modifiedfollowing''.');
    end
end


function tf = isTargetBusinessDay(d)
% Return true if the date is a TARGET business day

    wd = weekday(d); % 1 = Sunday, 7 = Saturday
    if wd == 1 || wd == 7
        tf = false;
        return;
    end

    h = targetHolidays(year(d));
    tf = ~ismember(datetime(year(d), month(d), day(d)), h);
end

function h = targetHolidays(y)
% Standard TARGET holidays:
%   - January 1
%   - Good Friday
%   - Easter Monday
%   - May 1
%   - December 25
%   - December 26

    easter = easterSunday(y);

    h = [
        datetime(y,1,1)
        easter - caldays(2)   % Good Friday
        easter + caldays(1)   % Easter Monday
        datetime(y,5,1)
        datetime(y,12,25)
        datetime(y,12,26)
    ];
end

function e = easterSunday(y)
% Compute Easter Sunday using the Meeus algorithm
% for the Gregorian calendar

    a = mod(y,19);
    b = floor(y/100);
    c = mod(y,100);
    d = floor(b/4);
    e1 = mod(b,4);
    f = floor((b+8)/25);
    g = floor((b-f+1)/3);
    h = mod(19*a + b - d - g + 15, 30);
    i = floor(c/4);
    k = mod(c,4);
    l = mod(32 + 2*e1 + 2*i - h - k, 7);
    m = floor((a + 11*h + 22*l)/451);
    monthE = floor((h + l - 7*m + 114)/31);
    dayE = mod(h + l - 7*m + 114, 31) + 1;

    e = datetime(y, monthE, dayE);
end