FROM rocker/r-ver:3.5.0

RUN apt-get update -qq && apt-get install -y \
      libssl-dev \
      libcurl4-gnutls-dev

## Install Padoc
Run apt-get install pandoc

## Install R packages
RUN R -e "install.packages('plumber')"
RUN R -e "install.packages('dplyr')"
RUN R -e "install.packages('remotes')"
RUN R -e "install.packages('igraph')"
RUN R -e "install.packages('visNetwork')"
RUN R -e "install.packages('DT')"
RUN installGithub.r NPSCORELAB/COREnets

COPY / /

EXPOSE 80

ENTRYPOINT ["Rscript", "API/main.R"]