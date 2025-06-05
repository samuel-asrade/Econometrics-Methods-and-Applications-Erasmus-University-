							### **TIME SERIES**
							
							# PART 2



# Set timeseries
tsset YEAR

# Labelling Variables
label var RPK1 "revenue passenger kilometers of company 1" 
label var RPK2 "revenue passenger kilometers of company 2"
label var X1 "logarithm of RPK1"
label var X2 "logarithm of RPK2"
label var DX1 "first difference of X1"
label var DX2 "first difference of X2"


			# GRANGER CAUSALITY TEST
			
			
// Granger causality test is used for determining whether one time series can predict another. It does not imply true causality, only predictive precedence. A variable X Granger-causes Y if past values of X contain information that helps predict Y, beyond the information contained in past values of Y alone.

# Regress first difference of X1 on its lagged and X2 lagged value
gen L_DX2 = L.DX2
gen L_DX1 = L.DX1
regress DX1 L_DX1 L_DX2

# Perform Granger Causaluty F-Test
test L_DX2

// We fail to reject the null hypothesis (P-value = 0.65). The lagged value of X2 does not predict X1. Hence, there is no granger causality from X2 to X1.

# Regress first difference of X2 on its lagged and X1 lagged value
regress DX2 L_DX2 L_DX1

# Perform Granger Causaluty F-Test
test L_DX1

// We reject the null hypothesis (p-value = 0). The lagged value of X1 predicts X2. Hence, there is granger causality from X1 to X2.


// There is unidirectional Granger causality: Changes in company 1's RPK growth help predict changes in company 2's RPK growth, but not vice versa. This might indicate that company 2 responds to competitive moves or demand shifts from company 1, but company 1 operates more independently.


			# AUGMENTED DICKEY-FULLER (ADF) TEST

# For X1
gen L_X1 = L.X1
gen t = _n
regress DX1 L_X1 L_DX1 t

// Here, we compare the critical value with the t-statistic. The test stationary (-2.76) is greater than the critical value (-3.50); hence, we fail to reject the null hypothesis. Hence, X1 is non-stationary. 

# For X2
gen L_X2 = L.X2
regress DX2 L_X2 L_DX2 t

// The test stationary (-1.21) is greater than the critical value (-3.50); hence, we fail to reject the null hypothesis. Hence, X2 is non-stationary.


			# ENGLE GRANGER TEST
			
	
// The Engle-Granger test checks whether two non-stationary series are cointegrated, meaning they have a long-run equilibrium relationship.

regress X2 X1

# generate residuals from the above regression
predict ehat, resid

# run ADF test on residuals
gen dehat = D.ehat
gen L1_ehat = L.ehat
gen L1_dehat = L.dehat

reg dehat L1_ehat L1_dehat t


// Although X2 and X1 appear highly correlated and show a strong linear relationship in the first regression, the residuals are not stationary at the 5% level of significance using the Engle-Granger test. 
// Since the t-statistic (–3.59) > the critical value (–3.79), we fail to reject the null hypothesis of no cointegration.
// There is no strong evidence of cointegration between X1 and X2. This implies that while they may move together in the short run, there is no stable long-run equilibrium relationship between them over time.


			# ERROR CORRECTION MODEL (ECM)
			

// An ECM explains short-run dynamics while incorporating long-run equilibrium via the error correction term (ECT). The ECMs show how short-run changes in X1 and X2 respond to deviations from their long-run equilibrium.

# Construct ECT from the above regression result
gen ect = X2 - 0.92*X1
gen L1_ect = L.ect

# Estimate ECM for X2
reg DX2 L_DX2 L1_ect

// The error correction term is statistically significant and negative, which confirms that X2 adjusts to restore equilibrium with X1, consistent with the assumptions of the Engle-Granger methodology. The system corrects ~44% of the disequilibrium in each time period.
// The insignificant coefficient on L_DX2 suggests that past short-run changes in X2 do not help predict current changes in X2 beyond the information already contained in the error correction term.


# Estimate ECM for X1
reg DX1 L_DX1 L1_ect

// This positive and significant coefficient is  unusual because typically, the ECT coefficient is expected to be negative in an ECM. This could indicate that X1 does not adjust to restore equilibrium, or the cointegration relationship might be misspecified from the perspective of X1.