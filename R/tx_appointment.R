#' Subset rows of clients who have clinic appointment/medication pick-up within
#' a particular period
#'
#' \code{tx_appointment} generates the line-list of clients who have clinic
#' appointment/medication refill for the specified state(s) and/or facilit(ies).
#' The default is to generate the appointment list for all the
#' states/facilities.
#'
#' @param data An ndr dataframe imported using the `read_ndr().
#' @param from The start date in ISO8601 format (i.e. "yyyy-mm-dd").
#' The default is to start at the beginning of the current Fiscal Year (i.e. 1st of October).
#' @param to The end date written in ISO8601 format (i.e. "yyyy-mm-dd").
#' The default is today (the date of analysis).
#' @param states The name(s) of the State(s) of interest. The default utilizes all
#'   the states in the dataframe. If specifying more than one state, combine the
#'   states using the \code{c()} e.g. \code{c("State 1", "State 2")}.
#' @param facilities The name(s) of the facilit(ies) of interest. Default is to utilize
#'   all the facilities contained in the dataframe. If specifying more than one
#'   facility, combine the facilities using the \code{c()} e.g.
#'   \code{c("Facility 1", "Facility 2")}.
#' @param status Determines how the number of active clients is calculated. The options
#'   are to either to use the NDR `current_status_28_days` column ("default") or the
#'   derived `current_status` column ("calculated").
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
#' from = "2021-03-01",
#' to = "2021-03-31",
#' status = "default")
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
                           facilities = .f,
                           status = "calculated") {

  .s <- unique(data$state)

  .f <- unique(data$facility)

  if (!any(states %in% unique(data$state))) {
    rlang::abort("region(s) is not contained in the supplied data. Check the spelling and/or case.")
  }

  if (!any(facilities %in% unique(subset(data, state %in% states)$facility))) {
    rlang::abort("site(s) is not found in the data or state supplied.
                 Check that the state is correctly spelt and located in the state.")
  }

  if(is.na(lubridate::as_date(from)) || is.na(lubridate::as_date(to))) {
    rlang::abort("The supplied date is not in 'yyyy-mm-dd' format.")
  }

  if (lubridate::as_date(from) > lubridate::as_date(to)) {
    rlang::abort("The `from` date cannot be after the `to` date.")
  }

  if(!status %in% c("default", "calculated")) {
    rlang::abort("`status` can only be one of 'default' or 'calculated'. Check that you did not mispell, include CAPS or forget to quotation marks!")
  }

  switch(status,
                "calculated" = dplyr::filter(data,
                                             current_status == "Active",
                                             dplyr::between(
                                               date_lost - 28,
                                               lubridate::as_date(from),
                                               lubridate::as_date(to)),
                                             state %in% states,
                                             facility %in% facilities),
                "default" = dplyr::filter(data,
                                          current_status_28_days == "Active",
                                          dplyr::between(
                                            date_lost - 28,
                                            lubridate::as_date(from),
                                            lubridate::as_date(to)),
                                          state %in% states,
                                          facility %in% facilities))

}


utils::globalVariables(c(
  "last_drug_pickup_date",
  "current_status",
  "days_of_arv_refill",
  "current_status_28_days",
  "appointment_date",
  "state",
  "facility"
))
