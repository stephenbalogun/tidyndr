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
#' @return tx_curr
#' @export
#'
#' @examples
#' # Calculatd active clients using the derived current status
#' tx_curr(ndr_example)
#'
#' # Calculate the active clients using the NDR `current_status_28_days` column
#' tx_curr(ndr_example, status = "default")
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
                    states = .s,
                    facilities = .f,
                    status = "calculated") {
  .s <- unique(data$state)

  .f <- unique(data$facility)

  if (!any(states %in% unique(data$state))) {
    rlang::abort("state(s) is/are not contained in the supplied data. Check the spelling and/or case.")
  }

  if (!any(facilities %in% unique(subset(data, state %in% states)$facility))) {
    rlang::abort("facilit(ies) is/are not found in the data or state supplied.
                 Check that the facility is correctly spelt and located in the state.")
  }

  if (!status %in% c("default", "calculated")) {
    rlang::abort("`status` can only be one of 'default' or 'calculated'. Check that you did not mispell, include CAPS or forget to quotation marks!")
  }

  switch(status,
    "calculated" = dplyr::filter(
      data,
      current_status == "Active",
      state %in% states,
      facility %in% facilities
    ),
    "default" = dplyr::filter(
      data,
      current_status_28_days == "Active",
      state %in% states,
      facility %in% facilities
    )
  )
}


utils::globalVariables("current_status")
