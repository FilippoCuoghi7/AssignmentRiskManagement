function zero_rates = fromDiscountFactorsToZeroRates(refDate, dates, discount_factors)
% FROMDISCOUNTFACTORSTOZERORATES Converts discount factors 
% to zero-coupon rates. The function uses an ACT/365 day count convention
% to determine the time to maturity for each node.

%   Input arguments:
%     refDate : Reference date (Settlement Date) of the curve.
%     dates : Vector of dates corresponding to the discount factors (including refDate).
%     discount_factors : Vector of discount factors (DF) for each date.
%
%   Output arguments:
%     zero_rates : Vector of continuously compounded zero rates calculated starting from the second node (excluding refDate).

    % Calculate time to maturity in years (ACT/365) starting from the second node
    T = yearfrac(refDate, dates(2:end), 3); 
    df_val = discount_factors(2:end);
    
    % Continuous compounding formula: DF = exp(-z * T), solving for z: z = -ln(DF) / T
    zero_rates = -log(df_val) ./ T;
end