					### **MODULE 4 EXAM**

			
			# GENERAL TO SPECIFIC MODEL ESTIMATION
	
describe
	
#First create new var with proper date format
gen datevar = monthly(OBS, "YM")
format datevar %tm



# regress all
regress INTRATE INFL PROD UNEMPL COMMPRI PCE PERSINC HOUST

//eliminate one variable at a time, always based on the highest p-value, until you are left with a parsimonious model in which all remaining variables are significant at conventional levels (typically p < 0.10 or p < 0.05).

# removed the least significant variable
regress INTRATE INFL PROD COMMPRI PCE PERSINC HOUST

# removed the least significant variable
regress INTRATE INFL COMMPRI PCE PERSINC HOUST

//This final model will be your specific model — a simplified Taylor rule where only the most relevant predictors of INTRATE remain.


			# SPECIFIC TO GENERAL MODEL ESTIMATION
		
//start from simple model to the general by adding new variables based on their theoretical significance to the dependent variable. Stop when you get an insignificant p-value for your variable.		

regress INTRATE
regress INTRATE INFL
regress INTRATE INFL PCE
regress INTRATE INFL PCE PERSINC
regress INTRATE INFL PCE PERSINC HOUST
regress INTRATE INFL PCE PERSINC HOUST COMMPRI
regress INTRATE INFL PCE PERSINC HOUST COMMPRI PROD

// We have reached the same model. When the variable "PROD" is added, the model becomes insignificant. So, the correct model is:
regress INTRATE INFL PCE PERSINC HOUST COMMPRI
//This Model, which is obtained through simple to general method, is the same as the privious general to simple model.


			# COMPARE THE PARSIMONIOUS AND FULL TYLOR RULE MODEL
			
			
# Parsimonious Model
regress INTRATE INFL PCE PERSINC HOUST COMMPRI
estat ic

# Full Taylor Rule Model
regress INTRATE INFL PROD UNEMPL COMMPRI PCE PERSINC HOUST
estat ic


//INFL, PCE, PERSINC, HOUST, and COMMPRI are significant in both models. PROD and UNEMPL are not statistically significant (p = 0.148 and 0.290 respectively) in the full model. The constant term is insignificant in both models.

//Adjusted R² is identical in both models, showing no gain from adding more variables. AIC and BIC are lower in the parsimonious model, indicating better model fit relative to complexity. The parsimonious model is more efficient, includes only statistically significant variables, and avoids overfitting.



			# TESTING BOTH MODELS

			
# RAMSEY RESET TEST:

regress INTRATE INFL PCE PERSINC HOUST COMMPRI
estat ovtest


# CHOW TEST (Structural Break in Jan 1980):

gen break = datevar >= tm(1980m1)

regress INTRATE INFL PCE PERSINC HOUST COMMPRI if break==0
est store pre1980
regress INTRATE INFL PCE PERSINC HOUST COMMPRI if break==1
est store post1980
suest pre1980 post1980
test [pre1980_mean=post1980_mean]

//This is strong evidence of a structural break around January 1980. The coefficients of your model before and after 1980 are statistically different. That means the model behaves very differently across these two periods.


# CHOW FORCAST TEST:

//Estimate the model on pre-break period (training)
regress INTRATE INFL PCE PERSINC HOUST COMMPRI if break == 0
//Predict fitted values (yhat_p) for the entire sample
predict yhat_p, xb
//Regress actual INTRATE on predicted yhat_p in the post-break period
regress INTRATE yhat_p if break == 1
//Display model fit info
estat ic

//Before the break, inflation, personal income, commodity prices positively influence interest rates, while housing starts have a negative effect. PCE is weakly negative but not strongly significant.

//The predicted interest rates explain about 41% of the variation in actual interest rates in the post-break period. The model is jointly statistically significant. The predicted values are significantly positively associated with actual interest rates.

//The relationship between predictors and interest rates changed after the break — the model trained on pre-break data does not forecast post-break interest rates perfectly. Overall, there is evidence of a structural change or forecast failure across the break, consistent with rejecting the null hypothesis of no break in the Chow forecast test.

# JARQUE-BERA TEST:

regress INTRATE INFL PCE PERSINC HOUST COMMPRI if break == 0
predict residuals, residuals
jb residuals

//Since the p-value is far below 0.05, the null hypothesis is rejected. The residuals are not normally distributed in the pre-break model.

regress INTRATE INFL PCE PERSINC HOUST COMMPRI if break == 1
predict resid, residuals
jb resid

//The residuals for the post-break period (break == 1) are not normally distributed. This suggests that the model may not fully capture the dynamics of the interest rate in the post-1980 period, even though the R-squared is high (0.74).

//Both models suffer from non-normal residuals, which suggests presence of some form of misspecification in both periods.
