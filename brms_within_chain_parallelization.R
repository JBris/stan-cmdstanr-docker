##################################################
# Imports
##################################################

library(tidyverse)
library(brms)

##################################################
# Main
##################################################

# See https://cran.r-project.org/web/packages/brms/vignettes/brms_threading.html#fake-data-simulation

set.seed(54647)
# number of observations
N <- 1E4
# number of group levels
G <- round(N / 10)
# number of predictors
P <- 3
# regression coefficients
beta <- rnorm(P)

# sampled covariates, group means and fake data
fake <- matrix(rnorm(N * P), ncol = P)
dimnames(fake) <- list(NULL, paste0("x", 1:P))

# fixed effect part and sampled group membership
fake <- transform(
  as.data.frame(fake),
  theta = fake %*% beta,
  g = sample.int(G, N, replace=TRUE)
)

# add random intercept by group
fake  <- merge(fake, data.frame(g = 1:G, eta = rnorm(G)), by = "g")

# linear predictor
fake  <- transform(fake, mu = theta + eta)

# sample Poisson data
fake  <- transform(fake, y = rpois(N, exp(mu)))

# shuffle order of data rows to ensure even distribution of computational effort
fake <- fake[sample.int(N, N),]

# drop not needed row names
rownames(fake) <- NULL

model_poisson <- brm(
  y ~ 1 + x1 + x2 + (1 | g),
  data = fake,
  family = poisson(),
  iter = 500, # short sampling to speedup example
  chains = 2,
  prior = prior(normal(0,1), class = b) +
    prior(constant(1), class = sd, group = g),
  backend = "cmdstanr",
  threads = threading(4)
)

summary(model_poisson)
