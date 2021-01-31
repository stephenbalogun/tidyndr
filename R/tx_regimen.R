#' Subset Clients Based on their Current ART Regimen
#'
#' Generates the line-list of clients on first-line regimen who are on the choice
#' combination regimen for their age or weight.
#'
#' @param data An ndr dataframe imported using the `read_ndr()
#' @param age_band a numeric vector of length 2 (lower age-range and upper
#'    age-range).
#' @inheritParams tx_appointment
#'
#' @return
#' @export
#'
#' @examples
#' tx_regimen(ndr_example)
tx_regimen <- function(data,
                       age_band = age_range,
                       state = region,
                       facility = site) {
  age_range <- c(0, Inf)
  region <- unique(data$state)
  site <- unique(data$facility)

  stopifnot(
    'please enter the `age_band` argument as "c(min_age, max_age)"' =
      all(purrr::is_double(age_band, n = 2))
  )

  stopifnot(
    "please check that state is contained in the dataset list of states" =
      any(state %in% unique(data$state))
  )

  stopifnot(
    "please check that facility is contained in the dataset list of facilities" =
      any(facility %in% unique(data$facility))
  )


  dplyr::filter(
    data,
    current_status_28_days == "Active",
    dplyr::if_else(
      current_age <= 3,
      last_regimen %in% c(
        "ABC-3TC-LPV/r",
        "AZT-3TC-LPV/r"
      ),
      last_regimen %in% c(
        "ABC-3TC-DTG",
        "TDF-3TC-DTG"
      )
    ),
    dplyr::between(current_age, age_range[1], age_range[2]),
    state %in% region,
    facility %in% site
  )
}



utils::globalVariables(c(
  "last_regimen",
  "current_age"
))
