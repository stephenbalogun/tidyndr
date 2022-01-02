#' Subset Rows of Clients who have Clinic Appointment/Medication Pick-up within
#' a Particular Period
#'
#' \code{tx_appointment} generates the line-list of clients who have clinic
#' appointment/medication refill for the specified state(s) and/or facilit(ies).
#' The default is to generate the appointment list for all the
#' states/facilities.
#' @inheritParams tx_new
#' @param active TRUE or FALSE. To determine whether the appointment should be for only active patients or irrespective of their status.
#'
#' @return tx_appointment
#' @export
#'
#' @examples
#' # Determine clients who have medication refill in Q2 of FY21
#' tx_appointment(ndr_example,
#'   from = "2021-06-01",
#'   to = "2021-09-30"
#' )
#'
#' # Determine clients who have medication refill in July 2021
#' tx_appointment(ndr_example,
#'   from = "2021-07-01",
#'   to = "2021-07-31",
#' )
#'
#' # Determine clients with medication refill in "Okun" state for a particular facility
#' tx_appointment(ndr_example,
#'   from = "2021-01-01",
#'   states = "Okun",
#'   facilities = "Facility1"
#' )
tx_appointment <- function(data,
                           from = NULL,
                           to = NULL,
                           states = NULL,
                           facilities = NULL,
                           active = FALSE
                           ) {

  from <- lubridate::ymd(from %||% get("fy_start")())

  to <- lubridate::ymd(to %||% get("Sys.Date")())

  states <- states %||% unique(data$state)

  facilities <- facilities %||% unique(subset(data, state %in% states)$facility)

  validate_appointment(data, from, to, states, facilities, active)

  get_tx_appointment(data, from, to, states, facilities, active)

}

validate_appointment <- function(data, from, to, states, facilities, active) {

  if (!all(states %in% unique(data$state))) {
    rlang::abort("state(s) is/are not contained in the supplied data. Check the spelling and/or case.")
  }

  if (!all(facilities %in% unique(subset(data, state %in% states)$facility))) {
    rlang::abort("facilit(ies) is/are not found in the data or state supplied.
                 Check that the facility is correctly spelt and located in the state.")
  }

  if (is.na(from) || is.na(to)) {
    rlang::abort("The supplied date is not in 'yyyy-mm-dd' format.")
  }

  if (from > to) {
    rlang::abort("The `from` date cannot be after the `to` date.")
  }

  if (!active %in% c(TRUE, FALSE)) {
    rlang::abort("Active can only be set to TRUE or FALSE")
  }

}


get_tx_appointment <- function(data, from, to, states, facilities, active) {

  df <- dplyr::filter(
    data,
    dplyr::between(
      appointment_date,
      from,
      to
    ),
    state %in% states,
    facility %in% facilities
  )

  if (active) {
    dplyr::filter(
      df,
      current_status == "Active",
      !patient_has_died %in% TRUE,
      !patient_transferred_out %in% TRUE
    )
  } else {
    return(df)
  }
}


utils::globalVariables(c(
  "last_drug_pickup_date",
  "current_status",
  "days_of_arv_refill",
  "appointment_date",
  "state",
  "facility"
))
