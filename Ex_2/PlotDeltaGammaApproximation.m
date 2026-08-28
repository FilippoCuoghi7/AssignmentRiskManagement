function PlotDeltaGammaApproximation(S0, K, r, q, sigma, T)
% PLOTDELTAGAMMAAPPROXIMATION Visualizes the true Black-Scholes put option price
% curve against its linear (Delta) and quadratic (Delta-Gamma) approximations.
%
% INPUTS:
%   S0:    Current underlying spot price.
%   K:     Strike price of the put option.
%   r:     Annualized risk-free interest rate.
%   q:     Annualized continuous dividend yield.
%   sigma: Annualized volatility of the underlying asset.
%   T:     Time to maturity in years (act/365 convention).

% Create a range of hypothetical stock prices (+/- 15%)
S_range = linspace(S0 * 0.85, S0 * 1.15, 100);

% Calculate the exact B&S parameters for today (ATM)
[P0, delta0, gamma0] = BlackScholesPutContinuous(S0, K, r, q, sigma, T);

% Calculate the exact B&S curve across the whole range
[P_exact, ~, ~] = BlackScholesPutContinuous(S_range, K, r, q, sigma, T);

% Compute the 1st order (Delta) and 2nd order (Delta-Gamma) Approximations
P_Delta = P0 + delta0 .* (S_range - S0);
P_DeltaGamma = P0 + delta0 .* (S_range - S0) + 0.5 * gamma0 .* (S_range - S0).^2;

figure;
plot(S_range, P_exact, 'b-', 'LineWidth', 2); hold on;
plot(S_range, P_Delta, 'r--', 'LineWidth', 2);
plot(S_range, P_DeltaGamma, 'g-.', 'LineWidth', 2);

% Mark the current ATM spot price
plot(S0, P0, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k');

grid on;
title('ATM Put Option Price: True Curve vs. Approximations');
xlabel('Underlying Stock Price (S)');
ylabel('Put Option Price (P)');
legend('True B&S Price', 'Delta Approx (Tangent Line)', 'Delta-Gamma Approx (Parabola)', 'Current Spot (ATM)', 'Location', 'Best');
hold off;

end