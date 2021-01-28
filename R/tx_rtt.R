#' Subset rows of clients who were previously inactive but now active
#'
#' @param old_data the initial dataframe containing the list of clients who have been previously inactive.
#' @param new_data the current datafame where changes in current treatment status will be checked.
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
#' ndr_old <- read_ndr(file_path)
#' ndr_new <- read_ndr(file_path)
#' tx_rtt(ndr_old, ndr_new)
#'
#' # Determine RTT for a particular state
#' tx_rtt(ndr_old, ndr_new, region = "State 1")
tx_rtt <- function(old_data,
                   new_data,
                   region = unique(new_data$state),
                   site = unique(new_data$facility)) {
  stopifnot(
    "please check that region is contained in the dataset list of states" =
      any(region %in% unique(new_data$state))
  )

  stopifnot(
    "please check that site is contained in the dataset list of facilities" =
      any(site %in% unique(new_data$facility))
  )

  stopifnot(
    "old_data is more recent than new_data" =
      max(old_data$art_start_date, na.rm = TRUE) <=
        max(new_data$art_start_date, na.rm = TRUE)
  )

  losses <- dplyr::filter(
    old_data,
    current_status_28_days == "Inactive"
  )

  new_data %>%
    dplyr::filter(
      current_status_28_days == "Active",
      patient_identifier %in% losses$patient_identifier,
      state %in% region,
      facility %in% site
    )
}


utils::globalVariables("patient_identifier")
