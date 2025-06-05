					### **MODULE 7 EXAM**



# Labelling Variables
label var CPI_EUR "Consumer price index in the Euro area"
label var CPI_USA "Consumer price index in the United States of America"
label var LOGPEUR "logarithm of CPI_EUR"
label var LOGPUSA "logarithm of CPI_USA"
label var DPEUR "first difference of LOGPEUR"
label var DPUSA "first difference of LOGPUSA"
label var TREND "linear trend"


* Convert string to Stata monthly date
gen mdate = monthly(YYYYMM, "YM")
format mdate %tm

* Declare time series
tsset mdate

* Safely convert inflation variables from string to numeric
destring DPEUR, gen(inf_eur) force
destring DPUSA, gen(inf_usa) force

# Drop data beyond 2010m12 (forecast period is 2011)
drop if mdate > tm(2010m12)


			# PLOT CPI, LOG(CPI), AND MONTHLY INFLATION

# Plot CPI Levels
twoway (line CPI_EUR mdate, lcolor(blue)) ///
       (line CPI_USA mdate, lcolor(red)), ///
       title("CPI Levels: Euro Area vs USA") ///
       legend(label(1 "Euro Area") label(2 "USA")) ///
       xtitle("Date") ytitle("CPI Level")

# Plot Log(CPI)
twoway (line LOGPEUR mdate, lcolor(blue)) ///
       (line LOGPUSA mdate, lcolor(red)), ///
       title("Log(CPI): Euro Area vs USA") ///
       legend(label(1 "log(CPI_EUR)") label(2 "log(CPI_USA)")) ///
       xtitle("Date") ytitle("Log CPI")

# Plot Monthly Inflation
twoway (line inf_eur mdate, lcolor(blue)) ///
       (line inf_usa mdate, lcolor(red)), ///
       title("Monthly Inflation Rates: Euro Area vs USA") ///
       legend(label(1 "Euro Area") label(2 "USA")) ///
       xtitle("Date") ytitle("Inflation (Δlog(CPI))")


			# ADF TEST
			
# ADF Test on log(CPI_EUR)
gen L1_LOGPEUR = L1.LOGPEUR

gen DLOGPEUR = D.LOGPEUR
gen LD1 = L1.DLOGPEUR
gen LD2 = L2.DLOGPEUR
gen LD3 = L3.DLOGPEUR

reg DLOGPEUR L1_LOGPEUR TREND LD1 LD2 LD3

// The coefficient on the lagged level term (L1_LOGPEUR) is negative and statistically significant at the 5% level (p = 0.016). The significance of the trend coefficient confirms the presence of a deterministic trend in the series. The log of CPI in the Euro Area does not have a unit root. Inflation is stationary around a trend, suitable for modeling in levels with trend terms.


# ADF Test on log(CPI_USA)
gen L1_LOGPUSA = L1.LOGPUSA

gen DLOGPUSA = D.LOGPUSA
gen LDP1 = L1.DLOGPUSA
gen LDP2 = L2.DLOGPUSA
gen LDP3 = L3.DLOGPUSA

reg DLOGPUSA L1_LOGPUSA TREND LDP1 LDP2 LDP3

// The coefficient on L1_LOGPUSA is also negative and significant (p = 0.018), though smaller in magnitude. The log of CPI in the USA is also trend-stationary. It does not contain a unit root, and the inflation process reverts to a linear trend over time.


			# AUTO REGRESSIVE (AR) MODEL
					
# Autocorrelation and Partial Autocorrelation
ac inf_eur, lags(24)
pac inf_eur, lags(24)

reg inf_eur L6.inf_eur L12.inf_eur if mdate < tm(2011m1)

// Lag 6 effect (biannual): The coefficient is positive and statistically significant (p = 0.016). This suggests that inflation six months ago has a moderate positive influence on current inflation, possibly capturing delayed pass-through effects or medium-term persistence.

// Lag 12 effect (annual): Strongly significant (p < 0.001), with a high coefficient (≈0.6). This clearly captures seasonal autocorrelation — the fact that inflation tends to repeat similar patterns each year.


			# AUTO REGRESSIVE DISTRIBUTED LAG (ADL) MODEL	
			
reg inf_eur L6.inf_eur L12.inf_eur L1.inf_usa L12.inf_usa if mdate < tm(2011m1)

// L6.inf_eur (lag 6): Significant (p = 0.019). Suggests a moderate medium-run autocorrelation in Euro inflation — i.e., inflation 6 months ago has predictive power. 
// L12.inf_eur (lag 12): Highly significant (p < 0.001). This is strong evidence of seasonal inflation persistence — Euro area inflation tends to follow yearly patterns.

// L1.inf_usa (lag 1): Highly significant (p < 0.001). Indicates that last month's U.S. inflation has a positive and substantial effect on current Euro area inflation. This supports short-term international inflation linkages.
// L12.inf_usa (lag 12): Highly significant and negative (p < 0.001). Suggests a reversal effect or seasonal divergence — i.e., U.S. inflation from a year ago predicts a decrease in Euro area inflation today.

// U.S. inflation does have predictive power for Euro area inflation, even after controlling for Euro inflation's own lags. Both short-term (lag 1) and seasonal (lag 12) U.S. inflation terms are statistically significant. The negative coefficient at lag 12 implies a more nuanced dynamic — inflation pressures may propagate differently over seasonal cycles between the U.S. and Euro area.
	
	   
			# COMPARE AUTO REGRESSIVE (AR) AND AUTO REGRESSIVE DISTRIBUTED (ARD) MODELS
			

** SUMMARY OF THE TWO
# AR Model (from part c)
// RMSE (Root Mean Squared Error): 0.00010
// MAE (Mean Absolute Error): 0.00010
// SUM of Forecast Errors: -0.00120
# ADL Model (from part d)
// RMSE: 0.00008
// MAE: 0.00007
// SUM of Forecast Errors: +0.00080

// The ADL model outperforms the AR model on both RMSE and MAE. Lower values indicate more accurate forecasts. The AR model has a negative sum of forecast errors, indicating a tendency to underpredict inflation. The ADL model has a small positive bias, suggesting a slight overprediction on average.
// Incorporating lagged U.S. inflation helps improve the predictive performance of the Euro area inflation model. This supports the hypothesis that U.S. inflation carries useful predictive information for Euro inflation dynamics.