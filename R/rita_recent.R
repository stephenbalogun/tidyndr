#' Generate List of Clients who are RITA Recent
#'
#' @inheritParams tx_new
#'
#' @return Line-list of clients who are RTRI recent and have a viral load result greater or equal to 1000 copies per microliter of blood.
#' @export rita_recent
#'
#' @examples
#' ## Line-list all HIV positive clients confirmed to be RITA recent
#' hts_pos <- hts_tst_pos(recency_example)
#'
#' rita_recent(hts_pos)

rita_recent <- function(data,
                     from = NULL,
                     to = NULL,
                     states = NULL,
                     facilities = NULL
) {



  states <- states %||% unique(data$facility_state)

  facilities <- facilities %||% unique(subset(data, facility_state %in% states)$facility)

  validate_recent(data, from, to , states, facilities)

  get_rita_recent(data, from, to, states, facilities)


}


get_rita_recent <-  function(data, from, to, states, facilities) {

  dt <- dplyr::filter(
    data,
    recency_interpretation == "Recent",
    viral_load_result >= 1000,
    final_recency_result == "RitaRecent",
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
  c("recency_interpretation", "date_of_viral_load_result", "final_recency_result", "viral_load_result", "facility_state")
)


