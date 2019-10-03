#' @title From Dataframe to Adjacency or Incidence Matrix
#'
#' @description `to_adj_matrix` returns a `matrix` with the values tibble 
#' imported from an excel file.
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#'
#' @param df, A `df` produced by the `read_xlsx` function.
#' @param rownames, A column value for the row that will be reassigned as 
#' rownames and then removed from the data frame.
#' 
to_matrix <- function(df, rownames = 1) {
  if (!is.data.frame(df)) {
    stop("Not a data frame.",
         call. = FALSE)
  }
  if (!is.numeric(rownames)) {
    stop("rownames value provided in not numeric",
         call. = FALSE)
  }
  
  df <- as.matrix(df)
  row.names(df) <- df[, rownames]
  df <- df[, -rownames]
  
  if (NROW(df) != NCOL(df)) message("An incidence matrix will be returned")
  if (NROW(df) == NCOL(df)) message("An adjacency matrix will be returned.")
  
  df
}

#' @title Read Matrix
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#'
#' @param file, the name of the file which the data are to be read from.
#' @param sep, the field separator character.
#' @param top_left_corner a regex to test whether or not to automatically assign row and column names.
#'
read_matrix <- function(file, sep = ",", top_left_corner = "^\\s*?$") {
  if (!file.exists(file)) {
    stop("Provided file does not exist.",
         call. = FALSE)
  }
  
  lines <- readLines(con = file)
  mat <- do.call(rbind,
          strsplit(
            lines,
            split = sep,
            fixed = TRUE
            )
  )
  if (grepl(top_left_corner, strsplit(lines[1], ",")[[1]][1])) {
    colnames(mat) <- mat[1,]
    rownames(mat) <- mat[,1]
    mat           <- mat[-1,-1] 
  }
  
  mat
  }

#' @title Transform to one-mode
#' 
#' @description `to_one_mode` takes in an `igraph` object, tests if bipartite,
#' and proceeds to project the network. This evaluation can be also conducted on
#' one-mode networks, yet no action will occur.`
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#'
#' @param g, An `igraph` object produced by the `to_graph` function.
#' @param project, Projection type for igraph to extract. "rows" will extract a 
#' one-mode matrix of rows-to-rows, while "columns" will extract a one-mode 
#' matrix of colums-to-columns.
#'
to_one_mode <- function(g, project = "rows") {
  if (!igraph::is.igraph(g)) {
    stop("Object provided is not an igraph object, try again.",
         call. = FALSE)
  }
  if (!is.character(project)) {
    stop("project value provided is not a string.",
         call. = FALSE)
  }

  valid_strings <- c("columns", "rows")

  if (!grepl(paste(valid_strings, collapse = "|"), x = project)) {
    stop("Project value invalid, only 'rows' and 'columns' strings are accepted.",
         call. = FALSE)
  }
  
  if (igraph::is.bipartite(g)) {
    if (project == "rows") {
      g <- igraph::bipartite.projection(g)$proj1
    }
    if (project == "columns") {
      g <- igraph::bipartite.projection(g)$proj2
    }
  }

  g
}

#' @title Read Multiple Tables from Excels
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#' 
#' @description `extract_xlsx` inspects excel documents for multiple tabs, then
#' proceeds to open these, and return all in a list as tibbles.
#'
#' @param path, A path to the workbook with multiple relational and 
#' non-relational network data.
#' 
extract_xlsx <- function(path) {
  if (!endsWith(basename(path), "xlsx")) {
    stop("Path provided did not end with the .xlsx extension expected",
         call. = FALSE)
  }
  
  `%>%` <- magrittr::`%>%`
  
  listed_tibbles <- path %>%
    readxl::excel_sheets() %>%
    purrr::set_names() %>%
    purrr::map(
      ~ readxl::read_excel(path = path, sheet = .x) %>%
        dplyr::as_tibble()
    )
  
  listed_tibbles
}