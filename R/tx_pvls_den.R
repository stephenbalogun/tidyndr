#' Subset Clients who have a Documented Viral Load Result
#'
#' Generate the line-list of clients whose date of last viral load result is not
#' more than one year (for adults 20 years and above) and 6 months (for
#' pediatrics and adolescents) from the specified reference date.
#'
#' @param data An NDR dataframe imported using the `read_ndr().
#' @param ref Date provided in ISO8601 format ("yyyy-mm-dd"). Used to
#'    determine clients who are eligible for viral load and should have a
#'    documented result. The default is the date of analysis.
#' @inheritParams tx_new
#' @inheritParams tx_curr
#'
#' @return tx_pvls_den
#' @export
#'
#' @examples
#' tx_pvls_den(ndr_example, status = "default")
#'
#' # Determine clients who are virally suppressed for two state at the end of Q4
#' tx_pvls_den(ndr_example,
#'   ref = "2021-09-30",
#'   states = c("Okun", "Arewa")
#' )
tx_pvls_den <- function(data,
                        ref = NULL,
                        states = NULL,
                        facilities = NULL,
                        status = "calculated") {

  ref <- lubridate::ymd(ref %||% get("Sys.Date")())

  states <- states %||% unique(data$state)

  facilities <- facilities %||% unique(subset(data, state %in% states)$facility)

  validate_pvls_den(data, ref, states, facilities, status)

  get_tx_pvls_den(data, ref, states, facilities, status)

}


validate_pvls_den <- function(data,
                              ref,
                              states,
                              facilities,
                              status) {

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

}


get_tx_pvls_den <- function(data, ref, states, facilities, status) {

  switch(status,
         "calculated" = dplyr::filter(
           data,
           current_status == "Active",
           !patient_has_died %in% TRUE,
           !patient_transferred_out %in% TRUE,
           lubridate::as_date(ref) - art_start_date >
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
           state %in% states,
           facility %in% facilities
         ),
         "default" = dplyr::filter(
           data,
           current_status_28_days == "Active",
           !patient_has_died %in% TRUE,
           !patient_transferred_out %in% TRUE,
           lubridate::as_date(ref) - art_start_date >
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
           state %in% states,
           facility %in% facilities
         )
  )
}


utils::globalVariables(c(
  "art_start_date",
  "current_age",
  "current_status",
  "date_of_current_viral_load"
))
