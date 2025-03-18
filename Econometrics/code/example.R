lgwage <- c(
  2.933567,
  2.942207,
  2.820629,
  2.473392,
  1.452585,
  2.870499,
  2.670823,
  2.052554,
  2.028668,
  3.628742)
schyear <- c(
  15,
  9,
  11,
  9,
  9,
  6,
  9,
  4,
  12,
  15
)
data5 <- data.frame(lgwage,schyear)
View(data5)

model2 <- lm(lgwage ~ schyear, data = data5)
summary(model2)

β1 <- sum((data5$lgwage - mean(data5$lgwage))*(data5$schyear - mean(data5$schyear)))/
  sum((data5$schyear - mean(data5$schyear))*(data5$schyear - mean(data5$schyear)))
β1

β0 <- mean(data5$lgwage) - β1*mean(data5$schyear)
β0


library(rio)
library(tidyverse)
setwd("C:/Users/Lenovo/Desktop/")
data6 <- rio::import("wg88.dta")
View(data6)
data6 <- data6 %>%
  mutate(constant = 1)
X <- as.matrix(data6[,c("constant","schyear","asex","cp","exper","expsq","minor",  
                        "ow2","ow3","ow4","ow5",
                        "oc2","oc3","oc4", 
                        "sec1","sec3","sec4","sec5","sec6","sec7","sec8",
                        "sec9","sec10","sec11","sec12", 
                        "zprvn11","zprvn14","zprvn21","zprvn34","zprvn41","zprvn42", 
                        "zprvn44","zprvn53","zprvn62")])
Y <- as.matrix(data6[,c("lgwg88c")])
b <- solve(t(X)%*%X)%*%(t(X)%*%Y)

data7 <- rio::import("caschool.dta")
View(data7)
colnames(data7)
model7 <- lm(testscr ~ str, data = data7)
summary(model7)

β1 <- sum((data7$testscr - mean(data7$testscr))*(data7$str - mean(data7$str)))/
  sum((data7$str - mean(data7$str))*(data7$str - mean(data7$str)))
β1

β0 <- mean(data7$testscr) - β1*mean(data7$str)
β0

R2 <- sum(((β0+β1*data7$str)-mean(data7$testscr))*((β0+β1*data7$str)-mean(data7$testscr)))/
  sum((data7$testscr-mean(data7$testscr))*(data7$testscr-mean(data7$testscr)))
R2

adjR2 <- 1 - (1-R2)*(length(data7$testscr)-1)/(length(data7$testscr)-2)
adjR2

library(ggplot2)
data7 <- rio::import("caschool.dta")
ggplot(data=data7,aes(x=avginc,y=testscr))+
  geom_point() +
  geom_smooth(method = "lm", se = F, color = "blue") +
  geom_smooth(method = "loess", se = F, color = "red")
  labs(title = "scatter plot", x = "distric average income", y = "testscore")

library("dplyr")
data7 <- data7 %>%
  mutate(
    avginc2=avginc^2,
    avginc3=avginc^3
  )
m2 <- lm(testscr~avginc+avginc2+avginc3, data = data7)
summary(m2)

plot(data7$avginc,data7$testscr,col="blue",pch=16)
abline(lm(testscr~avginc, data= data7, col="black"))
avginc3_fit <- predict(lm(testscr~avginc+avginc2+avginc3, data = data7))
points(data7$avginc,avginc3_fit,col="red",pch=1)
log_fit <- predict(lm(testscr~log(avginc),data=data7))
points(data7$avginc, log_fit, col="green",pch=1)

pf(37.69,2,416, lower.tail = F)

m3 <- lm(testscr ~ log(avginc), data = data7)
summary(m3)

data3 <- rio::import("wg88.dta")
model3 <- lm(lgwg88c ~ schyear+asex+cp+exper+expsq+minor+  
               ow2+ow3+ow4+ow5+ 
               oc2+oc3+oc4+
               sec1+sec3+sec4+sec5+sec6+sec7+sec8+sec9+sec10+sec11+sec12+ 
               zprvn11+zprvn14+zprvn21+zprvn34+zprvn41+zprvn42+ 
               zprvn44+zprvn53+zprvn62, data = data3)
summary(model3)

m4 <- lm(log(testscr) ~ log(avginc), data = data7)
summary(m4)

m4 <- lm(log(testscr)~log(avginc), data=data7)
summary(m4)
data7 <- data7 %>%
  mutate(lntestscr=log(testscr))
ll <- predict(lm(lntestscr~avginc, data = data7))
points(data7$lntestscr, data7$avginc, col="pink",pch=1.5)

logfit_curve <- function(x){
  predict(lm(testscr ~ log(avginc), data = data7),
          newdata = data.frame(avginc = x))
}
install.packages("haven")
library(haven)
model<-nls(
  testscr~b0*(1-exp(-1*b1*(avginc-b2))),
  data = data7,
  start = list(b0=720,b1=0.1,b2=10),
)
summary(model)
nonlfit_curve <- function(x){
  predict(nls(
    testscr ~ b0*(1-exp(-1*b1*(avginc-b2))),
    data = data7,
    start = list(b0=720,b1=0.2,b2=10)
  ),
  newdata = data.frame(avginc = x))
}
curve(nonlfit_curve(x), col = "green", lwd = 2, add = TRUE)
install.packages("quantreg")
library(quantreg)
fit <- rq(testscr~avginc, tau = seq(0.1, 0.9, by = 0.1), data = data7)
summary_fit <- summary(fit)
plot(summary_fit, parm = "avginc", main = "coefficient")
