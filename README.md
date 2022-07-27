# stan-cmdstanr-docker

## Table of Contents  

* [Introduction](#introduction) 
* [Stan](#stan) 
* [Docker](#docker) 

### Introduction

A Docker image to run Stan, cmdstanr, and brms for Bayesian statistical modelling

Launch an  RStudio webserver using `bash stan_serve.sh`.

Execute `docker pull ghcr.io/jbris/stan-cmdstanr-docker:latest` or `bash docker_pull.sh` to pull the image.

To convert the image into a Singularity container, run `singularity pull docker://ghcr.io/jbris/stan-cmdstanr-docker:latest` or `bash singularity_pull.sh`.

### Stan

The following packages are installed during the image build process:

* [Stan](https://mc-stan.org/)
* [RStan](https://mc-stan.org/users/interfaces/rstan)
* [rstanarm](https://mc-stan.org/rstanarm/)
* [CmdStan](https://mc-stan.org/users/interfaces/cmdstan)
* [brms](https://paul-buerkner.github.io/brms/)
* [tidybayes](https://mjskay.github.io/tidybayes/)
* [bayesplot](https://mc-stan.org/bayesplot/)

The [brms_within_chain_parallelization.R](brms_within_chain_parallelization.R) script can be executed within the Docker container to evaluate whether within-chain parallelization, CmdStan, and brms are working properly.

### Docker

This Docker image extends from `rocker/tidyverse`. [Click this link for more information about the Rocker project.](https://rocker-project.org/images/)

Running the Docker container will launch an RStudio web server. You can access RStudio by visiting localhost:$R_STUDIO_PORT on your web browser. See [.env](.env) for the defined environment variables.

Running docker-compose will bind a volume, mapping the container's `home` directory to a local `r_home` directory.

See the [Dockerfile](Dockerfile) for the instructions executed during the build of the Docker image. 

View [docker-compose.yaml](docker-compose.yaml) to see the definition for the Stan service.

