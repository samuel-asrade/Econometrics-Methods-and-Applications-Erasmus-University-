					### **MODEL SPECIFICATION**
					
					### PART 1

# set time series data
tsset Year 

summarize

			#LOG-CHANGE TRANSFORMED MODELS

# generate log model and change in the log model
gen ln_index = ln(Index)
gen dif_lnindex = D.ln_index

regress dif_lnindex BookMarket
predict residuals, residuals

//There is a statistically significant negative relationship between the book-to-market ratio and the change in the log of the S&P500 index. For every 1 unit increase in Book-to-Market, the expected log change in the S&P500 index decreases by 0.213.

			#LEVEL MODEL

regress Index BookMarket
predict resid, residuals

//Book-to-market is statistically significant in this level regression. A one unit increase in the book-to-market ratio is associated with a decrease of about 1217.68 points in the S&P500 index. The model explains around 43% of the variation in the index level.
//However, keep in mind that regression on levels can be misleading when the dependent variable is non-stationary, which is why log-difference models are often preferred.


			#PLOT THE RESIDUAL OF BOTH MODELS
			
# Generate Predictions
* Log-change model
reg dif_lnindex BookMarket
predict fitted_logchange, xb
predict resid_logchange, residuals
* Level model
reg Index BookMarket
predict fitted_index, xb
predict resid_index, residuals

# Log-Change Model
twoway ///
    (line resid_logchange Year, yaxis(1) lcolor(blue) lpattern(solid)) ///
    (line dif_lnindex Year, yaxis(2) lcolor(red) lpattern(solid)) ///
    (line fitted_logchange Year, yaxis(2) lcolor(brown) lpattern(solid)), ///
    ytitle("Residuals", axis(1)) ///
    ytitle("Δlog(Index)", axis(2)) ///
    xtitle("Year") ///
    legend(order(1 "Residual" 2 "Actual" 3 "Fitted")) ///
    title("Log-Change Model")
graph save logchange_graph.gph, replace

# Level Model
twoway ///
    (line resid_index Year, yaxis(1) lcolor(blue) lpattern(solid)) ///
    (line Index Year, yaxis(2) lcolor(red) lpattern(solid)) ///
    (line fitted_index Year, yaxis(2) lcolor(brown) lpattern(solid)), ///
    ytitle("Residuals", axis(1)) ///
    ytitle("Index Level", axis(2)) ///
    xtitle("Year") ///
    legend(order(1 "Residual" 2 "Actual" 3 "Fitted")) ///
    title("Level Model")
graph save level_graph.gph, replace

# Combine Both Graphs
graph combine logchange_graph.gph level_graph.gph, ///
    title("S&P500: Log-Change and Level Models") ///
    cols(2) ///
    xsize(10) ysize(4)
	
#Export the graph
graph export sp500_model_comparison.png, width(3000) replace



					### PART 3
			
			
			#QUADRATIC REGRESSION		
gen sqr_bookMarket = (BookMarket)^2

regress dif_lnindex BookMarket sqr_bookMarket

//The joint significance (F-test: p = 0.0085) suggests the overall model explains some variation, but individual coefficient insignificance weakens evidence for a clear quadratic relationship (Both are statistically insignificant at the 5% level).

test BookMarket sqr_bookMarket

//Since the p-value is less than 0.01, we reject the null hypothesis at the 1% significance level. So, both the linear and quadratic terms jointly explain a significant portion of the variation.


			#REGRESSION BY SEGMENTING YEAR
gen post1980 = Year >= 1980
gen bm_post1980 = BookMarket * post1980
reg dif_lnindex BookMarket post1980 bm_post1980
//A significant negative effect of book-to-market on log change in the pre-1980 period, whereas a significant positive change in slope after 1980 (the book-to-market effect becomes less negative or even positive post-1980)
//A statistically significant downward shift in intercept (baseline level of returns) after 1980.
//Overall, the relationship between the S&P 500 log change and the book-to-market ratio is not stable over time. It was significantly negative before 1980 but flattens out (or possibly turns slightly positive) after 1980.




					### **PART 5**
					
			#TESTING MODEL
			
regress LogEqPrem BookMarket DivPrice EarnPrice Inflation NTIS
test BookMarket DivPrice EarnPrice Inflation NTIS

regress LogEqPrem BookMarket
test BookMarket

//While the full model has a higher R² (10.8%), the improvement over the book-to-market only model (6.3%) is not statistically significant. Book-to-market alone is a better predictor in terms of significance and parsimony.
//A regression of the log equity premium on BookMarket alone yields an R² of 6.3%, with a statistically significant coefficient (p = 0.019). When four more variables — DivPrice, EarnPrice, Inflation, and NTIS — are added, R² increases modestly to 10.8%. However, a joint F-test for all five variables results in F(5, 81) = 1.97 (p = 0.092), which is not significant at the 5% level. This indicates that the additional four variables do not provide a statistically significant improvement in explanatory power over BookMarket alone.



			#CONDUCTING RESET TEST
			
//RESET (Regression Specification Error Test) - checks for misspecification of the functional form by testing whether nonlinear transformations (typically squares or cubes of fitted values) significantly improve the model.

regress LogEqPrem BookMarket

#Save the fitted values from this regression
predict yhat

#generate squared and cubic variables and regress them
gen yhat_sq = yhat^2
gen yhat_cu = yhat^3
regress LogEqPrem BookMarket yhat_sq yhat_cu

#perform RESET F test
test yhat_sq yhat_cu

//This suggests no strong evidence of functional form misspecification in your regression of LogEqPrem on BookMarket, so the null hypothesis of no misspecification is not rejected. In other words, adding nonlinear terms of the fitted values does not significantly improve model fit.


			#CHOW BREAK TEST
			
regress LogEqPrem BookMarket

#Store the sum of squared residuals
scalar SSR_full = e(rss)
scalar N_full = e(N)
scalar k = e(df_m) + 1

#sample pre-1980
regress LogEqPrem BookMarket if Year < 1980
scalar SSR_pre = e(rss)
scalar N_pre = e(N)

#sample post-1980
regress LogEqPrem BookMarket if Year >= 1980
scalar SSR_post = e(rss)
scalar N_post = e(N)

#compute chow break statistic 
scalar Chow_num = (SSR_full - (SSR_pre + SSR_post)) / k
scalar Chow_den = (SSR_pre + SSR_post) / (N_full - 2*k)
scalar Chow_F = Chow_num / Chow_den
display "Chow break F-statistic = " Chow_F

#to compute the significance of chow break statistic
//NB: Chow F-statistic = 2.27; 
//numerator degrees of freedom(df1) = 2 (intercept + BookMarket) 
//Sample Size (N) = 87; 
//denominator degree of freedom(df2) = 87-4 = 83
//The "4" comes from estimating 2 parameters (k = 2) in 2 subsamples, costing you 2k = 4 degrees of freedom.

display Ftail(2, 83, 2.27)

//The Chow break test is not statistically significant at the 5% level as the p- value is 0.1097.
//The null hypothesis (coefficients are stable across the 1927–1979 and 1980–2013 subsamples) is not rejected. There's weak or no evidence of a structural break in the relationship between BookMarket and LogEqPrem.



			#CHOW FORCAST TEST

// Chow forcast test does not estimate a new model for the post-1980 data, instead it is used to check how well the pre-1980 model predicts post-1980.

scalar ChowForecast_num = (SSR_full - SSR_post) / k
scalar ChowForecast_den = SSR_post / (N_post - k)
scalar ChowForecast_F = ChowForecast_num / ChowForecast_den
display "Chow forecast F-statistic = " ChowForecast_F

//df1 = k = 2
//df2 = N_post - 2 = 34 - 2 = 32

display Ftail(2, 32, 39.97)


//The p-value (1.989e-09) is almost 0 (1.989 × 10⁻⁹). Hence, there is very strong evidence that the model trained on the pre-1980 period does not forecast well for the post-1980 period.
//This strongly suggests structural change over time in how Book-to-Market explains the log equity premium.


	
