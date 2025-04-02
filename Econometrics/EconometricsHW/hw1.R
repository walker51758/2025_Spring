# E4.1
library(ggplot2)
setwd("C:/Users/Lenovo/Desktop/EconometricsHW/data")
install.packages("haven")
library(haven)
GrowthData <- read_dta("Growth.dta")
View(GrowthData)
ggplot(GrowthData, aes(x = tradeshare, y = growth)) +
  geom_point() +  
  labs(x = "Average Trade Share (TradeShare)", 
       y = "Average Annual Growth Rate (Growth)", 
       title = "Scatterplot of Growth vs. TradeShare") +
  theme_minimal()

ggplot(GrowthData, aes(x = tradeshare, y = growth)) +
  geom_point(aes(color = country_name == "Malta")) +
  scale_color_manual(values = c("grey", "red")) +
  geom_text(data = subset(GrowthData, country_name == "Malta"),
            aes(x = tradeshare, y = growth, label = country_name),
            hjust = 1.1, vjust = 1.1) +
  labs(x = "Average Trade Share (TradeShare)", 
       y = "Average Annual Growth Rate (Growth)", 
       title = "Scatterplot of Growth vs. TradeShare",
       color = "Country") +
  theme_minimal()

model <- lm(growth ~ tradeshare, data = GrowthData)
summary(model)

GrowthData_no_Malta <- subset(GrowthData, country_name != "Malta")
model_no_Malta <- lm(growth ~ tradeshare, data = GrowthData_no_Malta)
summary(model_no_Malta)

GrowthData$predicted_all <- predict(model, newdata = GrowthData)
GrowthData_no_Malta$predicted_no_Malta <- predict(model_no_Malta, newdata = GrowthData_no_Malta)
ggplot(GrowthData, aes(x = tradeshare, y = growth)) +
  geom_point() +
  geom_line(data = GrowthData, aes(x = tradeshare, y = predicted_all), color = "blue") +
  geom_line(data = GrowthData_no_Malta, aes(x = tradeshare, y = predicted_no_Malta), color = "red") +
  labs(x = "Average Trade Share (TradeShare)", 
       y = "Average Annual Growth Rate (Growth)", 
       title = "Scatterplot of Growth vs. TradeShare with Regression Lines") +
  theme_minimal()

# E4.2
EarningData <- read_dta("Earnings_and_Height.dta")
View(EarningData)
median_height <- median(EarningData$height, na.rm = TRUE)

subset1 <- subset(EarningData, height <= 67)
average_under67 <- mean(subset1$earnings, na.rm = TRUE)
subset2 <- subset(EarningData, height > 67)
average_above67 <- mean(subset2$earnings, na.rm = TRUE)
t_test_result <- t.test(subset2$earnings, subset1$earnings, conf.level = 0.95)
confidence_interval <- t_test_result$conf.in
print(confidence_interval)

ggplot(EarningData, aes(x = height, y = earnings)) +
  geom_point() +  
  labs(x = "Height", 
       y = "Earnings", 
       title = "Scatterplot of Earnings vs Height") +
  theme_minimal()

model <- lm(earnings ~ height, data = EarningData)
summary(model)
new_height <- data.frame(height = c(65, 67, 70))
predicted_earnings <- predict(model, newdata = new_height)
print(predicted_earnings)

EarningData$height_cm <- EarningData$height * 2.54
model <- lm(earnings ~ height_cm, data = EarningData)
summary(model)

subset3 <- subset(EarningData, sex == 0)
View(subset3)
model <- lm(earnings ~ height, data = subset3)
summary(model)
avg_female_height <- mean(subset3$height, na.rm = TRUE)
new_wom_height = data.frame(height = avg_female_height+1)
pred_wom_earnings <- predict(model, newdata = new_wom_height)
print(pred_wom_earnings)
avg_wom_earnings <- mean(subset3$earnings, na.rm = TRUE)
pred_wom_earnings - avg_wom_earnings

subset4 <- subset(EarningData, sex == 1)
View(subset4)
model <- lm(earnings ~ height, data = subset4)
summary(model)
avg_man_height <- mean(subset4$height, na.rm = TRUE)
new_man_height = data.frame(height = avg_man_height+1)
pred_man_earnings <- predict(model, newdata = new_man_height)
print(pred_man_earnings)
avg_man_earnings <- mean(subset4$earnings, na.rm = TRUE)
pred_man_earnings - avg_man_earnings

# E5.1
confidence_level <- 0.90
t_critical <- qt((1 + confidence_level) / 2, df = 62)
ci_lower <- 1.6809 - t_critical * 0.9874
ci_upper <- 1.6809 + t_critical * 0.9874
cat("90% 置信区间为: [", ci_lower, ", ", ci_upper, "]\n")

#E5.2
confidence_level <- 0.95
t_critical <- qt((1 + confidence_level) / 2, df = 17867)
ci_lower <- 707.67 - t_critical * 50.49
ci_upper <- 707.67 + t_critical * 50.49
cat("95% 置信区间为: [", ci_lower, ", ", ci_upper, "]\n")
t_critical <- qt((1 + confidence_level) / 2, df = 9971)
ci_lower <- 511.2 - t_critical * 98.9
ci_upper <- 511.2 + t_critical * 98.9
cat("95% 置信区间为: [", ci_lower, ", ", ci_upper, "]\n")
t_critical <- qt((1 + confidence_level) / 2, df = 7893)
ci_lower <- 1306.9 - t_critical * 100.8
ci_upper <- 1306.9 + t_critical * 100.8
cat("95% 置信区间为: [", ci_lower, ", ", ci_upper, "]\n")
model_with_interaction <- lm(earnings ~ height * sex, data = EarningData)
summary(model_with_interaction)

# E6.1
BirthData <- read_dta("birthweight_smoking.dta")
View(BirthData)
model <- lm(birthweight ~ smoker, data = BirthData)
summary(model)
model <- lm(birthweight ~ smoker + alcohol + nprevist, data = BirthData)
summary(model)
Jane <- data.frame(
  smoker = 1,    # Jane smoked during pregnancy
  alcohol = 0,  # Jane did not drink alcohol
  nprevist = 8  # Jane had 8 prenatal care visits
)
predicted_birthweight <- predict(model, newdata = Jane)
predicted_birthweight
FWstep1 <- lm(smoker ~ alcohol + nprevist, data = BirthData)
residSmoker <- FWstep1$residuals
Fwstep2 <- lm(birthweight ~ alcohol + nprevist, data = BirthData)
residBirthweight <- Fwstep2$residuals
FWstep3 <- lm(residBirthweight ~ residSmoker, data = BirthData)
summary(FWstep3)
model <- lm(birthweight ~ smoker + alcohol + tripre0 + tripre2 + tripre3, data = BirthData)
summary(model)

# E6.2
install.packages("knitr")
library(knitr)
stats <- sapply(GrowthData[, c("growth", "tradeshare", "yearsschool", "oil", "rev_coups", "assasinations", "rgdp60")], 
                function(x) c(mean = mean(x, na.rm = TRUE), sd = sd(x, na.rm = TRUE), 
                              min = min(x, na.rm = TRUE), max = max(x, na.rm = TRUE)))
stats_df <- as.data.frame(t(stats))
colnames(stats_df) <- c("Mean", "SD", "Min", "Max")
row.names(stats_df) <- c("Growth", "TradeShare", "YearsSchool", "Oil", "Rev_Coups", "Assassinations", "RGDP60")
kable(stats_df, format = "markdown", caption = "Summary Statistics for the Variables", align = 'c')
model <- lm(growth ~ tradeshare + yearsschool + rev_coups + assasinations + rgdp60, data = GrowthData)
summary(model)
average_values <- colMeans(GrowthData[, c("tradeshare", "yearsschool", "rev_coups", "assasinations", "rgdp60")])
new_data <- data.frame(
  tradeshare = average_values["tradeshare"],
  yearsschool = average_values["yearsschool"],
  rev_coups = average_values["rev_coups"],
  assasinations = average_values["assasinations"],
  rgdp60 = average_values["rgdp60"]
)
predicted_growth <- predict(model, newdata = new_data)
cat("Predicted Average Annual Growth Rate:", predicted_growth, "\n")
tradeshare_sd <- sd(GrowthData$tradeshare, na.rm = TRUE)
new_data <- data.frame(
  tradeshare = average_values["tradeshare"]+tradeshare_sd,
  yearsschool = average_values["yearsschool"],
  rev_coups = average_values["rev_coups"],
  assasinations = average_values["assasinations"],
  rgdp60 = average_values["rgdp60"]
)
predicted_growth <- predict(model, newdata = new_data)
cat("Predicted Average Annual Growth Rate:", predicted_growth, "\n")

# E7.1
model <- lm(birthweight ~ smoker, data = BirthData)
summary(model)
model <- lm(birthweight ~ smoker + alcohol + nprevist, data = BirthData)
summary(model)
model <- lm(birthweight ~ smoker + alcohol + nprevist + unmarried, data = BirthData)
summary(model)
confidence_level <- 0.95
degreeOfFreedom <- 2994
coeff <- -175.377
stdError <- 27.099
t_critical <- qt((1 + confidence_level) / 2, df = degreeOfFreedom)
ci_lower <- coeff - t_critical * stdError
ci_upper <- coeff + t_critical * stdError
cat("95% 置信区间为: [", ci_lower, ", ", ci_upper, "]\n")

install.packages("stargazer")
library(stargazer)
model1 <- lm(birthweight ~ smoker, data = BirthData)
model2 <- lm(birthweight ~ smoker + alcohol + nprevist, data = BirthData)
model3 <- lm(birthweight ~ smoker + alcohol + nprevist + unmarried, data = BirthData)
stargazer(
  model1, model2, model3,
  type = "text",
  title = "Regression Results",
  dep.var.labels = "Birthweight",
  covariate.labels = c(
    "Smoker (X1)",
    "Alcohol (X2)",
    "Nprevist (X3)"
  ),
  omit.stat = c("f", "ser"),
  ci = TRUE,
  ci.level = 0.95,
  star.cutoffs = c(0.05, 0.01, 0.001)
)

# E7.2
EarningData <- read_dta("Earnings_and_Height.dta")
EarningData$LT_HS <- ifelse(EarningData$educ < 12, 1, 0)
EarningData$HS <- ifelse(EarningData$educ == 12, 1, 0)
EarningData$Some_Col <- ifelse(EarningData$educ > 12 & EarningData$educ < 16, 1, 0)
EarningData$College <- ifelse(EarningData$educ >= 16, 1, 0)
View(EarningData)
subsetWom <- subset(EarningData, sex == 0)
subsetMan <- subset(EarningData, sex == 1)
model1 <- lm(earnings ~ height, data = subsetWom)
model2 <- lm(earnings ~ height + LT_HS + HS + Some_Col, data = subsetWom)
summary(model1)
summary(model2)
install.packages("car")
library(car)
hypothesis_matrix <- c("LT_HS = 0", "HS = 0", "Some_Col = 0")
result <- linearHypothesis(model2, hypothesis_matrix)
result
model1 <- lm(earnings ~ height, data = subsetMan)
model2 <- lm(earnings ~ height + LT_HS + HS + Some_Col, data = subsetMan)
summary(model1)
summary(model2)
library(car)
hypothesis_matrix <- c("LT_HS = 0", "HS = 0", "Some_Col = 0")
result <- linearHypothesis(model2, hypothesis_matrix)
result
