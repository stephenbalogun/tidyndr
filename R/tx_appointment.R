#' Subset rows of clients who have clinic appointment/medication pick-up within a particular period
#'
#' @param data an ndr dataframe imported using the `read_ndr()
#' @param from the start date for clients with clinic appointments in
#' ISO8601 format (i.e. "yyyy-mm-dd"). The default is to start at the
#' beginning of the current Fiscal Year (i.e. 1st of October).
#' @param to the end date for the appointment period of interest written
#' in ISO8601 format (i.e. "yyyy-mm-dd"). The default is today.
#' @param region a character vector specifying the "State" of interest.
#' The default utilizes all the states in the dataframe.
#' @param site a character vector of at least length 1. Default is to utilize all
#' the facilities contained in the dataframe.
#'
#' @return
#' @export
#'
#' @examples
#' # Determine clients who have medication refill in Q2 of Fy21
#' file_path <- "C:/Users/stephenbalogun/Documents/My R/tidyndr/ndr_example.csv"
#' ndr_example <- read_ndr(file_path)
#' tx_appointment(ndr_example,
#' from = "2021-01-01",
#' to = "2021-03-30")
#'
#' # Determine clients with medication refill in January 2021 for a particular facility
#' tx_appointment(ndr_example,
#' from = "2021-01-01",
#' to = "2021-01-31",
#' region = "State 1",
#' site = "Facility 1")
tx_appointment <- function(data,
                           from = fy_start,
                           to = Sys.Date(),
                           region = unique(data$state),
                           site = unique(data$facility)) {

  fy_start <- lubridate::as_date(
    ifelse(lubridate::month(Sys.Date()) < 10,
           update(Sys.Date(),
                  year = year(Sys.Date()) - 1,
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


  data %>%
    dplyr::mutate(appointment_date = last_drug_pickup_date +
             lubridate::days(days_of_arv_refill)) %>%
    dplyr::filter(current_status_28_days == "Active",
           dplyr::between(appointment_date,
                          lubridate::as_date(from),
                          lubridate::as_date(to)),
           state %in% region,
           facility %in% site)
}
