#' Analyse the Treatment Continuity Cascade
#'
#' Generate aggregate summary of treatment continuity indicators based on a specified quarter. The indicators include
#' `tx_curr` (previous quarter), `tx_new`, `tx_ml`, `tx_ml_dead`, `tx_ml_to`, `tx_ml_iit`, and `iit_rate`.
#'
#' @inheritParams tx_curr
#' @param quarter the quarter of the fiscal year for which the treatment continuity indicators should be calculated.
#' @param ref the referenced date for the analysis. If this is not set (i.e. `NULL`) it will be assumed to be the last day of the quarter.
#' @param .level the level at which the aggregate summary should be performed. The options are "ip", "country", "state", "lga" and "facility".
#' @param .names if specified, these will be used for naming of the viral load indicators instead of the default.
#'
#' @return summary of treatment continuity indicators
#' @export
#'
#' @examples
#' cot_cascade(ndr_example, quarter = 2, ref = "2022-02-28", .level = "state")
#'
#' # Determine the treatment continuity cascade for a state at the end of quarter one of FY22
#' cot_cascade(ndr_example,
#'   quarter = 1,
#'   states = "Arewa"
#' )
#'
cot_cascade <- function(data,
                       quarter = NULL,
                       ref = NULL,
                       states = NULL,
                       facilities = NULL,
                       status = "default",
                       remove_duplicates = FALSE,
                       .level = "state",
                       .names = NULL) {

  quarter <- quarter %||% dplyr::if_else(lubridate::quarter(get("Sys.Date")()) <= 3,
                            lubridate::quarter(get("Sys.Date")()) + 1,
                            1)

  states <- states %||% unique(data$state)

  facilities <- facilities %||% unique(subset(data, state %in% states)$facility)

  validate_cot_cascade(data, quarter, ref, states, facilities, status, remove_duplicates, .level, .names)

  get_cot_cascade(data, quarter, ref, states, facilities, status, remove_duplicates, .level, .names)
}


validate_cot_cascade <- function(data,
                                quarter,
                                ref,
                                states,
                                facilities,
                                status,
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

  if (!is.null(quarter) && !is.numeric(quarter)) {
    rlang::abort("The supplied quarter is not an integer. Kindly a supply whole number")
  }

  if (!is.null(quarter) && quarter > 4) {
    rlang::abort("Kindly supply a whole number between 1 and 4 corresponding to the quarter of the fiscal year")
  }

  if (!is.null(ref) && is.na(ref)) {
    rlang::abort("The supplied date is not in 'yyyy-mm-dd' format.")
  }

  if (!status %in% c("default", "calculated")) {
    rlang::abort("`status` can only be one of 'default' or 'calculated'. Check that you did not mispell, include CAPS or forget to quotation marks!")
  }

  if (!is.logical(remove_duplicates)) {
    rlang::abort("The `remove_duplicates` argument is a logical variable and can only be set to `TRUE` or `FALSE`")
  }

  if (!any(.level %in% c("ip", "country", "state", "lga", "facility"))) {
    rlang::abort(".level must be one of 'ip', 'country', 'state', 'lga', or 'facility'")
  }

  if (!is.null(.names) && length(.names) != 7) {
    rlang::abort(
      'the number of `.names` supplied should be equal to the number of the six treatment continuity indicators'
    )
  }

  if (!is.null(.names) && !is.character(.names)) {
    rlang::abort(
      "names must be supplied as characters. Did you forget to put the names in quotes?"
    )
  }

}


get_cot_cascade <- function(data, quarter, ref, states, facilities, status, remove_duplicates, .level, .names) {


  switch(quarter,

         `1` = {

           start <- paste(
             dplyr::if_else(lubridate::month(Sys.Date()) < 10, lubridate::year(Sys.Date()) - 1, lubridate::year(Sys.Date())),
             "10",
             "01",
             sep = "-"
           )

           stop <- ref %||% (lubridate::`%m+%`(lubridate::ymd(start),  lubridate::period(3, "months")) - 1)

           tx_curr_prev <- dplyr::filter(data, current_status_q4_28_days == "Active", state %in% states, facility %in% facilities)

           tx_new <- tx_new(
             data,
             from = start,
             to = stop,
             states = states,
             facilities = facilities,
             remove_duplicates = remove_duplicates
             )

           tx_ml <- tx_ml(
             data,
             from = start,
             to = stop,
             states = states,
             facilities = facilities,
             status = status,
             remove_duplicates = remove_duplicates
           )

           tx_ml_dead <- tx_ml_outcomes(tx_ml, outcome = "dead")

           tx_ml_to <- tx_ml_outcomes(tx_ml, outcome = "transferred out")

           summarise_ndr(
             tx_curr_prev,
             tx_new,
             tx_ml,
             tx_ml_dead,
             tx_ml_to,
             level = .level,
             names = .names
           ) %>%
             dplyr::mutate(
               tx_ml_iit = tx_ml - tx_ml_dead - tx_ml_to,

               iit_rate = janitor::round_half_up(tx_ml_iit / (tx_curr_prev + tx_new) * 100, digits = 3)
             )

         },

         `2` = {
           start <- paste(
             lubridate::year(Sys.Date()),
             "01",
             "01",
             sep = "-"
           )

           stop <- ref %||% (lubridate::`%m+%`(lubridate::ymd(start), lubridate::period(3, "months")) - 1)

           tx_curr_prev <- dplyr::filter(data, current_status_q1_28_days == "Active")

           tx_new <- tx_new(
             data,
             from = start,
             to = stop,
             states = states,
             facilities = facilities,
             remove_duplicates = remove_duplicates
           )

           tx_ml <- tx_ml(
             data,
             from = start,
             to = stop,
             states = states,
             facilities = facilities,
             status = status,
             remove_duplicates = remove_duplicates
           )

           tx_ml_dead <- tx_ml_outcomes(tx_ml, outcome = "dead")

           tx_ml_to <- tx_ml_outcomes(tx_ml, outcome = "transferred out")

           summarise_ndr(
             tx_curr_prev,
             tx_new,
             tx_ml,
             tx_ml_dead,
             tx_ml_to,
             level = .level,
             names = .names
           ) %>%
             dplyr::mutate(
               tx_ml_iit = tx_ml - tx_ml_dead - tx_ml_to,

               iit_rate = janitor::round_half_up(tx_ml_iit / (tx_curr_prev + tx_new) * 100, digits = 3)
             )

         },

         `3` = {
           start <- paste(
             lubridate::year(Sys.Date()),
             "04",
             "01",
             sep = "-"
           )

           stop <- ref %||% (lubridate::`%m+%`(lubridate::ymd(start), lubridate::period(3, "months")) - 1)

           tx_curr_prev <- dplyr::filter(data, current_status_q2_28_days == "Active")

           tx_new <- tx_new(
             data,
             from = start,
             to = stop,
             states = states,
             facilities = facilities,
             remove_duplicates = remove_duplicates
           )

           tx_ml <- tx_ml(
             data,
             from = start,
             to = stop,
             states = states,
             facilities = facilities,
             status = status,
             remove_duplicates = remove_duplicates
           )

           tx_ml_dead <- tx_ml_outcomes(tx_ml, outcome = "dead")

           tx_ml_to <- tx_ml_outcomes(tx_ml, outcome = "transferred out")

           summarise_ndr(
             tx_curr_prev,
             tx_new,
             tx_ml,
             tx_ml_dead,
             tx_ml_to,
             level = .level,
             names = .names
           ) %>%
             dplyr::mutate(
               tx_ml_iit = tx_ml - tx_ml_dead - tx_ml_to,

               iit_rate = janitor::round_half_up(tx_ml_iit / (tx_curr_prev + tx_new) * 100, digits = 3)
             )

         },

         `4` = {
           start <- paste(
             lubridate::year(Sys.Date()),
             "07",
             "01",
             sep = "-"
           )

           stop <- ref %||% (lubridate::`%m+%`(lubridate::ymd(start), lubridate::period(3, "months")) - 1)

           tx_curr_prev <- dplyr::filter(data, current_status_q3_28_days == "Active")

           tx_new <- tx_new(
             data,
             from = start,
             to = stop,
             states = states,
             facilities = facilities,
             remove_duplicates = remove_duplicates
           )

           tx_ml <- tx_ml(
             data,
             from = start,
             to = stop,
             states = states,
             facilities = facilities,
             status = status,
             remove_duplicates = remove_duplicates
           )

           tx_ml_dead <- tx_ml_outcomes(tx_ml, outcome = "dead")

           tx_ml_to <- tx_ml_outcomes(tx_ml, outcome = "transferred out")

           summarise_ndr(
             tx_curr_prev,
             tx_new,
             tx_ml,
             tx_ml_dead,
             tx_ml_to,
             level = .level,
             names = .names
           ) %>%
             dplyr::mutate(
               tx_ml_iit = tx_ml - tx_ml_dead - tx_ml_to,

               iit_rate = janitor::round_half_up(tx_ml_iit / (tx_curr_prev + tx_new) * 100, digits = 3)
             )

         }
  )


}



utils::globalVariables(c(
  "current_status_q4_28_days",
  "current_status_q1_28_days",
  "current_status_q2_28_days",
  "current_status_q3_28_days",
  "tx_ml_iit"
))
