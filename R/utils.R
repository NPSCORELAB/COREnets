
'%!in%' <- function(x,y){!('%in%'(x,y))}

.map_chr <- function(.x, .f, ..., .n = 1L) {
  vapply(.x, .f, FUN.VALUE = character(.n), ...)
}
