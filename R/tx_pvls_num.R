#' Determine Clients who are Virally Suppressed
#'
#' Generate the line-list of clients whose date of last viral load result is not
#' more than one year (for adults 20 years and above) and 6 months (for
#' pediatrics and adolescents) from the specified reference date and are virally
#' suppressed.
#'
#' @param n the value below which viral load result is adjudged to be suppressed.
#' @inheritParams tx_pvls_den
#'
#' @return tx_pvls_num
#' @export
#'
#' @examples
#' tx_pvls_num(ndr_example)
#'
#' # Determine clients who are virally suppressed for a state at the end of October 2021
#' tx_pvls_num(ndr_example,
#'   ref = "2021-10-31",
#'   states = "Arewa"
#' )
#'
#' # Determine clients with viral load result less than 400
#' tx_pvls_num(ndr_example, n = 400)
tx_pvls_num <- function(data,
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

  validate_pvls_num(data, ref, states, facilities, status, n, use_six_months, remove_duplicates)

  get_tx_pvls_num(data, ref, states, facilities, status, n, use_six_months, remove_duplicates)
}


validate_pvls_num <- function(data,
                              ref,
                              states,
                              facilities,
                              status,
                              n,
                              use_six_months, remove_duplicates) {
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


get_tx_pvls_num <- function(data, ref, states, facilities, status, n, use_six_months, remove_duplicates) {
  df <- if (use_six_months) {
    switch(status,
      "calculated" = dplyr::filter(
        data,
        current_status == "Active",
        !patient_has_died %in% TRUE,
        lubridate::`%m+%`(art_start_date, lubridate::period(6, "months")) <= ref,
        dplyr::if_else(
          lubridate::`%m+%`(date_of_current_viral_load, lubridate::period(6, "months")) > ref,
          lubridate::`%m+%`(date_of_current_viral_load, lubridate::period(1, "year")) > ref
        ),
        current_viral_load < n,
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
          lubridate::`%m+%`(date_of_current_viral_load, lubridate::period(6, "months")) > ref,
          lubridate::`%m+%`(date_of_current_viral_load, lubridate::period(1, "year")) > ref
        ),
        current_viral_load < n,
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
        lubridate::`%m+%`(date_of_current_viral_load, lubridate::period(1, "year")) > ref,
        current_viral_load < n,
        state %in% states,
        facility %in% facilities
      ),
      "default" = dplyr::filter(
        data,
        current_status_28_days == "Active",
        !patient_has_died %in% TRUE,
        lubridate::`%m+%`(art_start_date, lubridate::period(6, "months")) <= ref,
        lubridate::`%m+%`(date_of_current_viral_load, lubridate::period(1, "year")) > ref,
        current_viral_load < n,
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
