#' Utils-summarise-ndr
#'
#' @param data A dataframe argument used by the \code{summarise_ndr()}.
#' @param l The level a level at which the summary is to be performed. Options are:
#' "country", "state" or "facility".
#' @param n The name assignment to the summary operator
#'
#' @export
#' @keywords internal
my_summary <- function(data, l, n) {
  if (l == "state") {
    data %>%
      dplyr::count(ip, state, name = n, .drop = TRUE) %>%
      janitor::adorn_totals()
  } else if (l == "facility") {
    data %>%
      dplyr::count(ip, state, facility, name = n, .drop = TRUE) %>%
      janitor::adorn_totals()
  } else if (l == "country" | l == "ip") {
    data %>%
      dplyr::count(ip, name = n, .drop = TRUE)
  } else if (l == "lga") {
    data %>%
      dplyr::count(ip, state, lga, name = n, .drop = TRUE)
  }
}
