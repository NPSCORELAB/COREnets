% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cleaning_and_structuring_tools.R
\name{to_matrix}
\alias{to_matrix}
\title{From Tibble to Adjacency or Incidence Matrix}
\usage{
to_matrix(.df)
}
\arguments{
\item{.df, }{A `df` produced by the `read_xlsx` function.}
}
\description{
`to_adj_matrix` returns a `matrix` with the values tibble imported from an excel file.
}
\author{
Christopher Callaghan, \email{cjcallag@nps.edu}
}