#' Generate List of RTRI-Positive Clients with Documented Viral Load Results
#'
#' @inheritParams tx_new
#'
#' @return Line-list of clients with recent infection and a viral load result
#' @export rita_result
#'
#' @examples
#' ## Get HTS_POS clients who had a documented viral load result for recency in 2021
#' rita_result(recency_example, from = "2021-01-01")
rita_result <- function(data,
                        from = NULL,
                        to = NULL,
                        states = NULL,
                        facilities = NULL
) {



  states <- states %||% unique(data$facility_state)

  facilities <- facilities %||% unique(subset(data, facility_state %in% states)$facility)

  validate_recent(data, from, to , states, facilities)

  get_rita(data, from, to, states, facilities)


}


get_rita <-  function(data, from, to, states, facilities) {

  dt <- dplyr::filter(
    data,
    recency_interpretation == "Recent",
    !is.na(viral_load_result),
    facility_state %in% states,
    facility %in% facilities
  )



  if (!is.null(from)) {
    dt <- dplyr::filter(
      dt,
      date_of_viral_load_result >= lubridate::ymd(from)
    )
  }

  if(!is.null(to)) {
    dt <- dplyr::filter(
      dt, date_of_viral_load_result <= lubridate::ymd(to)
    )
  }

  return(dt)

}



utils::globalVariables(
  c("recency_interpretation", "date_of_viral_load_result", "viral_load_result", "facility_state")
)

