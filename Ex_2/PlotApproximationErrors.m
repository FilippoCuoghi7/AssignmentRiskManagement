function PlotApproximationErrors(S0, K, r, q, sigma, T)
% PLOTAPPROXIMATIONERRORS Plots the estimation error of the Delta
% and Delta-Gamma approximations compared to the exact B&S model for
% computing the Loss distribution.
%
% INPUTS:
%   S0:    Current underlying spot price.
%   K:     Strike price of the put option.
%   r:     Annualized risk-free interest rate.
%   q:     Annualized continuous dividend yield.
%   sigma: Annualized volatility of the underlying asset.
%   T:     Time to maturity in years (act/365 convention).

% Define range (+/- 15% to guarantee we see the curvature)
dS = linspace(-S0 * 0.15, S0 * 0.15, 100);
S_range = S0 + dS;

% Get today's Greeks and Exact Prices
[P0, delta0, gamma0] = BlackScholesPutContinuous(S0, K, r, q, sigma, T);
[P_exact, ~, ~] = BlackScholesPutContinuous(S_range, K, r, q, sigma, T);

% Compute the Losses
Loss_exact = - (P_exact - P0);
Loss_Delta = - delta0 .* dS;
Loss_DeltaGamma = - (delta0 .* dS + 0.5 * gamma0 .* (dS.^2));

% Compute the Errors
Error_Delta = Loss_Delta - Loss_exact;
Error_DeltaGamma = Loss_DeltaGamma - Loss_exact;

figure;

% Plot the exact baseline (zero error)
yline(0, 'b-', 'LineWidth', 2); hold on;

% Plot the errors
plot(dS, Error_Delta, 'r--', 'LineWidth', 2);
plot(dS, Error_DeltaGamma, 'g-.', 'LineWidth', 2);

grid on;
title('Approximation Error: Delta vs. Delta-Gamma');
xlabel('Change in Underlying Stock Price (\Delta S)');
ylabel('Estimation Error (Approx - Exact)');
legend('True B&S (Zero Error Baseline)', 'Error of Delta Approx', 'Error of Delta-Gamma Approx', 'Location', 'Best');
hold off;

end