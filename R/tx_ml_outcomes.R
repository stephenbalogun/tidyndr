#' subset rows containing clients who have either "Transferred Out" or are "Deceased"
#'
#' @param data an ndr dataframe imported using the `read_ndr()
#' @param outcome the particular outcome of interest based on options available on the NDR ("transfer out" or "dead").
#'
#' @return
#' @export
#'
#' @examples
#' file_path <- "C:/Users/stephenbalogun/Documents/My R/tidyndr/ndr_example.csv"
#' ndr_example <- read_ndr(file_path)
#' tx_ml(ndr_example) %>%
#'   tx_ml_outcomes("dead")
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
