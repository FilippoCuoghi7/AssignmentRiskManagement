function [VaR, details] = DeltaNormalVaR(alpha, numberOfShares, numberOfPuts, ...
    stockPrice, strike, rate, dividendYield, volatility, TTMinYears, ...
    riskMeasureTimeIntervalInDays, returns)
% DELTANORMALVAR Computes the Value at Risk (VaR) for a mixed portfolio
% of stocks and put options using a Delta-Normal approximation approach.
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
[~, delta_P0, gamma_PO] = BlackScholesPutContinuous(S0, strike, rate, dividendYield, volatility, TTMinYears);
delta_V0 = numberOfShares * 1 + numberOfPuts * delta_P0;

% Compute the Mean and Standard Deviation of the Risk Factors (daily)
mu = mean(returns,1);
sigma = std(returns);

% Convert unit delta to Dollar Delta (cash exposure)
dollarDelta = delta_V0 * S0;

% Scale statistics to the requested time horizon (h)
h = riskMeasureTimeIntervalInDays;
mu_h = mu * h; 
sigma_h = sigma * sqrt(h); 

% Compute the Mean and Standard Deviation of the Portfolio P&L
mu_pnl = dollarDelta * mu_h;
sig_pnl = abs(dollarDelta) * sigma_h;

% Calculate VaR using the Normal Distribution
z_score = norminv(alpha);
VaR = -mu_pnl + sig_pnl * z_score;

% Details struct
details = struct();

details.delta_P0 = delta_P0;
details.delta_V0 = delta_V0;
details.dollarDelta = dollarDelta;
details.gamma_P0 = gamma_PO;
details.mu_daily = mu;
details.sigma_daily = sigma;
details.mu_pnl = mu_pnl;
details.sig_pnl = sig_pnl;
details.z_score = z_score;
details.horizon = h;
details.VaR = VaR;   
details.alpha = alpha;                           
details.horizon = riskMeasureTimeIntervalInDays; 


end

