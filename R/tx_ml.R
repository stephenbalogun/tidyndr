#' Subset Clients who Became Inactive (IIT) Within a Given Period
#'
#' \code{tx_ml} Generates clients who have become inactive over a specified
#' period of time. The default is to generate all clients who became inactive
#' in the current Fiscal Year. You can specify the period of interest
#' (using the \code{from} and \code{to} arguments). Used together
#' with \code{tx_ml_outcomes()}, generates inactive clients with a particular
#' outcome of interest.
#'
#' @inheritParams tx_new
#' @inheritParams tx_curr
#' @param old_data The initial dataframe containing the list of clients who
#'    were previously active.
#' @param new_data The current datafame where changes in current treatment
#'    status will be checked.
#'
#' @return tx_ml
#' @export
#'
#' @examples
#' tx_ml(new_data = ndr_example, from = "2021-06-01")
#'
#' # Find clients who were inactive in Q4 of FY21
#' tx_ml(
#'   new_data = ndr_example,
#'   from = "2021-07-01", to = "2021-09-30"
#' )
#'
#' ## generate line-list of `tx_ml()` using two datasets
#' \donttest{
#' file_path <- "https://raw.githubusercontent.com/stephenbalogun/example_files/main/ndr_example.csv"
#' ndr_old <- read_ndr(file_path, time_stamp = "2021-02-15")
#' ndr_new <- ndr_example
#' tx_ml(
#'   old_data = ndr_old,
#'   new_data = ndr_new,
#'   from = "2021-07-01",
#'   to = "2021-09-30"
#' )
#' }
tx_ml <- function(new_data,
                  old_data = NULL,
                  from = NULL,
                  to = NULL,
                  states = NULL,
                  facilities = NULL,
                  status = "calculated") {


  from <- lubridate::ymd(from %||% get("fy_start")())

  to <- lubridate::ymd(to %||% get("Sys.Date")())

  states <- states %||% unique(new_data$state)

  facilities <- facilities %||% unique(subset(new_data, state %in% states)$facility)

  validate_ml(new_data, old_data, from, to, states, facilities, status)

  get_tx_ml(new_data, old_data, from, to, states, facilities, status)

}


validate_ml <- function(new_data,
                        old_data,
                        from,
                        to,
                        states,
                        facilities,
                        status) {

  if (!all(states %in% unique(new_data$state))) {
    rlang::abort("state(s) is/are not contained in the supplied data. Check the spelling and/or case.")
  }

  if (!all(facilities %in% unique(subset(new_data, state %in% states)$facility))) {
    rlang::abort("facilit(ies) is/are not found in the data or state supplied.
                 Check that the facility is correctly spelt and located in the state.")
  }

  if (!rlang::is_null(from) && is.na(from)) {
    rlang::abort("The supplied date is not in 'yyyy-mm-dd' format.")
  }

  if (!rlang::is_null(to) && is.na(to)) {
    rlang::abort("The supplied date is not in 'yyyy-mm-dd' format.")
  }

  if (!status %in% c("default", "calculated")) {
    rlang::abort("`status` can only be one of 'default' or 'calculated'. Check that you did not mispell, include CAPS or forget to quotation marks!")
  }
}


get_tx_ml <- function(new_data,
                      old_data,
                      from,
                      to,
                      states,
                      facilities,
                      status) {

  if (rlang::is_null(old_data)) {
    dplyr::filter(
      new_data,
      dplyr::between(
        date_lost,
        from,
        to
      ),
      state %in% states,
      facility %in% facilities
    )
  } else {
    active <- switch(status,
                     "calculated" = dplyr::filter(
                       old_data,
                       current_status == "Active"
                     ),
                     "default" = dplyr::filter(
                       old_data,
                       current_status_28_days == "Active"
                     )
    )

    switch(status,
           "calculated" = dplyr::filter(
             new_data,
             patient_identifier %in% active$patient_identifier,
             current_status == "Inactive",
             state %in% states,
             facility %in% facilities
           ),
           "default" = dplyr::filter(
             new_data,
             patient_identifier %in% active$patient_identifier,
             current_status_28_days == "Inactive",
             state %in% states,
             facility %in% facilities
           )
    )
  }
}


utils::globalVariables(c(
  "date_lost",
  "patient_identifier",
  "current_status",
  "current_status_28_days"
))
