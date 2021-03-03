#' Subset clients who became inactive (IIT) within a given period
#'
#' \code{tx_ml} Generates clients who have become inactive over a specified
#' period of time. The default is to generate all clients who became inactive
#' in the current Fiscal Year. You can specify the period of interest
#' (using the \code{from} and \code{to} arguments). Used together
#' with \code{tx_ml_outcomes()}, generates inactive clients with a particular
#' outcome of interest.
#'
#' @inheritParams tx_appointment
#'
#' @return tx_ml
#' @export
#'
#' @examples
#' tx_ml(ndr_example)
#'
#' # Find clients who were inactive at the end of Q1 of FY21
#' tx_ml(ndr_example, to = "2020-12-31")
tx_ml <- function(data,
                  from = get("fy_start")(),
                  to = get("Sys.Date")(),
                  states = .s,
                  facilities = .f) {
  .s <- unique(data$state)

  .f <- unique(data$facility)


  if (!any(states %in% unique(data$state))) {
    rlang::abort("state(s) is/are not contained in the supplied data. Check the spelling and/or case.")
  }

  if (!any(facilities %in% unique(subset(data, state %in% states)$facility))) {
    rlang::abort("facilit(ies) is/are not found in the data or state supplied.
                 Check that the facility is correctly spelt and located in the state.")
  }

  if (is.na(lubridate::as_date(from)) || is.na(lubridate::as_date(to))) {
    rlang::abort("The supplied date is not in 'yyyy-mm-dd' format.")
  }

  dplyr::filter(
    data,
    dplyr::between(
      date_lost,
      lubridate::as_date(from),
      lubridate::as_date(to)
    ),
    state %in% states,
    facility %in% facilities
  )
}



utils::globalVariables("date_lost")
