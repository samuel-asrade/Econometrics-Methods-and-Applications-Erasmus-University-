					### **SIMPLE LINEAR REGRESSION**
					
					###  PART 2

			## ESTIMATE R^2 AND STANDARD ERROR
summarize

#regress the simple regression					
regress Winningtimemen Game

//For each Olympic Games (every 4 years), the winning time decreases by 0.038 seconds on average.
//About 67% of the variation in winning times is explained by the trend in Games.
//The trend is highly statistically significant (p-value < 0.001)
//Predictions have an average error of ±0.12 seconds (Root MSE = 0.12283 seconds)


#Predictive ability
//The model has high cofficient of determination (67%) and its adjusted cofficient of determination is close as well (64%). Also, the model is statistically significant. These results show strong predictive ability of the model.

//RMSE measures the typical size of the prediction error. This model's predicted 100m winning time is, on average, off by about 0.12 seconds. But this is large as 100m running game winners differ in matter of few seconds. Hence, the RMSE result shows a less predictive ability of the model.


#Predictions for 2008, 2012, and 2016 
//the years correspond to games 16, 17, and 18.
margins, at(Game=(16 17 18))

//the actual time was smaller than the predicted one on 2008 and 2012 games, whereas the actual time was larger than the predicted time in 2016.



