FROM rocker/r-base:latest

RUN apt-get update -qq && apt-get install -y \
      libssl-dev \
      libcurl4-gnutls-dev

## Install Padoc
RUN mkdir -p /opt/pandoc \
  && wget --no-check-certificate -O /tmp/pandoc.zip https://s3.amazonaws.com/rstudio-buildtools/pandoc-1.13.1.zip \
  && unzip -j /tmp/pandoc.zip "pandoc-1.13.1/linux/debian/x86_64/pandoc" -d /opt/pandoc \
  && chmod +x /opt/pandoc/pandoc \
  && ln -s /opt/pandoc/pandoc /usr/local/bin \
  && unzip -j /tmp/pandoc.zip "pandoc-1.13.1/linux/debian/x86_64/pandoc-citeproc" -d /opt/pandoc \
  && chmod +x "/opt/pandoc/pandoc-citeproc" \
  && ln -s "/opt/pandoc/pandoc-citeproc" /usr/local/bin \
  && rm -f /tmp/pandoc.zip

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