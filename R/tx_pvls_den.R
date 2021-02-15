#' Subset clients who have a documented viral load result
#'
#' Generate the line-list of clients whose date of last viral load result is not
#' more than one year (for adults 20 years and above) and 6 months (for
#' paediatrics and adolescents) from the specified reference date.
#'
#' @param data An ndr dataframe imported using the `read_ndr().
#' @param reference Date provided in ISO8601 format ("yyyy-mm-dd"). Used to
#'    determine clients who are eligible for viral load and should have a
#'    documented result. The default is the date of analysis.
#' @inheritParams tx_appointment
#'
#' @return tx_pvls_den
#' @export
#'
#' @examples
#' tx_pvls_den(ndr_example)
#'
#' # Determine clients who are virally suppressed for two state at the end of Q1
#' tx_pvls_den(ndr_example,
#'   reference = "2020-12-31",
#'   states = c("State 1", "State 2")
#' )
tx_pvls_den <- function(data,
                        reference = ref_date,
                        states = regions,
                        facilities = sites) {
  ref_date <- Sys.Date()
  regions <- unique(data$state)
  sites <- unique(data$facility)

  stopifnot(
    "please check that region is contained in the dataset list of states" =
      any(states %in% unique(data$state))
  )

  stopifnot(
    "please check that site is contained in the dataset list of facilities" =
      any(facilities %in% unique(data$facility))
  )

  stopifnot(
    'please check that your reference date format is "yyyy-mm-dd"' =
      !is.na(lubridate::as_date(reference))
  )

  dplyr::filter(
    data,
    current_status_28_days == "Active",
    lubridate::as_date(reference) - art_start_date >=
      lubridate::period(6, "months"),
    ifelse(current_age < 20,
      date_of_current_viral_load >
        lubridate::as_date(reference) -
          lubridate::period(month = 6),
      date_of_current_viral_load >
        lubridate::as_date(reference) -
          lubridate::period(year = 1)
    ),
    state %in% states,
    facility %in% facilities
  )
}


utils::globalVariables(c(
  "art_start_date",
  "current_age",
  "date_of_current_viral_load"
))
