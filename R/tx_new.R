#' Subset clients starting ART within a particular period.
#'
#' Generates the line-list of clients who commenced ARV within the specified
#' period of interest. The default is to generate the list for all clients who
#' commenced ARV in the current Fiscal Year. You can specify the period of
#' interest using the \code{from} and \code{to} arguments; and the state or
#' facility of interest with the \code{states} and \code{facilities} arguments.
#' For multiple states or facilities, use the \code{c()} to combine the names.
#'
#' @param data An NDR dataframe imported using the `read_ndr().
#' @param from The start date in ISO8601 format (i.e. "yyyy-mm-dd").
#' The default is to start at the beginning of the current Fiscal Year (i.e. 1st of October).
#' @param to The end date written in ISO8601 format (i.e. "yyyy-mm-dd").
#' The default is the date of analysis.
#' @param states The name(s) of the State(s) of interest. The default utilizes all
#'   the states in the dataframe. If specifying more than one state, combine the
#'   states using the \code{c()} e.g. \code{c("State 1", "State 2")}.
#' @param facilities The name(s) of the facilit(ies) of interest. Default is to utilize
#'   all the facilities contained in the dataframe. If specifying more than one
#'   facility, combine the facilities using the \code{c()} e.g.
#'   \code{c("Facility 1", "Facility 2")}.
#'
#' @return tx_new
#' @export
#'
#' @examples
#' tx_new(ndr_example)
#'
#' # generate the TX_NEW for a specific state (State 1)
#' tx_new(ndr_example, states = "State 1")
#'
#' ## Determine the TX_NEW for Quarter 1 of FY21 for State 2
#' tx_new(ndr_example,
#'   from = "2020-10-01",
#'   to = "2020-12-31",
#'   states = c("State 2", "State 3")
#' )
tx_new <- function(data,
                   from = get("fy_start")(),
                   to = get("Sys.Date")(),
                   states = .s,
                   facilities = .f) {
  .s <- unique(data$state)

  .f <- unique(data$facility)

  if (!all(states %in% unique(data$state))) {
    rlang::abort("state(s) is/are not contained in the supplied data. Check the spelling and/or case.")
  }

  if (!all(facilities %in% unique(subset(data, state %in% states)$facility))) {
    rlang::abort("facilit(ies) is/are not found in the data or state supplied.
                 Check that the facility is correctly spelt and located in the state.")
  }

  if (is.na(lubridate::as_date(from)) || is.na(lubridate::as_date(to))) {
    rlang::abort("The supplied date is not in the right format. Did you remember to
                 enter the date in 'yyyy-mm-dd' or forget the quotation marks?")
  }

  if (lubridate::as_date(from) > Sys.Date() || lubridate::as_date(to) > Sys.Date()) {
    rlang::abort("The date arguments cannot be in the future!!")
  }

  if (lubridate::as_date(from) > lubridate::as_date(to)) {
    rlang::abort("The 'to' date cannot be before the 'from' date!!")
  }



  dplyr::filter(
    data,
    dplyr::between(
      art_start_date,
      lubridate::as_date(from),
      lubridate::as_date(to)
    ),
    state %in% states,
    facility %in% facilities
  )
}


utils::globalVariables("art_start_date")
