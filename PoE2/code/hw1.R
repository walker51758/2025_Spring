
data <- read.csv("data_pums_2000.csv")
library(ggplot2)
sorted_data <- data[order(data$INCTOT), ]
total_income <- sum(sorted_data$INCTOT)
n <- nrow(sorted_data)
cumulative_population <- cumsum(rep(1/n, n))
cumulative_income <- cumsum(as.numeric(sorted_data$INCTOT)) / total_income
lorenz_data <- data.frame(
  cumulative_population,
  cumulative_income
)
# 绘制洛伦兹曲线
ggplot(lorenz_data, aes(x = cumulative_population, y = cumulative_income)) +
  geom_line(color = "blue", linewidth = 1) +
  geom_point(color = "blue") +
  geom_abline(slope = 1, intercept = 0, color = "red", linetype = "dashed") +
  labs(title = "Lorenz Curve", x = "Cumulative Population", y = "Cumulative Income") +
  theme_minimal()
# 计算基尼系数
n <- nrow(lorenz_data)
gini_index <- sum((lorenz_data$cumulative_population[-1] - lorenz_data$cumulative_population[-n]) *
                    (lorenz_data$cumulative_income[-1] + lorenz_data$cumulative_income[-n]))
gini_coefficient <- 1 - gini_index
gini_coefficient
# 基尼系数 = 0.5069736