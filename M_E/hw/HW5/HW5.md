# HW5

冼名儒 2300017466

## 1. Write the Bellman Equation

$$
V_{E,t}(w) = u(w) + \beta [\alpha V_{U,t+1} + (1-\alpha)V_{E,t+1}(w)]\\
V_{U,t} = u(b) + \beta [(1-\gamma)V_{U,t+1} + \gamma \mathbb{E}_{w'} (\max\{V_{E,t+1}(w'),V_{U,t+1}\})]
$$
