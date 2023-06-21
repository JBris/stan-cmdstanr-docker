ARG TIDYVERSE_TAG

FROM rocker/tidyverse:${TIDYVERSE_TAG}

# Clang seems to be more memory efficient than g++
RUN apt-get update -y && apt-get install -y --no-install-recommends libglpk-dev clang-3.6 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV R_PACKAGES="\
    dagitty \
    future \
" 

RUN install2.r --error --skipinstalled $R_PACKAGES

RUN mkdir -p $HOME/.R/ \ 
  && echo "CXX=clang++ -stdlib=libc++ -fsanitize=address,undefined -fno-sanitize=float-divide-by-zero -fno-omit-frame-pointer -fsanitize-address-use-after-scope -fno-sanitize=alignment -frtti" >> $HOME/.R/Makevars \
  && echo "CC=clang -fsanitize=address,undefined -fno-sanitize=float-divide-by-zero -fno-omit-frame-pointer -fsanitize-address-use-after-scope -fno-sanitize=alignment" >> $HOME/.R/Makevars \
  && echo "CFLAGS=-O3 -Wall -pedantic -mtune=native" >> $HOME/.R/Makevars \
  && echo "FFLAGS=-O2 -mtune=native" >> $HOME/.R/Makevars \
  && echo "FCFLAGS=-O2 -mtune=native" >> $HOME/.R/Makevars \
  && echo "CXXFLAGS=-O3 -march=native -mtune=native -fPIC" >> $HOME/.R/Makevars \
  && echo "MAIN_LD=clang++ -stdlib=libc++ -fsanitize=undefined,address" >> $HOME/.R/Makevars \
  && echo "rstan::rstan_options(auto_write = TRUE)" >> /home/rstudio/.Rprofile \
  && echo "options(mc.cores = parallel::detectCores())" >> /home/rstudio/.Rprofile

RUN Rscript -e 'Sys.setenv(DOWNLOAD_STATIC_LIBV8 = 1); install.packages("rstan")'

ENV CMDSTAN /usr/share/.cmdstan

RUN cd /usr/share/ \
  && wget --progress=dot:mega https://github.com/stan-dev/cmdstan/releases/download/v2.30.0/cmdstan-2.30.0.tar.gz \
  && tar -zxpf cmdstan-2.30.0.tar.gz && mv cmdstan-2.30.0 .cmdstan \
  && ln -s .cmdstan cmdstan && cd .cmdstan && echo "CXX = clang++" >> make/local \
  && make build

RUN Rscript -e 'install.packages("cmdstanr", repos = c("https://mc-stan.org/r-packages/", getOption("repos")))' 
 
RUN install2.r --error --skipinstalled rstanarm

ENV BAYES_R_PACKAGES="\
    brms \
    tidybayes \
    bayesplot \
    Matrix \
    projpred \
" 

RUN install2.r --error --skipinstalled $BAYES_R_PACKAGES
