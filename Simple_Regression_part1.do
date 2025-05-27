					### **SIMPLE LINEAR REGRESSION**
				
					###	PART 1
			
			
			
			### CREATE HISTOGRAM AND SCATTER PLOT DIAGRAM

#Histogram
histogram Age, frequency
histogram Expenditures, frequency

#Scatter Plot
twoway (scatter Expenditures Age)


			### FURTHER ANALYSIS

tabstat Expenditures, by(Age) statistics(mean, count) columns(statistics)

#creates new dataset with mean expenditures for each age group
preserve
collapse (mean) Expenditures, by(Age)
#use "restore" to restore the previous dataset

#Line graph of average expenditure by each age group
twoway line Expenditures Age, sort ///
    title("Mean Expenditures by Age") ///
    ytitle("Mean Expenditures") ///
    xtitle("Age") ///
    lcolor(blue) lwidth(medium)
	
// the line graph shows that, on average, the youth make more expenditures than adult and older population.

#Analyze the data with normal distribution
restore
histogram Expenditures, normal ///
    title("Histogram of Expenditures with Normal Curve") ///
    ytitle("Frequency") ///
    xtitle("Expenditures")

// the data is not normally distributed; it is positively skewed.

   

			### SUMMARY STATISTICS

#Sample mean of expenditures
summarize Expenditures
summarize Age

			### CALCULATE MEAN FOR AGE GROUPS

#Create age group
gen age_group = Age >= 40
label define agegrp 0 "Under 40" 1 "40 or Older"
label values age_group agegrp
label var age_group "Age Group"

#Calculate group mean
tabstat Expenditures, by(age_group) statistics(mean n) columns(statistics)


			### PREDICT EXPENDITURE OF NEW CLIENTS

#Regress expenditures on age
regress Expenditures Age

#Predict for 25 and 50 years old people
gen age_predict = .
replace age_predict = 50 in 1
replace age_predict = 25 in 2
predict exp_hat, xb
list age_predict exp_hat in 1/2



#regression line
twoway (scatter Expenditures Age) (lfit Expenditures Age), ///
    title("Regression Line: Expenditure vs Age") ///
    ytitle("Expenditure") ///
    xtitle("Age") ///
    legend(order(1 "Data Points" 2 "Fitted Line"))


			### ELASTICITY OF REGRESSION FUNCTION

gen ln_Expenditures = ln(Expenditures)
gen ln_age = ln(Age)

#Log-Log Model
regress ln_Expenditures ln_age

//The relationship is statistically significant (p = 0.007 < 0.05) with r-sqaured 0.267.

//In a log-log model, the slope is the elasticity. The coefficient on ln_age is the elasticity of expenditures with respect to age.

//A 1% increase in age is associated with a 0.0996% (approximately 0.1%) decrease in daily holiday expenditures, on average, holding other factors constant.

# Linear-Log Model
regress Expenditures ln_age

//A 1% increase in age is associated with a decrease of approximately 0.0989 units in expenditures.

//In this regression, elasticity is not constant. We can compute elasticity of the mean Expenditures as follows:
#'summarize' must run before executing the rest to get the mean
summarize Expenditures
display _b[ln_age] / r(mean)

// the elasticity of the model is −0.0978, which is close to that of the log-log model.


# Log-Linear Model
regress ln_Expenditures Age

//A one-unit increase in age (i.e., one additional year) is associated with approximately a 0.335% decrease in daily holiday expenditures.

//In this model, elasticity equals β * x. So it varies with age.
#To compute elasticity at age 40 and 20
display _b[Age]*40
display _b[Age]*20

//A 40-year age increase would correspond to approximately a 13.4% decrease in expenditures.
//A 20-year age increase would correspond to approximately a 6.7% decrease.
