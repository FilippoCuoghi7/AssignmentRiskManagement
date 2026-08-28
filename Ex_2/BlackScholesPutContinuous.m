function [P, delta, gamma] = BlackScholesPutContinuous(S, K, r, q, sigma, T)
% BLACKSCHOLESPUTCONTINUOUS Computes the price, delta, and gamma of a European Put option
% using the Black-Scholes-Merton model with a continuous dividend yield.
%
% INPUTS:
%   S:     The current spot price of the underlying asset. (Can be a vector)
%   K:     The strike price of the option.
%   r:     The annualized risk-free interest rate.
%   q:     The annualized continuous dividend yield.
%   sigma: The annualized volatility of the underlying asset.
%   T:     The time to maturity in years (day-count convention is act/365).
%
% OUTPUTS:
%   P:     The calculated price of the European Put option.
%   delta: The first-order sensitivity of the put price to the underlying (Delta).
%   gamma: The second-order sensitivity of the put price to the underlying (Gamma).

% If exactly at maturity, the value is the intrinsic payoff
if T == 0
    P = max(K - S, 0);
    delta = -1 .* (S < K); % Delta is -1 if in-the-money, 0 otherwise
    gamma = zeros(size(S)); % Gamma collapses at maturity
    return;

% If the option has already expired, it is a dead contract and worthless
elseif T < 0
    P = zeros(size(S));
    delta = zeros(size(S));
    gamma = zeros(size(S));
    return;
end

% Calculate the d1 and d2 parameters
d1 = (log(S ./ K) + (r - q + 0.5 * sigma^2) * T) / (sigma * sqrt(T));
d2 = d1 - sigma * sqrt(T);

% Compute the Put price, delta, and gamma using the normal distributions
P = K * exp(-r * T) * normcdf(-d2) - S .* exp(-q * T) .* normcdf(-d1);

delta = -exp(-q*T) * normcdf(-d1);
gamma = (exp(-q*T) * normpdf(d1)) ./ (S .* sigma .* sqrt(T));

end