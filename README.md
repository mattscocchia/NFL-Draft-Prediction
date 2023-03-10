# NFL-Draft-Prediction
NFL Draft Prediction Model using advanced statistical methods.


### 1 Introduction
The NFL draft is a chance for poorly performing NFL teams to have the first selection of draft
eligible players. The draft provides teams with the opportunity to get better by using ordered draft
picks to select who they want. The order is decided by the final standings from the prior season in a
reverse serpentine order. NFL fans from all over travel to view the event live while those who choose
not to go, can watch from home as the three day event takes place. Lots of eager fans wait in
anticipation as their teams decide who to select, with some even going so far as to bet on where
certain players will get drafted to. It is estimated that there was approximately fifty million dollars’
worth of bets that were placed on the 2020 NFL draft. This doesn’t make it one of the most popular
betting events but it’s still relatively new, with sportsbooks only being allowed to book the event for
the first time in 2017. In 2018, most sportsbooks actually lost money on the draft making future
events enticing for informed bettors to make money. The NFL scouting combine is an event held
before the draft for players to showcase their athletic abilities that might not be quantifiable during
games. It is the most in depth look NFL teams get into the physical abilities of the next wave of
draftable football players. That’s why the results from the NFL scouting combine provide teams with
the best look at how players stack up head to head physically given they participate in the same
standard drills. The results of the combine can directly influence a player’s draft position. Draft player
information is very sensitive for NFL teams since the research and information they collect about
players are generally done individually. A lot of misinformation gets released in the months prior to
the draft, including teams intentionally relaying false information to the media for the purpose of
protecting their intentions. This makes betting without proper knowledge difficult, since it isn’t easy
to tell whether the news that gets released is true or not. In addition a lot of football experts, who are
employed by sports companies release what they call “mock drafts” that include their idea of when
players will get selected and which team will select them. The experts usually don’t make their
rankings on a best available option but rather based on other knowledge. This process is done using
the various knowledge of the expert, as well as information such as which position the team needs a
player for, previous team draft history, player profiles and team values. Most NFL experts don’t use
many advanced statistical methods if any at all, as a result of not having the knowledge of how to
carry out these processes. The actual draft picks are made by the team’s General Manager with input
from coaches, advisors, higher ups and in some cases, even the owner. In this report, I will use a
variety of statistical methods with the goal of accurately projecting where a player will be drafted.
### 2 Dataset
The dataset I have chosen is the NFL combine results from the years 2009-2019 which was
found on Kaggle. The dataset does not contain the results for every player who has participated in the
event over the time period but it does include the results for at least 220 players from every year for a
total of 3477 observations. There are a total of 18 columns which include the year of the combine, the
player’s name, age in years, school, height in meters, weight in kilograms, 40 yard sprint time in
seconds, vertical jump in cm, number of reps lifting 102.1 kilograms on bench press, broad jump in
centimeters, 3 cone agility time in seconds, lateral shuttle time in seconds, a text containing (the
team, round, overall and draft year), body mass index, player’s general position, player’s broad
position, player’s specific position and a dummy variable indicating whether or not the player was
drafted which will also be the response variable.
To assist in carrying out the analysis, another dataset has been used and was found on GitHub.
This dataset is much larger but only a small part is being used. The main data being used from this
dataset include the overall prospect rank, their position rank and their prospect grade, all of which will
be added as columns to the original dataset. This will be done by matching player names in the
dataset and then adding that player’s respective information. The overall and position ranks were
made by ESPN analysts who have spent lots of years covering the NFL, so these rankings although
arbitrary, serve as the best guess of a prior distribution for a Bayesian hierarchal model. The prospect
grade measures a team’s performance with the certain player on compared to when they aren’t on. It
was made using a Bayesian model taking into account a player’s direct contribution to a play. A
number is finalized on a scale of 0-100, with 100 being the best. To account for differences in
positions, a 99 rated quarterback will have more impact than a 98 rated wide receiver. These ratings
do not reflect who will get drafted first, though there is a strong correlation between the two.
When merging the two datasets, there were some players from the original dataset that the
new dataset didn’t have. In 2009, twenty two players didn’t have an overall rank and one player didn’t
have a position rank out of a possible 327 players. In 2010, one hundred and six players didn’t have an
overall rank out of a possible 326 players. In 2011, five players didn’t have an overall rank out of a
possible 329 players. In 2012, twenty six players didn’t have an overall rank out of a possible 324
players. In 2013, fifteen players didn’t have an overall rank and one player didn’t have an overall rank,
position rank or a grade out of a possible 332 players. In 2014, eight players didn’t have an overall
rank out of a possible 333 players. In 2015, two players didn’t have an overall rank and three players
didn’t have an overall rank, position rank or a grade out of a possible 322 players. In 2016, only one
player didn’t have an overall rank out of a possible 329 players. In 2017, seven players didn’t have an
overall rank out of a possible 327 players. In 2018, eight players didn’t have an overall rank and one
player didn’t have an overall rank, position rank or a grade out of a possible 308 players. In 2019, only
one player didn’t have an overall rank, position rank or a grade out of a possible 220 players.
### 3 Methods
In the dataset, the column containing a player’s draft information was a character string with
their team and pick information if they had gotten picked. In order to use this information, I extracted
the overall pick number that was used to select the player so that it was the only information in the
column and subsequently renamed the column accordingly. A big issue regarding the NFL combine is
that some players decide not to participate in certain events. This provided a big issue regarding how
the missing data would be handled, so the data was dealt with two different ways. The amount of
players that get drafted to the NFL changes each year. To account for this, I gave the players who
didn’t get drafted, a fake draft number that was a continuation from the last player drafted in the
given year. For example, the last player that got drafted in 2009 was taken 255th overall. The
remaining players would then be ordered from 256 onwards. It should also be noted that for the
majority of the years, there were multiple players selected for some picks. This was fixed by hand, as
there was only a few numbers to change. Since not every player from the draft year was included in
the data, I reranked every player so that there was no “missing” picks in each year. With regard to the
combine events, it was determined that using multivariate imputation by chained equations (MICE), it
would produce the most accurate results. MICE is based on Fully Conditional Specification which has
each incomplete variable be computed by sperate models. Since the data was numeric, predictive
means matching method (PMM) would make the most sense since it produces the least amount of
implausible values. The function 𝑚𝑖𝑐𝑒(), from the package mice was used to carry out the MICE
method using PMM which can be found on page 14 in the Appendix.
In the main data analysis, a basic linear regression and two Bayesian Regularized Neural
Network’s (BRNN) was used to predict where a player would be drafted to. The function 𝑙𝑚() from
the package 𝑠𝑡𝑎𝑡𝑠 was used to make the linear regression model. The linear regression is of the form:

$$Y_i = \beta_0+\beta_i*x_i+e_i, i=1,...,14$$

Where: $e_i~𝑁(0, \sigma^2), 𝑥_𝑖$ is the $𝑖^{𝑡ℎ}$ independent variable, $\beta_0$ is the intercept and $\beta_𝑖$ is the
coefficient for the $𝑖^{𝑡h}𝑥$ term. The linear regression model uses all the physical measures such as age,
height, weight and body mass index, the physical tests ran by the combine and the grade, overall rank
and team of the player for a total of 13 predictors. The model was assessed using a total sum of
logarithmic squares test. The function 𝑏𝑟𝑛𝑛() from the package 𝑏𝑟𝑛𝑛 was used to carry out the
training for the RNN. The equation used by the 𝑚𝑖𝑐𝑒() is:

$$Y_i = g(x_i)+e_i=\sum_{k+1}^{s}w_kg_k(b_k+\sum_{j=1}^{p}x_i\beta_j^{[k]})+e_i,i=1,..,n$$

Where: $e_i~N(0,\sigma_e^2)$ n is either 12 or 13 depending on the model, s is the number of
neurons, $𝑤_𝑘$ is the weight of the $𝑘^{𝑡ℎ}$ neuron, $𝑘=1,…,𝑠$, $𝑏_𝑘$ is a bias for the $𝑘^{𝑡ℎ}$ neuron, $𝑘=1,…,𝑠$,
$\beta_j^{[s]}$ is the weight of the $𝑗^{𝑡ℎ}$ input to the net, $𝑗=1,...,𝑝$, $𝑔_𝑘(.)$ is the activation function, in this
implementation $𝑔_𝑘(𝑥)=(𝑒^{(2𝑥)} − 1)/(𝑒^{(2𝑥)} + 1)$. The software will minimize: $𝐹 = \beta∗𝐸_𝐷 + \alpha∗𝐸_𝑊$, 
where $𝑦_𝑖 − \hat 𝑦_𝑖$, i.e. the total sum of squares, $𝐸_𝑊$ is the sum of squares of network parameters (weights
and biases), $\beta = 1/(2 ∗ \sigma_𝑒^2), \alpha = 1/(2 ∗ \sigma_\theta^2)$ and $\sigma_\theta^2$ is a dispersion parameter for weights and biases.
In total, the first model used 40 total parameters and the second model used 92 parameters. There
were two BRNN’s that were used in the analysis. The first model used only 12 predictors while the
second used 13 predictors. The first model was made to be “blind” to how players stack up against
each other with respect to predicted football skill. It used only physical measures such as age, height,
weight and body mass index, the physical tests ran by the combine and three different position
classifications. The second BRNN model had team, overall rank and prospect grade, in addition to the
all the covariates listed in the first model.
A fourth model was considered in addition to the three previously mentioned. This model is a
combination of the two BRNN models as well as the linear regression model, taking as input the
weighted average of the three predicted ranks. The weights that were applied were 0% for the smaller
model BRNN model, 60% for the larger BRNN model and 40% for the linear regression model. These
weights were determined through trial and error and will be discussed further in the analysis. The
model only applies these weights for players that appear in all three datasets, since two of three
datasets are subsets. The subset of players in only one of the three datasets are left with their original
predicted order. Both subsets of players are merged together and only reranked after going through
the weighting process. The players are ranked on the set of positive integers starting at 1.
The NFL draft is very arbitrary and there may never be a perfect ordering of players. Some
teams may benefit more from one player compared to another and vice versa for the remaining
teams. Overall there may be a general consensus about a player expected to be picked early being
better than a player expected to be picked super late, though the consensus may change with time
after the players have finished their careers. Due to this unpredictability within the draft, testing
whether the model predicted the draft pick right wouldn’t be a good measure of overall strength.
Therefore, a logarithmic transformation was applied in the form of total sum of squares to measure
the difference between the predictions made by the model and the actual observations. This was
applied to the training and test sets before they were used by the model and the exponential was
taken after the model was completed to produce a proper draft number. The logarithmic difference
between the real draft results and the predicted draft results was also used to asses how far off the
predictions were on a logarithmic scale. By using the logarithmic transformation, it will be evident
how far off the predictions were from the actual observations. For example, the difference between a
player taken 256th and a player taken 286th is approximately 0.048, compared to a player taken 1st and
a player taken 31st, which is approximately 1.49. A difference by a factor of approximately 31. The
reasoning behind this is due to the exponential increase in the skill of the players taken earlier in the
draft. The prospects expected to go in the first round are the most highly talked about and as a result,
get the most attention since it’s expected that they are going to have the biggest impact on the team
in the near and far futures. There are also a few positions where highly skilled players are hard to
come by, which further adds to the exponential difference in the players.
Four functions were made, one for each of the three models and one for combining the results
of the three models. The functions made for each of the three models take as arguments, the two
years being examined. They all start by defining the training and test set, then producing a log output
of the draft rankings. The training and testing sets have been split into the results by year. The training
model was originally an 80% random sample of the whole dataset but unfortunately, the RStudio on
my computer was not capable of handling it. Instead, the data was split by year so that the model was
trained by the data from one year before the year being predicted by the test set. By doing this, the
data would be able to respond to trends over time better than it would be by clumping all the years
together. All three functions have the same functionality and only the model changed in each. The
models all used the logarithmic rankings as the response variable against their respective covariates.
After the prediction was made on the model, the logarithmic rankings were put to the exponential to
return them back to a proper ranking number. Since the predictions weren’t returned as positive
integers, the numbers were subsequently ranked on a set of positive integers from one to the number
of players in the data from the given year. The function returns the ordered list of players in a dataset
and preserves all the original column values for each player, with a new column containing the
predicted spot the player will be picked. The last function which was used for aggregating the results,
takes as input the data frames of the all three results. Using a weighted measure, it averages the
predictions and returns the dataset in order of predicted draft order. Since two of the three models
use a subset of the entire group of players, the combined results will contain all of the players from
each year which is only possible by including the results of the first BRNN model. To account for the
players without the three player skill assessments that end up very high on the draft predictions,
those players will be ranked by the average of their actual draft ranking and predicted draft rating.
This will ideally make the combined results a bit more realistic and the total sum of logarithmic
squares a little lower.
### 4 Analysis
By splitting the draft by year and separating by player type, it was found that with the
exception of 2019, defensive players made up around 43-49% of the players drafted, offensive players
between 48-54% and players who played special teams always accounted for under 5% of the players
selected. The most likely cause of the exception in 2019, can be explained by the small sample size of
drafted players that were acquired since 2019 had around 100 observations less than any other year.
When examining the correlation plots, it was found that there was a significant correlation in BMI and
weight but this was expected as BMI is a measure of height against weight. It’s worth noting that
there were no correlations between any of height, weight and draft order. There were also significant
correlations in: 40 yard sprint time and broad jump, 40 yard sprint time and agility 3 cone, vertical
jump and broad jump, agility 3 cone and shuttle. To my surprise, there was no correlation between
age and draft order. These correlation plots can be found inside the R Code on page 18. With the
exception of the 40 yard sprint, the rest of the combine events had seemingly close to normal
distributions. Though overall, the distribution of each of the combine events were non-parametric as
seen by the graphs in the R Code throughout pages 15, 16 and 17.
The first model ran was the linear regression model using the years 2009 and 2010. The total
sum of logarithmic squares for the prediction of 2010 was 30.28. This is a very good number, but the
dataset produced is roughly only a third of the total players drafted from that year. The results from
2011 to 2019 are as follows: {85.10, 55.94, 286.73, 86.95, 107.11, 95.53, 65.41, 70.33, 116.17}. It’s
evident that 2013 was the least accurate prediction that was produced while 2012 was the most
accurate. The results of the 2013 draft featured multiple players who were expected to be drafted in
the much later rounds go in the first round. Most notably, the biggest jump into the first round and
biggest jump overall was from 299 to 13. This is a major concern considering the extreme rarity of this
ever happening and to my knowledge and research, there has never been a player be picked around
50 spots higher than expected. In 2012, the largest jump to the first round was from 92 to 18 and the
largest jump overall was from 284 to 78.
The first and smaller BRNN model had the worst performance of the three models tested. The
total sum of logarithmic squares from 2010 to 2019 were: {387.63, 283.88, 345.75, 409.19, 352.00,
346.53, 357.71, 386.98, 410.98, 315.59}. Obviously, these numbers were much worse than the prior
linear regression model. This can most likely be explained by the three player skill assessments
included in the linear regression but omitted in this BRNN. The second and larger BRNN model had the
best performance of the three models listed thus far. The total sum of logarithmic squares from 2010
to 2019 were: {61.64, 77.93, 53.94, 55.85, 73.00, 79.08, 73.87, 71.97, 61.11, 67.66}. There was no
single year where this model was more accurate then the linear regression model, though the overall
mean was lower and it was much more consistent then the linear regression model. The fourth model
was less accurate overall than the linear regression model and the second BRNN model. The total sum
of logarithmic squares from 2010 to 2019 were: {83.67, 94.12, 85.15, 128.29, 83.35, 91.41, 94.45,
82.88, 71.38, 91.95}. This was not a surprise since the combined model included the worst performing
model which increased the total sum of logarithmic squares. The worst performing model was
necessary for predicting the ranking of players without a grade, overall rank and position rank since
those players would be otherwise unaccounted for. This final model would be the most accurate
representation of how a given predicted draft would go, considering it includes the entire list of
players included in each year.
At the end of the NFL season, the players who have performed the best are voted into the Pro
Bowl. There are a total of 88 players that participate in the Pro Bowl and they are determined by a
voting process that is an equal share of fan, coach and player voting. When looking through the
results of previous drafts, there are often players from the later rounds that end up making a Pro
Bowl. These players are generally called “sleeper picks” since nobody expected them to make a Pro
Bowl. While the models may not have been extremely accurate at predicting the correct order, the
models did do a fairly good job at selecting these sleeper picks a lot higher than they were originally
selected. From the predictions, players highlighted in yellow indicate they’ve made a Pro Bowl. From
Table 1, the model predicted a high of 17 Pro Bowl players to go in the first round in 2010. The lowest
was Table 10,the year 2019 with 6 players, though there are a few explanations for it. First of all, 2019
was the year that was missing the most players and the players that were selected that year are the
youngest and will have most likely played the least amount of time. As a result, they still have plenty
of time to develop and potentially make a Pro Bowl in the future. The combined results most notable
sleeper pick would be Lamar Miller from Table 4 in 2013 who was predicted to go 18 but actually went
92. If NFL teams had this data beside them in the draft, a team may have selected him a lot earlier had
they known he may have been a sleeper pick.
Another surprising yet possibly random result was that the models did a good job at predicting
“busts” and players who may end up having off-field issues. Busts are players that are expected to be
good, but end up performing well below the expectations set for them. More often than not, the
models did have busts being picked much lower then they were originally picked. In Table 5 on page
10, Blake Bortles who was originally drafted 3, ended up being selected 19 and in Table 8 on page 11,
Baker Mayfield was originally drafted 1, ended up being selected 11. Both of these players and
especially Mayfield can be considered busts as they’ve failed to live up to the lofty expectations set for
them. This also came with players who weren’t busts probably being picked a lot lower then they
should’ve been. With respect to the off-field issues, NFL players have a very concerning history of 
offfield decisions. I won’t get into why this may or may not happen but will examine if the model can
predict which players will be affected by them. After a brief examination, the models do not appear to
predict which players will be affected by off-field decisions. The most likely explanation for any
correlation can likely be explained by chance and by the alarmingly high rate of NFL players that end
up having off-field issues.

### 5 Conclusions
The goal of each of the models was to realistically predict which pick would be used to select a
player. This goal was met by the combined model, to a lesser extent the second BRNN model and to
an even lesser extent, the linear regression model. I was pleasantly surprised by the results of the
combined model and am very curious to see how it would perform on the 2022 NFL Draft. The linear
regression model was interesting to me, because I did not expect the extreme variability and lack of
consistency regarding the predictions it gave the players. I didn’t expect it to perform as well as the
BRNN models due to the low complexity of the model. The results of the first BRNN model was what
surprised me the most though, as I expected it to perform much better than it did, even though there
was no hierarchal player structure involved. The results of the second BRNN model were not
surprising due to my high expectations for it. In the future I would be extremely curious to see how it
would perform if every player had an overall ranking, position ranking and grade. I would expect that
it would increase the overall accuracy of the model. The combined results model wasn’t as surprising
since I combined the most accurate parts of the three other models. I was still very surprised by the
results of the total sum of logarithmic squares since I expected them to be a bit higher due to the first
BRNN model.
The biggest overall surprise were the models ability to identify sleeper picks, which are players
that aren’t expected to be good, but end up being good. For simplicity, the players that I’ve
considered sleeper picks are only those who have made a Pro Bowl. In reality, sleeper picks may never
make a Pro Bowl to be considered a sleeper pick, but rather have better careers than the majority of
the players picked before them. These players are often scattered through the third through seventh
rounds and are often very unpredictable which is why they get picked where they do. I’m not sure
there was a direct correlation between my models successfully picking these players and them turning
out to be good, as much as there was a random chance that the player was predicted to go high by
the model. The models did predict a modest amount of sleepers to go high, but also predicted a
modest amount of “non-sleepers” to go high. The most accurate model at distinguishing whether a
potential sleeper should go high was the combined model, which should come as no surprise. Looking
at the draft in hindsight is always 20/20 and so the predicted results can always be at least partially
explained. The results of any of these models, most importantly the combined model if followed
perfectly, do not promise the perfect results. Not in terms of correct draft order or ranked by best to
worst players. These models however, do still provide valuable information for prospective decision
makers and may be a helpful tool in determining who to draft.
Overall each of the three models were useful for the combined model, but some were
definitely more important than others. As previously mentioned, the most accurate model was the
combined model. This model would not have been possible or at least as accurate, without input from
each of the other three models. By that measure, each model was important and needed for the final
product, though replacing the first BRNN model with a model that’s a bit more accurate from start to
finish may prove to be beneficial in the long run.

### 6 References
Cormier, J. (2020, April 24). How neural networks can predict performance in the NFL. Medium. Retrieved April 20, 2022, from https://medium.com/the-sports-scientist/how-neural-networks-can-predict-performance-in-the-nfl-24fa845c1d15

EvanZ. (2020, October 31). Bayesian-meta-mock/bayesian-meta-mock-draft.ipynb at master · Evanz/Bayesian-meta-mock. GitHub. Retrieved April 20, 2022, from https://github.com/EvanZ/bayesian-meta-mock/blob/master/bayesian-meta-mock-draft.ipynb  

hiepnguyen034. (2020, February 25). Improving neural network's performance with bayesian optimization. Medium. Retrieved April 20, 2022, from https://medium.com/@hiepnguyen034/improving-neural-networks-performance-with-bayesian-optimization-efbaa801ad26 

Lichtenstein, J. (2021, May 5). ESPN NFL draft prospect data. Kaggle. Retrieved April 20, 2022, from https://www.kaggle.com/datasets/jacklichtenstein/espn-nfl-draft-prospect-data?resource=download&select=college_statistics.csv 

Purdum, D. (2020, April 20). Sportsbooks see big betting interest in NFL draft. ESPN. Retrieved April 20, 2022, from https://www.espn.com/chalk/story/_/id/29070773/sportsbooks-see-big-betting-interest-nfl-draft 

Purdum, D. (2021, April 28). Inside NFL draft betting: Why bookmakers hate the props. ESPN. Retrieved April 20, 2022, from https://www.espn.com/chalk/story/_/id/31335476/inside-nfl-draft-betting-here-why-bookmakers-get-crushed 

RecruitingNation. (2011, June 7). ESPN recruitingnation grading scale. ESPN. Retrieved April 20, 2022, from https://www.espn.com/college-sports/recruiting/football/news/story?id=6635735 

Redlineracer. (2021, December 23). NFL combine - performance data (2009 - 2019). Kaggle. Retrieved April 20, 2022, from https://www.kaggle.com/datasets/redlineracer/nfl-combine-performance-data-2009-2019 

Robinson, B. (2019, October 19). Grinding the Bayes a hierarchical ... - CMU statistics. Retrieved April 21, 2022, from https://www.stat.cmu.edu/cmsac/conference/2020/assets/pdf/Robinson.pdf 

Rodriguez, P. P., & Gianola, D. (2021, September 23). Breedwheat genomic selection pipeline [R package BWGS version 0.2.1]. The Comprehensive R Archive Network. Retrieved April 20, 2022, from https://cran.r-project.org/web/packages/BWGS/

Ronnie. (2021, December 27). NFL Scouting combine. Kaggle. Retrieved April 20, 2022, from https://www.kaggle.com/code/redlineracer/nfl-scouting-combine#dealing-with-missing-values 

Sabin, P., & Walder, S. (2019, August 19). Introducing a new way to rate college football players. ESPN. Retrieved April 20, 2022, from https://www.espn.com/college-football/story/_/page/PSimpactrating0819/introducing-new-way-rate-college-football-players 


### 7 Appendix

![image](https://user-images.githubusercontent.com/115805649/224416732-168236d6-2fe7-4d7d-9211-1f38952fab83.png)
![image](https://user-images.githubusercontent.com/115805649/224416810-43f896c0-bdb0-4b08-9f61-d4273fbea980.png)
![image](https://user-images.githubusercontent.com/115805649/224416855-e144d076-7fa6-4040-927e-e3f2efc7b3ba.png)
![image](https://user-images.githubusercontent.com/115805649/224416899-22097292-480e-4036-be94-7a13ae2449d0.png)
![image](https://user-images.githubusercontent.com/115805649/224416926-670c907a-22dd-42e2-874c-cfb495d9d23b.png)
![image](https://user-images.githubusercontent.com/115805649/224416962-8335b13d-204a-4439-b70a-e139796c5dbe.png)
![image](https://user-images.githubusercontent.com/115805649/224417002-336b6b89-ec2a-4c08-aa2a-2159ee38bf66.png)
![image](https://user-images.githubusercontent.com/115805649/224417031-17673863-a77e-416c-8f7e-0009c68c6b5a.png)
![image](https://user-images.githubusercontent.com/115805649/224417066-81dac43f-8ce0-40d2-94cb-51389344d94c.png)
![image](https://user-images.githubusercontent.com/115805649/224417097-3caef1b2-e50e-42a3-8851-47c3cbd6065c.png)
