function [portfolioValue, weights] = compute_ptf_value(shareData, sharesList, num_shares, end_date)
% COMPUTE_PTF_VALUE Calculates the total portfolio value and individual asset weights
%
% INPUTS:
% - shareData:  The data struct pre-loaded from Excel (shareData.cell)
% - sharesList: Cell array or string matrix of company names
% - num_shares: Vector containing the number of shares for each company
% - end_date:   The evaluation date 
%
% OUTPUTS:
% - portfolioValue: Total value of the portfolio on the end_date
% - weights:        Vector of weights for each asset (sums to 1)

% Convert the target date to MATLAB serial date number if it's a string
targetDate = datenum(end_date);

% Initialize variables
numAssets = length(sharesList);
positionValues = zeros(numAssets, 1);

% Loop through each asset to find its specific value on the target date
for i = 1:numAssets

    if iscell(sharesList)
        assetName = sharesList{i};
    else
        assetName = sharesList(i, :);
    end

    % Translate the common name to the Bloomberg code
    bbgCode = underlyingCode(assetName);

    % Extract historical prices and dates for this specific asset
    [values_share, t_share, ~] = findSeries(shareData, bbgCode);

    % Find the exact (or closest previous) date index
    [~, idx] = closestDate(targetDate, t_share);

    % Calculate the monetary value of this position (Price * Number of Shares)
    positionValues(i) = values_share(idx) * num_shares(i);

end

% Total portfolio value is the sum of all individual positions
portfolioValue = sum(positionValues);

% Weights are the individual position values divided by the total portfolio value
weights = positionValues / portfolioValue;

end




