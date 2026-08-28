function C = BlackScholesCallContinuous(S, K, r, q, sigma, T)
% BLACKSCHOLESCALLCONTINUOUS Computes the price of a European Call option
% using the Black-Scholes-Merton model with a continuous dividend yield.
%
% INPUTS:
%   S:     The current spot price (Scalar or Vector)
%   K:     The strike price of the option (Scalar)
%   r:     The annualized risk-free interest rate (Scalar or Vector)
%   q:     The annualized continuous dividend yield (Scalar)
%   sigma: The annualized volatility of the underlying asset (Scalar)
%   T:     The time to maturity in years (Scalar or Vector)
%
% OUTPUTS:
%   C:     The calculated price of the European Call option.

% Create a dummy variable to automatically broadcast S, r, and T to the same size
broadcast_size = S .* r .* T;
C = zeros(size(broadcast_size));

% Expand variables to uniform sizes to prevent indexing mismatch
S_full = S + zeros(size(C));
r_full = r + zeros(size(C));
T_full = T + zeros(size(C));

% Identify the valid indices where T > 0
valid = T_full > 0;

% Extract only the valid elements for the Black-Scholes formula
S_v = S_full(valid);
r_v = r_full(valid);
T_v = T_full(valid);

% Calculate d1 and d2 only for valid T
d1 = (log(S_v ./ K) + (r_v - q + 0.5 * sigma^2) .* T_v) ./ (sigma .* sqrt(T_v));
d2 = d1 - sigma .* sqrt(T_v);

% Compute the Call price and place it in the correct spots of C
C(valid) = S_v .* exp(-q .* T_v) .* normcdf(d1) - K .* exp(-r_v .* T_v) .* normcdf(d2);

% Handle boundary cases (T == 0)
zero_mask = (T_full == 0);
C(zero_mask) = max(S_full(zero_mask) - K, 0);

% T < 0 is implicitly handled because we initialized C with zeros,
% so any dead contracts simply remain 0.

end