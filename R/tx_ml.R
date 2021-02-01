#' Subset clients who became inactive (IIT) within a given period
#'
#' \code{tx_ml} Generates clients who have become inactive over a specified
#' period of time. The default is to generate all clients who became inactive
#' in the current Fiscal Year. You can specify the period of interest
#' (using the \code{from} and \code{to} arguments). Used together
#' with \code{tx_ml_outcomes()}, generates inactive clients with a particular
#' outcome of interest.
#'
#' @inheritParams tx_appointment
#'
#' @return
#' @export
#'
#' @examples
#' tx_ml(ndr_example)
#'
#' # Find clients who were inactive at the end of Q1 of FY21
#' tx_ml(ndr_example, to = "2020-12-31")
tx_ml <- function(data,
                  from = fy_start,
                  to = end_date,
                  states = regions,
                  facilities = sites) {
  end_date <- Sys.Date()
  regions <- unique(data$state)
  sites <- unique(data$facility)


  fy_start <- lubridate::as_date(
    ifelse(lubridate::month(Sys.Date()) < 10,
      stats::update(Sys.Date(),
        year = lubridate::year(Sys.Date()) - 1,
        month = 10,
        day = 1
      ),
      stats::update(Sys.Date(),
        month = 10,
        day = 1
      )
    )
  )

  stopifnot(
    "please check that region is contained in the dataset list of states" =
      any(states %in% unique(data$state))
  )

  stopifnot(
    "please check that site is contained in the dataset list of facilities" =
      any(facilities %in% unique(data$facility))
  )

  stopifnot(
    'please check that your date format is "yyyy-mm-dd"' =
      !is.na(lubridate::as_date(from))
  )
  stopifnot(
    'please check that your date format is "yyyy-mm-dd"' =
      !is.na(lubridate::as_date(to))
  )

  dat <- dplyr::mutate(data,
    date_lost = last_drug_pickup_date +
      lubridate::days(days_of_arv_refill) +
      lubridate::days(28)
  )
  dplyr::filter(
    dat,
    dplyr::between(
      date_lost,
      lubridate::as_date(from),
      lubridate::as_date(to)
    ),
    state %in% states,
    facility %in% facilities
  )
}



utils::globalVariables("date_lost")
