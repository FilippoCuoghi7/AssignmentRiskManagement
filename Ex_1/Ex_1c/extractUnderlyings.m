function sharesList = extractUnderlyings(filename, maxShares)
% EXTRACTUNDERLYINGS Extracts a specific number of share names from a given .m file.
%
% INPUTS:
%   filename:  A string representing the name of the file to read.
%   maxShares: The maximum number of shares to extract.
%
% OUTPUTS:
%   sharesList: A cell array containing the extracted share names.


% Open the file
fid = fopen(filename, 'r');
if fid == -1
    error('Could not open %s. Check if it is in your current folder!', filename);
end

% Preallocate a cell array
sharesList = cell(maxShares, 1);
count = 0;

% Read the file line by line
while ~feof(fid)
    line = fgetl(fid);

    % REGEX: Looks specifically for strcmp(underlyingName, 'Name')
    tokens = regexp(line, 'strcmp\(underlyingName,\s*''(.*?)''\)', 'tokens');

    if ~isempty(tokens)
        assetName = tokens{1}{1};

        % Skip the 'Eurostoxx' index because we only want the individual equity shares
        if strcmp(assetName, 'Eurostoxx')
            continue;
        end

        % Add the share to our list
        count = count + 1;
        sharesList{count} = assetName;

        % Stop immediately once we hit the max number or 'FT' (France Telecom) [cite: 15]
        if count == maxShares || strcmp(assetName, 'FT')
            break;
        end
    end
end
fclose(fid);

% Clean up empty cells (just in case the loop stopped before reaching maxShares)
sharesList = sharesList(1:count);

end