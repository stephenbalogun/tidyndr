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




my_summary2 <- function(data, l, n) {
  switch(
    l,
    "country" = janitor::adorn_totals(
      dplyr::count(data, ip, name = n, .drop = TRUE)
    ),
    "ip" = janitor::adorn_totals(
      dplyr::count(data, ip, name = n, .drop = TRUE)
    ),
    "facility_state" = janitor::adorn_totals(
      dplyr::count(data, ip, facility_state, name = n, .drop = TRUE)
    ),
    "facility_lga" = janitor::adorn_totals(
      dplyr::count(data, ip, facility_state, facility_lga, name = n, .drop = TRUE)
    ),
    "facility" = janitor::adorn_totals(
      dplyr::count(data, ip, facility_state, facility_lga, facility, name = n, .drop = TRUE)
    ),
    "client_state" = janitor::adorn_totals(
      dplyr::count(data, ip, client_state, name = n, .drop = TRUE)
    ),
    "client_lga" = janitor::adorn_totals(
      dplyr::count(data, ip, client_state, client_lga, name = n, .drop = TRUE)
    )
  )

}




utils::globalVariables(
  c("facility_lga", "client_state", "client_lga")
)
