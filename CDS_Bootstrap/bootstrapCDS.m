function [datesCDS, survProbs, intensities] = bootstrapCDS(datesDF, discounts, datesCDS, spreadsCDS, flag, recovery)
%BOOTSTRAPCDS Bootstrap CDS survival probabilities and piecewise intensities.
%   This function bootstraps survival probabilities and piecewise-constant
%   hazard rates from market CDS spreads under three alternative pricing
%   conventions:
%       0 = Approximate (accrual term neglected)
%       1 = Exact (accrual included, default at mid-period)
%       2 = Jarrow-Turnbull (continuous premium, marginal lambda extraction)
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
%   datesCDS : double vector
%       CDS maturities expressed in years.
%
%   spreadsCDS : double vector
%       Market CDS spreads in decimal form.
%
%   flag : integer
%       Bootstrap method selector:
%           0 -> Approximate
%           1 -> Exact
%           2 -> Jarrow-Turnbull
%
%   recovery : double
%       Constant recovery rate.
%
%   Outputs
%   -------
%   datesCDS : double column vector
%       CDS maturities in years.
%
%   survProbs : double column vector
%       Bootstrapped survival probabilities at each CDS maturity.
%
%   intensities : double column vector
%       Piecewise-constant hazard rates for each interval.

    datesCDS   = datesCDS(:);
    spreadsCDS = spreadsCDS(:);
    discounts  = discounts(:);
    datesDF    = datesDF(:);

    if numel(datesCDS) ~= numel(spreadsCDS)
        error('Input vectors "datesCDS" and "spreadsCDS" must have the same length.');
    end

    if numel(datesDF) ~= numel(discounts)
        error('Input vectors "datesDF" and "discounts" must have the same length.');
    end

    if ~isdatetime(datesDF)
        error('Input "datesDF" must be a datetime vector.');
    end

    if any(diff(datesCDS) <= 0)
        error('"datesCDS" must be strictly increasing.');
    end

    if any(discounts <= 0)
        error('All discount factors must be strictly positive.');
    end

    if recovery < 0 || recovery >= 1
        error('"recovery" must satisfy 0 <= recovery < 1.');
    end

    if ~ismember(flag, [0, 1, 2])
        error('Invalid flag. Use 0 (Approx), 1 (Exact), or 2 (JT).');
    end

    switch flag
        case 0
            [survProbs, intensities] = bootstrapCDSDiscretePremium( ...
                datesDF, discounts, datesCDS, spreadsCDS, recovery, false);

        case 1
            [survProbs, intensities] = bootstrapCDSDiscretePremium( ...
                datesDF, discounts, datesCDS, spreadsCDS, recovery, true);

        case 2
            [survProbs, intensities] = bootstrapCDSJarrowTurnbull( ...
                datesDF, datesCDS, spreadsCDS, recovery);
    end
end
