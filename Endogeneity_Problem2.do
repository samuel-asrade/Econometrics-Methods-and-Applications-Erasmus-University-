					### **ENDOGENEITY PROBLEM**
					
					### PART 2
					
					
			# ESTIMATE PRICE ELASTICITY BY 2SLS

# First stage regression (Check whether instruments significantly explain PG)
regress PG RI RPT RPN RPU

# 2SLS estimation
ivregress 2sls GC (PG = RPT RPN RPU) RI, first

// This estimates the effect of gasoline price (PG) on gasoline consumption (GC), correcting for endogeneity using instrumental variables.
	* GC: Dependent variable (log gasoline consumption)
	* PG: Endogenous regressor
	* Instruments for PG: RPT, RPN, RPU
	* RI: Included exogenous regressor

# Check Hausman test if you want to test endogeneity:
estat endogenous

// Durbin or Wu-Hausman tests whether PG is actually endogenous, but the Sargan test tests whether the instruments are valid, assuming PG is endogenous.
// Both tests (Durbin and Hausman) have p-values > 0.05, meaning there is no statistically significant evidence of endogeneity for PG at conventional levels. OLS might be consistent here, and using IV/2SLS may not be strictly necessary.


***While we find no statistically significant evidence of endogeneity in PG (Durbin and Wu-Hausman tests), we proceed with 2SLS estimation for robustness and to account for potential endogeneity concerns. The Sargan test supports the validity of our instruments.***


			#PERFORM THE SARGAN TEST

#Run the 2SLS estimation	
ivregress 2sls GC (PG = RPT RPN RPU) RI, first

# Perform the Sargan test
estat overid

//The Sargan test tests instrument validity, that is whether the instruments (RPT, RPN, RPU, RI) are uncorrelated with the structural error term in your main equation. It only applies when you have more instruments than endogenous regressors (i.e., the model is overidentified).

//The null hypothesis claims that instruments are valid (i.e., uncorrelated with the error term and correctly excluded from the structural equation). The p-values (p = 0.2096) indicate strong evidence of the validity of the instruments.

