#' Subset Clients Based on their Current ART Regimen
#'
#' Generates the line-list of clients on first-line regimen who are on the choice
#' combination regimen for their age or weight. The NDR does not currently report
#' 'weight' so the function uses 'age' to approximate the choice-regimen for the
#' clients.
#'
#' @param data An NDR dataframe imported using the `read_ndr()
#' @param age_band a numeric vector of length 2 `c(min_age, max_age)`.
#' @inheritParams tx_new
#' @inheritParams tx_curr
#'
#' @return tx_regimen
#' @export
#'
#' @examples
#' tx_regimen(ndr_example)
#'
#' tx_regimen(ndr_example,
#'   status = "default",
#'   age_band = c(0, 3)
#' )
tx_regimen <- function(data,
                       age_band = NULL,
                       states = NULL,
                       facilities = NULL,
                       status = "calculated") {

  states <- states %||% unique(data$state)

  facilities <- facilities %||% unique(subset(data, state %in% states)$facility)

  validate_regimen(data, age_band, states, facilities, status)

  get_tx_regimen(data, age_band, states, facilities, status)


}


validate_regimen <- function(data, age_band, states, facilities, status) {
  if (!rlang::is_double(age_band) && !rlang::is_null(age_band)) {
    rlang::abort("age_band is not of the class numeric. Did you quote any of the values?")
  }

  if (length(age_band) != 2 && !rlang::is_null(age_band)) {
    rlang::abort("The age_band argument requires that you supply min and max values.")
  }

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


get_tx_regimen <- function(data, age_band, states, facilities, status) {

  age_range <- c(0, 150)

  switch(status,
         "calculated" = dplyr::filter(
           data,
           current_status == "Active",
           !patient_has_died %in% TRUE,
           !patient_transferred_out %in% TRUE,
           dplyr::if_else(
             current_age <= 3,
             last_regimen %in% c(
               "ABC-3TC-LPV/r",
               "AZT-3TC-LPV/r"
             ),
             last_regimen %in% c(
               "ABC-3TC-DTG",
               "TDF-3TC-DTG"
             )
           ),
           dplyr::between(
             current_age,
             age_band[[1]] %||% age_range[[1]],
             age_band[[2]] %||% age_range[[2]]
           ),
           state %in% states,
           facility %in% facilities
         ),
         "default" = dplyr::filter(
           data,
           current_status_28_days == "Active",
           !patient_has_died %in% TRUE,
           !patient_transferred_out %in% TRUE,
           dplyr::if_else(
             current_age <= 3,
             last_regimen %in% c(
               "ABC-3TC-LPV/r",
               "AZT-3TC-LPV/r"
             ),
             last_regimen %in% c(
               "ABC-3TC-DTG",
               "TDF-3TC-DTG"
             )
           ),
           dplyr::between(
             current_age,
             age_band[[1]] %||% age_range[[1]],
             age_band[[2]] %||% age_range[[2]]
           ),
           state %in% states,
           facility %in% facilities
         )
  )
}

utils::globalVariables(c(
  "last_regimen",
  "current_status",
  "patient_has_died",
  "patient_transferred_out",
  "current_age"
))
