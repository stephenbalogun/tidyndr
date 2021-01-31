#' Subset Rows of Previously Inactive Clients Who are Now Active
#'
#' Generates the line-list of clients who were inactive in the data supplied to
#' the \code{old_data} argument but have now become active in the data supplied
#' to the \code{new_data} argument.
#'
#' @param old_data The initial dataframe containing the list of clients who
#'    have been previously inactive.
#' @param new_data The current datafame where changes in current treatment
#'    status will be checked.
#' @inheritParams tx_appointment
#'
#' @return
#' @export
#'
#' @examples
#' file_path <- system.file("extdata", "ndr_example.csv", package = "tidyndr")
#' ndr_old <- read_ndr(file_path)
#' ndr_new <- ndr_example
#' tx_rtt(ndr_old, ndr_new)
#'
#' # Determine RTT for a particular state
#' tx_rtt(ndr_old, ndr_new, state = "State 1")
tx_rtt <- function(old_data,
                   new_data,
                   state = region,
                   facility = site) {
  region <- unique(new_data$state)
  site <- unique(new_data$facility)

  stopifnot(
    "the states contained in the 'old data' and 'new data' files are not the
    same. Please ensure that the two files contain similar states" =
      unique(old_data$state) == unique(new_data$state)
  )

  stopifnot(
    "the facilities contained in the 'old data' and 'new data' files are not the
    same. Please ensure that the two files contain similar facilities" =
      unique(old_data$facility) == unique(new_data$facility)
  )

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

  dplyr::filter(
    new_data,
    current_status_28_days == "Active",
    patient_identifier %in% losses$patient_identifier,
    state %in% region,
    facility %in% site
  )
}


utils::globalVariables("patient_identifier")
