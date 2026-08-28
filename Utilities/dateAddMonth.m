function fdate = dateAddMonth(startDate, num)
% Adds a number of months to a given date 
%
% INPUTS:
%  startDate
%  num: number of months
%
% OUTPUT:
%  the date of interest
%
% Last Modified: 24.03.2014 R. Baviera 

s = size(num);
if (s(1)==1)
    num = num';
    n = s(2);
else
    n = s(1);
end

if ischar(startDate)
    startDate = datenum(startDate);
end

startDate = repmat(startDate,n,1);

t = datevec(startDate);
t(:,1) = t(:,1)+dividi12(t(:,2)+num);
t(:,2)= resto12(t(:,2)+num);
t(:,3) = min(t(:,3),eomday(t(:,1),t(:,2)));

fdate = datenum(t);

end % function dateAddMonth

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function d = dividi12(x)
d = floor((x-1)/12) ;
end % function dividi12

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function r = resto12(x)
r = mod(x-1,12)+1 ;
end % function resto12
