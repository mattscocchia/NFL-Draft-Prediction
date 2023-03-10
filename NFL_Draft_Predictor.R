df = read.csv("NFL.csv")

#Load the reuired libraries
library(stringr)
#install.packages("mice")
library(mice)
#install.packages("brnn",dependencies = TRUE)
library(brnn)
#install.packages("writexl")
library("writexl")
library(ggpubr)


#Turn the draft information into just the draft position
#and handling of the NA draft_positions by making these 
#players ranked for non existing draft positions
for (i in 1:nrow(df)){
  j = i
  #if loop for the NA draft position players
  if(is.na(df$Drafted..tm.rnd.yr.[i])){
    year_i = df$Year[i]
    max_draft = max(sort(as.numeric(df[which(df$Year == year_i),13])))
    df$Drafted..tm.rnd.yr.[i] = max_draft+1
    j = j + 1
  }
  #Because some picks were 1 number, some were 2 and some 
  #were 3, this is accounted. There was also a team which 
  #had number in its name, so this had to be accounted for in 
  #the loop. 
  if (j == i){
    string = str_interp(df$Drafted..tm.rnd.yr.[i])
    individ = strsplit(string,split = numeric())
    temp = as.numeric(individ[[1]])
    nas = na.omit(temp)[2:(length(na.omit(temp)) - 4)]
    #if loop for handling the team with numbers in the name
    if ((na.omit(temp)[1] == "4" && na.omit(temp)[2] == "9")){
      nas = na.omit(temp)[4:(length(na.omit(temp)) - 4)]
      if (length(nas) == 1){
        df$Drafted..tm.rnd.yr.[i] = nas
      }
      if (length(nas) == 2){
        nas_combined = paste(nas[1],nas[2],sep='')
        df$Drafted..tm.rnd.yr.[i] = nas_combined
      }
      if (length(nas) == 3){
        nas_combined = paste(nas[1],nas[2],nas[3],sep='')
        df$Drafted..tm.rnd.yr.[i] = nas_combined
      }
    }
    if (length(nas) == 1){
      df$Drafted..tm.rnd.yr.[i] = nas
    }
    if (length(nas) == 2){
      nas_combined = paste(nas[1],nas[2],sep='')
      df$Drafted..tm.rnd.yr.[i] = nas_combined
    }
    if (length(nas) == 3){
      nas_combined = paste(nas[1],nas[2],nas[3],sep='')
      df$Drafted..tm.rnd.yr.[i] = nas_combined
    }
    if (length(nas) == 5){
      nas = nas[c(-1,-2)]
      nas_combined = paste(nas[1],nas[2],nas[3],sep='')
      df$Drafted..tm.rnd.yr.[i] = nas_combined
    }
  }
}

#To start, change the draft position of certain players, 
#since the draft position for these players was inputted 
#into the orginal dataset wrong.
df[322,13] = 99
df[461,13] = 98
df[613,13] = 99
df[766,13] = 96
df[775,13] = 97
df[732,13] = 99
df[1033,13] = 98
df[969,13] = 99
df[1557,13] = 99
df[3469,13] = 23
df[3469,18] = "Yes"

#load the dataset made on python
nfl_final = read.csv("NFL_updated.csv")
#set the draft information from the new dataset equal to the
#draft information from the original dataset.
nfl_final$Drafted..tm.rnd.yr. = df$Drafted..tm.rnd.yr.
#Make the new column name "Draft Position"
colnames(nfl_final)[13] = "Draft_Position"
#make the Draft Position data numeric
nfl_final$Draft_Position = as.numeric(nfl_final$Draft_Position)


# For the missing values in age and combine events, MICE
#algorithm was used to predict the value of the missing 
#data
pmm = mice(nfl_final[,c(3,7,8,9,10,11,12)],method = "pmm")
#replace the NA's by the predicted values
nfl_final[,c(3,7,8,9,10,11,12)] = complete(pmm,1)

#Make a row for the readjusted rank of a player
nfl_final$Rank = nfl_final$Draft_Position
#Function that readjusts the rank of a player based on how 
#many players there were in each draft year
for (i in 2009:2019){
  for (j in 1:length(which(nfl_final$Year==i))){
    temp_data = nfl_final[which(nfl_final$Year == i),]
    temp_sort = order(temp_data$Draft_Position) 
    rank_num = which(temp_sort == j)
    #Making sure the school and year also line up since some
    #players have the same name and year
    nfl_final[which((nfl_final$Player == temp_data$Player[j])&
                    nfl_final$Year == i &
                    nfl_final$School == temp_data$School[j]),23] = rank_num
  }
}

#Some teams relocated, so we make them one franchise instead
#of two
for (i in 1:nrow(nfl_final)){
  if (nfl_final$Team[i] == "St. Louis Rams"){
    nfl_final$Team[i] = "Los Angeles Rams"
  }
  if (nfl_final$Team[i] == "Oakland Raiders"){
    nfl_final$Team[i] = "Las Vegas Raiders"
  }
  if (nfl_final$Team[i] == "San Diego Chargers"){
    nfl_final$Team[i] = "Los Angeles Chargers"
  } 
}





#Plot showing the overall density of the 40 Yard dash 
#by drafted and undrafted players
p1 = ggdensity(nfl_final, x = "Sprint_40yd", add = "median", 
                rug = TRUE, color = "Drafted", 
                fill = "Drafted", palette = c("#fca103","#49c726"),
                xlab = "40 yd Sprint (s)", ylab = "Density")
p1

#Plot showing the overall density of the vertical jump 
#by drafted and undrafted players
p2 = ggdensity(nfl_final, x = "Vertical_Jump", add = "median", 
                rug = TRUE, color = "Drafted", 
                fill = "Drafted", palette = c("#fca103","#49c726"),
                xlab = "Vertical Jump (cm)", ylab = "Density")
p2

#Plot showing the overall density of the broad jump
#by drafted and undrafted players
p3 = ggdensity(nfl_final, x = "Broad_Jump", add = "median", 
                rug = TRUE, color = "Drafted", 
                fill = "Drafted", palette = c("#fca103","#49c726"),
                xlab = "Broad Jump (cm)", ylab = "Density")
p3

#Plot showing the overall density of bench press reps 
#by drafted and undrafted players
p4 = ggdensity(nfl_final, x = "Bench_Press_Reps", add = "median", 
                rug = TRUE,color = "Drafted", 
                fill = "Drafted", palette = c("#fca103","#49c726"),
                xlab = "Bench Press Reps (n)", ylab = "Density")
p4

#Plot showing the overall density of the agility 3 cone  
#by drafted and undrafted players
p5 = ggdensity(nfl_final, x = "Agility_3cone", add = "median", 
                rug = TRUE, color = "Drafted",
                fill = "Drafted", palette = c("#fca103","#49c726"),
                xlab = "Agility 3 Cone (s)", ylab = "Density")
p5

#Plot showing the overall density of the shuttle
#by drafted and undrafted players
p6 = ggdensity(nfl_final, x = "Shuttle", add = "median", 
                rug = TRUE, color = "Drafted", 
                fill = "Drafted", palette = c("#fca103","#49c726"),
                xlab = "Shuttle (s)", ylab = "Density")
p6


# Function to add correlation coefficients
panel.cor <- function(x, y, digits = 2, prefix = "", cex.cor, ...) {
  usr <- par("usr")
  on.exit(par(usr))
  par(usr = c(0, 1, 0, 1))
  Cor <- abs(cor(x, y)) # Remove abs function if desired
  txt <- paste0(prefix, format(c(Cor, 0.123456789), digits = digits)[1])
  if(missing(cex.cor)) {
    cex.cor <- 0.4 / strwidth(txt)
  }
  text(0.5, 0.5, txt,
       cex = 1 + cex.cor * Cor) # Resize the text by level of correlation
}

# Plotting the correlation matrix
pairs(nfl_final[,c(7,8,9,10,11,12,23)],
      upper.panel = panel.cor,    # Correlation panel
      lower.panel = panel.smooth) # Smoothed regression lines

pairs(nfl_final[,c(3,5,6,14,23)],
      upper.panel = panel.cor,    # Correlation panel
      lower.panel = panel.smooth) # Smoothed regression lines



#linear model funciton
func = function(year1,year2){
  #Filter to only players that have a grade, overall and 
  #position rank for both years
  indices = c(which(nfl_final$Year == year1 & 
                      !is.na(nfl_final$grade) &
                      !is.na(nfl_final$ovr_rank &
                      !is.na(nfl_final$pos_rank))))
  next_indices = c(which(nfl_final$Year == year2 & 
                      !is.na(nfl_final$grade) &
                      !is.na(nfl_final$ovr_rank &
                      !is.na(nfl_final$pos_rank))))
  #Separate into training and testing sets
  training_set = nfl_final[indices,]
  test_set = nfl_final[next_indices,]
  #Make the response variable a log scale
  training_set$Rank = log(training_set$Rank)
  test_set$Rank = log(test_set$Rank)
  
  #Run the linear regresison model
  nfl_lm = lm(Rank ~ Sprint_40yd + Vertical_Jump + grade +
                Bench_Press_Reps + Broad_Jump + Age + 
                Agility_3cone + Shuttle + Weight + Height +
                BMI + ovr_rank,
                data= training_set)
  
  #Sort by Rank from 1 to the end
  nfl_sort = test_set[order(test_set$Rank),]
  #Predict the new data
  nfl_pred_sort = predict(nfl_lm,nfl_sort)
  #Return the data to the regular scale
  nfl_sort$Rank = exp(nfl_sort$Rank)
  #Make a new column for the predictions
  nfl_sort$Pred = nfl_pred_sort
  #Re-rank the predictions from 1 to the end
  temp_order = order(nfl_sort$Pred)
  for (i in 1:length(nfl_pred_sort)){
    nfl_pred_sort[temp_order[i]] = nfl_sort$Pred[temp_order[i]] = i
  }
  #Plot the predictions against the rank
  plot(nfl_pred_sort,nfl_sort$Rank, 
       xlab = "Projected Rank", ylab = "Actual Rank")
  abline(0,1)
  #Print the total sum of logarithmic squares
  print(sum((log(nfl_sort$Rank)-log(nfl_pred_sort))^2))
  #Return the sorted dataset with the new predictions
  return (nfl_sort[order(nfl_pred_sort),])
}

#Model that uses all predictors possible while also keeping
#all players eligible for the prediction
year_by_year = function(year1,year2) {
  #Filter the players by year
  indicies_loop = c(which(nfl_final$Year == year1))
  next_indicies_loop = c(which(nfl_final$Year == year2))
  #Separate into training and testing sets
  training_loop = nfl_final[indicies_loop,]
  test_loop = nfl_final[next_indicies_loop,]
  #Make the response variable a log scale
  training_loop$Rank = log(training_loop$Rank)
  test_loop$Rank = log(test_loop$Rank)
  
  #Make the BRNN model
  mod_loop = brnn(formula=Rank ~ Sprint_40yd + Vertical_Jump +
                      Bench_Press_Reps + Broad_Jump + Age + 
                      Agility_3cone + Shuttle + Weight + Height +
                      BMI + Player_Type + Position_Type,
                  data=training_loop,Monte_Carlo = TRUE)
  
  #Sort by Rank from 1 to the end
  sorted_loop = test_loop[order(test_loop$Rank),]
  #Predict the new data
  sorted_pred_loop = abs(predict.brnn(mod_loop,sorted_loop))
  #Return the data to the regular scale
  sorted_loop$Rank = exp(sorted_loop$Rank)
  #Make a new column for the predictions
  sorted_loop$Pred = exp(sorted_pred_loop)
  #Re-rank the predictions from 1 to the end
  temp_order = order(sorted_loop$Pred)
  for (i in 1:length(sorted_pred_loop)){
    sorted_pred_loop[temp_order[i]] = sorted_loop$Pred[temp_order[i]] = i
  }
  #Plot the predictions against the rank
  plot(sorted_pred_loop,sorted_loop$Rank, 
       xlab = "Projected Rank", ylab = "Actual Rank")
  abline(0,1)
  #Print the total sum of logarithmic squares
  print(sum((log(sorted_loop$Rank)-log(sorted_pred_loop))^2))
  #Return the sorted dataset with the new predictions
  return(sorted_loop[temp_order,])
}

#Model that includes the players grade, overall and position
#rank
year_by_year_2 = function(year1,year2) {
  #Filter to only players that have a grade, overall and 
  #position rank for both years
  indicies_loop = c(which(nfl_final$Year == year1 & 
                            !is.na(nfl_final$grade) &
                            !is.na(nfl_final$ovr_rank &
                            !is.na(nfl_final$pos_rank))))
  next_indicies_loop = c(which(nfl_final$Year == year2 & 
                                 !is.na(nfl_final$grade) &
                                 !is.na(nfl_final$ovr_rank &
                                  !is.na(nfl_final$pos_rank))))
  #seperate into training and testing sets
  training_loop = nfl_final[indicies_loop,]
  test_loop = nfl_final[next_indicies_loop,]
  #Make the response variable a log scale
  training_loop$Rank = log(training_loop$Rank)
  test_loop$Rank = log(test_loop$Rank)
  
  #Make the BRNN model
  mod_loop = brnn(formula=Rank ~ Sprint_40yd + Vertical_Jump +
                    Bench_Press_Reps + Broad_Jump + Age +
                    Agility_3cone + Shuttle + Weight + Height +
                    BMI + ovr_rank + grade + Team,
                  data=training_loop,Monte_Carlo = TRUE)
  
  
  #Sort by Rank from 1 to the end
  sorted_loop = test_loop[order(test_loop$Rank),]
  #Predict the new data
  sorted_pred_loop = abs(predict.brnn(mod_loop,sorted_loop))
  #Return the data to the regular scale
  sorted_loop$Rank = exp(sorted_loop$Rank)
  #Make a new column for the predictions
  sorted_loop$Pred = exp(sorted_pred_loop)
  #Re-rank the predictions from 1 to the end
  temp_order = order(sorted_loop$Pred)
  for (i in 1:length(sorted_pred_loop)){
    sorted_pred_loop[temp_order[i]] = sorted_loop$Pred[temp_order[i]] = i
  }
  #Plot the predictions against the rank
  plot(sorted_pred_loop,sorted_loop$Rank, 
       xlab = "Projected Rank", ylab = "Actual Rank")
  abline(0,1)
  #Print the total sum of logarithmic squares
  print(sum((log(sorted_loop$Rank)-log(sorted_pred_loop))^2))
  #Return the sorted data set with the new predictions
  return(sorted_loop[temp_order,])
}

#Function to aggregate the predictions made by the two models
comb_func = function(draft_1,draft_2, draft_3){
  #Make the combined data set using the same parameters
  #as the biggest data set
  combined = draft_1
  for (i in 1:nrow(draft_1)){
    #Make the prediction for the players who don't have all of
    #the grade, position and overall ranks the average of 
    #their rank and predicted rank
    if ((is.na(draft_1$ovr_rank[i]) || is.na(draft_1$pos_rank[i]) ||
        is.na(draft_1$grade[i])) & (abs(draft_1$Rank[i] - draft_1$Pred[i]) > 80)){
      combined$Pred[i] = (abs(draft_1$Rank[i] - draft_1$Pred[i]))/2
    }
    #Make the prediction for the weighted average of the
    #linear regression model and the second BRNN model
    for (j in 1:nrow(draft_2)){
      for (k in 1:nrow(draft_3)){
        if ((draft_1$Player[i] == draft_2$Player[j]) &
            (draft_1$Player[i] == draft_3$Player[k])){
          combined$Pred[i] = (0*draft_1$Pred[i] +
                                0.6*draft_2$Pred[j] + 
                                0.4*draft_3$Pred[k])/3
        }
      }
    }
  }
  #Reorder the players by prediction rankings
  temp_order = order(combined$Pred)
  for (i in 1:nrow(combined)){
    combined$Pred[temp_order[i]] = i
  }
  #Print the total sum of logarithmic squares
  print(sum((log(combined$Rank)-log(combined$Pred))^2))
  #Return the full data set sorted by predictions
  return(combined[order(combined$Pred),])
}



#The first BRNN model predicted draft order for 2010
pred_draft_2010 = year_by_year(2009,2010)
#The second BRNN model predicted draft order for 2010
pred_draft_2010_2 = year_by_year_2(2009,2010)
#The linear model predicted draft order for 2010
lm_2010 = func(2009,2010)

#The first BRNN model predicted draft order for 2011
pred_draft_2011 = year_by_year(2010,2011)
#The second BRNN model predicted draft order for 2011
pred_draft_2011_2 = year_by_year_2(2010,2011)
#The linear model predicted draft order for 2011
lm_2011 = func(2010,2011)

#The first BRNN model predicted draft order for 2012
pred_draft_2012 = year_by_year(2011,2012)
#The second BRNN model predicted draft order for 2012
pred_draft_2012_2 = year_by_year_2(2011,2012)
#The linear model predicted draft order for 2012
lm_2012 = func(2011,2012)

#The first BRNN model predicted draft order for 2013
pred_draft_2013 = year_by_year(2012,2013)
#The second BRNN model predicted draft order for 2013
pred_draft_2013_2 = year_by_year_2(2012,2013)
#The linear model predicted draft order for 2013
lm_2013 = func(2012,2013)

#The first BRNN model predicted draft order for 2014
pred_draft_2014 = year_by_year(2013,2014)
#The second BRNN model predicted draft order for 2014
pred_draft_2014_2 = year_by_year_2(2013,2014)
#The linear model predicted draft order for 2014
lm_2014 = func(2013,2014)

#The first BRNN model predicted draft order for 2015
pred_draft_2015 = year_by_year(2014,2015)
#The second BRNN model predicted draft order for 2015
pred_draft_2015_2 = year_by_year_2(2014,2015)
#The linear model predicted draft order for 2015
lm_2015 = func(2014,2015)

#The first BRNN model predicted draft order for 2016
pred_draft_2016 = year_by_year(2015,2016)
#The second BRNN model predicted draft order for 2016
pred_draft_2016_2 = year_by_year_2(2015,2016)
#The linear model predicted draft order for 2016
lm_2016 = func(2015,2016)

#The first BRNN model predicted draft order for 2017
pred_draft_2017 = year_by_year(2016,2017)
#The second BRNN model predicted draft order for 2017
pred_draft_2017_2 = year_by_year_2(2016,2017)
#The linear model predicted draft order for 2017
lm_2017 = func(2016,2017)

#The first BRNN model predicted draft order for 2018
pred_draft_2018 = year_by_year(2017,2018)
#The second BRNN model predicted draft order for 2018
pred_draft_2018_2 = year_by_year_2(2017,2018)
#The linear model predicted draft order for 2018
lm_2018 = func(2017,2018)

pred_draft_2019 = year_by_year(2018,2019)
#The second BRNN model predicted draft order for 2019
pred_draft_2019_2 = year_by_year_2(2018,2019)
#The linear model predicted draft order for 2019
lm_2019 = func(2018,2019)


#The combined model results for the year 2010
comb_2010 = comb_func(pred_draft_2010,pred_draft_2010_2,lm_2010)[,c(2,23,24)]
write_xlsx(comb_2010,"C:/Users/Scocc/OneDrive/Documents/Stats 4850//Comb_2010.xlsx")
#The combined model results for the year 2011
comb_2011 = comb_func(pred_draft_2011,pred_draft_2011_2,lm_2011)[,c(2,23,24)]
write_xlsx(comb_2011,"C:/Users/Scocc/OneDrive/Documents/Stats 4850//Comb_2011.xlsx")
#The combined model results for the year 2012
comb_2012 = comb_func(pred_draft_2012,pred_draft_2012_2,lm_2012)[,c(2,23,24)]
write_xlsx(comb_2012,"C:/Users/Scocc/OneDrive/Documents/Stats 4850//Comb_2012.xlsx")
#The combined model results for the year 2013
comb_2013 = comb_func(pred_draft_2013,pred_draft_2013_2,lm_2013)[,c(2,23,24)]
write_xlsx(comb_2013,"C:/Users/Scocc/OneDrive/Documents/Stats 4850//Comb_2013.xlsx")
#The combined model results for the year 2014
comb_2014 = comb_func(pred_draft_2014,pred_draft_2014_2,lm_2014)[,c(2,23,24)]
write_xlsx(comb_2014,"C:/Users/Scocc/OneDrive/Documents/Stats 4850//Comb_2014.xlsx")
#The combined model results for the year 2015
comb_2015 = comb_func(pred_draft_2015,pred_draft_2015_2,lm_2015)[,c(2,23,24)]
write_xlsx(comb_2015,"C:/Users/Scocc/OneDrive/Documents/Stats 4850//Comb_2015.xlsx")
#The combined model results for the year 2016
comb_2016 = comb_func(pred_draft_2016,pred_draft_2016_2,lm_2016)[,c(2,23,24)]
write_xlsx(comb_2016,"C:/Users/Scocc/OneDrive/Documents/Stats 4850//Comb_2016.xlsx")
#The combined model results for the year 2017
comb_2017 = comb_func(pred_draft_2017,pred_draft_2017_2,lm_2017)[,c(2,23,24)]
write_xlsx(comb_2017,"C:/Users/Scocc/OneDrive/Documents/Stats 4850//Comb_2017.xlsx")
#The combined model results for the year 2018
comb_2018 = comb_func(pred_draft_2018,pred_draft_2018_2,lm_2018)[,c(2,23,24)]
write_xlsx(comb_2018,"C:/Users/Scocc/OneDrive/Documents/Stats 4850//Comb_2018.xlsx")
#The combined model results for the year 2019
comb_2019 = comb_func(pred_draft_2019,pred_draft_2019_2,lm_2019)[,c(2,23,24)]
write_xlsx(comb_2019,"C:/Users/Scocc/OneDrive/Documents/Stats 4850//Comb_2019.xlsx")
