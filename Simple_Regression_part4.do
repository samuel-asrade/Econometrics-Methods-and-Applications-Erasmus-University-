					### **SIMPLE LINEAR REGRESSION**
					
					### PART 4

summarize

			#PREDICT LINEAR TREND
#for women in 2140			
regress Winningtimewomen Game
margins, at(Game=(49))

#for men in 2140
regress Winningtimemen Game
margins, at(Game=(49))

//The linear trend model predicts men and women will run 100m in the same time (~8.53 sec) around the year 2140 (Game 49).


			#PREDICT NON-LINEAR TREND
gen lnwin_wom = ln(Winningtimewomen)
gen lnwin_men = ln(Winningtimemen)

#for women in 2192
regress lnwin_wom Game
margins, at(Game=(62))
matrix K = r(b)
scalar ln_prd = M[1,1]
display exp(ln_prd)

#for men in 2192
regress lnwin_men Game
margins, at(Game = (62))
matrix M = r(b)
scalar ln_pred = M[1,1]
display exp(ln_pred)

//According to the log-linear trend model, men and women are expected to run equally fast (≈8.23s) in the 62nd Games in 2192.

//The linear model is less realistic in the long-term because we can't improve by fixed seconds forever. The log-linear model assumes diminishing improvements (constant % gains), and it is more realistic for biological limits in sprinting.


