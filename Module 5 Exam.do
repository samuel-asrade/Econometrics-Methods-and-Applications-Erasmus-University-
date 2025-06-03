					### **MODULE 5 EXAM**
					


			# OLS ESTIMATION

gen exper2 = exper^2

regress logw educ exper exper2 smsa south

//education has a statistically significant positive effect on wage level. A one-year increase in education is associated with an 8.16% increase in wages, holding other factors constant


			# WHY THE ABOVE OLS MODEL COULD BE INCONSISTENT? 

// The above OLS may be inconsistent because:
	*Unobserved ability or motivation may affect both education and wages.
	*Education could be correlated with the error term in the wage equation (e.g. due to omitted factors like family background, innate ability)
	*Experience may be endogenous (influenced by unobserved factors, like career choice, ambition) that also affect wages.

	

			# WHY AGE AND AGE2 COULD BE INSTRUMENTS FOR EXPER AND EXPER2
			
// Age affects how long someone could have possibly worked (thus affects exper), but age itself does not directly determine wage in the model after controlling for experience. Hence, age and age² can be used as instruments for experience and experience², assuming they:
	*Are correlated with experience
	*Not correlated with the error term in the wage equation




			# 2SLS REGRESSION

gen age2 = age^2

# First Stage regression
regress educ age age2 nearc daded momed

# Second Stage regression
ivregress 2sls logw (educ exper exper2 = age age2 nearc daded momed) smsa south, first

// this treats both educ and exper as endogenous variables.



			# SARGAN TEST

estat overid

//The null hypothesis claims that instruments are valid (uncorrelated with error term). Since the p-value > 0.05, we fail to reject the null. Therefore, instruments (age², nearc, daded, momed) are valid and exogenous.


