						### **TIME SERIES**
						
						# PART 1

						
			# PLOT GRAPH AND SCATTER PLOT OF RANDOM WALK VARIABLES

# Create time variable
gen t = _n
tsset t

# random walk plot of x
twoway line X t, title("Random Walk X over Time") ytitle("X") xtitle("Time") ///
    lcolor(blue) graphregion(color(white))

# random walk plot of y	
twoway line Y t, title("Random Walk Y over Time") ytitle("Y") xtitle("Time") ///
    lcolor(red) graphregion(color(white))

# Scatterplot of x and y
scatter Y X, title("Scatter Plot: Y vs X") xtitle("X") ytitle("Y") ///
    mcolor(black) graphregion(color(white))
	
// Despite the fact that X and Y are based on independent white noise, the scatterplot may misleadingly suggest a strong linear relationship. This is a spurious correlation.


			#REGRESSION
			
regress Y X

// Even though X and Y are theoretically uncorrelated, you will likely see a statistically significant slope due to the non-stationary (trending) nature of both variables. As a result, regression on non-stationary time series is unreliable — it violates core assumptions of OLS.

# generate residual and run regression on its lag
predict ehat, residuals
gen ehat_lag = L.ehat
regress ehat ehat_lag

// Since, the coefficient is statistically significant (typically p<0.05), this is evidence of autocorrelation in residuals. The classical regression assumption of no autocorrelation in residuals is violated.



			#RUN REGRESSION ON LAG VARIABLES AND TEST SIGNIFICANCE

#run regression
regress Y X L.X L2.X L3.X L.Y L2.Y L3.Y

#Joint significance test
test X L.X L2.X L3.X

//Reject the null hypothesis that all the coefficients on X and its lags are jointly zero. Even though the true data generating process implies no relationship between X and Y (because both are independent random walks), the regression shows statistically significant results. This illustrates a classic spurious regression situation due to the non-stationary, trending nature of the random walks.