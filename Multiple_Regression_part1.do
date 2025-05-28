						### **MULTIPLE LINEAR REGRESSION MODEL**
						
						### PART 1

summarize

				#Regress logarithim of wage on female dummy
regress LogWage Female

//Being female is associated with a 25% lower log-wage on average compared to males. The result is statistically significant (p < 0.001).

				#Regress residual on Education and Part time job
predict residuals, residuals
regress residuals Educ

//This tells us that Education has a strong and statistically significant effect on the residuals from the original model (LogWage ~ Female).
//Not including Education in the original model leads to biased residuals, indicating a violation of the zero conditional mean assumption.

regress residuals Parttime

// Parttime is a statistically significant predictor of the residuals from the original model (LogWage ~ Female), but its explanatory power is very low:
// This indicates that Parttime accounts for very little of the variation in residuals, so it's a mild case of omitted variable bias.