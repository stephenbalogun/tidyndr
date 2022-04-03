#' Determine Clients who are not Virally Suppressed
#'
#' Generate the line-list of clients whose date of last viral load result is not
#' not more than one year (for adults 20 years and above) and 6 months (for
#' pediatrics and adolescents) from the specified reference date and are not virally
#' suppressed.
#'
#' @inheritParams tx_pvls_num
#'
#' @return tx_vl_unsuppressed
#' @export
#'
#' @examples
#' tx_vl_unsuppressed(ndr_example)
#'
#' # Determine clients who are virally unsuppressed for a state at the end of Q1
#' tx_vl_unsuppressed(ndr_example,
#'   ref = "2021-12-31",
#'   states = "Ayetoro"
#' )
#'
#' # Determine clients with viral load result of 400 or more (low level viremia)
#' tx_vl_unsuppressed(ndr_example, n = 400)
#'
tx_vl_unsuppressed <- function(data,
                               ref = NULL,
                               states = NULL,
                               facilities = NULL,
                               status = "default",
                               n = 1000,
                               use_six_months = TRUE,
                               remove_duplicates = FALSE) {
  ref <- lubridate::ymd(ref %||% get("Sys.Date")())

  states <- states %||% unique(data$state)

  facilities <- facilities %||% unique(subset(data, state %in% states)$facility)

  validate_vl_unsuppressed(data, ref, states, facilities, status, n, use_six_months, remove_duplicates)

  get_tx_vl_unsuppressed(data, ref, states, facilities, status, n, use_six_months, remove_duplicates)
}



validate_vl_unsuppressed <- function(data,
                                     ref,
                                     states,
                                     facilities,
                                     status,
                                     n,
                                     use_six_months,
                                     remove_duplicates) {
  if (!all(states %in% unique(data$state))) {
    rlang::abort("state(s) is not contained in the supplied data. Check the spelling and/or case.")
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

  if (n < 0) {
    rlang::abort("n cannot be less than zero")
  }

  if (!is.logical(use_six_months)) {
    rlang::abort("use_six_months can either be TRUE or FALSE")
  }

  if (!is.logical(remove_duplicates)) {
    rlang::abort("The `remove_duplicates` argument is a logical variable and can only be set to `TRUE` or `FALSE`")
  }
}



get_tx_vl_unsuppressed <- function(data, ref, states, facilities, status, n, use_six_months, remove_duplicates) {
  df <- if (use_six_months) {
    switch(status,
      "calculated" = dplyr::filter(
        data,
        current_status == "Active",
        !patient_has_died %in% TRUE,
        lubridate::as_date(ref) - art_start_date >=
          lubridate::period(6, "months"),
        dplyr::if_else(
          current_age < 20,
          lubridate::as_date(ref) -
            date_of_current_viral_load <=
            lubridate::period(6, "months"),
          lubridate::as_date(ref) -
            date_of_current_viral_load <=
            lubridate::period(1, "year")
        ),
        current_viral_load >= n,
        state %in% states,
        facility %in% facilities
      ),
      "default" = dplyr::filter(
        data,
        current_status_28_days == "Active",
        !patient_has_died %in% TRUE,
        lubridate::as_date(ref) - art_start_date >=
          lubridate::period(6, "months"),
        dplyr::if_else(
          current_age < 20,
          lubridate::as_date(ref) -
            date_of_current_viral_load <=
            lubridate::period(6, "months"),
          lubridate::as_date(ref) -
            date_of_current_viral_load <=
            lubridate::period(1, "year")
        ),
        current_viral_load >= n,
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
        lubridate::as_date(ref) - art_start_date >=
          lubridate::period(6, "months"),
        lubridate::as_date(ref) -
          date_of_current_viral_load <=
          lubridate::period(1, "year"),
        current_viral_load >= n,
        state %in% states,
        facility %in% facilities
      ),
      "default" = dplyr::filter(
        data,
        current_status_28_days == "Active",
        !patient_has_died %in% TRUE,
        lubridate::as_date(ref) - art_start_date >=
          lubridate::period(6, "months"),
        lubridate::as_date(ref) -
          date_of_current_viral_load <=
          lubridate::period(1, "year"),
        current_viral_load >= n,
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
  "current_age",
  "current_status",
  "date_of_current_viral_load",
  "current_viral_load"
))
