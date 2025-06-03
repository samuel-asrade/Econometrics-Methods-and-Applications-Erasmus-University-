					### ** BINARY CHOICE MODEL**
					

			# ESTIMATE THE LOGIT MODEL BY MLE

gen age2 = (age/10)^2
			
***Use logit if you're interpreting the model structure or computing marginal effects. Use logistic if you need intuitive results for reports or presentations (odds ratios are easier to explain).

logit response male activity age age2

// Being male increases the log-odds of responding by 0.954 (significant at 1%). Being active increases log-odds of response by 0.914 (significant at 1%). Each year of age increases log-odds of response by 0.070 (marginally significant). There is a diminishing return: age squared reduces log-odds (significant at 5%). Baseline log-odds when all predictors are 0.

#For better interpretation, use logestics
logistic response male activity age age2



			# ESTIMATE NON-RESPONSE MODEL

gen respnew = 1 - response
logit respnew male activity age age2

//The magnitude and statistical significance of all predictors remain unchanged. Only the signs of coefficients and intercept are flipped, because we're modeling the probability of non-response instead of response.


// Males are 2.6 times more likely to respond than females. Active users are ~2.5 times more likely to respond. Each year of age increases odds of response by 7%. The squared age effect decreases odds (reflecting diminishing effect). Baseline odds of response when all predictors are zero.

// The interpretation is "the same" in substance, but the signs and odds ratios flip because you're now predicting the complement.

			# LIKELIHOOD RATIO TEST
			
#unrestricted model
logit response male activity age age2
est store unrestricted

#restricted model
logit response age age2
est store restricted

lrtest restricted unrestricted


// Since p < 0.05, reject the null. The data provides significant evidence that male and activity improve the model.



			# NON-LINEAR LOGIT MODEL
			
			
gen male_age = male * age
gen male_age2 = male * age2

logit response male activity age age2 male_age male_age2


// The above extended the logit model shows the different age effects to by gender. For females, age has no clear effect. For males, there appears to be an age (around 50) where the probability of response peaks.