FROM rocker/r-ver:3.5.0

## Install Secure Sockets Layer Toolkit and Development Files and Documentation for libcurl
RUN apt-get update -qq && apt-get install -y \
      libssl-dev \
      libcurl4-gnutls-dev

## Install Padoc
Run apt-get install pandoc -y

## Install R packages from CRAN
RUN R -e "install.packages('plumber')"
RUN R -e "install.packages('dplyr')"
RUN R -e "install.packages('remotes')"
RUN R -e "install.packages('igraph')"
RUN R -e "install.packages('visNetwork')"
RUN R -e "install.packages('DT')"

## Install R packages from Github
RUN installGithub.r NPSCORELAB/COREnets

COPY / /

EXPOSE 80

ENTRYPOINT ["Rscript", "API/main.R"]