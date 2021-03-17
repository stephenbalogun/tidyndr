#' Subset rows of Inactive Clients with Specific Outcome
#'
#' \code{tx_ml_outcomes} generates the line-list of clients based on the
#' outcome of interest ("dead" or "transfer out"). It should be used after
#' \code{tx_ml()}.
#'
#' @param data An ndr dataframe imported using the `read_ndr()
#' @param outcome The particular outcome of interest based on options available
#' on the NDR ("transfer out" or "dead").
#'
#' @return tx_ml_outcomes
#' @export
#'
#' @examples
#' tx_ml_outcomes(tx_ml(new_data = ndr_example),
#'   outcome = "dead"
#' )
tx_ml_outcomes <- function(data,
                           outcome) {
  if (!outcome %in% c("dead", "transferred out", "transfer out")) {
    rlang::abort("Outcome should be either `dead` or `transferred out`.
                 Check you spellings and your CAPS!")
  }

  switch(outcome,
    "dead" = dplyr::filter(data, patient_has_died == TRUE),
    "transferred out" = dplyr::filter(data, patient_transferred_out == TRUE),
    "transfer out" = dplyr::filter(data, patient_transferred_out == TRUE),
    "transferred out" = dplyr::filter(data, patient_transferred_out == TRUE)
  )
}

utils::globalVariables(c(
  "patient_has_died",
  "patient_transferred_out"
))
