#' Subset clients who are on treatment
#' @importFrom magrittr %>%
#'
#' @param data an ndr dataframe imported using the `read_ndr()`.
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
#' ndr_example %>%
#'   tx_curr()
#'
#' # generate the TX_CURR for two states (e.g. "State 1" and "State 2" in the ndr_example file)
#' ndr_example %>%
#'   tx_curr(region = c("State 1", "State 2"))
#'
#' # determine the active clients in two facilities ("Facility 1", and "Facility 2) in "State 1"
#' ndr_example %>%
#'   tx_curr(
#'     region = "State 1",
#'     site = c("Facility 1", "Facility 2")
#'   )
tx_curr <- function(data,
                    region = unique(data$state),
                    site = unique(data$facility)) {
  stopifnot(
    "please check that region is contained in the dataset list of states" =
      any(region %in% unique(data$state))
  )

  stopifnot(
    "please check that site is contained in the dataset list of facilities" =
      any(site %in% unique(data$facility))
  )

  filter(
    data,
    current_status_28_days == "Active",
    state %in% region,
    facility %in% site
  )
}
