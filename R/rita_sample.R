#' Generate List of RTRI-Positive Clients whose Viral Load Samples Have Been Collected
#'
#' @inheritParams tx_new
#'
#' @return Line-list of clients with recent infection and a viral load samples collected
#' @export rita_sample
#'
#' @examples
#' ## Get HTS_POS clients who had recency testing and viral load sample collected from 2021
#' sample_collected <- rita_sample(recency_example, from = "2021-01-01")
#'
#' ## Samples collected in 'Ayetoro', and 'Arewa' states in FY21 Q3
#'
#' rita_sample(recency_example, states = c("Arewa", "Ayetoro"), from = "2021-04-01", to = "2021-06-30")
#'
rita_sample <- function(data,
                        from = NULL,
                        to = NULL,
                        states = NULL,
                        facilities = NULL) {
  states <- states %||% unique(data$facility_state)

  facilities <- facilities %||% unique(subset(data, facility_state %in% states)$facility)

  validate_recent(data, from, to, states, facilities)

  get_sample(data, from, to, states, facilities)
}


get_sample <- function(data, from, to, states, facilities) {
  dt <- dplyr::filter(
    data,
    viral_load_requested %in% c("Yes", "yes", "true", TRUE),
    recency_interpretation == "Recent",
    facility_state %in% states,
    facility %in% facilities
  )



  if (!is.null(from)) {
    dt <- dplyr::filter(
      dt,
      date_sample_collected >= lubridate::ymd(from)
    )
  }

  if (!is.null(to)) {
    dt <- dplyr::filter(
      dt, date_sample_collected <= lubridate::ymd(to)
    )
  }

  return(dt)
}



utils::globalVariables(
  c("recency_interpretation", "date_sample_collected", "viral_load_requested", "facility_state")
)
