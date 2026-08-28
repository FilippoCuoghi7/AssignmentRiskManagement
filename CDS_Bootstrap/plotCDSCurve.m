function [T_fine, S_fine_bps] = plotCDSCurve(T_nodes, S_nodes)
    % PLOTCDSCURVE Visualizes the Credit Default Swap (CDS) spread curve 
    % using cubic spline interpolation. It generates a smooth continuous 
    % curve from discrete market data points and plots the result.
    %
    % INPUTS:
    %   T_nodes : Vector of market maturities in years (e.g., [1; 2; 3; 4; 5; 7]).
    %   S_nodes : Vector of market CDS spreads in decimal format 
    %             (e.g., 0.0029 for 29 bps).
    %
    % OUTPUTS:
    %   T_fine     : Vector representing the fine time grid (monthly steps) 
    %                used for the interpolation.
    %   S_fine_bps : Vector of interpolated CDS spreads expressed in basis points.

    % 1. Generate a fine time grid for a smooth curve
    % We use a step of 1/12 to simulate monthly granularity between min and max maturities
    T_fine = min(T_nodes) : 1/12 : max(T_nodes);
    
    % 2. Perform Cubic Spline Interpolation
    % Interpolates the market spreads over the fine time grid
    S_fine = interp1(T_nodes, S_nodes, T_fine, 'spline');
    
    % 3. Initialize the figure window
    figure('Color', 'w', 'Name', 'CDS Bootstrap - Step A');
    hold on;
    
    % 4. Convert spreads from decimals to Basis Points (bps) for readability
    S_nodes_bps = S_nodes * 10000;
    S_fine_bps = S_fine * 10000;
    
    % 5. Plot the data
    % Plot the continuous spline curve (blue line)
    plot(T_fine, S_fine_bps, 'LineWidth', 2, 'Color', [0 0.447 0.741]); 
    
    % Plot the discrete market data points (red dots with black edges)
    plot(T_nodes, S_nodes_bps, 'ko', 'MarkerFaceColor', 'r', 'MarkerSize', 8);
    
    % 6. Apply formatting, labels, and legend
    grid on;
    xlabel('Maturity (Years)', 'FontWeight', 'bold');
    ylabel('Spread (bps)', 'FontWeight', 'bold');
    title('ISP CDS Spread Curve: Cubic Spline Interpolation', 'FontSize', 12);
    legend('Spline Interpolant', 'Market Spreads', 'Location', 'southeast');
    
    % Set axis limits for better visual presentation
    xlim([0, max(T_nodes) + 0.5]);
    ylim([min(S_nodes_bps) - 5, max(S_nodes_bps) + 5]);
    
    hold off;
end