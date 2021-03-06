#' Beginning of the Fiscal Year
#'
#' Sets the date of some functions to begin at 1st of October.
#'
#' @export
#' @keywords internal
#'
fy_start <- function() {
  lubridate::as_date(
    ifelse(lubridate::month(Sys.Date()) < 10,
      stats::update(Sys.Date(),
        years = lubridate::year(Sys.Date()) - 1,
        months = 10,
        days = 1
      ),
      stats::update(Sys.Date(),
        months = 10,
        days = 1
      )
    )
  )
}
