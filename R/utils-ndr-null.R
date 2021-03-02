#' Borrowed NULL
#'
#' @param x value set to a default value of null
#' @param y value to be used with x is null
#'
#'@name ndr-null-op
#' @export
<<<<<<< HEAD
#' @keywords internal
=======
#'
>>>>>>> 82bc88cea456aae49cd70b9b04969fc72b487d3c
`%||%` <- function (x, y)
{
  if (rlang::is_null(x))
    y
  else x
}
