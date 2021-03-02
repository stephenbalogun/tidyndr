#' Beginning of the Fiscal Year
#'
#' Sets the date of some functions to begin at 1st of October.
#'
#' @export
<<<<<<< HEAD
#' @keywords internal
=======
#'
>>>>>>> 82bc88cea456aae49cd70b9b04969fc72b487d3c
fy_start <- function() {
  lubridate::as_date(
    ifelse(lubridate::month(Sys.Date()) < 10,
           stats::update(Sys.Date(),
                         years = lubridate::year(Sys.Date()) - 1,
                         months = 10,
                         days = 1),
           stats::update(Sys.Date(),
                         months = 10,
                         days = 1)
           )
    )
}
