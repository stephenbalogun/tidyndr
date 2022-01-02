#' Subset Clients who are Currently on Treatment
#'
#' \code{tx_curr} pulls up the line-list of clients who are active
#'    on treatment using the calculated `current_status` column. You can specify
#'    the state(s) and/or facilit(ies) of interest using the \code{region} or
#'    \code{site} arguments.
#' @param status Determines how the number of active clients is calculated.
#'  The options are to either to use the NDR current_status_28_days column
#'  or the derived current_status column ("calculated").
#' @inheritParams tx_new
#'
#' @return TX_CURR
#' @export
#'
#' @examples
#' # Calculated active clients using the derived current status
#' tx_curr(ndr_example)
#'
#' # Calculate the active clients using the NDR `current_status_28_days` column
#' tx_curr(ndr_example, status = "default")
#'
#' # generate the TX_CURR for two states (e.g. "Arewa" and "Okun" in the ndr_example file)
#' tx_curr(ndr_example,
#'   states = c("Okun", "Arewa")
#' )
#'
#' # determine the active clients in two facilities ("Facility1", and "Facility2) in "Abaji"
#' tx_curr(ndr_example,
#'   states = "Abaji",
#'   facilities = c("Facility1", "Facility2")
#' )
tx_curr <- function(data,
                    states = NULL,
                    facilities = NULL,
                    status = "calculated") {

  states <- states %||% unique(data$state)

  facilities <- facilities %||% unique(subset(data, state %in% states)$facility)

  validate_curr(data, states, facilities, status)

  get_tx_curr(data, states, facilities, status)
}


validate_curr <- function(data, states, facilities, status) {
  if (!all(states %in% unique(data$state))) {
    rlang::abort("state(s) is/are not contained in the supplied data. Check the spelling and/or case.")
  }

  if (!all(facilities %in% unique(subset(data, state %in% states)$facility))) {
    rlang::abort("facilit(ies) is/are not found in the data or state supplied.
                 Check that the facility is correctly spelt and located in the state.")
  }

  if (!status %in% c("default", "calculated")) {
    rlang::abort("`status` can only be one of 'default' or 'calculated'. Check that you did not mispell, include CAPS or forget to quotation marks!")
  }
}

get_tx_curr <- function(data,
                        states,
                        facilities,
                        status) {
  switch(status,
    "calculated" = dplyr::filter(
      data,
      current_status == "Active",
      !patient_has_died %in% TRUE,
      !patient_transferred_out %in% TRUE,
      state %in% states,
      facility %in% facilities
    ),
    "default" = dplyr::filter(
      data,
      current_status_28_days == "Active",
      !patient_has_died %in% TRUE,
      !patient_transferred_out %in% TRUE,
      state %in% states,
      facility %in% facilities
    )
  )
}

utils::globalVariables(
  c("current_status",
    "patient_has_died",
    "patient_transferred_out")
)
