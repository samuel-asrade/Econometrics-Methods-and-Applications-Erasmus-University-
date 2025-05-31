						### **MODULE 2 EXAM**
						
					
summarize

			#Plot a Scatter Diagram and Fit Regression Line
twoway (scatter Sales Advertising) (lfit Sales Advertising)

			#Simple Regression Model
regress Sales Advertising

//based on the model, for each additional unit of advertising, sales (on average) decrease by 0.325 units.
// the cofficient of advetising is -o.324, and the standard error is 0.458
// the model is statistically insignificant with p-value is 0.488, and coffient of determination of 2.7%.


			#Compute Residuals and Draw Histogram
predict residuals, residuals
histogram residuals, normal

//The histogram shows skewness to the right, and violate the normality assumption. This could be due to outliers, like evening opening weeks.


			#Include Dummay Variable 
#include dummy for 'evening', and regress the binary model
gen evening = 0
replace evening = 1 if Observation == [12]
regress Sales Advertising evening

//The evening event had a massive and statistically significant impact on sales. Including it in the model drastically improved the model fit (R^2 jumped from ~2.7% to 97%).


			#Remove the outlier and Regress the Model again
#regress without the dummy (the outlier data)
regress Sales Advertising if evening == 0

//Removing the outlier (evening week) gives a decent model (R^2 = 51.5%) and confirms that advertising does have a positive, statistically significant impact on sales.




