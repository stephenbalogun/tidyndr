#' Subset active clients based on months of ARV Dispensed
#'
#' Generates list of clients who had 3 - 6 months of ARV dispensed during the
#' medication refill. You can specify the number of month(s) of ARV dispensed
#' by changing the \code{month} argument.
#'
#'
#' @param data An ndr dataframe imported using the `read_ndr()`.
#' @param month The number(s) of month of interest of ARV dispensed
#'    (rounded to the nearest who number). The default is to subset active
#'    clients who had 3 - 6 months of ARV dispensed.
#' @inheritParams tx_appointment
#'
#' @return
#' @export
#'
#' @examples
#' tx_mmd(ndr_example)
#'
#' # subset active clients who had 2 or 4 months of ARV dispensed at last encounter
#' tx_mmd(ndr_example,
#'   month = c(2, 4)
#' )
tx_mmd <- function(data,
                   month = months_dispensed,
                   state = region,
                   facility = site) {
  months_dispensed <- c(3, 4, 5, 6)
  region <- unique(data$state)
  site <- unique(data$facility)

  stopifnot(
    "number of months dispensed must be numeric" = is.numeric(month)
  )


  stopifnot(
    "please check that region is contained in the dataset list of states" =
      any(region %in% unique(data$state))
  )

  stopifnot(
    "please check that site is contained in the dataset list of facilities" =
      any(site %in% unique(data$facility))
  )

  dat <- dplyr::mutate(data,
    months_dispensed = round(days_of_arv_refill / 30, 0)
  )

  dplyr::filter(
    dat,
    current_status_28_days == "Active",
    months_dispensed %in% month,
    state %in% region,
    facility %in% site
  )
}


utils::globalVariables("months_dispensed")
