					### **MULTIPLE REGRESSION MODEL**
					
					### PART 2
	

		#JOINT HYPOTHESIS TESTING
			
regress LogWage Female Age Educ Parttime
testparm Female Age Educ Parttime

// The null hypothesis (all variables are 0) is rejected, since p-value is less than 0.05. Hence, at least one of the explanatory variables (Female, Age, Educ, Parttime) has a statistically significant effect on log(Wage).


		#REGRESS BY MAKING EDUCATION DUMMY 

#create dummies for education, and drop one dummy to avoid dummy variable trap
tabulate Educ, generate(E)
drop E1

#run the regression using dummies (exclude the var Educ)
regress LogWage Female Age E2 E3 E4 Parttime

		#TEST FITTNESS OF RESTRICTED AND UNRESTRICTED MODEL

#run unrestricted model with dummies
regress LogWage Female Age E2 E3 E4 Parttime
test (E2 - 2*E3 + E4 = 0) (E3 - 2*E4 = 0)
 
// The number of linear restrictions (g) is calculated as follows:
// g = number of parameters in general model - number of parameters in restricted(simpler) model
// Hence, there are two restrictions (g = 3 - 1 = 2)

// The null hypothesis assumes that education coefficients satisfy the linear restriction, whereas the alternative hypothesis assumes that at least one restriction does not hold (i.e., the effect depends on education level)

// Based on the above test, the null hypothsis is rejected; Hence, the more flexible model with education dummies (allowing the effect to vary by education level) fits the data much better.
