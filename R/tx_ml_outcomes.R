#' Subset rows of Inactive Clients with Specific Outcome
#'
#' \code{tx_ml_outcomes} generates the line-list of clients based on the
#' outcome of interest ("dead" or "transfer out"). It should be used after
#' \code{tx_ml()}.
#'
#' @param data An ndr dataframe imported using the `read_ndr()
#' @param outcome The particular outcome of interest based on options available
#' on the NDR ("transfer out", "dead" or "discontinued/stopped" [where available]).
#'
#' @return tx_ml_outcomes
#' @export
#'
#' @examples
#' tx_ml_outcomes(tx_ml(new_data = ndr_example),
#'   outcome = "dead"
#' )
tx_ml_outcomes <- function(data, outcome) {
  validate_ml_outcomes(data, outcome)

  get_tx_ml_outcomes(data, outcome)
}


validate_ml_outcomes <- function(data, outcome) {
  if (!outcome %in% c("dead", "transferred out", "transfer out", "stopped", "discontinued")) {
    rlang::abort("Outcome should be either `dead`, `transferred out`, `stopped` or `discontinued`.
                 Check you spellings and your CAPS!")
  }

}

get_tx_ml_outcomes <- function(data, outcome) {
  switch(outcome,
    "dead" = dplyr::filter(data, patient_has_died == TRUE),
    "transfer out" = dplyr::filter(data, patient_transferred_out == TRUE),
    "transferred out" = dplyr::filter(data, patient_transferred_out == TRUE),
    "stopped" = ifelse(
      any(names(data) %in% c("patient_stopped_treatment")),
      dplyr::filter(data, patient_stopped_treatment == TRUE),
        rlang::abort("This data does not contain `stopped/discontinued` record")
      ),
    "discontinued" = ifelse(
      !names(data) %in% c("patient_stopped_treatment"),
      dplyr::filter(data, patient_stopped_treatment == TRUE),
      rlang::abort("This data does not contain `stopped/discontinued` record")
    )
  )
}


utils::globalVariables(c(
  "patient_has_died",
  "patient_transferred_out",
  "patient_stopped_treatment"
))
