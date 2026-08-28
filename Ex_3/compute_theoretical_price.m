function [Caplet_Values,Price] = compute_theoretical_price(M, ref_date, maturity_dates, ...
    stock, strike, r, q, sigma, delta_t)
% COMPUTE_THEORETICAL_PRICE Calculates the total theoretical price of a
% Cliquet option.
%
% INPUTS:
%   M                : Notional amount of the contract
%   ref_date         : The valuation date (datenum)
%   maturity_dates   : Vector of adjusted maturity dates (datetime)
%   stock            : The initial stock price
%   strike           : The strike price
%   r                : Vector of forward interest rates
%   q                : Continuous dividend yield
%   sigma            : Volatility
%   delta_t          : Vector of time fractions for each segment (ACT/365) 
%
% OUTPUTS:
%   Price            : The total theoretical price of the contract
%   Caplet_Values    : The price of each Caplet (ATM Call)

% Preallocate
T_start = zeros(size(maturity_dates));

% Compute the time from Ref_Date to the start of each segment
T_start(1) = 0; % First segment starts at Ref_Date.
for i = 2:length(maturity_dates)
        T_start(i) = yearfrac(ref_date, maturity_dates(i-1), 3);
end

% Compute the vector of Call prices (Normalized Unit Calls) for all segments simultaneously
Unit_Calls = BlackScholesCallContinuous(stock, strike, r, q, sigma, delta_t);

% Apply the Dividend Discount Factor
Discounted_Calls = exp(-q .* T_start) .* Unit_Calls;
Caplet_Values = Discounted_Calls;

% The total price is the sum of the individual options, scaled by M
Price = M * sum(Discounted_Calls);

end