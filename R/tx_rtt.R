#' Subset Rows of Previously Inactive Clients Who are Now Active
#'
#' Generates the line-list of clients who were inactive in the data supplied to
#' the \code{old_data} argument but have now become active in the data supplied
#' to the \code{new_data} argument.
#'
#' @param new_data The current datafame where changes in current treatment
#'    status will be checked.
#' @param old_data The initial dataframe containing the list of clients who
#'    have been previously inactive.
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
                   old_data = NULL,
                   quarter = NULL,
                   states = NULL,
                   facilities = NULL,
                   status = "default",
                   remove_duplicates = FALSE) {
  states <- states %||% unique(new_data$state)

  facilities <- facilities %||% unique(subset(new_data, state %in% states)$facility)

  validate_rtt(new_data, old_data, quarter, states, facilities, status, remove_duplicates)

  get_tx_rtt(new_data, old_data, quarter, states, facilities, status, remove_duplicates)
}



validate_rtt <- function(new_data,
                         old_data,
                         quarter,
                         states,
                         facilities,
                         status,
                         remove_duplicates) {
  if (!all(states %in% unique(new_data$state))) {
    rlang::warn("state(s) is/are not contained in the supplied data. Check the spelling and/or case.")
  }

  if (!all(facilities %in% unique(subset(new_data, state %in% states)$facility))) {
    rlang::warn("facilit(ies) is/are not found in the data or state supplied.
                 Check that the facility is correctly spelt and located in the state.")
  }

  if (!rlang::is_null(old_data) && !status %in% c("default", "calculated")) {
    rlang::abort("`status` can only be one of 'default' or 'calculated'. Check that you did not mispell, include CAPS or forget to quotation marks!")
  }

  if (!is.logical(remove_duplicates)) {
    rlang::abort("The `remove_duplicates` argument is a logical variable and can only be set to `TRUE` or `FALSE`")
  }
  if (rlang::is_null(old_data) && rlang::is_null(quarter)) {
    rlang::abort("Kindly supply one of `old_data` or `quarter` arguments")
  }

  if (!rlang::is_null(quarter)) {
    if(!is.numeric(quarter) || nchar(quarter) > 1 || quarter > 4 || quarter < 1) {
      rlang::abort("Please supply a whole number between 1 and 4 to the `quarter` argument")
    }
  }
}



get_tx_rtt <- function(new_data, old_data, quarter, states, facilities, status, remove_duplicates) {

  if (rlang::is_null(old_data)) {
    df <- switch(quarter,
                 `1` = dplyr::filter(
                   new_data,
                   current_status_q4_28_days == "Inactive",
                   current_status_q1_28_days == "Active",
                   state %in% states,
                   facility %in% facilities
                 )
                 ,
                 `2` = dplyr::filter(
                   new_data,
                   current_status_q1_28_days == "Inactive",
                   current_status_q2_28_days == "Active",
                   state %in% states,
                   facility %in% facilities
                 ),
                 `3` = dplyr::filter(
                   new_data,
                   current_status_q2_28_days == "Inactive",
                   current_status_q3_28_days == "Active",
                   state %in% states,
                   facility %in% facilities
                 ),
                 `4` = dplyr::filter(
                   new_data,
                   current_status_q3_28_days == "Inactive",
                   current_status_q4_28_days == "Active",
                   state %in% states,
                   facility %in% facilities
                 )
    )

  } else {
    losses <- switch(status,
                     "calculated" = dplyr::filter(
                       old_data,
                       current_status == "Inactive",
                       !patient_has_died %in% TRUE
                     ),
                     "default" = dplyr::filter(
                       old_data,
                       current_status_28_days == "Inactive",
                       !patient_has_died %in% TRUE
                     )
    )

    df <- switch(status,
                 "calculated" = dplyr::filter(
                   new_data,
                   current_status == "Active",
                   patient_identifier %in% losses$patient_identifier,
                   !patient_has_died %in% TRUE,
                   state %in% states,
                   facility %in% facilities
                 ),
                 "default" = dplyr::filter(
                   new_data,
                   current_status_28_days == "Active",
                   patient_identifier %in% losses$patient_identifier,
                   !patient_has_died %in% TRUE,
                   state %in% states,
                   facility %in% facilities
                 )
    )
  }


  if (remove_duplicates) {
    df <- dplyr::distinct(df, facility, patient_identifier, .keep_all = TRUE)
  }

  return(df)
}


utils::globalVariables(c(
  "patient_identifier",
  "current_status",
  "patient_has_died",
  "patient_transferred_out",
  "current_status_q1_28_days",
  "current_status_q2_28_days",
  "current_status_q3_28_days",
  "current_status_q4_28_days",
  "current_status_28_days"
))


