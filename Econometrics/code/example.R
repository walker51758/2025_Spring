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

data7 <- rio::import("caschool.dta")
install.packages("quantreg")
library(quantreg)
m2 <- rq(testscr ~avginc, tau=0.9, data = data7)
summary(m2)

fit <- rq(testscr~avginc, tau = seq(0.1, 0.9, by = 0.1), data = data7)
summary_fit <- summary(fit)
plot(summary_fit, parm = "avginc", main = "coefficient")

setwd("C:/Users/Lenovo/Desktop/2025_Spring/Econometrics/code")
data3 <- rio::import("wg88.dta")
library(quantreg)
fit <- rq( lgwg88c ~ schyear + asex + exper + expsq + cp + minor + 
             ow2+ow3+ow4+ow5+
             oc2+oc3+oc4+
             sec1+sec3+sec4+sec5+sec6+sec7+sec8+sec9+sec10+sec11+sec12+
             zprvn11+zprvn14+zprvn21++zprvn34+zprvn41+zprvn42+zprvn44+
             zprvn53+zprvn62, tau = seq(0.1, 0.9, by = 0.1),data = data3)
smmary_fit <- summary(fit)
plot(summary_fit, parm = "schyear", main = "Coefficient for school year")

install.packages("mgcv")
library(mgcv)
data3 <- rio::import("wg88.dta")
nl2 <- gam(lgwg88c ~ schyear + asex + s(exper) + expsq + cp + minor + 
             ow2+ow3+ow4+ow5+
             oc2+oc3+oc4+
             sec1+sec3+sec4+sec5+sec6+sec7+sec8+sec9+sec10+sec11+sec12+
             zprvn11+zprvn14+zprvn21++zprvn34+zprvn41+zprvn42+zprvn44+
             zprvn53+zprvn62,data = data3)
plot(nl2)

install.packages("car")
library(car)
data(UN)
attach(UN)
View(UN)
colnames(UN)
plot(ppgdp, infantMortality)
plot(log(ppgdp), log(infantMortality))
loglog.fit <- lm(I(log(infantMortality))~I(log(ppgdp)))
curve(exp(coef(loglog.fit)[1]+coef(loglog.fit)[2]*log(x)),5,43000,add=T,col="red")
poly5.fit <- lm(infantMortality ~ ppgdp + I(ppgdp^2) + I(ppgdp^3) + I(ppgdp^4) + I(ppgdp^5))
plot(ppgdp, infantMortality)
b0 <- coef(poly5.fit)[1]
b1 <- coef(poly5.fit)[2]
b2 <- coef(poly5.fit)[3]
b3 <- coef(poly5.fit)[4]
b4 <- coef(poly5.fit)[5]
b5 <- coef(poly5.fit)[6]
curve(b0+b1*x+b2*x^2+b3*x^3+b4*x^4+b5*x^5,4,43000,add=T,col="red")
fit.jpw <- lm(infantMortality~1+ppgdp+I((ppgdp-1750)*(ppgdp>1750)))
summary(fit.jpw)
b.0 <- coef(fit.jpw)[1]
b.1 <- coef(fit.jpw)[2]
b.2 <- coef(fit.jpw)[3]
x.0 <- seq(0, 1750,1)
x.1 <- seq(1750,42000,1)
y.0 <- b.0 + b.1*x.0
y.1 <- (b.0+b.1*1750+(b.1+b.2)*x.1)
plot(ppgdp, infantMortality,pch=16,cex=0.5)
lines(x.0, y.0, col="red",lwd=2)
lines(x.1, y.1, col="blue",lwd=2)

install.packages("MultiKink")
library(MultiKink)
install.packages("splines")
library(splines)
install.packages("rms")
library(rms)
data("triceps")
View(triceps)
data_plot <- ggplot(data=triceps, aes(x=age, y=triceps))+
  geom_point(alpha=0.55, col="black")+
  theme_minimal()
data_plot

triceps <- triceps%>%
  mutate(age5=I((age-5)^3),
         age55=I((age-5)^3*(age<=5)))

lm_unnatural <- lm(triceps~age + I(age^2) + I(age^3)+
                     I((age-5)^3*(age>=5))+
                     I((age-10)^3*(age>=10))+
                   I((age-20)^3*(age>=20))+
                   I((age-30)^3*(age>=30))+
                   I((age-40)^3*(age>=40)),
                   data = triceps
                   )
pred_unnatural <- predict(lm_unnatural)
summary(lm_unnatural)
data_plot + geom_line(data = triceps, aes(y=pred_unnatrual,x=age),lwd=1,col="blue")

lm_half_natural <- lm(triceps~age +
                        I((age-5)^3*(age>=5))+
                        I((age-10)^3*(age>=10))+
                        I((age-20)^3*(age>=20))+
                        I((age-30)^3*(age>=30))+
                        I((age-40)^3*(age>=40)),
                      data = triceps
                      )
pred_half_natural <- predict(lm_half_natural)

data_plot + 
  geom_line(data=triceps,aes(y=pred_unnatrual,x=age),lwd=1,col="blue")+
  geom_line(data=triceps,aes(y=pred_half_natural,x=age),lwd=1,col="red")

model.full_natural <- ols(triceps ~ rcs(age,parms=c(5,10,20,30,40)),data = triceps)
pred_full_natural <- predict(model.full_natural)

data_plot + 
  geom_line(data=triceps, aes(y=pred_unnatrual,x=age),size=1,col="blue")+
  geom_line(data=triceps, aes(y=pred_half_natural, x=age),size=1,col="red")+
  geom_line(data =triceps, aes(y= pred_full_natural,x=age),size=1,col="green")
sk <- function(x,xi_k){
  xi_1 <- 5
  xi_K_1 <- 30
  xi_K <- 40
  dk <- ((x-xi_k)^3*(x>=xi_k)-(x-xi_K)^3 * (x>=xi_K))/(xi_K - xi_k)
  dK_1 <- ((x-xi_K_1)^3*(x>=xi_K_1) - (x-xi_K)^3*(x>=xi_K))/(xi_K-xi_K_1)
  sk <- (xi_K-xi_k)*(dk-dK_1)/(xi_K-xi_1)^2
  return (sk)
}
s1 <- sk(triceps$age,5)
s2 <- sk(triceps$age,10)
s3 <- sk(triceps$age,20)
triceps_new <- cbind(triceps,s1,s2,s3)
head(triceps_new,100)
spline_by_hand <- lm(triceps~age+s1+s2+s3, data=triceps)
summary(model.full_natural)
pred_spline_by_hand <- predict(spline_by_hand)
spline.ns <- lm(triceps~ns(age, knots = c(5,10,20,30,40)), data = triceps)
summary(spline.ns)
pred_spline_ns <- predict(spline.ns)

data_plot+
  geom_line(data=triceps,
            aes(y=pred_unnatural,x=age),lwd=1,col="blue")+
  geom_line(data=triceps,
            aes(y=pred_half_natural,x=age),lwd=1,col="red")+
  geom_line(data=triceps,
            aes(y=pred_full_natural,x=age),lwd=1,col="green")+
  geom_line(data=triceps,
            aes(y=pred_spline_by_hand,x=age),lwd=1,col="orange")+
  geom_line(data=triceps,
            aes(y=pred_spline_ns,x=age),lwd=1,col="pink")

set.seed(123)
n <- 100
x <- seq(0,10,length.out=n)
y <- sin(x) + rnorm(n, mean=0,sd=0.3)
K <- 10
knots <- seq(min(x), max(x), length.out=K+2)[-c(1,K+2)]
boundary <- range(x)
boundary
h <- diff(boundary)
h
natural_spline_basis <- function(x,knots,boundary){
  n <- length(x)
  K <- length(knots)
  a1 <- function(x)(boundary[2] - x)/h
  a2 <- funtion(x)(x - boundary[1])/h
  B <- matrix(0,n,K+2)
  B[,1] <- a1(x)
  B[,2] <- a2(x)
  for(j in 1:K){
    B[,j+2] < pmax(x-knots[j],0)^3-
      a1(x)*pmax(boundary[1]-knots[j])^3-
      a2(x)*pmax(boundary[2]-knots[j])^3
  }
  return(B)
}
B <- natural_spline_basis(x,knots,boundary)
B 

install.packages("AER")
install.packages("plm")
install.packages("sandwich")
library(AER)
library(plm)
library(sandwich)
data("Fatalities")
data2 <- pdata.frame(Fatalities, index = c("state", "year"))
data2$fatal_rate <- data2$fatal / data2$pop * 10000
data21982 <- subset(data2, year = "1982")
data21988 <- subset(data2, year = "1988")
fatal1982_mod <- lm(fatal_rate ~ beertax, data=data21982)
fatal1988_mod <- lm(fatal_rate ~ beertax, data = data21988)
coeftest(fatal1982_mod, vcov. = vcovHC, type="HC1")
summary(fatal1982_mod)
coeftest(fatal1988_mod, vcov. = vcovHC, type="HC1")
par(mfrow = c(1,2))
plot(x=as.double(data21982$beertax),
     y = as.double(data21982$fatal_rate),
     xlab = "Beer tax (in 1988 dollars)",
     ylab = "fatality rate",
     main = "Traffic Fatality Rates and Beer Taxes",
     ylim = c(0, 4.5),
     pch=20,
     col="steelblue"
    )

setwd("C:/Users/Lenovo/Desktop/2025_Spring/Econometrics/code")
library(rio)
library(tidyverse)
data <- import("WDI.dta")
data$after = ifelse(data$year>=2009,1,0)
Treated <- import("Treated.dta")
data <- left_join(data, Treated, by = "country", suffix = c("","merge1"))
data$treated[is.na(data$treated)] <- 0
data$did = data$after*data$treated
data$country1 <-  as.numeric(as.factor(data$country))
install.packages("fixest")
library(fixest)
model <- feols(gdppc ~ did | country1 + year, data = data)
summary(model)
paralell_trends <- data %>%
  group_by(year, treated) %>%
  summarise(mean_gdppc = mean(gdppc, na.rm=TRUE), groups = "drop")
model_reg <- feols(gdppc ~ treated*factor(year), data = data %>% filter(after = 0), cluster = ~country1)
summary(model_reg)

data$time_to_event2009 <- ifelse(data$treated == 1, data$year-2009, 0)
table(data$time_to_event2009)
install.packages("fastDummies")
library(fastDummies)
data <- dummy_cols