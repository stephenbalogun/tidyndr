#' Borrowed NULL
#'
#' @param x value set to a default value of null
#' @param y value to be used with x is null
#'
#'@name ndr-null-op
#' @export
#'
`%||%` <- function (x, y)
{
  if (rlang::is_null(x))
    y
  else x
}
