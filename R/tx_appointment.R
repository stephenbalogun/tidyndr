#' Subset rows of clients who have clinic appointment/medication pick-up within
#' a particular period
#'
#' \code{tx_appointment} generates the line-list of clients who have clinic
#' appointment/medication refill for the specified state(s) and/or facilit(ies).
#' The default is to generate the appointment list for all the
#' states/facilities.
#'
#' @param data An ndr dataframe imported using the `read_ndr().
#' @param from The start date for clients with clinic appointments in ISO8601
#'   format (i.e. "yyyy-mm-dd"). The default is to start at the beginning of the
#'   current Fiscal Year (i.e. 1st of October).
#' @param to The end date for the appointment period of interest written in
#'   ISO8601 format (i.e. "yyyy-mm-dd"). The default is today.
#' @param states The name(s) of the State(s) of interest. The default utilizes all
#'   the states in the dataframe. If specifying more than one state, combine the
#'   states using the \code{c()} e.g. \code{c("State 1", "State 2")}.
#' @param facilities The name(s) of the facilit(ies) of interest. Default is to utilize
#'   all the facilities contained in the dataframe. If specifying more than one
#'   facility, combine the facilities using the \code{c()} e.g.
#'   \code{c("Facility 1", "Facility 2")}.
#'
#' @return
#' @export
#'
#' @examples
#' # Determine clients who have medication refill in Q2 of FY21
#' tx_appointment(ndr_example,
#'   from = "2021-01-01",
#'   to = "2021-03-30"
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
                           from = fy_start,
                           to = end_date,
                           states = regions,
                           facilities = sites) {
  end_date <- Sys.Date()
  regions <- unique(data$state)
  sites <- unique(data$facility)

  fy_start <- lubridate::as_date(
    ifelse(lubridate::month(Sys.Date()) < 10,
      stats::update(Sys.Date(),
        year = lubridate::year(Sys.Date()) - 1,
        month = 10,
        day = 1
      ),
      stats::update(Sys.Date(),
        month = 10,
        day = 1
      )
    )
  )

  stopifnot(
    "please check that region is contained in the dataset list of states" =
      any(states %in% unique(data$state))
  )

  stopifnot(
    "please check that site is contained in the dataset list of facilities" =
      any(facilities %in% unique(data$facility))
  )

  stopifnot(
    'please check that your date format is "yyyy-mm-dd"' =
      !is.na(lubridate::as_date(from))
  )
  stopifnot(
    'please check that your date format is "yyyy-mm-dd"' =
      !is.na(lubridate::as_date(to))
  )


  dat <- dplyr::mutate(data, appointment_date = last_drug_pickup_date +
    lubridate::days(days_of_arv_refill))

  dplyr::filter(
    dat,
    current_status_28_days == "Active",
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
  "days_of_arv_refill",
  "current_status_28_days",
  "appointment_date",
  "state",
  "facility"
))
