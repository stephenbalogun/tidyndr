#' Subset Rows of Clients who have Clinic Appointment/Medication Pick-up within
#' a Particular Period
#'
#' \code{tx_appointment} generates the line-list of clients who have clinic
#' appointment/medication refill for the specified state(s) and/or facilit(ies).
#' The default is to generate the appointment list for all the
#' states/facilities.
#' @inheritParams tx_new
#'
#' @return tx_appointment
#' @export
#'
#' @examples
#' # Determine clients who have medication refill in Q2 of FY21
#' tx_appointment(ndr_example,
#'   from = "2021-01-01",
#'   to = "2021-03-30"
#' )
#'
#' # Determine clients who have medication refill in March 2021 using the 'default' status
#' tx_appointment(ndr_example,
#'   from = "2021-03-01",
#'   to = "2021-03-31",
#' )
#'
#' # Determine clients with medication refill in January 2021 for a particular facility
#' tx_appointment(ndr_example,
#'   from = "2021-01-01",
#'   to = "2021-01-31",
#'   states = "State 1",
#'   facilities = "Facility 1"
#' )
tx_appointment <- function(data,
                           from = get("fy_start")(),
                           to = get("Sys.Date")(),
                           states = .s,
                           facilities = .f) {
  .s <- unique(data$state)

  .f <- unique(subset(data, state %in% states)$facility)

  if (!all(states %in% unique(data$state))) {
    rlang::abort("state(s) is/are not contained in the supplied data. Check the spelling and/or case.")
  }

  if (!all(facilities %in% unique(subset(data, state %in% states)$facility))) {
    rlang::abort("facilit(ies) is/are not found in the data or state supplied.
                 Check that the facility is correctly spelt and located in the state.")
  }

  if (is.na(lubridate::as_date(from)) || is.na(lubridate::as_date(to))) {
    rlang::abort("The supplied date is not in 'yyyy-mm-dd' format.")
  }

  if (lubridate::as_date(from) > lubridate::as_date(to)) {
    rlang::abort("The `from` date cannot be after the `to` date.")
  }

  dplyr::filter(
    data,
    dplyr::between(
      appointment_date,
      lubridate::as_date(from),
      lubridate::as_date(to)
    ),
    state %in% states,
    facility %in% facilities
  )
}


utils::globalVariables(c(
  "last_drug_pickup_date",
  "current_status",
  "days_of_arv_refill",
  "appointment_date",
  "state",
  "facility"
))
