function [dates, rates] = readExcelData(filename, formatData)
    % Read the entire worksheet as 'raw' data to keep full control
    [~, ~, raw] = xlsread(filename, 1);

    %% Internal utility function for date parsing
    % Handles: strings, Excel serial numbers, and empty cells
    function d = parseDate(val)
        if isempty(val) || (isnumeric(val) && isnan(val))
            d = NaN;
        elseif ischar(val) || isstring(val)
            % If the value is text, use datenum with the specified format
            d = datenum(val, formatData);
        elseif isnumeric(val)
            % IF IT IS A NUMBER: Excel uses the 1900 date system,
            % while MATLAB uses a different base date.
            % The 'x2mdate' function converts correctly between the two.
            d = x2mdate(val); 
        else
            d = NaN;
        end
    end

    %% Date extraction
    % Settlement (E8 -> row 8, column 5)
    dates.settlement = parseDate(raw{8, 5});

    % Deposits (D11:D18 -> rows 11-18, column 4)
    dates.depos = cellfun(@parseDate, raw(11:18, 4));

    % Futures (Q12:R20 -> columns 17 and 18)
    dates.futures(:,1) = cellfun(@parseDate, raw(12:20, 17));
    dates.futures(:,2) = cellfun(@parseDate, raw(12:20, 18));

    % Swaps (D39:D88 -> rows 39-88, column 4)
    dates.swaps = cellfun(@parseDate, raw(39:88, 4));

    %% Rate extraction
    % Use cell2mat to convert numeric values from cells
    % Deposits (E11:F18)
    rates.depos = cell2mat(raw(11:18, 5:6)) / 100;
    
    % Futures (E28:F36) -> Rate = (100 - Price)/100
    prezzi_futures = cell2mat(raw(28:36, 5:6));
    rates.futures = (100 - prezzi_futures) / 100;
    
    % Swaps (E39:F88)
    rates.swaps = cell2mat(raw(39:88, 5:6)) / 100;

end