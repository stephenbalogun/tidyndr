#' Subset Clients who are Eligible for Viral Load
#'
#' Generates the line-list of clients who have been (or would have been) on ARV
#' medications for at least 6 months from the reference date. The default
#' reference date is the date of analysis.
#'
#' @param sample Logical (TRUE or FALSE) indicating whether all clients eligible for
#' viral load test should be filtered irrespective of their eligibility for sample
#' collection or only those due for sample collection.
#' @inheritParams tx_pvls_den
#'
#' @return tx_vl_eligible
#' @export
#'
#' @examples
#' tx_vl_eligible(ndr_example)
#'
#' # Determine clients who are going to be eligible for VL by the end of Q2 of FY21
#' tx_vl_eligible(ndr_example,
#'   ref = "2021-03-31"
#' )
#'
#' # Subset clients from "State 1" who are due for viral load in Q2 of FY21
#' tx_vl_eligible(ndr_example,
#'   ref = "2021-03-31",
#'   states = c("State 1", "State 3"),
#'   sample = TRUE
#' )
tx_vl_eligible <- function(data,
                           ref = get("Sys.Date")(),
                           states = .s,
                           facilities = .f,
                           status = "calculated",
                           sample = FALSE) {
  .s <- unique(data$state)
  .f <- unique(subset(data, state %in% states)$facility)

  if (!all(states %in% unique(data$state))) {
    rlang::abort("state(s) is/are not contained in the supplied data. Check the spelling and/or case.")
  }

  if (!all(facilities %in% unique(subset(data, state %in% states)$facility))) {
    rlang::abort("facilit(ies) is/are not found in the data or state supplied.
                 Check that the facility is correctly spelt and located in the state.")
  }

  if (is.na(lubridate::as_date(ref))) {
    rlang::abort("The supplied date is not in 'yyyy-mm-dd' format.")
  }

  if (!status %in% c("default", "calculated")) {
    rlang::abort("`status` can only be one of 'default' or 'calculated'. Check that you did not mispell, include CAPS or forget to quotation marks!")
  }

  if (sample) {
    switch(status,
      "calculated" = dplyr::filter(
        data,
        current_status == "Active",
        lubridate::as_date(ref) - art_start_date >=
          lubridate::period(6, "months"),
        dplyr::if_else(
          current_age < 20,
          lubridate::as_date(ref) -
            date_of_current_viral_load >
            lubridate::period(6, "months"),
          lubridate::as_date(ref) -
            date_of_current_viral_load >
            lubridate::period(1, "year")
        ) |
          is.na(date_of_current_viral_load),
        state %in% states,
        facility %in% facilities
      ),
      "default" = dplyr::filter(
        data,
        current_status_28_days == "Active",
        lubridate::as_date(ref) - art_start_date >=
          lubridate::period(6, "months"),
        dplyr::if_else(
          current_age < 20,
          lubridate::as_date(ref) -
            date_of_current_viral_load >
            lubridate::period(6, "months"),
          lubridate::as_date(ref) -
            date_of_current_viral_load >
            lubridate::period(1, "year")
        ) |
          is.na(date_of_current_viral_load),
        state %in% states,
        facility %in% facilities
      )
    )
  } else {
    switch(status,
      "calculated" = dplyr::filter(
        data,
        current_status == "Active",
        lubridate::as_date(ref) - art_start_date >=
          lubridate::period(6, "months"),
        state %in% states,
        facility %in% facilities
      ),
      "default" = dplyr::filter(
        data,
        current_status_28_days == "Active",
        lubridate::as_date(ref) - art_start_date >=
          lubridate::period(6, "months"),
        state %in% states,
        facility %in% facilities
      )
    )
  }
}



utils::globalVariables(c(
  "art_start_date",
  "current_status"
))
