#' Subset Clients Starting ART Within a Particular Period.
#'
#' Generates the line-list of clients who commenced ARV within the specified
#' period of interest. The default is to generate the list for all clients who
#' commenced ARV in the current Fiscal Year. You can specify the period of
#' interest using the \code{from} and \code{to} arguments; and the state or
#' facility of interest with the \code{states} and \code{facilities} arguments.
#' For multiple states or facilities, use the \code{c()} to combine the names.
#'
#' @param data An NDR dataframe imported using the `read_ndr()`.
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
#' @param remove_duplicates Boolean argument. It specifies if duplicate patient entries in the facilities should be removed or kept
#'
#' @return TX_NEW clients in the period of interest
#' @export tx_new
#'
#' @examples
#' tx_new(ndr_example, from = "2021-06-01", to = "2021-09-30")
#'
#' # generate the TX_NEW for a specific state (Ayetoro)
#' tx_new(ndr_example, states = "Ayetoro")
#'
#' # Determine the TX_NEW for Quarter 1 of FY21 for State 2
#' tx_new(ndr_example,
#'   from = "2021-10-01",
#'   to = "2021-12-31",
#'   states = c("Arewa", "Ayetoro")
#' )
tx_new <- function(data,
                   from = NULL,
                   to = NULL,
                   states = NULL,
                   facilities = NULL,
                   remove_duplicates = FALSE) {
  from <- lubridate::ymd(from %||% get("fy_start")())

  to <- lubridate::ymd(to %||% get("Sys.Date")())

  states <- states %||% unique(data$state)

  facilities <- facilities %||% unique(subset(data, state %in% states)$facility)

  validate_new(data, from, to, states, facilities, remove_duplicates)

  get_tx_new(data, from, to, states, facilities, remove_duplicates)
}

validate_new <- function(data, from, to, states, facilities, remove_duplicates) {
  if (!all(states %in% unique(data$state))) {
    rlang::abort("state(s) is/are not contained in the supplied data. Check the spelling and/or case.")
  }

  if (!all(facilities %in% unique(subset(data, state %in% states)$facility))) {
    rlang::abort("facilit(ies) is/are not found in the data or state supplied.
                 Check that the facility is correctly spelt and located in the state.")
  }

  if (is.na(from) || is.na(to)) {
    rlang::abort("The supplied date is not in the right format. Did you remember to
                 enter the date in 'yyyy-mm-dd' or forget the quotation marks?")
  }

  if (from > Sys.Date() || to > Sys.Date()) {
    rlang::warn("The date arguments should not be in the future!!")
  }

  if (from > to) {
    rlang::abort("The 'to' date cannot be before the 'from' date!!")
  }

  if (!is.logical(remove_duplicates)) {
    rlang::abort("The `remove_duplicates` argument is a logical variable and can only be set to `TRUE` or `FALSE`")
  }
}


get_tx_new <- function(data, from, to, states, facilities, remove_duplicates) {
  data <- dplyr::filter(
    data,
    dplyr::between(
      art_start_date,
      from,
      to
    ),
    state %in% states,
    facility %in% facilities
  )

  if (remove_duplicates) {
    data <- dplyr::distinct(data, facility, patient_identifier, .keep_all = TRUE)
  }

  return(data)
}



utils::globalVariables("art_start_date")
