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
#' @return tx_rtt
#' @export
#'
#' @examples
#' file_path <- "https://raw.githubusercontent.com/stephenbalogun/example_files/main/ndr_example.csv"
#' ndr_old <- read_ndr(file_path, time_stamp = "2021-02-15")
#' ndr_new <- ndr_example
#' tx_rtt(ndr_old, ndr_new)
#'
#' # Determine RTT for a particular state
#' tx_rtt(ndr_old, ndr_new, states = "State 1")
tx_rtt <- function(old_data,
                   new_data,
                   states = .s,
                   facilities = .f,
                   status = "calculated") {
  .s <- unique(new_data$state)
  .f <- unique(new_data$facility)


  # if (!any(states %in% unique(data$state))) {
  #   rlang::abort("state(s) is not contained in the supplied data. Check the spelling and/or case.")
  # }
  #
  # if (!any(facilities %in% unique(subset(old_ddata, state %in% states)$facility))) {
  #   rlang::abort("facilit(ies) is/are not found in the data or state supplied.
  #                Check that the facility is correctly spelt and located in the state.")
  # }

  # if (max(old_data$art_start_date, na.rm = TRUE) >
  #      max(new_data$art_start_date, na.rm = TRUE)) {
  #   rlang::abort("old_data is more recent than new_data. Did you swtich the position of the two datasets?")
  # }

  if(!status %in% c("default", "calculated")) {
    rlang::abort("`status` can only be one of 'default' or 'calculated'. Check that you did not mispell, include CAPS or forget to quotation marks!")
  }


  losses <- switch(status,
         "calculated" = dplyr::filter(old_data,
           current_status == "Inactive"),
         "default" = dplyr::filter(old_data,
           current_status_28_days == "Inactive")
         )

  switch(status,
         "calculated" =  dplyr::filter(
           new_data,
           current_status == "Active",
           patient_identifier %in% losses$patient_identifier,
           state %in% states,
           facility %in% facilities),
         "default" =  dplyr::filter(
           new_data,
           current_status_28_days == "Active",
           patient_identifier %in% losses$patient_identifier,
           state %in% states,
           facility %in% facilities)
  )
}


utils::globalVariables(c("patient_identifier",
                         "current_status"))
