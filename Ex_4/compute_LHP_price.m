function P = compute_LHP_price(rec, Ku, Kd, rho, pd, dates, discounts, refDate, interpDate)
% COMPUTE_EXACT_PRICE Calculates the present value (price) of a CDO tranche
% as a percentage of its face value using the Large Homodgeneous Portfolio (LHP) approximation.
%
% INPUTS:
%   rec        - A decimal representing the uniform recovery rate.
%   Ku         - Detachment point (upper bound) of the CDO tranche.
%   Kd         - Attachment point (lower bound) of the CDO tranche.
%   rho        - Uniform pairwise asset correlation.
%   pd         - Unconditional, individual probability of default.
%   dates      - An array of numerical dates representing the maturity pillars
%                of the market yield curve.
%   discounts  - An array of discount factors corresponding to the yield curve 'dates'.
%   refDate    - The current valuation date (settlement date).
%   interpDate - The maturity date of the tranche (when the payoff occurs).
%
% OUTPUT:
%   P          - A decimal value representing the present value (price) of
%                the tranche, expressed as a percentage of the face value.

% Create an anonymous function locking in the portfolio parameters
integrand_LHP = @(z) compute_LHP_integrand(z, rec, Ku, Kd, rho, pd);

% Calculate the unconditional expected tranche loss (as a percentage)
LHP_expected_tranche_loss = quadgk(integrand_LHP, 0, 1); % exact formula,
% but can cause some problems close to 0 and 1, since norminv(z) goes to
% -inf and +inf --> normpdf goes to 0: 0/0 errors. Handle it in the
% 'compute_LHP_integrand'.

% Extract the discount factor for the maturity date
df = getDiscountFactorByZeroRatesLinearInterp(refDate, interpDate, dates, discounts);

% Compute the final present value of the surviving principal
P = df * (1 - LHP_expected_tranche_loss);

end