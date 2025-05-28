					### **MULTIPLE REGRESSION MODEL**
					
					### PART 5
					
summarize
browse

			#REGRESS AND INTERPRET THE COFFICIENTS

regress LogWage Age Female Educ Parttime 

//Intercept (≈ 0.027) is the mean residual for education level 1 (the omitted category). The mean residual for education level 2, 3, and 4 are -0.062, –0.087, 0.062, respectively.


			#TEST THE JOINT SIGNIFICANCE TEST
			
predict residuals, residuals
regress residuals DE4 DE3 DE2
testparm DE4 DE3 DE2

//The education dummies are jointly significant (P < 0.01), so reject Ho that all 3 coefficients are zero.


			#INTERPRETATION
//There is additional structure in the residuals related to education level that the original model did not capture.

//That implies education might have nonlinear or level-specific effects on wages that aren't fully modeled by a linear Educ variable alone.
// Hence, improving the model by including education dummies directly makes the model better.
