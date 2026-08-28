function [survProbs, intensities] = bootstrapCDSJarrowTurnbull(datesDF, datesCDS, spreadsCDS, recovery)
%BOOTSTRAPCDSJARROWTURNBULL Bootstrap CDS survival probabilities and
% piecewise intensities using the Jarrow-Turnbull method.
%   This method assumes continuous premium payment and extracts the
%   marginal piecewise-constant hazard rate from the term structure of
%   CDS spreads.
%
%   Day count convention for CDS times: ACT/365
%
%   Inputs
%   ------
%   datesDF : datetime vector
%       Dates of the discount curve. The first element is the reference
%       date.
%
%   datesCDS : double column vector
%       CDS maturities expressed as calendar-year tenors
%       (e.g. [1; 2; 3; 5; 7; 10]).
%
%   spreadsCDS : double column vector
%       Market CDS spreads in decimal form.
%
%   recovery : double
%       Constant recovery rate.
%
%   Outputs
%   -------
%   survProbs : double column vector
%       Bootstrapped survival probabilities at each CDS maturity.
%
%   intensities : double column vector
%       Piecewise-constant hazard rates for each interval.
%
%   cdsTimes : double column vector
%       CDS maturities expressed as ACT/365 year fractions.

    refDate = datesDF(1);

    datesCDS   = datesCDS(:);
    spreadsCDS = spreadsCDS(:);

    % Build absolute CDS maturity dates from calendar-year tenors
    % and apply TARGET Following adjustment
    absDatesCDS = refDate + calyears(datesCDS);
    absDatesCDS = arrayfun(@(d) adjustTargetBusinessDay(d, 'following'), absDatesCDS(:));
    absDatesCDS = absDatesCDS(:);

    % ACT/365 year fractions and interval lengths
    cdsTimes = yearfrac(refDate, absDatesCDS, 3);
    cdsTimes = cdsTimes(:);

    % Boundary conditions:
    % T0 = 0, S0 = 0
    T = [0; cdsTimes];
    S = [0; spreadsCDS];
    dt = diff(T);

    intensities = diff(S .* T) ./ ((1 - recovery) .* dt);
    survProbs = exp(-cumsum(intensities .* dt));
end