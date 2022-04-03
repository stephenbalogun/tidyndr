#' Analyse the Viral Load Cascade Indicators
#'
#' Generate aggregate summary of viral load indicators based on a referenced date. The indicators include `eligible`, `documented results`,
#' `virally suppressed`, `viral load coverage`, and `viral load suppression rate`.
#'
#' @inheritParams tx_pvls_num
#' @param .level the level at which the aggregate summary should be performed. The options are "ip", "country", "state", "lga" and "facility".
#' @param .names if specified, these will be used for naming of the viral load indicators instead of the default.
#'
#' @return summary of viral load cascade
#' @export
#'
#' @examples
#' vl_cascade(ndr_example, ref = "2021-12-31", .level = "state")
#'
#' # Determine the viral load cascade for a state at the end of September 2021
#' vl_cascade(ndr_example,
#'   ref = "2021-10-31",
#'   states = "Arewa"
#' )
#'
vl_cascade <- function(data,
                        ref = NULL,
                        states = NULL,
                        facilities = NULL,
                        status = "default",
                        n = 1000,
                        use_six_months = TRUE,
                        remove_duplicates = FALSE,
                       .level = "state",
                       .names = NULL) {

  ref <- lubridate::ymd(ref %||% get("Sys.Date")())

  states <- states %||% unique(data$state)

  facilities <- facilities %||% unique(subset(data, state %in% states)$facility)

  validate_vl_cascade(data, ref, states, facilities, status, n, use_six_months, remove_duplicates, .level, .names)

  get_vl_cascade(data, ref, states, facilities, status, n, use_six_months, remove_duplicates, .level, .names)
}


validate_vl_cascade <- function(data,
                              ref,
                              states,
                              facilities,
                              status,
                              n,
                              use_six_months,
                              remove_duplicates,
                              .level,
                              .names) {
  if (!all(states %in% unique(data$state))) {
    rlang::abort("state(s) is not contained in the supplied data. Check the spelling and/or case.")
  }

  if (!all(facilities %in% unique(subset(data, state %in% states)$facility))) {
    rlang::abort("facilit(ies) is/are not found in the data or state supplied.
                 Check that the facility is correctly spelt and located in the state.")
  }

  if (is.na(ref)) {
    rlang::abort("The supplied date is not in 'yyyy-mm-dd' format.")
  }

  if (!status %in% c("default", "calculated")) {
    rlang::abort("`status` can only be one of 'default' or 'calculated'. Check that you did not mispell, include CAPS or forget to quotation marks!")
  }

  if (n < 0) {
    rlang::abort("n cannot be less than zero")
  }

  if (!is.logical(use_six_months)) {
    rlang::abort("use_six_months can either be TRUE or FALSE")
  }

  if (!is.logical(remove_duplicates)) {
    rlang::abort("The `remove_duplicates` argument is a logical variable and can only be set to `TRUE` or `FALSE`")
  }

  if (!any(.level %in% c("ip", "country", "state", "lga", "facility"))) {
    rlang::abort(".level must be one of 'ip', 'country', 'state', 'lga', or 'facility'")
  }

  if (!is.null(.names) && length(.names) != 5) {
    rlang::abort(
      'the number of `.names` supplied should be equal to the number of the five viral load cascade indicators'
    )
  }

  if (!is.null(.names) && !is.character(.names)) {
    rlang::abort(
      "names must be supplied as characters. Did you forget to put the names in quotes?"
    )
  }

}


get_vl_cascade <- function(data, ref, states, facilities, status, n, use_six_months, remove_duplicates, .level, .names) {

  vl_eligible <- tx_vl_eligible(
    data,
    ref = ref,
    states = states,
    facilities = facilities,
    status = status,
    use_six_months = use_six_months,
    remove_duplicates = remove_duplicates
  )

  vl_result <- tx_pvls_den(
    data,
    ref = ref,
    states = states,
    facilities = facilities,
    status = status,
    use_six_months = use_six_months,
    remove_duplicates = remove_duplicates
  )

  vl_suppressed <- tx_pvls_num(
    data,
    ref = ref,
    states = states,
    facilities = facilities,
    status = status,
    n = n,
    use_six_months = use_six_months,
    remove_duplicates = remove_duplicates
  )


  summarise_ndr(
    vl_eligible,
    vl_result,
    vl_suppressed,
    level = .level,
    names = .names
  ) %>%
    dplyr::mutate(
      vl_coverage = janitor::round_half_up(
        vl_result / vl_eligible * 100, digits = 3
      ),
      vl_suppression_rate = janitor::round_half_up(
        vl_suppressed / vl_result * 100, digits = 3
      )
    )


}

# utils::globalVariables(c(
#   "art_start_date",
#   "current_age",
#   "current_status",
#   "date_of_current_viral_load",
#   "current_viral_load"
# ))
