function out = compute_KL_integrand(z_vec, I, rec, Ku, Kd, rho, pd)
% COMPUTE_KL_INTEGRAND Calculates probability-weighted tranche loss
% using the Kullback-Leibler approximation for a homogeneous portfolio.
%
% INPUTS:
%   z_vec - A numerical vector of default fractions provided by the quadgk integration function.
%   I     - The total number of obligors in the credit portfolio.
%   rec   - The average recovery rate upon defaults.
%   Ku    - The detachment point (upper bound) of the specific CDO tranche.
%   Kd    - The attachment point (lower bound) of the specific CDO tranche.
%   rho   - The correlation
%   pd    - The unconditional, individual probability of default for the assets.
%
% OUTPUT:
%   out   - A numerical vector of the exact same dimensions as z_vec.
%           Each element contains the computed tranche loss for that 
%           specific default fraction z, weighted by the unconditional 
%           probability density of z.

% Pre-allocate the output vector to the size of quadgk's z_vec
out = zeros(size(z_vec));

% Discretize y in (-6, 6)
N = 10000; % Number of grid points
y_vec = linspace(-6, 6, N);

% Prepare the step size for the Rectangular sum
% dy = y_vec(2) - y_vec(1); <-- we didn't use the Rectangular sum.

phi_y = normpdf(y_vec);
p_y = normcdf((norminv(pd) - sqrt(rho) * y_vec) / sqrt(1 - rho));

for i = 1:length(z_vec)
    z = z_vec(i);
    
    % Guard against extreme boundaries
    % The KL density goes to infinity exactly at z=0 and z=1.
    % Skip these boundaries to avoid NaN errors.
    if z <= 0 || z >= 1
        out(i) = 0;
        continue;
    end

    % Compute Kullback-Leibler divergence: KL(z || p_y)
    KL_div = z * log(z ./ p_y) + (1 - z) * log((1 - z) ./ (1 - p_y));

    % Compute conditional density f(z|y) using the KL approximation
    f_z_y = sqrt(I / (2 * pi * z * (1 - z))) * exp(-I * KL_div);

    % Integrate over 'y' using a Trapezoidal sum to get f(z).
    f_z = trapz(y_vec, f_z_y .* phi_y);

    % (Alternative Rectangular sum: f_z = sum(f_z_y .* phi_y) * dy;)

    % Compute the tranche loss for this fraction of defaults z
    loss_z = min(max(((1 - rec) * z - Kd) / (Ku - Kd), 0), 1);

    % Multiply the loss by the unconditional probability density of z
    out(i) = f_z * loss_z;
end
end