function [VaR, details] = DeltaHistoricalVaR(alpha, numberOfShares, numberOfPuts, ...
    stockPrice, strike, rate, dividendYield, volatility, TTMinYears, ...
    riskMeasureTimeIntervalInDays, returns)
% DELTAHISTORICALVAR Computes the Value at Risk (VaR) for a mixed portfolio
% of stocks and put options using a Delta-Historical approximation approach.
%
% INPUTS:
%   alpha:                         The confidence level for the VaR.
%   numberOfShares:                The total number of underlying shares held.
%   numberOfPuts:                  The total number of put options held.
%   stockPrice:                    The current spot price of the underlying.
%   strike:                        The strike price of the put options.
%   rate:                          The annualized risk-free interest rate.
%   dividendYield:                 The annualized continuous dividend yield.
%   volatility:                    The annualized volatility of the underlying.
%   TTMinYears:                    The current time to maturity in years.
%   riskMeasureTimeIntervalInDays: The VaR horizon in days.
%   returns:                       A vector of historical daily log returns.
%
% OUTPUTS:
%   VaR:                           The calculated Delta-Approximated Value at Risk.
%   details:                       A struct containing intermediate delta and loss data for reporting.

% Compute the delta of the portfolio today
S0 = stockPrice;
[~, delta_P0, ~] = BlackScholesPutContinuous(S0, strike, rate, dividendYield, volatility, TTMinYears);
delta_V0 = numberOfShares * 1 + numberOfPuts * delta_P0;

% Simulate the underlying asset for tomorrow
S_sim = S0 .* exp(returns);

% Compute the difference in the Stock
dS = S_sim - S0;

% Compute the losses
Losses = - delta_V0 * dS;

% Order losses in descending order (largest losses at the top)
Losses_ordered = sort(Losses, 'descend');

% Find the index corresponding to the confidence level
numScenarios = length(returns);
index_VaR = floor(numScenarios * (1 - alpha));

% Safety check: ensure index is at least 1
if index_VaR < 1
    index_VaR = 1;
end

% Extract the VaR 1-day
VaR_1day = Losses_ordered(index_VaR);

% Scale the VaR to the requested time horizon
VaR = VaR_1day * sqrt(riskMeasureTimeIntervalInDays);

% Package the details struct
details = struct();

details.S0 = S0;                                 % Initial stock price
details.delta_P0 = delta_P0;                     % Initial put option delta
details.delta_V0 = delta_V0;                     % Total portfolio delta
details.S_sim = S_sim;                           % Vector of simulated stock prices
details.dS = dS;                                 % Vector of simulated stock price changes
details.Losses = Losses;                         % Vector of unsorted simulated losses
details.VaR = VaR;                               % The final calculated VaR
details.alpha = alpha;                           % Confidence level
details.horizon = riskMeasureTimeIntervalInDays; % Time horizon
details.Losses_ordered = Losses_ordered;         % Vector of sorted losses
details.index_VaR = index_VaR;                   % The row index where VaR was extracted
details.numScenarios = numScenarios;             % Total number of scenarios run
details.VaR_1day = VaR_1day;                     % The unscaled 1-day VaR

end