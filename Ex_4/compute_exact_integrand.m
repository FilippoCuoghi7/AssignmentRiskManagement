function out = compute_exact_integrand(y_vec, I, rec, Ku, Kd, rho, pd)
% COMPUTE_EXACT_INTEGRAND Calculates the probability-weighted tranche loss
% conditional on the systematic risk factor 'y'.
%
% INPUTS:
%   y_vec - A numerical vector representing the systematic risk factor values,
% provided by the quadgk integration function..
%   I     - The total number of obligors in the credit portfolio.
%   rec   - The average recovery rate upon defaults.
%   Ku    - The detachment point (upper bound) of the specific CDO tranche.
%   Kd    - The attachment point (lower bound) of the specific CDO tranche.
%   rho   - The correlation
%   pd    - The unconditional, individual probability of default for the assets.
%
% OUTPUT:
%   out   - A numerical vector of the exact same dimensions as y_vec.
%           Each element contains the computed conditional expected tranche
%           loss, weighted by the standard normal probability density of
%           the corresponding market state y.


phi_y = normpdf(y_vec);
p_y = normcdf((norminv(pd) - sqrt(rho)*y_vec) / sqrt(1 - rho));

% Initialize the running total for the sum_term
sum_term = zeros(size(y_vec));

% Store the original warning state and escalate ALL warnings to errors -->
% ww want to stop at the very first warning, not wait until it crashes.
oldWarnState = warning('error', 'MATLAB:nchoosek:LargeCoefficient');

% Loop over m (we want to find the exact I and m s.t. the function crashes)
for m = 0:I
    z = m / I; % Fraction of defaults

    % Tranche loss
    loss_m = min(max(((1 - rec) * z - Kd) / (Ku - Kd), 0), 1);

    % TRY-CATCH BLOCK FOR NCHOOSEK
    try
        % Because of warning('error', 'all'), the nchoosek warning will now trigger the catch block
        % Vectorized combinatorial math across all p_y simultaneously
        prob_m = nchoosek(I, m) * (p_y.^m) .* ((1 - p_y).^(I - m));

    catch ME
        % Restore the original warning state before we crash out
        warning(oldWarnState);

        fprintf('CRASH DETECTED: nchoosek failed at I = %d, m = %d.\n', I, m);
        fprintf('MATLAB Message: %s\n', ME.message);
        
        error('Binomial limit exceeded. Halting exact calculation.');
    end

    % Add the weighted loss to our running sum vector
    sum_term = sum_term + (prob_m * loss_m);
end

% Restore the original warning state if the loop actually finishes successfully
warning(oldWarnState);

% Final calculation
out = phi_y .* sum_term;

end