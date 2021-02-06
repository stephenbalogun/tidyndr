#' Subset clients who are currently on treatment
#'
#' \code{tx_curr} pulls up the line-list of clients who are active
#'    on treatment using the `current_status_28_days` column. You can specify
#'    the state(s) and/or facilit(ies) of interest using the \code{region} or
#'    \code{site} arguments.
#'
#' @inheritParams tx_appointment
#'
#' @importFrom magrittr %>%
#'
#' @return
#' @export
#'
#' @examples
#' tx_curr(ndr_example)
#'
#' # generate the TX_CURR for two states (e.g. "State 1" and "State 2" in the ndr_example file)
#' tx_curr(ndr_example,
#'   states = c("State 1", "State 2")
#' )
#'
#' # determine the active clients in two facilities ("Facility 1", and "Facility 2) in "State 1"
#' tx_curr(ndr_example,
#'   states = "State 1",
#'   facilities = c("Facility 1", "Facility 2")
#' )
tx_curr <- function(data,
                    states = regions,
                    facilities = sites) {
  regions <- unique(data$state)
  sites <- unique(data$facility)

  stopifnot(
    "please check that region is contained in the dataset list of states" =
      any(states %in% unique(data$state))
  )

  stopifnot(
    "please check that site is contained in the dataset list of facilities" =
      any(facilities %in% unique(data$facility))
  )

  dplyr::filter(
    data,
    current_status_28_days == "Active",
    state %in% states,
    facility %in% facilities
  )
}
