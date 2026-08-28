function [newDate,idx]=closestDate(date,dateVec,adjRule)
% [newDate,idx]=closestDate(date,dateVec,adjRule)
% 
% It searches in an increasing vector of dates, that one closest to a give 
%  date (the same one if possible)
% The adjRule can be preceeding (default) or following.
%
% INPUT:
% - date: date to be searched
% - dateVec: reference dates vector
% - adjRule. 'p': preceding, 'f': following 
% 
% OUTPUT:
% - newDate: closest found date;
% - idx: index of the found date in the dateVec
%
% Last Modifified 10.04.17

%% minimum distance between date & dateVec
[diffAbsDate,idx]=min(abs(date-dateVec));
if (diffAbsDate ~= 0) %~(diffAbsDate == 0)
    diffDate=dateVec(idx)-date;  
    if ((nargin < 3)||strcmp(adjRule,'p')) %preceding & default adjRule
        if diffDate > 0
            idx = idx-1;
        end
    else %following
        if diffDate < 0
            idx = idx+1;
        end
    end 
%    datestr(date,'dd-mmm-yyyy') %TEST
%    datestr(dateVec(idx),'dd-mmm-yyyy') %TEST
end

newDate=dateVec(idx);

end % closestDate