#' Subset active clients based on months of ARV Dispensed
#'
#' @param data an ndr dataframe imported using the `read_ndr()`.
#' @param month the number(s) of month of interest of ARV dispensed (rounded to the nearest who number).
#' The default is to subset active clients who had 3 - 6 months of ARV dispensed.
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
#' tx_mmd(ndr_example)
#'
#' # subset active clients who had 2 or 4 months of ARV dispensed at last encounter
#' tx_mmd(ndr_example, month = c(2, 4))
tx_mmd <- function(data,
                   month = c(3, 4, 5, 6),
                   region = unique(data$state),
                   site = unique(data$facility)) {
  stopifnot(
    "number of months dispensed must be numeric" = is.numeric(month)
  )


  stopifnot(
    "please check that region is contained in the dataset list of states" =
      any(region %in% unique(data$state))
  )

  stopifnot(
    "please check that site is contained in the dataset list of facilities" =
      any(site %in% unique(data$facility))
  )

  data %>%
    dplyr::mutate(months_dispensed = round(days_of_arv_refill / 30, 0)) %>%
    dplyr::filter(
      current_status_28_days == "Active",
      months_dispensed %in% month,
      state %in% region,
      facility %in% site
    )
}


utils::globalVariables("months_dispensed")

