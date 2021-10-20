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
#' @inheritParams tx_new
#' @inheritParams tx_curr
#'
#' @return tx_rtt
#' @export
#'
#' @examples
#' \donttest{
#' file_path <- "https://raw.githubusercontent.com/stephenbalogun/example_files/main/ndr_example.csv"
#' ndr_new <- read_ndr(file_path, time_stamp = "2021-02-15")
#' ndr_old <- ndr_example
#' tx_rtt(ndr_new, ndr_old)
#' }
#'
#' ## Determine RTT for a particular state
#' \donttest{
#' tx_rtt(ndr_old, ndr_new, states = "State 1")
#' }
tx_rtt <- function(new_data,
                   old_data,
                   states = NULL,
                   facilities = NULL,
                   status = "calculated") {


  states <- states %||% unique(new_data$state)

  facilities <- facilities %||% unique(subset(new_data, state %in% states)$facility)

  validate_rtt(new_data, old_data, states, facilities, status)

  get_tx_rtt(new_data, old_data, states, facilities, status)
}



validate_rtt <- function(new_data,
                         old_data,
                         states,
                         facilities,
                         status) {
  if (!all(states %in% unique(new_data$state))) {
    rlang::warn("state(s) is/are not contained in the supplied data. Check the spelling and/or case.")
  }

  if (!all(facilities %in% unique(subset(new_data, state %in% states)$facility))) {
    rlang::warn("facilit(ies) is/are not found in the data or state supplied.
                 Check that the facility is correctly spelt and located in the state.")
  }

  if (!status %in% c("default", "calculated")) {
    rlang::abort("`status` can only be one of 'default' or 'calculated'. Check that you did not mispell, include CAPS or forget to quotation marks!")
  }
}



get_tx_rtt <- function(new_data, old_data, states, facilities, status) {
  losses <- switch(status,
    "calculated" = dplyr::filter(
      old_data,
      current_status == "Inactive",
      !patient_has_died %in% TRUE,
      !patient_transferred_out %in% TRUE,
    ),
    "default" = dplyr::filter(
      old_data,
      current_status_28_days == "Inactive",
      !patient_has_died %in% TRUE,
      !patient_transferred_out %in% TRUE,
    )
  )

  switch(status,
    "calculated" = dplyr::filter(
      new_data,
      current_status == "Active",
      patient_identifier %in% losses$patient_identifier,
      !patient_has_died %in% TRUE,
      !patient_transferred_out %in% TRUE,
      state %in% states,
      facility %in% facilities
    ),
    "default" = dplyr::filter(
      new_data,
      current_status_28_days == "Active",
      patient_identifier %in% losses$patient_identifier,
      !patient_has_died %in% TRUE,
      !patient_transferred_out %in% TRUE,
      state %in% states,
      facility %in% facilities
    )
  )
}


utils::globalVariables(c(
  "patient_identifier",
  "current_status",
  "patient_has_died",
  "patient_transferred_out",
  "current_status_28_days"
))
