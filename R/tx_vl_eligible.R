#' Subset clients who are eligible for viral load
#'
#' @param data an ndr dataframe imported using the `read_ndr()
#' @param reference date, provided in ISO8601 format ("yyyy-mm-dd"), used to
#' determine clients who are eligible for viral load. The default is to subset clients
#' who have been on medication for at least 6 months
#' (ART start date is at least 6 months ago).
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
#' tx_vl_eligible(ndr_example)
#'
#' # Determine clients who are going to be eligible for VL by the end of Q2 of FY21
#' ndr_example %>%
#' tx_vl_eligible(reference = "2021-03-31")
#'
tx_vl_eligible <- function(data,
                           reference = Sys.Date(),
                           region = unique(data$state),
                           site = unique(data$facility)) {

  stopifnot("please check that region is contained in the dataset list of states" =
              any(region %in% unique(data$state)))

  stopifnot("please check that site is contained in the dataset list of facilities" =
              any(site %in% unique(data$facility)))

  stopifnot('please check that your reference date format is "yyyy-mm-dd"' =
              !is.na(lubridate::as_date(reference)))

  dplyr::filter(data,
                current_status_28_days == "Active",
                lubridate::as_date(reference) - art_start_date >=
                  lubridate::period(6, "months"),
           state %in% region,
           facility %in% site)
}
