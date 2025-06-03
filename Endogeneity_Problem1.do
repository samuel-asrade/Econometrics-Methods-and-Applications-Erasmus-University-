					### **ENDOGENEITY PROBLEM**
					
					### PART 1
			
			
			
			#REGRESS WHEN EVENT AFFECTS ONLY PRICE, NOT SALES(a=0, and b= 0, 1, 5, 10)

regress SALES0_0 PRICE0
regress SALES0_1 PRICE1
regress SALES0_5 PRICE5
regress SALES0_10 PRICE10

//The coefficients are all very close to each other (between -0.965 and -0.985), and all statistically significant. Since α=0, the Event does not affect sales directly, meaning there is no omitted variable bias even though Event affects price. So, Price is not endogenous in this setup — and the regressions are valid OLS.
//R² increases as β increases from 0.79 to 0.97. This happens because Price becomes more variable as β increases, since it is more influenced by the Event (which is binary). That added variation in Price improves the model's ability to explain variation in Sales.


			#REGRESS WHEN EVENT AFFECTS ONLY SALES, NOT PRICES (b=0, and a= 0, 1, 5, 10)
			
regress SALES0_0 PRICE0
regress SALES1_0 PRICE0
regress SALES5_0 PRICE0
regress SALES10_0 PRICE0

//The estimated price coefficients remain negative and relatively stable, hovering around -0.91 to -0.98. This suggests no serious endogeneity problem, which is expected: Event affects only sales, and price is exogenous.
//As α increases, the Event dummy causes more variability in sales that is not explained by Price. Since Event (a key explanatory variable) is omitted, more of the variation in sales appears random to the regression. Thus, R² drops significantly — from 0.79 to 0.07. This reflects greater omitted variable variance.


			#REGRESS WHEN EVENT AFFECTS BOTH SALES AND PRICES (b=a= 0, 1, 5, 10)
			
regress SALES0_0 PRICE0
regress SALES1_1 PRICE1
regress SALES5_5 PRICE5
regress SALES10_10 PRICE10

//The true price effect is -1, but the regression omits the event variable. As the event has a stronger effect on both sales and price, the correlation between price and the error increases. This causes downward bias in the estimate of the price coefficient. R² declines because price is a poor proxy for both event and true demand now. It violates the exogeneity assumption leading to bias towards 0 (attenuation) when the omitted variable is positively correlated with both the regressor and the outcome.
//When α = β = 0: Price is exogenous → unbiased estimate. As α = β increases: Price is endogenous (due to common cause: event). OLS estimate becomes biased and inconsistent. This illustrates why causal inference requires accounting for omitted variables — and the danger of using OLS blindly when endogeneity is present.