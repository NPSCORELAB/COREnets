library(plumber)
r <- plumb("API/data_fetcher_api.R")
r$run(port=80, host="0.0.0.0")


