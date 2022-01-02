#' Subset Newly Identified HIV Positive Clients over a Particular Period
#'
#' @inheritParams tx_new
#'
#' @return line-list of hts_tst_pos clients
#' @export hts_tst_pos
#'
#' @examples
#' ### Line-list of clients hts positives from 'Okun' and 'Abaji' states in first half of 2021
#' hts_pos <- hts_tst_pos(
#' recency_example,
#' state = c("Okun", "Abaji"),
#' from = "2021-01-01",
#' to = "2021-06-30"
#' )

hts_tst_pos <- function(data,
                        from = NULL,
                        to = NULL,
                        states = NULL,
                        facilities = NULL
) {


  from <- lubridate::ymd(from %||% get("fy_start")())

  to <- lubridate::ymd(to %||% get("Sys.Date")())

  states <- states %||% unique(data$facility_state)

  facilities <- facilities %||% unique(subset(data, facility_state %in% states)$facility)

  validate_pos(data, from, to , states, facilities)

  get_hts_pos(data, from, to, states, facilities)


}


get_hts_pos <-  function(data, from, to, states, facilities) {

  dplyr::filter(
    data,
    dplyr::between(
      visit_date,
      from,
      to
    ),
    hts_result %in% c("R", "Pos", "Positive", "Reactive", "POSITIVE", "REACTIVE", "pos"),
    hts_confirmatory_result %in% c("R", "Pos", "Positive", "Reactive", "POSITIVE", "REACTIVE", "pos") |
      hts_tie_breaker_result %in% c("R", "Pos", "Positive", "Reactive", "POSITIVE", "REACTIVE", "pos"),
    facility_state %in% states,
    facility %in% facilities
  )
}


validate_pos <- function(data, from, to, states, facilities) {

  if (!all(states %in% unique(data$facility_state))) {
    rlang::abort("state(s) is/are not contained in the supplied data. Check the spelling and/or case.")
  }

  if (!all(facilities %in% unique(subset(data, facility_state %in% states)$facility))) {
    rlang::abort("facilit(ies) is/are not found in the data or state supplied.
                 Check that the facility is correctly spelt and located in the state.")
  }

  if (is.na(from) || is.na(to)) {
    rlang::abort("The supplied date is not in the right format. Did you remember to
                 enter the date in 'yyyy-mm-dd' or forget the quotation marks?")
  }

  if (from > Sys.Date() || to > Sys.Date()) {
    rlang::warn("The date arguments should not be in the future!!")
  }

  if (from > to) {
    rlang::abort("The 'to' date cannot be before the 'from' date!!")
  }

}




utils::globalVariables(
  c("hts_result", "hts_confirmatory_result", "hts_tie_breaker_result", "visit_date", "facility_state")
)

