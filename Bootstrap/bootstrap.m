function [dates, discounts, zeroRates] = bootstrap(datesSet, ratesSet)
% BOOTSTRAP Constructs a yield curve from Deposits, Futures, and Swaps
% using Depos, Futures, and Swaps quotes.

%% --- Normalize all dates to datetime ---
refDate         = ensureDatetime(datesSet.settlement);
deposDates      = ensureDatetime(datesSet.depos);
futuresDates    = ensureDatetime(datesSet.futures);
swapDates       = ensureDatetime(datesSet.swaps);

% businessDateOffsetTarget requires a scalar datetime
if ~isscalar(refDate)
    error('datesSet.settlement must contain exactly one date.');
end

dates = refDate;
discounts = 1.0;

%% --- 1. DEPOS (Short End) ---
% Use the first 3 deposits (1W, 1M, 3M)
for i = 1:3
    d_end = deposDates(i);
    r_mid = mean(ratesSet.depos(i, :));   % Mean Bid/Ask
    tau = yearfrac(refDate, d_end, 2);    % ACT/360 for Depos
    df = 1 / (1 + r_mid * tau);

    dates = [dates; d_end];
    discounts = [discounts; df];
end

%% --- 2. FUTURES (Middle Part) ---
% Use the first 7 futures (3M, 6M, ..., 21M)
for i = 1:7
    d_start = futuresDates(i, 1);
    d_end   = futuresDates(i, 2);
    r_fut = mean(ratesSet.futures(i, :));

    % Interpolate DF at the start date of the future contract
    df_start = getDiscountFactorByZeroRatesLinearInterp(refDate, d_start, dates, discounts);

    tau = yearfrac(d_start, d_end, 2);    % ACT/360 for Futures
    df_end = df_start / (1 + r_fut * tau);

    dates = [dates; d_end];
    discounts = [discounts; df_end];
end

%% --- 3. SWAPS (Long End) ---
for i = 2:length(swapDates)
    targetDate = swapDates(i);
    swapRate = mean(ratesSet.swaps(i, :));

    % Generate annual fixed-leg coupon dates using TARGET business-day adjustment
    couponDates = datetime.empty(0,1);
    k = 1;

    while true
        % Adjust using following convention
        currDate = businessDateOffsetTarget(refDate, k, 0, 0, 'following');
        couponDates = [couponDates; currDate];

        if currDate >= targetDate
            break;
        end
        k = k + 1;
    end

    % Force last coupon date to actual swap maturity
    couponDates(end) = targetDate;

    % PV of known fixed-leg coupons
    pv_fixed_known = 0;
    prev_date = refDate;

    for j = 1:length(couponDates)-1
        pay_date = couponDates(j);
        tau = yearfrac(prev_date, pay_date, 6);   % 30E/360 European
        df_pay = getDiscountFactorByZeroRatesLinearInterp(refDate, pay_date, dates, discounts);
        pv_fixed_known = pv_fixed_known + tau * df_pay;
        prev_date = pay_date;
    end

    % Solve for DF at swap maturity
    tau_last = yearfrac(prev_date, couponDates(end), 6);
    df_final = (1 - swapRate * pv_fixed_known) / (1 + swapRate * tau_last);

    dates = [dates; targetDate];
    discounts = [discounts; df_final];
end

%% --- Zero rates ---
zeroRates = fromDiscountFactorsToZeroRates(dates(1), dates, discounts);

% If your function returns N-1 rates, keep this line; otherwise remove it
zeroRates = [zeroRates(1); zeroRates];
end


function d = ensureDatetime(x)
% Convert supported date formats to datetime.
% Assumes numeric values are MATLAB datenums.
% If your numbers come from Excel serial dates, replace 'datenum' with 'excel'.

if isa(x, 'datetime')
    d = x;
elseif isnumeric(x)
    d = datetime(x, 'ConvertFrom', 'datenum');
elseif iscellstr(x) || isstring(x) || ischar(x)
    d = datetime(x);
else
    error('Unsupported date format: %s', class(x));
end
end