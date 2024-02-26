#Create a 2x2 unit matrix as a scaling parameter for the fuzzy prior of the Wishart distribution
R <- matrix(0,nrow=2,ncol=2)
diag(R)<-1.0
#Create a list containing more than the discrete initialisation values for MCMC analysis
inits <- list(list(parms.lentic=c(-3,1),parms.lotic=c(-3,1),beta=c(0,0,0,0,0,0,0,0),beta1=c(0,0,0,0,0,0,0,0),sigma.intercept=0.01,sigma.slope=0.01),
              list(parms.lentic=c(0,0),parms.lotic=c(0,0),beta=c(0,0,0,0,0,0,0,0),beta1=c(0,0,0,0,0,0,0,0),sigma.intercept=1.2,sigma.slope=1.2),
              list(parms.lentic=c(3,-1),parms.lotic=c(3,-1),beta=c(0,0,0,0,0,0,0,0),beta1=c(0,0,0,0,0,0,0,0),sigma.intercept=10,sigma.slope=10))
#Create a list containing the data that will be used in fitting the hierarchical model
lamprey.data <- list(Years=ratio$Years,males=ratio$Male,streams=ratio$Location,N=nrow(ratio),R=R,mn=c(0,0))
#Identify the parameters and derived variables that will characterise the posterior probability distribution
lamprey.parms <- c("parms.lentic","parms.lotic","sigma.intercept","sigma.slope","predicted","lentic","lotic","beta","beta1")
#Assigning JAGS codes to fitted models
lamprey.model <- function() {
  #Specify a priori and super a priori for model parameters
  TAU[1:2,1:2] ~ dwish(R[1:2,1:2],3)
  TAU2[1:2,1:2] ~ dwish(R[1:2,1:2],3) 
  parms.lentic[1:2] ~ dmnorm(mn,TAU)
  parms.lotic[1:2] ~ dmnorm(mn,TAU2)
  sigma.intercept ~ dunif(0,100)
  tau.intercept <- 1/(sigma.intercept*sigma.intercept)
  sigma.slope ~ dunif(0,100)
  tau.slope <- 1/(sigma.slope*sigma.slope)
  
  #Specifying model likelihood
 # For each observation
for (i in 1:N) {
  # Using logistic regression modelling to calculate log odds ratios for male proportions
  logit(p[i]) <- beta[streams[i]] + beta1[streams[i]] * Years[i]
  # Assuming that the proportion of males follows a Bernoulli distribution and is sampled according to log odds ratio
  males[i] ~ dbern(p[i])
}

# Predicting the proportion of males at each location from 0 to 7 years after labelling
for (k in 1:7) {
  logit(lentic[k]) = parms.lentic[1] + parms.lentic[2] * (k-1)
  logit(lotic[k]) = parms.lotic[1] + parms.lotic[2] * (k-1)
}
}

# Specify random seeds to ensure reproducible results
set.seed(302563)

# Run the JAGS model, print the results, and convert the results to .mcmc objects
jags.model <- jags(lamprey.data, inits=inits, parameters.to.save=lamprey.parms, n.chains=3, n.iter=2000000, n.burnin=1000000, n.thin=100, model.file=lamprey.model)
print(jags.model)
mcmc.model <- as.mcmc(jags.model)