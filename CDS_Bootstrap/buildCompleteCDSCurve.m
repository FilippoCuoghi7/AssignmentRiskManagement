function [T_complete, S_complete_dec] = buildCompleteCDSCurve(T_nodes, S_bps_nodes)
    % BUILDCOMPLETECDSCURVE Interpolates the missing 6-year node, 
    % sorts the maturities, and converts spreads to decimal format.
    %
    % Inputs:
    %   T_nodes: Column vector of market maturities (e.g., 1, 2, 3, 4, 5, 7)
    %   S_bps_nodes: Column vector of market spreads in basis points
    %
    % Outputs:
    %   T_complete: Sorted column vector with all maturities (1:7)
    %   S_complete_dec: Sorted column vector of spreads in decimals
    
    % Ensure inputs are column vectors
    T_nodes = T_nodes(:);
    S_bps_nodes = S_bps_nodes(:);

    % 1. Calculate the interpolated spread (spline) for year 6
    S_6_bps = interp1(T_nodes, S_bps_nodes, 6, 'spline');
    
    % 2. Append the 6th year at the end of the vectors
    T_complete = [T_nodes; 6];
    S_complete_bps = [S_bps_nodes; S_6_bps];
    
    % 3. Sort the vectors based on maturities (T)
    [T_complete, sortIdx] = sort(T_complete); 
    S_complete_bps = S_complete_bps(sortIdx);
    
    % 4. Convert spreads to decimals for pricing purposes
    S_complete_dec = S_complete_bps / 10000;
end