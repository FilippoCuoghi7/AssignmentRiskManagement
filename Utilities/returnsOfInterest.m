function [tSelected, returnsSelected, shareData] = returnsOfInterest(inputFile, refDate, timeWindow, sharesList, formatDate)
% RETURNSOFINTEREST Selects set of dates and returns in a lag of interest
%
% INPUTS:
% - inputFile:  complete excel file name (with path)
% - refDate:    first date of interest
% - timeWindow: in months
% - sharesList: list of the N Shares of Interest
% - formatDate: format used for dates (default 'mm/dd/yyyy')
%
% OUTPUTS:
% - tSelected:  vector with the T dates of interest
% - returnsSel: matrix with TxN returns values
%
% USES:
% - findSeries: given the set of data selects the asset of interest
% - dateAddMonth: adds to a month a given number of months
% - closestDate: selects the nearest (even the previous one) to a given date
% - underlyingCode: Converts share name in bbg code


if(nargin <5)
    formatDate = 'mm/dd/yyyy';
end

elementsBasket = size(sharesList,1);

% Scarico dati storici
shareData.cell = readcell(inputFile, 'Sheet', 'Data');

% Select the set of dates of interest: the ones in Eurostoxx50
[~, t_index]=findSeries(shareData,'SX5E Index', formatDate);

% refDate, endDate
refDate=datenum(refDate);
[refDate, idxStart] = closestDate(refDate, t_index);
endDate = dateAddMonth(refDate, timeWindow);
[~, idxEnd] = closestDate(endDate, t_index);

tSelected = t_index(idxStart:idxEnd);

% Prices of the selected shares
% If the value is not present I take the value from the previous date
valuesSelectedShares=zeros(idxEnd-idxStart+1,elementsBasket);

for i=1:elementsBasket

    bbgCode= underlyingCode(sharesList(i,:));
    % Select the shares of interest
    [values_share, t_share]=findSeries(shareData, bbgCode, formatDate);

    % For each underlying in the pft I check that it is present
    % in the time-interval of interest otherwise I take previous business day
    %%%%%%%%%%%%
    % ADD HERE %  VECTORIZE!

       % Vectorized 
    valuesSelectedShares(:, i) = interp1(t_share, values_share, tSelected, 'previous');
end
    %%%%%%%%%%%%

returnsSelected=log(valuesSelectedShares(2:end,:)./valuesSelectedShares(1:end-1,:));
tSelected = tSelected(2:end);

end %returnsOfInterest