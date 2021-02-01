#' Subset Clients who are Eligible for Viral Load
#'
#' Generates the line-list of clients who have been (or would have been) on ARv
#' medications for at least 6 months from the reference date. The default
#' reference date is the date of analysis.
#'
#' @param sample Logical (TRUE or FALSE) indicating wheter all clients eligible for
#' viral load test should be filtered irrespective of their eligibility for sample
#' collection or only those due for sample collection.
#' @inheritParams tx_pvls_den
#'
#' @return
#' @export
#'
#' @examples
#' tx_vl_eligible(ndr_example)
#'
#' # Determine clients who are going to be eligible for VL by the end of Q2 of FY21
#' tx_vl_eligible(ndr_example,
#'   reference = "2021-03-31"
#' )
#'
#'  # Subset clients from "State 1" who are due for viral load in Q2 of FY21
#'  tx_vl_eligible(ndr_example,
#'  reference = "2021-03-31",
#'  states = c("State 1", "State 3"),
#'  sample = TRUE)
tx_vl_eligible <- function(data,
                           reference = ref_date,
                           states = regions,
                           facilities = sites,
                           sample = FALSE) {
  ref_date <- Sys.Date()
  regions <- unique(data$state)
  sites <- unique(data$facility)

  stopifnot(
    "please check that region is contained in the dataset list of states" =
      any(states %in% unique(data$state))
  )

  stopifnot(
    "please check that site is contained in the dataset list of facilities" =
      any(facilities %in% unique(data$facility))
  )

  stopifnot(
    'please check that your reference date format is "yyyy-mm-dd"' =
      !is.na(lubridate::as_date(reference))
  )

  if (sample == FALSE) {
    dplyr::filter(
      data,
      current_status_28_days == "Active",
      lubridate::as_date(reference) - art_start_date >=
        lubridate::period(6, "months"),
      state %in% states,
      facility %in% facilities)
  } else {
    dplyr::filter(
      data,
      current_status_28_days == "Active",
      lubridate::as_date(reference) - art_start_date >=
        lubridate::period(6, "months"),
      date_of_current_viral_load <=
        lubridate::as_date(reference) -
        lubridate::period(year = 1),
      state %in% states,
      facility %in% facilities)
  }
}



utils::globalVariables("art_start_date")
