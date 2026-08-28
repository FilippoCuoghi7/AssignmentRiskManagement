function [VaR, details] = FullMonteCarloVaR(alpha, numberOfShares, ...
    numberOfPuts, stockPrice, strike, rate, dividendYield, volatility, ...
    TTMinYears, riskMeasureTimeIntervalInDays, returns)
% FULLMONTECARLOVAR Computes the Value at Risk (VaR) for a mixed portfolio
% of stocks and put options using a Full Valuation Historical Simulation approach.
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
%   returns:                       A vector of historical daily log returns used for scenarios.
%
% OUTPUTS:
%   VaR:                           The calculated Full Valuation Value at Risk.
%   details:                       A struct containing intermediate pricing and loss data for reporting.

% Compute the value of the portfolio today
S0 = stockPrice;
[P0, ~] = BlackScholesPutContinuous(S0, strike, rate, dividendYield, volatility, TTMinYears);
V0 = (numberOfShares * S0) + (numberOfPuts * P0);

% Simulate the underlying asset for the horizon (generalized version)
scaled_returns = returns .* sqrt(riskMeasureTimeIntervalInDays);
S_sim = S0 .* exp(scaled_returns);

% Reprice the portfolio for each scenario (reduce Time to Maturity by the risk horizon)
TTM_sim = TTMinYears - (riskMeasureTimeIntervalInDays / 365);

% Already vectorized (look at how the function works)
[P_sim, ~, ~] = BlackScholesPutContinuous(S_sim, strike, rate, dividendYield, volatility, TTM_sim);
V_sim = (numberOfShares * S_sim) + (numberOfPuts * P_sim);

% Compute the losses
Losses = -(V_sim - V0);

% Order losses in descending order (largest losses at the top)
Losses_ordered = sort(Losses, 'descend');

% Find the index corresponding to the confidence level
numScenarios = length(returns);
index_VaR = floor(numScenarios * (1 - alpha));

% Safety check: ensure index is at least 1
if index_VaR < 1
    index_VaR = 1;
end

% Extract the VaR for the horizon considered
VaR = Losses_ordered(index_VaR);

% Package the details struct
details = struct();

details.S0 = S0;                                 % Initial stock price
details.P0 = P0;                                 % Initial put price
details.V0 = V0;                                 % Initial portfolio value
details.S_sim = S_sim;                           % Vector of simulated stock prices
details.P_sim = P_sim;                           % Vector of simulated put prices
details.V_sim = V_sim;                           % Vector of simulated portfolio values
details.Losses = Losses;                         % Vector of unsorted simulated losses
details.VaR = VaR;                               % The final calculated VaR
details.alpha = alpha;                           % Confidence level
details.horizon = riskMeasureTimeIntervalInDays; % Time horizon
details.Losses_ordered = Losses_ordered;         % Vector of sorted losses
details.index_VaR = index_VaR;                   % The row index where VaR was extracted
details.numScenarios = numScenarios;             % Total number of scenarios run

end