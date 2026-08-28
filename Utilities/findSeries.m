function [values, date, CompleteName] = findSeries(equityData, assetName, formatDate)
% FINDSERIES Extracts the dates and price series for a specific asset from a dataset.
%
% INPUTS:
%   equityData:   A structure containing the imported spreadsheet data (must contain a .cell field).
%   assetName:    A string representing the target asset's name to search for in the headers.
%   formatDate:   (Optional) A string specifying the date format. Defaults to 'mm/dd/yyyy'.
%
% OUTPUTS:
%   values:       A numeric column vector containing the extracted valid prices.
%   date:         A numeric column vector containing the extracted dates in MATLAB serial date format.
%   CompleteName: A string containing the exact matched header name from the dataset.

if nargin < 3
    formatDate = 'mm/dd/yyyy';
end

cellData = equityData.cell;
CompleteName = '';
row = []; col = [];

% Trova l'intestazione
for c = 1:size(cellData, 2)
    for r = 1:size(cellData, 1)
        val = cellData{r, c};
        if ischar(val) && ~isempty(strfind(val, assetName))
            row = r; col = c; CompleteName = val; break;
        end
    end
    if ~isempty(row), break; end
end

if isempty(CompleteName)
    error(['Titolo "' assetName '" non trovato.']);
end

% Estrai date e prezzi grezzi
rawDates = cellData(row+1:end, col);
rawPrices = cellData(row+1:end, col+1);

% Filtro per mantenere solo i dati validi
validIdx = false(length(rawPrices), 1);
for i = 1:length(rawPrices)
    val = rawPrices{i};
    if ischar(val)
        val = strrep(val, ',', '.');
        val = str2double(val);
        rawPrices{i} = val;
    end
    if isnumeric(val) && ~isnan(val)
        validIdx(i) = true;
    end
end

if sum(validIdx) == 0
    disp(['ERRORE SILENZIOSO: Nessun prezzo valido per ', assetName]);
    values = []; date = []; return;
end

rawDates = rawDates(validIdx);
values = cell2mat(rawPrices(validIdx));

% Converti Date a prova di bomba
date = zeros(length(rawDates), 1);
for i = 1:length(rawDates)
    d = rawDates{i};

    % Se MATLAB è stato intelligente e ha creato un oggetto datetime
    if isdatetime(d)
        date(i) = datenum(d);

        % Se è testo (singoli o doppi apici)
    elseif ischar(d) || isstring(d)
        d = char(d);
        d = strrep(d, ',', '.');
        numD = str2double(d);
        if ~isnan(numD)
            date(i) = numD + 693960; % Formato Seriale Excel
        else
            date(i) = datenum(d); % Lascia indovinare il formato a MATLAB
        end

        % Se è un numero
    elseif isnumeric(d)
        if d < 100000
            date(i) = d + 693960; % Converti da Excel a MATLAB
        else
            date(i) = d; % E' già un numero seriale MATLAB corretto!
        end
    end
end
end