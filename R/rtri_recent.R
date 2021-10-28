#' Get List of RTRI Recent Clients
#'
#' @inheritParams tx_new
#'
#' @return Line-list of clients with who are RTRI Positive
#' @export hts_rtri_pos
#'
#' @examples
rtri_recent <- function(data,
                     from = NULL,
                     to = NULL,
                     states = NULL,
                     facilities = NULL
) {

  states <- states %||% unique(data$facility_state)

  facilities <- facilities %||% unique(subset(data, facility_state %in% states)$facility)

  validate_recent(data, from, to , states, facilities)

  get_rtri_recent(data, from, to, states, facilities)


}


get_rtri_recent <-  function(data, from, to, states, facilities) {

  dt <- dplyr::filter(
    data,
    recency_interpretation == "Recent",
    facility_state %in% states,
    facility %in% facilities
  )

  if (!is.null(from)) {
    dt <- dplyr::filter(
      dt,
      recency_test_date >= lubridate::ymd(from)
    )
  }

  if(!is.null(to)) {
    dt <- dplyr::filter(
      dt, recency_test_date <= lubridate::ymd(to)
    )
  }

  return(dt)
}



utils::globalVariables(
  c("recency_test_date", "recency_interpretation")
)

