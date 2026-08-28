function [survProbs, intensities] = bootstrapCDSDiscretePremium(datesDF, discounts, datesCDS, spreadsCDS, recovery, includeAccrual)
%BOOTSTRAPCDSDISCRETEPREMIUM Bootstrap CDS curve with discrete premium payments.
%   This function bootstraps survival probabilities under a piecewise-
%   constant hazard-rate assumption using quoted CDS spreads and discount
%   factors at CDS maturities.
%
%   Two variants are supported:
%       includeAccrual = false -> Approximate method
%       includeAccrual = true  -> Exact method with accrual at mid-period
%
%   Inputs
%   ------
%   datesDF : datetime vector
%       Dates of the discount curve. The first element is the reference
%       date.
%
%   discounts : double vector
%       Discount factors corresponding to datesDF.
%
%   datesCDS : double column vector
%       CDS maturities expressed in years.
%
%   spreadsCDS : double column vector
%       Market CDS spreads in decimal form.
%
%   recovery : double
%       Constant recovery rate.
%
%   includeAccrual : logical scalar
%       If true, include accrued premium upon default using the standard
%       mid-period approximation. If false, neglect the accrual term.
%
%   Outputs
%   -------
%   survProbs : double column vector
%       Bootstrapped survival probabilities at each CDS maturity.
%
%   intensities : double column vector
%       Piecewise-constant hazard rates for each interval.

    N = numel(datesCDS);
    refDate = datesDF(1);

    % Build absolute CDS maturity dates from calendar-year tenors
    % and apply TARGET Following adjustment
    absDatesCDS = refDate + calyears(datesCDS);
    absDatesCDS = arrayfun(@(d) adjustTargetBusinessDay(d, 'following'), absDatesCDS(:));
    absDatesCDS = absDatesCDS(:);

    % ACT/365 year fractions and interval lengths
    cdsTimes = yearfrac(refDate, absDatesCDS, 3);
    cdsTimes = cdsTimes(:);

    % Boundary condition:T0 = 0
    dt = diff([0; cdsTimes]);    
    B = getDiscountFactorByZeroRatesLinearInterp(refDate, absDatesCDS, datesDF, discounts);
    B = B(:);

    % Extended survival vector:
    % Pext(1) = P0 = 1
    % Pext(i+1) = P(T_i)
    Pext = zeros(N + 1, 1);
    Pext(1) = 1;

    for i = 1:N
        S_i = spreadsCDS(i);
        dt_i = dt(i);

        % Previous nodes:
        % P_prev       = P(T_1), ..., P(T_{i-1})
        % P_prev_shift = P(0),   ..., P(T_{i-2})
        % B_prev       = B(T_1), ..., B(T_{i-1})
        % dt_prev      = dt_1,   ..., dt_{i-1}
        P_prev       = Pext(2:i);
        P_prev_shift = Pext(1:i-1);
        B_prev       = B(1:i-1);
        dt_prev      = dt(1:i-1);

        premiumPast = S_i * sum(dt_prev .* B_prev .* P_prev);
        protectionPast = (1 - recovery) * sum(B_prev .* (P_prev_shift - P_prev));

        if includeAccrual
            accrualPast = 0.5 * S_i * sum(dt_prev .* B_prev .* (P_prev_shift - P_prev));
        else
            accrualPast = 0;
        end

        P_im1 = Pext(i);
        B_i   = B(i);

        if includeAccrual
            numerator = protectionPast - premiumPast - accrualPast + ...
                        B_i * P_im1 * (1 - recovery - 0.5 * S_i * dt_i);

            denominator = B_i * (1 - recovery + 0.5 * S_i * dt_i);
        else
            numerator = protectionPast - premiumPast + ...
                        (1 - recovery) * B_i * P_im1;

            denominator = B_i * (S_i * dt_i + 1 - recovery);
        end

        Pext(i+1) = numerator / denominator;
    end

    survProbs = Pext(2:end);
    intensities = -log(Pext(2:end) ./ Pext(1:end-1)) ./ dt;
end
