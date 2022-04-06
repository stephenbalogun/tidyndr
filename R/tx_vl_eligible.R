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
#' tx_vl_eligible(ndr_example, ref = "2021-09-30")
#'
#' # Determine clients who are going to be eligible for VL by the end of Q1 of FY22
#' tx_vl_eligible(ndr_example,
#'   ref = "2021-12-31"
#' )
#'
#' # Subset clients from "Arewa" and "Okun" who are due for viral load in Q1 of FY22
#' tx_vl_eligible(ndr_example,
#'   ref = "2021-12-31",
#'   states = c("Arewa", "Okun"),
#'   sample = TRUE
#' )
tx_vl_eligible <- function(data,
                           ref = NULL,
                           states = NULL,
                           facilities = NULL,
                           status = "default",
                           sample = FALSE,
                           use_six_months = TRUE,
                           remove_duplicates = FALSE) {
  ref <- lubridate::ymd(ref %||% get("Sys.Date")())

  states <- states %||% unique(data$state)

  facilities <- facilities %||% unique(subset(data, state %in% states)$facility)

  validate_vl_eligible(data, ref, states, facilities, status, sample, use_six_months, remove_duplicates)

  get_tx_vl_eligible(data, ref, states, facilities, status, sample, use_six_months, remove_duplicates)
}


validate_vl_eligible <- function(data,
                                 ref,
                                 states,
                                 facilities,
                                 status,
                                 sample,
                                 use_six_months,
                                 remove_duplicates) {
  if (!all(states %in% unique(data$state))) {
    rlang::abort("state(s) is/are not contained in the supplied data. Check the spelling and/or case.")
  }

  if (!all(facilities %in% unique(subset(data, state %in% states)$facility))) {
    rlang::abort("facilit(ies) is/are not found in the data or state supplied.
                 Check that the facility is correctly spelt and located in the state.")
  }

  if (is.na(ref)) {
    rlang::abort("The supplied date is not in 'yyyy-mm-dd' format.")
  }

  if (!status %in% c("default", "calculated")) {
    rlang::abort("`status` can only be one of 'default' or 'calculated'. Check that you did not mispell, include CAPS or forget to quotation marks!")
  }


  if (!sample %in% c(TRUE, FALSE)) {
    rlang::abort("Sample can only be set to TRUE or FALSE")
  }

  if (!is.logical(use_six_months)) {
    rlang::abort("use_six_months can either be TRUE or FALSE")
  }

  if (!is.logical(remove_duplicates)) {
    rlang::abort("The `remove_duplicates` argument is a logical variable and can only be set to `TRUE` or `FALSE`")
  }
}

get_tx_vl_eligible <- function(data,
                               ref,
                               states,
                               facilities,
                               status,
                               sample,
                               use_six_months,
                               remove_duplicates) {
  df <- if (sample) {
    if (use_six_months) {
      switch(status,
        "calculated" = dplyr::filter(
          data,
          current_status == "Active",
          !patient_has_died %in% TRUE,
          lubridate::`%m+%`(art_start_date, lubridate::period(6, "months")) <= ref,
          dplyr::if_else(
            current_age < 20,
            lubridate::`%m+%`(date_of_current_viral_load, lubridate::period(6, "months")) <= ref,
            lubridate::`%m+%`(date_of_current_viral_load, lubridate::period(1, "year")) <= ref
          ) |
            is.na(date_of_current_viral_load),
          state %in% states,
          facility %in% facilities
        ),
        "default" = dplyr::filter(
          data,
          current_status_28_days == "Active",
          !patient_has_died %in% TRUE,
          lubridate::`%m+%`(art_start_date, lubridate::period(6, "months")) <= ref,
          dplyr::if_else(
            current_age < 20,
            lubridate::`%m+%`(date_of_current_viral_load, lubridate::period(6, "months")) <= ref,
            lubridate::`%m+%`(date_of_current_viral_load, lubridate::period(1, "year")) <= ref
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
          !patient_has_died %in% TRUE,
          lubridate::`%m+%`(art_start_date, lubridate::period(6, "months")) <= ref,
          lubridate::`%m+%`(date_of_current_viral_load, lubridate::period(1, "year")) <= ref |
            is.na(date_of_current_viral_load),
          state %in% states,
          facility %in% facilities
        ),
        "default" = dplyr::filter(
          data,
          current_status_28_days == "Active",
          !patient_has_died %in% TRUE,
          lubridate::`%m+%`(art_start_date, lubridate::period(6, "months")) <= ref,
          lubridate::`%m+%`(date_of_current_viral_load, lubridate::period(1, "year")) <= ref |
            is.na(date_of_current_viral_load),
          state %in% states,
          facility %in% facilities
        )
      )
    }
  } else {
    switch(status,
      "calculated" = dplyr::filter(
        data,
        current_status == "Active",
        !patient_has_died %in% TRUE,
        lubridate::`%m+%`(art_start_date, lubridate::period(6, "months")) <= ref,
        state %in% states,
        facility %in% facilities
      ),
      "default" = dplyr::filter(
        data,
        current_status_28_days == "Active",
        !patient_has_died %in% TRUE,
        lubridate::`%m+%`(art_start_date, lubridate::period(6, "months")) <= ref,
        state %in% states,
        facility %in% facilities
      )
    )
  }

  if (remove_duplicates) {
    df <- dplyr::distinct(df, facility, patient_identifier, .keep_all = TRUE)
  }

  return(df)
}


utils::globalVariables(c(
  "art_start_date",
  "current_status"
))
