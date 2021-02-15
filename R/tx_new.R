#' Subset clients starting ART within a particular period.
#'
#' Generates the line-list of clients who commenced ARV within the specified
#' period of interest. The default is to generate the list for all clients who
#' commenced ARV in the current Fiscal Year. You can change the period of
#' interest using the \code{from} and \code{to} arguments; and the state or
#' facility of interest with the \code{state} and \code{facility} arguments.
#' For multiple states or facilities, use the \code{c()} to combine the names.
#'
#' @inheritParams tx_appointment
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
