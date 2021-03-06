install.packages("rjags")
install.packages("coda")
library("coda")

#1. Specify the model
library("rjags")

mod_string = "model{
  for (i in 1: n){
    y[i] ~ dnorm(mu,1/sig2)
  }
  
  mu ~ dt(0, 1.0/1.0, 1)  #location, inverse scale, degrees of freedom
  sig2 = 1.0
}"


#2. Set up the model
set.seed(50)
y = c(1.2, 1.4, -0.5, 0.3, 0.9, 2.3, 1.0, 0.1, 1.3, 1.9)
n = length(y)

data_jags = list(y=y, n=n)
params = c("mu")

inits = function(){
  inits = list("mu" = 0.0)
}

mod = jags.model(textConnection(mod_string), data = data_jags, inits = inits)


#3. Run the MCMC sample
update(mod, 500)
mod_sim = coda.samples(model = mod, variable.names = params, n.iter = 1000)

#4. Post Processing
library("coda")
plot(mod_sim)
summary(mod_sim)



