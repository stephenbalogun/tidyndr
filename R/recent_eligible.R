#' Subset Clients who had Recent Infection Test Done during a period of Interest
#'
#' @inheritParams tx_new
#'
#' @return line-list of clients who had recent HIV infection test done during the period of interest
#' @export recent_eligible
#'
#' @examples
#' ## Line-list all HIV positive clients who are eligible for recency testing in FY21 Q2
#' hts_pos <- hts_tst_pos(recency_example, from = "2021-01-01", to = "2021-03-01")
#'
#' recent_eligible(hts_pos, state = "Arewa") # eligible clients in 'Arewa' state
#'
recent_eligible <- function(data,
                            from = NULL,
                            to = NULL,
                            states = NULL,
                            facilities = NULL) {
  states <- states %||% unique(data$facility_state)

  facilities <- facilities %||% unique(subset(data, facility_state %in% states)$facility)

  validate_recent(data, from, to, states, facilities)

  get_recent_eligible(data, from, to, states, facilities)
}


get_recent_eligible <- function(data, from, to, states, facilities) {
  dt <- dplyr::filter(
    data,
    hts_result %in% c("R", "Pos", "Positive", "Reactive", "POSITIVE", "REACTIVE", "pos"),
    hts_confirmatory_result %in% c("R", "Pos", "Positive", "Reactive", "POSITIVE", "REACTIVE", "pos") |
      hts_tie_breaker_result %in% c("R", "Pos", "Positive", "Reactive", "POSITIVE", "REACTIVE", "pos"),
    !opt_out %in% c("Yes", "yes", "YES", TRUE, "true"),
    age >= 15,
    facility_state %in% states,
    facility %in% facilities
  )

  if (!is.null(from)) {
    dt <- dplyr::filter(
      dt,
      recency_test_date >= lubridate::ymd(from)
    )
  }

  if (!is.null(to)) {
    dt <- dplyr::filter(
      dt, recency_test_date <= lubridate::ymd(to)
    )
  }

  return(dt)
}




validate_recent <- function(data, from, to, states, facilities) {
  if (!all(states %in% unique(data$facility_state))) {
    rlang::abort("state(s) is/are not contained in the supplied data. Check the spelling and/or case.")
  }

  if (!all(facilities %in% unique(subset(data, facility_state %in% states)$facility))) {
    rlang::abort("facilit(ies) is/are not found in the data or state supplied.
                 Check that the facility is correctly spelt and located in the state.")
  }

  if (!is.null(from) && stringr::str_detect(from, "202[0-9]-[0-9][0-9]-[0-9][0-9]") == FALSE) {
    rlang::abort("The supplied date to the `from` argument is not in the right format. Did you remember to
                 enter the date in 'yyyy-mm-dd' or forget the quotation marks?")
  }

  if (!is.null(to) && stringr::str_detect(from, "202[0-9]-[0-9][0-9]-[0-9][0-9]") == FALSE) {
    rlang::abort("The supplied date to the `to` argument is not in the right format. Did you remember to
                 enter the date in 'yyyy-mm-dd' or forget the quotation marks?")
  }


  if (!is.null(from) && as.Date(from) > Sys.Date()) {
    rlang::warn("The period referenced extends into the future!")
  }

  if (!is.null(from) && !is.null(to) && as.Date(from) > as.Date(to)) {
    rlang::abort("The 'to' date cannot be before the 'from' date!!")
  }
}





utils::globalVariables(
  c("recency_test_date", "recency_test_name", "facility_state", "opt_out", "age")
)
