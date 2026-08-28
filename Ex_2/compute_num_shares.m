function [numShares, value_stock] = compute_num_shares(shareData, date, assetName, notional)
% COMPUTE_NUM_SHARES Calculates the required number of shares for a specific
% asset to match a target notional value on a given date.
%
% INPUTS:
%   shareData: A structure containing the imported market data.
%   date:      The target evaluation date to find the price.
%   assetName: A string representing the common name of the asset.
%   notional:  The total monetary value allocated to this specific asset.
%
% OUTPUTS:
%   numShares: The calculated number of shares.

% Convert the target date string to a MATLAB serial date number
targetDate = datenum(date);

% Translate the common asset name to its Bloomberg code
bbgCode = underlyingCode(assetName);

% Extract the historical price series and corresponding dates for the asset
[values_share, t_share, ~] = findSeries(shareData, bbgCode);

% Find the index of the exact target date (or the closest available previous date)
[~, idx] = closestDate(targetDate, t_share);

% Calculate the number of shares by dividing the notional by the asset's price
numShares = round(notional / values_share(idx));
value_stock = values_share(idx);

end