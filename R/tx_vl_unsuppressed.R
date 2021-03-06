#' Determine Clients who are Virally Suppressed
#'
#' Generate the line-list of clients whose date of last viral load result is not
#' more than one year (for adults 20 years and above) and 6 months (for
#' paediatrics and adolescents) from the specified reference date and are virally
#' suppressed.
#'
#' @inheritParams tx_pvls_num
#'
#' @return tx_vl_unsuppressed
#' @export
#'
#' @examples
#' tx_vl_unsuppressed(ndr_example)
#'
#' # Determine clients who are virally unsuppressed for a state at the end of Q1
#' tx_vl_unsuppressed(ndr_example,
#'   ref = "2020-12-31",
#'   states = "State 1"
#' )
#'
#' # Determine clients with viral load result of 400 or more (low level viremia)
#' tx_vl_unsuppressed(ndr_example, n = 400)
tx_vl_unsuppressed <- function(data,
                               ref = get("Sys.Date")(),
                               states = .s,
                               facilities = .f,
                               status = "calculated",
                               n = 1000) {
  .s <- unique(data$state)
  .f <- unique(data$facility)

  if (!all(states %in% unique(data$state))) {
    rlang::abort("state(s) is/are not contained in the supplied data. Check the spelling and/or case.")
  }

  if (!all(facilities %in% unique(subset(data, state %in% states)$facility))) {
    rlang::abort("facilit(ies) is/are not found in the data or state supplied.
                 Check that the facility is correctly spelt and located in the state.")
  }

  if (is.na(lubridate::as_date(ref))) {
    rlang::abort("The supplied date is not in 'yyyy-mm-dd' format.")
  }

  if (!status %in% c("default", "calculated")) {
    rlang::abort("`status` can only be one of 'default' or 'calculated'. Check that you did not mispell, include CAPS or forget to quotation marks!")
  }


  switch(status,
    "calculated" = dplyr::filter(
      data,
      current_status == "Active",
      lubridate::as_date(ref) - art_start_date >=
        lubridate::period(6, "months"),
      dplyr::if_else(
        current_age < 20,
        lubridate::as_date(ref) -
          date_of_current_viral_load <=
          lubridate::period(6, "months"),
        lubridate::as_date(ref) -
          date_of_current_viral_load <=
          lubridate::period(1, "year")
      ),
      current_viral_load >= n,
      state %in% states,
      facility %in% facilities
    ),
    "default" = dplyr::filter(
      data,
      current_status_28_days == "Active",
      lubridate::as_date(ref) - art_start_date >=
        lubridate::period(6, "months"),
      dplyr::if_else(
        current_age < 20,
        lubridate::as_date(ref) -
          date_of_current_viral_load <=
          lubridate::period(6, "months"),
        lubridate::as_date(ref) -
          date_of_current_viral_load <=
          lubridate::period(1, "year")
      ),
      current_viral_load >= n,
      state %in% states,
      facility %in% facilities
    )
  )
}


utils::globalVariables(c(
  "art_start_date",
  "current_age",
  "current_status",
  "date_of_current_viral_load",
  "current_viral_load"
))
