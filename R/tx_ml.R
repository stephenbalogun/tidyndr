#' Subset Clients who Became Inactive (IIT) Within a Given Period
#'
#' \code{tx_ml} Generates clients who have become inactive over a specified
#' period of time. The default is to generate all clients who became inactive
#' in the current Fiscal Year. You can specify the period of interest
#' (using the \code{from} and \code{to} arguments). Used together
#' with \code{tx_ml_outcomes()}, generates inactive clients with a particular
#' outcome of interest.
#'
#' @inheritParams tx_new
#' @inheritParams tx_curr
#' @param old_data The initial dataframe containing the list of clients who
#'    were previously active.
#' @param new_data The current datafame where changes in current treatment
#'    status will be checked.
#'
#' @return tx_ml
#' @export
#'
#' @examples
#' tx_ml(new_data = ndr_example)
#'
#' # Find clients who were inactive at the end of Q1 of FY21
#' tx_ml(
#'   new_data = ndr_example,
#'   to = "2020-12-31"
#' )
#'
#' ## not run:
#' ## generate line-list of `tx_ml()` using two datasets
#' # file_path <- "https://raw.githubusercontent.com/stephenbalogun/example_files/main/ndr_example.csv"
#' # ndr_old <- read_ndr(file_path, time_stamp = "2021-02-15")
#' # ndr_new <- ndr_example
#' # tx_ml(
#' #   old_data = ndr_old,
#' #   new_data = ndr_new
#' # )
tx_ml <- function(old_data = NULL,
                  new_data,
                  from = NULL,
                  to = NULL,
                  states = .s,
                  facilities = .f,
                  status = "calculated") {
  .s <- unique(new_data$state)

  .f <- unique(subset(new_data, state %in% states)$facility)


  if (!all(states %in% unique(new_data$state))) {
    rlang::abort("state(s) is/are not contained in the supplied data. Check the spelling and/or case.")
  }

  if (!all(facilities %in% unique(subset(new_data, state %in% states)$facility))) {
    rlang::abort("facilit(ies) is/are not found in the data or state supplied.
                 Check that the facility is correctly spelt and located in the state.")
  }

  if (!rlang::is_null(from) && is.na(lubridate::as_date(from))) {
    rlang::abort("The supplied date is not in 'yyyy-mm-dd' format.")
  }

  if (!rlang::is_null(to) && is.na(lubridate::as_date(to))) {
    rlang::abort("The supplied date is not in 'yyyy-mm-dd' format.")
  }

  if (!status %in% c("default", "calculated")) {
    rlang::abort("`status` can only be one of 'default' or 'calculated'. Check that you did not mispell, include CAPS or forget to quotation marks!")
  }

  if (rlang::is_null(old_data)) {
    dplyr::filter(
      new_data,
      dplyr::between(
        date_lost,
        lubridate::as_date(from %||% get("fy_start")()),
        lubridate::as_date(to %||% get("Sys.Date")())
      ),
      state %in% states,
      facility %in% facilities
    )
  } else {
    active <- switch(status,
      "calculated" = dplyr::filter(
        old_data,
        current_status == "Active"
      ),
      "default" = dplyr::filter(
        old_data,
        current_status_28_days == "Active"
      )
    )

    switch(status,
      "calculated" = dplyr::filter(
        new_data,
        patient_identifier %in% active$patient_identifier,
        current_status == "Inactive",
        state %in% states,
        facility %in% facilities
      ),
      "default" = dplyr::filter(
        new_data,
        patient_identifier %in% active$patient_identifier,
        current_status_28_days == "Inactive",
        state %in% states,
        facility %in% facilities
      )
    )
  }
}



utils::globalVariables(c(
  "date_lost",
  "patient_identifier",
  "current_status",
  "current_status_28_days"
))
