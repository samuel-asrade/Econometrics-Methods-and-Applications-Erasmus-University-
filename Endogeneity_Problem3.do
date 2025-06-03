					### **ENDOGENEITY PROBLEM**
					
					### PART 3
					
					
			#RUN REGRESSION

regress GPA GENDER PARTICIPATION

//A 1-unit increase in participation is associated with a 0.824 increase in GPA (significant at 1%). Gender has a negative effect on GPA: males have a 0.214 point lower GPA than female (significant at 1%).

			#2SLS
#First stage
regress PARTICIPATION GENDER EMAIL

//EMAIL is a strong predictor of participation: significant, large effect. GENDER is marginally significant (p = 0.072), and has a weak relationship with participation.

#Second stage
ivregress 2sls GPA (PARTICIPATION = EMAIL) GENDER, first

//The causal effect of participation on GPA is positive and significant (coef ≈ 0.24, p = 0.037). This effect, however, is much smaller than the OLS estimate (0.824). This confirms a positive bias in OLS due to endogeneity. Gender effect remains negative and significant.



			#CHECK HAUSMAN TEST
			
estat endogenous

//Participation is endogenous since the null is rejected (p-value = 0). Thus, the OLS estimate is inconsistent, and 2SLS is preferred.