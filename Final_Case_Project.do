					### **FINAL CASE PROJECT**
					

			# Linear Model
			
# regress all variables on sales
regress sell lot bdms fb sty drv rec ffin ghw ca gar reg

# Ramsey RESET test - tests linearity or non-linearity of the model
ovtest

// Reject the null hypothesis as p-value < 0.05. Hence the model does not fully capture the relationship between dependent and explanatory variables. Hence, there is evidence of nonlinearity or misspecification.


			# Log Linear Model

# regress all variables on log of sales
gen logsales = log(sell)
regress logsales lot bdms fb sty drv rec ffin ghw ca gar reg

ovtest

// Fail to reject the null hypothesis as p-value > 0.05. The model is specified, linear, and includes relevant variables.


			# Non-Linear Model Construction

gen loglot = log(lot)
reg logsales lot loglot bdms fb sty drv rec ffin ghw ca gar reg

// The regression results indicate that log(lot) is statistically significant (p < 0.01), whereas lot in levels is not (p > 0.05). This suggests a logarithmic relationship between lot size and house prices. Hence, only the logarithm of lot size should be included in the model.


			# Interaction Effects

# Generate interaction terms
gen loglot_bdms = loglot * bdms
gen loglot_fb = loglot * fb
gen loglot_sty = loglot * sty
gen loglot_drv = loglot * drv
gen loglot_rec = loglot * rec
gen loglot_ffin = loglot * ffin
gen loglot_ghw = loglot * ghw
gen loglot_ca = loglot * ca
gen loglot_gar = loglot * gar
gen loglot_reg = loglot * reg

# Run the regression
reg logsales loglot bdms fb sty drv rec ffin ghw ca gar reg ///
    loglot_bdms loglot_fb loglot_sty loglot_drv loglot_rec ///
    loglot_ffin loglot_ghw loglot_ca loglot_gar loglot_reg
	
// Individually, four variables are significant at 5% significance level. The constat term is also significant.


			# Perform F Test

test loglot_bdms loglot_fb loglot_sty loglot_drv loglot_rec ///
     loglot_ffin loglot_ghw loglot_ca loglot_gar loglot_reg

// Since the p-value > 0,05, the F-test fails to reject the null hypothesis. Thus, there is no strong evidence that the interaction effects are jointly significant. The simpler model without interactions may be preferred.


			# General to Specific Model Specification
# Full regression
reg logsales loglot bdms fb sty drv rec ffin ghw ca gar reg ///
    loglot_bdms loglot_fb loglot_sty loglot_drv loglot_rec ///
    loglot_ffin loglot_ghw loglot_ca loglot_gar loglot_reg
	
	
# Removed loglot_reg
reg logsales loglot bdms fb sty drv rec ffin ghw ca gar reg ///
    loglot_bdms loglot_fb loglot_sty loglot_drv loglot_rec ///
    loglot_ffin loglot_ghw loglot_ca loglot_gar
	
# Removed loglot_bdms
reg logsales loglot bdms fb sty drv rec ffin ghw ca gar reg ///
    loglot_fb loglot_sty loglot_drv loglot_rec ///
    loglot_ffin loglot_ghw loglot_ca loglot_gar
	
# Removed loglot_ffin
reg logsales loglot bdms fb sty drv rec ffin ghw ca gar reg ///
    loglot_fb loglot_sty loglot_drv loglot_rec ///
    loglot_ghw loglot_ca loglot_gar
	
# Removed loglot_ghw
reg logsales loglot bdms fb sty drv rec ffin ghw ca gar reg ///
    loglot_fb loglot_sty loglot_drv loglot_rec ///
    loglot_ca loglot_gar
	
# Removed loglot_ca
reg logsales loglot bdms fb sty drv rec ffin ghw ca gar reg ///
    loglot_fb loglot_sty loglot_drv loglot_rec loglot_gar
	
# Removed loglot_gar
reg logsales loglot bdms fb sty drv rec ffin ghw ca gar reg ///
    loglot_fb loglot_sty loglot_drv loglot_rec
	
# Removed loglot_fb
reg logsales loglot bdms fb sty drv rec ffin ghw ca gar reg ///
    loglot_sty loglot_drv loglot_rec
	
# Removed loglot_sty
reg logsales loglot bdms fb sty drv rec ffin ghw ca gar reg ///
    loglot_drv loglot_rec
	
# Final Model
reg logsales loglot bdms fb sty drv rec ffin ghw ca gar reg ///
    loglot_drv loglot_rec
	
	
			# What if house condition is missing in the model?
			
// If the condition of the house is omitted but affects both the sale price and the presence of central air conditioning, the estimated effect of air conditioning will be biased. Since better-conditioned houses are more likely to have air conditioning and also sell for higher prices, failing to account for condition will cause the effect of air conditioning on price to be overestimated.


			# Predictive Ability Analysis
			
# Create a sample indicator
gen sample = (obs <= 400)

reg logsales loglot bdms fb sty drv rec ffin ghw ca gar reg if sample == 1

# Predict the remaining 146 samples
predict pred_logsales if sample == 0

# Calculate the Mean Absolute Error
gen abs_error = abs(logsales - pred_logsales) if sample == 0
sum abs_error if sample == 0

# Access the predictive power
sum logsales if sample == 0

// The mean absolute error (MAE) of the predicted log sale prices is 0.128. This means that, on average, the model's prediction for the log of the house price is off by about 0.128 log points. The standard deviation of actual log sale prices in the test sample is 0.289. This represents the natural variability in the log prices. Since 0.128 is less than half of 0.289, the model performs reasonably well in predictive terms — it captures much of the variation in prices, although not perfectly.

// The average prediction error is about 44% of the standard deviation in log sale prices (0.128 / 0.289 ≈ 0.44), which indicates moderate predictive power.

// The range of prediction errors goes from as low as 0.0013 to as high as 0.6765 log points. Overall the trained model on the first 400 houses predicts log sale prices on the remaining 146 houses with reasonable accuracy.

