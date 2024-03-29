#' Analyse the Treatment Continuity Cascade
#'
#' Generate aggregate summary of treatment continuity indicators based on a specified quarter. The indicators include
#' `tx_curr` (previous quarter), `tx_new`, `tx_ml`, `tx_ml_dead`, `tx_ml_to`, `tx_ml_iit`, and `iit_rate`.
#'
#' @inheritParams tx_curr
#' @param quarter the quarter of the fiscal year (based on the PEPFAR calendar) for which the treatment continuity indicators should be calculated.
#' @param ref the referenced date for the analysis. If this is not set (i.e. `NULL`) it will be assumed to be the last day of the quarter.
#' @param .level the level at which the aggregate summary should be performed. The options are "ip", "country", "state", "lga" and "facility".
#' @param .names if specified, these will be used for naming of the viral load indicators instead of the default.
#' @param .disagg if specified, the cot_cascade will be disaggregated using "age", "sex", "age_sex", "pregnancy_status", "art_duration" or "months_dispensed".
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
                        .names = NULL,
                        .disagg = NULL) {
  quarter <- quarter %||% dplyr::if_else(lubridate::quarter(get("Sys.Date")()) <= 3,
    lubridate::quarter(get("Sys.Date")()) + 1,
    1
  )

  states <- states %||% unique(data$state)

  facilities <- facilities %||% unique(subset(data, state %in% states)$facility)

  validate_cot_cascade(data, quarter, ref, states, facilities, status, remove_duplicates, .level, .names, .disagg)

  get_cot_cascade(data, quarter, ref, states, facilities, status, remove_duplicates, .level, .names, .disagg)
}


validate_cot_cascade <- function(data,
                                 quarter,
                                 ref,
                                 states,
                                 facilities,
                                 status,
                                 remove_duplicates,
                                 .level,
                                 .names,
                                 .disagg) {
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
    rlang::abort("Kindly supply a whole number between 1 and 4 corresponding to the quarter of the PEPFAR fiscal year")
  }

  if (quarter == 1 && !is.null(ref) && !dplyr::between(lubridate::month(lubridate::ymd(ref)), 10, 12)) {
    rlang::abort("The date referenced appears not to be in Quarter 1 of the PEPFAR FY")
  }


  if (quarter == 2 && !is.null(ref) && !dplyr::between(lubridate::month(lubridate::ymd(ref)), 1, 3)) {
    rlang::abort("The date referenced appears not to be in Quarter 2 of the PEPFAR FY")
  }

  if (quarter == 3 && !is.null(ref) && !dplyr::between(lubridate::month(lubridate::ymd(ref)), 4, 6)) {
    rlang::abort("The date referenced appears not to be in Quarter 3 of the PEPFAR FY")
  }


  if (quarter == 4 && !is.null(ref) && !dplyr::between(lubridate::month(lubridate::ymd(ref)), 7, 9)) {
    rlang::abort("The date referenced appears not to be in Quarter 4 of the PEPFAR FY")
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
      "the number of `.names` supplied should be equal to the number of the six treatment continuity indicators"
    )
  }

  if (!is.null(.names) && !is.character(.names)) {
    rlang::abort(
      "names must be supplied as characters. Did you forget to put the names in quotes?"
    )
  }

  if (!any(.disagg %in% c("current_age", "sex", "art_duration", "months_dispensed", "pregnancy_status", "age_sex")) &&
    !is.null(.disagg)) {
    rlang::abort(".disagg must be one of 'current_age', 'sex', 'art_duration', 'months_dispensed', 'pregnancy_status' or 'age_sex'")
  }
}


get_cot_cascade <- function(data, quarter, ref, states, facilities, status, remove_duplicates, .level, .names, .disagg) {
  switch(quarter,
    `1` = {
      stop <- ref %||% if (lubridate::month(Sys.Date()) >= 10) {
        (lubridate::`%m+%`(lubridate::make_date(lubridate::year(Sys.Date()), 10, 01), lubridate::period(3, "months")) - 1)
      } else {
        (lubridate::`%m+%`(lubridate::make_date(lubridate::year(Sys.Date()) - 1, 10, 01), lubridate::period(3, "months")) - 1)
      }


      start <- if (lubridate::year(stop) < lubridate::year(Sys.Date())) {
        paste(
          lubridate::year(stop),
          "10",
          "01",
          sep = "-"
        )
      } else {
        paste(
          lubridate::year(Sys.Date()) - 1,
          "10",
          "01",
          sep = "-"
        )
      }


      if (remove_duplicates) {
        tx_curr_prev <- dplyr::distinct(
          dplyr::filter(data, current_status_q4_28_days == "Active", state %in% states, facility %in% facilities),
          facility, patient_identifier,
          .keep_all = TRUE
        )
      } else {
        tx_curr_prev <- dplyr::filter(data, current_status_q4_28_days == "Active", state %in% states, facility %in% facilities)
      }

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
    },
    `2` = {
      stop <- ref %||% (lubridate::`%m+%`(lubridate::ymd(start), lubridate::period(3, "months")) - 1)

      stop <- ref %||% (lubridate::`%m+%`(lubridate::make_date(lubridate::year(Sys.Date()), 01, 01), lubridate::period(3, "months")) - 1)



      start <- if (lubridate::year(stop) < lubridate::year(Sys.Date())) {
        paste(
          lubridate::year(stop),
          "01",
          "01",
          sep = "-"
        )
      } else {
        paste(
          lubridate::year(Sys.Date()),
          "01",
          "01",
          sep = "-"
        )
      }


      if (remove_duplicates) {
        tx_curr_prev <- dplyr::distinct(
          dplyr::filter(data, current_status_q1_28_days == "Active", state %in% states, facility %in% facilities),
          facility, patient_identifier,
          .keep_all = TRUE
        )
      } else {
        tx_curr_prev <- dplyr::filter(data, current_status_q1_28_days == "Active", state %in% states, facility %in% facilities)
      }


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
    },
    `3` = {
      stop <- ref %||% (lubridate::`%m+%`(lubridate::make_date(lubridate::year(Sys.Date()), 04, 01), lubridate::period(3, "months")) - 1)


      start <- if (lubridate::year(stop) < lubridate::year(Sys.Date())) {
        paste(
          lubridate::year(stop),
          "04",
          "01",
          sep = "-"
        )
      } else {
        paste(
          lubridate::year(Sys.Date()),
          "04",
          "01",
          sep = "-"
        )
      }

      if (remove_duplicates) {
        tx_curr_prev <- dplyr::distinct(
          dplyr::filter(data, current_status_q2_28_days == "Active", state %in% states, facility %in% facilities),
          facility, patient_identifier,
          .keep_all = TRUE
        )
      } else {
        tx_curr_prev <- dplyr::filter(data, current_status_q2_28_days == "Active", state %in% states, facility %in% facilities)
      }

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
    },
    `4` = {
      stop <- ref %||% if (lubridate::month(Sys.Date()) >= 7) {
        (lubridate::`%m+%`(lubridate::make_date(lubridate::year(Sys.Date()), 07, 01), lubridate::period(3, "months")) - 1)
      } else {
        (lubridate::`%m+%`(lubridate::make_date(lubridate::year(Sys.Date()) - 1, 07, 01), lubridate::period(3, "months")) - 1)
      }

      start <- if (lubridate::year(stop) < lubridate::year(Sys.Date())) {
        paste(
          lubridate::year(stop),
          "07",
          "01",
          sep = "-"
        )
      } else {
        paste(
          lubridate::year(Sys.Date()),
          "07",
          "01",
          sep = "-"
        )
      }


      if (remove_duplicates) {
        tx_curr_prev <- dplyr::distinct(
          dplyr::filter(data, current_status_q3_28_days == "Active", state %in% states, facility %in% facilities),
          facility, patient_identifier,
          .keep_all = TRUE
        )
      } else {
        tx_curr_prev <- dplyr::filter(data, current_status_q3_28_days == "Active", state %in% states, facility %in% facilities)
      }

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
    }
  )


  if (is.null(.disagg)) {
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
      ) %>%
      dplyr::arrange(state)
  } else {
    tx_curr_prev %>%
      disaggregate(by = .disagg, level = .level, pivot_wide = FALSE) %>%
      dplyr::rename(tx_curr_prev = number) %>%
      dplyr::full_join(
        tx_new %>%
          disaggregate(by = .disagg, level = .level, pivot_wide = FALSE) %>%
          dplyr::rename(tx_new = number)
      ) %>%
      dplyr::full_join(
        tx_ml %>%
          disaggregate(by = .disagg, level = .level, pivot_wide = FALSE) %>%
          dplyr::rename(tx_ml = number)
      ) %>%
      dplyr::full_join(
        tx_ml_dead %>%
          disaggregate(by = .disagg, level = .level, pivot_wide = FALSE) %>%
          dplyr::rename(tx_ml_dead = number)
      ) %>%
      dplyr::full_join(
        tx_ml_to %>%
          disaggregate(by = .disagg, level = .level, pivot_wide = FALSE) %>%
          dplyr::rename(tx_ml_to = number)
      ) %>%
      dplyr::mutate(
        tx_ml_iit = tx_ml - tx_ml_dead - tx_ml_to,
        iit_rate = janitor::round_half_up(tx_ml_iit / (tx_curr_prev + tx_new) * 100, digits = 3)
      ) %>%
      dplyr::arrange(state)
  }
}



utils::globalVariables(c(
  "current_status_q4_28_days",
  "current_status_q1_28_days",
  "current_status_q2_28_days",
  "current_status_q3_28_days",
  "tx_ml_iit",
  "number"
))
