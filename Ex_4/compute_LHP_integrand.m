function out = compute_LHP_integrand(z_vec, rec, Ku, Kd, rho, pd)
% COMPUTE_LHP_INTEGRAND Calculates the probability-weighted tranche loss
% under the Vasicek Large Homogeneous Portfolio (LHP) approximation.
%
% INPUTS:
%   z_vec - A numerical vector of default fractions provided by the quadgk integration function.
%   rec   - Uniform recovery rate upon default.
%   Ku    - Detachment point (upper bound) of the specific CDO tranche.
%   Kd    - Attachment point (lower bound) of the specific CDO tranche.
%   rho   - Uniform pairwise asset correlation (between 0 and 1).
%   pd    - Unconditional, individual probability of default.
%
% OUTPUT:
%   out   - A numerical vector of the expected tranche losses weighted
%           by the Vasicek probability density for each loss fraction z.

% LHP Probability Density (phi_z)
y_bar = (norminv(pd) - sqrt(1 - rho) * norminv(z_vec)) / sqrt(rho);

phi_z = sqrt((1 - rho) / rho) .* normpdf(-y_bar) ./ normpdf(norminv(z_vec));

% Tranche Loss Calculation
loss_z = min(max(((1 - rec) .* z_vec - Kd) / (Ku - Kd), 0), 1);

% Final Expected Value Calculation
out = phi_z .* loss_z;

% Guard against extreme boundaries
% If z exactly equals 0 or 1, norminv(z) yields -Inf or Inf, which
% creates NaNs (Not-a-Number) in the math. This converts them to 0 loss.
out(isnan(out)) = 0;

end