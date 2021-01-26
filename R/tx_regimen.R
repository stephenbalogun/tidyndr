#' Subset clients based on their current ART regimen
#'
#' @param data an ndr dataframe imported using the `read_ndr()
#' @param regimen the current 3-digits per medication combination regimen
#' the client is currently using (e.g. "ABC-3TC-DTG"). The default subset
#' clients who are on any of ""AZT-3TC-RAL", "ABC-3TC-LPV/r",
#' "AZT-3TC-LPV/r", "ABC-3TC-DTG" or "TDF-3TC-DTG".
#' @param age_range a numeric vector of length 2 (lower age-range and upper age-range).
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
#' tx_regimen(ndr_example)
#'
#' # Subset the clients aged 0 to 3 who are on choice regimen
#'
#' # Determine clients who are virally suppressed for two state at the end of Q1
#' ndr_example %>%
#' tx_pvls_den(reference = "2020-12-31",
#' region = c("State 1", "State 2"))
tx_regimen <- function(data,
                       regimen = c("AZT-3TC-RAL",
                                   "ABC-3TC-LPV/r",
                                   "AZT-3TC-LPV/r",
                                   "ABC-3TC-DTG",
                                   "TDF-3TC-DTG"),
                       age_range = c(0, Inf),
                       region = unique(data$state),
                       site = unique(data$facility)) {

  stopifnot('please enter the "age_range" argument as "c(min_age, max_age)"' =
              all(purrr::is_double(age_range, n = 2)))

  stopifnot("please check that region is contained in the dataset list of states" =
              any(region %in% unique(data$state)))

  stopifnot("please check that site is contained in the dataset list of facilities" =
              any(site %in% unique(data$facility)))


    dplyr::filter(data,
           current_status_28_days == "Active",
           last_regimen %in% regimen,
           dplyr::between(current_age, age_range[1], age_range[2]),
           state %in% region,
           facility %in% site)
}
