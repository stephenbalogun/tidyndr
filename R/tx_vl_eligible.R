#' Subset Clients who are Eligible for Viral Load
#'
#' Generates the line-list of clients who have been (or would have been) on ARv
#' medications for at least 6 months from the reference date. The default
#' reference date is the date of analysis.
#'
#' @inheritParams tx_pvls_den
#'
#' @return
#' @export
#'
#' @examples
#' tx_vl_eligible(ndr_example)
#'
#' # Determine clients who are going to be eligible for VL by the end of Q2 of FY21
#'   tx_vl_eligible(ndr_example,
#'   reference = "2021-03-31")
tx_vl_eligible <- function(data,
                           reference = ref_date,
                           state = region,
                           facility = site) {

  ref_date <- Sys.Date()
  region <- unique(data$state)
  site <- unique(data$facility)

  stopifnot(
    "please check that region is contained in the dataset list of states" =
      any(region %in% unique(data$state))
  )

  stopifnot(
    "please check that site is contained in the dataset list of facilities" =
      any(site %in% unique(data$facility))
  )

  stopifnot(
    'please check that your reference date format is "yyyy-mm-dd"' =
      !is.na(lubridate::as_date(reference))
  )

  dplyr::filter(
    data,
    current_status_28_days == "Active",
    lubridate::as_date(reference) - art_start_date >=
      lubridate::period(6, "months"),
    state %in% region,
    facility %in% site
  )
}



utils::globalVariables("art_start_date")
