#' Subset rows of inactive clients with specific outcome
#'
#' \code{tx_ml_outcomes} generates the line-list of clients based on the
#' outcome of interest ("dead" or "transfer out"). It should be use after
#' \code{tx_ml()}.
#'
#' @param data An ndr dataframe imported using the `read_ndr()
#' @param outcome The particular outcome of interest based on options available
#' on the NDR ("transfer out" or "dead").
#'
#' @return
#' @export
#'
#' @examples
#' tx_ml_outcomes(tx_ml(ndr_example),
#' outcome = "dead")
#'
tx_ml_outcomes <- function(data,
                           outcome) {
  stopifnot(
    'outcome is neither "transfer out" nor "dead"' =
      outcome == "dead" || outcome == "transfer out"
  )

  if (outcome == "dead") {
    dplyr::filter(
      data,
      patient_has_died == TRUE
    )
  } else if (outcome == "transfer out") {
    dplyr::filter(
      data,
      patient_transferred_out == TRUE
    )
  }
}

utils::globalVariables(c("patient_has_died",
                         "patient_transferred_out"))