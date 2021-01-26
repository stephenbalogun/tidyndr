#' Determine clients who are virally suppressed
#' @importFrom dplyr filter
#'
#' @param data an ndr dataframe imported using the `read_ndr()
#' @param reference date, provided in ISO8601 format ("yyyy-mm-dd"), used to
#' determine clients who are eligible for viral load and should have a
#' documented result. The default is the date of analysis (today).
#' Repeat viral load is calculated for adults of age 20 years annually and every
#' 6 months for clients of 19 years and below.
#' @param region a character vector specifying the "State" of interest.
#' The default utilizes all the states in the dataframe.
#' @param site a character vector of at least length 1. Default is to utilize all
#' the facilities contained in the dataframe.
#' @param n the value below which viral load result is adjudged to be suppressed.
#'
#' @return
#' @export
#'
#' @examples
#' file_path <- "C:/Users/stephenbalogun/Documents/My R/tidyndr/ndr_example.csv"
#' ndr_example <- read_ndr(file_path)
#'
#' tx_pvls_num(ndr_example)
#'
#' # Determine clients who are virally suppressed for a state at the end of Q1
#' ndr_example %>%
#' tx_pvls_num(reference = "2020-12-31",
#' region = "State 1")
#'
#' # Determine clients with viral load result less than 400
#' ndr_example %>%
#' tx_pvls_num(n = 400)
tx_pvls_num <- function(data,
                        reference = Sys.Date(),
                        region = unique(data$state),
                        site = unique(data$facility),
                        n = 1000) {

  stopifnot("please check that region is contained in the dataset list of states" =
              any(region %in% unique(data$state)))

  stopifnot("please check that site is contained in the dataset list of facilities" =
              any(site %in% unique(data$facility)))

  stopifnot('please check that your reference date format is "yyyy-mm-dd"' =
              !is.na(lubridate::as_date(reference)))


    filter(data,
           current_status_28_days == "Active",
           lubridate::as_date(reference) -
             art_start_date >= lubridate::period(6, "months"),
           ifelse(current_age < 20,
                  date_of_current_viral_load > lubridate::as_date(reference) -
                    lubridate::period(month = 6),
                  date_of_current_viral_load > lubridate::as_date(reference) -
                    lubridate::period(year = 1)),
           current_viral_load < n,
           state %in% region,
           facility %in% site)
}
