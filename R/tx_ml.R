#' Subset clients who became inactive (IIT) within a given period
#'
#' @param data an ndr dataframe imported using the `read_ndr()
#' @param from reference date to start the determination of the "TX_ML"
#' in ISO8601 format (i.e. "yyyy-mm-dd"). The default is to start at the
#' beginning of the current Fiscal Year (i.e. 1st of October).
#' @param to last reference date for the "TX_ML" determination written in
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
#' tx_ml(ndr_example)
#'
#' # Find clients who were inactive at the end of Q1 of FY21
#' tx_ml(ndr_example, to = "2020-12-31")
tx_ml <- function(data,
                  from = fy_start,
                  to = Sys.Date(),
                  region = unique(data$state),
                  site = unique(data$facility)) {

  fy_start <- lubridate::as_date(
    ifelse(lubridate::month(Sys.Date()) < 10,
           update(Sys.Date(),
                  year = lubridate::year(Sys.Date()) - 1,
                  month = 10,
                  day = 1),
           update(Sys.Date(),
                  month = 10,
                  day = 1))
  )

  stopifnot("please check that region is contained in the dataset list of states" =
              any(region %in% unique(data$state)))

  stopifnot("please check that site is contained in the dataset list of facilities" =
              any(site %in% unique(data$facility)))

  stopifnot('please check that your date format is "yyyy-mm-dd"' =
              !is.na(lubridate::as_date(from)))
  stopifnot('please check that your date format is "yyyy-mm-dd"' =
              !is.na(lubridate::as_date(to)))

    dplyr::mutate(data,
           date_lost = last_drug_pickup_date +
             lubridate::days(days_of_arv_refill) +
             lubridate::days(28)) %>%
    dplyr::filter(
      # current_status_28_days == "Inactive",
      dplyr::between(date_lost,
                     lubridate::as_date(from),
                     lubridate::as_date(to)),
      state %in% region,
      facility %in% site)
}

