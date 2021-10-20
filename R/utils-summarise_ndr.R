#' Utils-summarise-ndr
#'
#' @param data A dataframe argument used by the \code{summarise_ndr()}.
#' @param l The level a level at which the summary is to be performed. Options are:
#' "country", "state" or "facility".
#' @param n The name assignment to the summary operator
#'
#' @export
#' @keywords internal
#' @return No return value, called for side effects
my_summary <- function(data, l, n) {
  switch(
    l,
    "country" = janitor::adorn_totals(
      dplyr::count(data, ip, name = n, .drop = TRUE)
    ),
    "ip" = janitor::adorn_totals(
      dplyr::count(data, ip, name = n, .drop = TRUE)
    ),
    "state" = janitor::adorn_totals(
      dplyr::count(data, ip, state, name = n, .drop = TRUE)
      ),
  "lga" = janitor::adorn_totals(
    dplyr::count(data, ip, state, lga, name = n, .drop = TRUE)
    ),
  "facility" = janitor::adorn_totals(
    dplyr::count(data, ip, state, lga, facility, name = n, .drop = TRUE)
    )
  )

}
