#' Beginning of the Fiscal Year
#'
#' Sets the date of some functions to begin at 1st of October.
#'
#' @export
#' @keywords internal
#' @return No return value, called for side effects
fy_start <- function() {
  if (lubridate::month(Sys.Date()) < 10) {
    stats::update(Sys.Date(),
                  years = lubridate::year(Sys.Date()) - 1,
                  months = 10,
                  days = 1)
  } else {
    stats::update(Sys.Date(),
                  months = 10,
                  days = 1
    )
  }
}
