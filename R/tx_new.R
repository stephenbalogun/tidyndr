#' Subset clients starting ART within a particular period.
#'
#' @param data an ndr dataframe imported using the `read_ndr()`.
#' @param from reference date to start the determination of the "TX_NEW"
#' in ISO8601 format (i.e. "yyyy-mm-dd"). The default is to start at the
#' beginning of the current Fiscal Year (i.e. 1st of October).
#' @param to last reference date for the "TX_NEW" determination written in
#' ISO8601 format (i.e. "yyyy-mm-dd"). The default is today.
#' @param region a character vector specifying the "State" of interest.
#' The default utilizes all the states in the dataframe.
#' @param site a character vector of at least length 1. Default is to utilize all
#' the facilities contained in the dataframe.
#'
#' @return
#' @export
#'
#' @examples
#' file_path <- "C:/Users/stephenbalogun/Documents/My R/tidyndr/ndr_example.csv"
#' ndr_example <- read_ndr(file_path)
#'
#' tx_new(ndr_example)
#'
#' # generate the TX_NEW for a specific state (State 1)
#' tx_new(ndr_example, region = "State 1")
#'
#' ## Determine the TX_NEW for Quarter 1 of FY21 for State 2
#' ndr_example %>%
#'   tx_new(
#'     from = "2020-10-01",
#'     to = "2020-12-31",
#'     region = "State 2"
#'   )
tx_new <- function(data,
                   from = fy_start,
                   to = Sys.Date(),
                   region = unique(data$state),
                   site = unique(data$facility)) {
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
      any(region %in% unique(data$state))
  )

  stopifnot(
    "please check that site is contained in the dataset list of facilities" =
      any(site %in% unique(data$facility))
  )

  stopifnot(
    'please check that your date format is "yyyy-mm-dd"' =
      !is.na(lubridate::as_date(from))
  )
  stopifnot(
    'please check that your date format is "yyyy-mm-dd"' =
      !is.na(lubridate::as_date(to))
  )

  filter(
    data,
    dplyr::between(
      art_start_date,
      lubridate::as_date(from),
      lubridate::as_date(to)
    ),
    state %in% region,
    facility %in% site
  )
}


utils::globalVariables("art_start_date")
