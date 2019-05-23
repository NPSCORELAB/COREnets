FROM rocker/r-ver:3.5.0

RUN apt-get update -qq && apt-get install -y \
      libssl-dev \
      libcurl4-gnutls-dev

RUN R -e "install.packages('plumber')"
RUN R -e "install.packages('dplyr')"
RUN R -e "install.packages('devtools')"
RUN R -e "install.packages('igraph')"
RUN R -e "install.packages('visNetwork')"
RUN installGithub.r NPSCORELAB/COREnets

COPY / /

EXPOSE 80

ENTRYPOINT ["Rscript", "API/main.R"]