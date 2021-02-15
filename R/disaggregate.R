#' Summarise an indicator into finer details by the specified variable
#'
#' Counts the number of occurrence of an outcome based on the category of
#' interest. It also provides "Totals" at the end of the columns or rows (or both)
#' where appropriate.
#'
#' @param data Data containing the indicator to be disaggregated.
#' @param by The variable of interest to be used for the disaggregation. The
#' options are any of: \code{"sex"}, \code{"age"} and \code{"pregnancy status"}.
#' To improve the user experience, the \code{by} parameter accepts any of
#' \code{"current_age"} and \code{"current_age"} as substitutes for \code{"age"},
#' \code{"gender"} as substitute for \code{"sex"} and
#' \code{"pregnancy_status"} as substitute for \code{"pregnancy status"}.
#' @param level The level at which the disaggregation should be performed.
#' The options are "ip" (or "country"), "state", "lga" or "facility". The default
#' value is "state".
#'
#' @return disaggregate
#' @export
#'
#' @examples
#' ### Disaggregate "TX_NEW" clients into age categories for each state
#' new_clients <- tx_new(ndr_example)
#' disaggregate(new_clients, by = "age") # default value of level is "state"
#'
#' ### Disaggregate "TX_CURR" into by gender for each facility
#' curr_clients <- tx_curr(ndr_example)
#' disaggregate(curr_clients, by = "sex", level = "facility")
disaggregate <- function(data, by, level = "state") {
  if (any(!by %in% c(
    "gender", "sex", "age", "current_age", "current age",
    "pregnancy status", "pregnancy_status"
  ))) {
    stop("the value supplied to the `by` parameter is invalid. Please check!")
  }

  stopifnot(
    "the value supplied to the `level` parameter is invalid!" =
      any(level %in% c("ip", "country", "state", "lga", "facility"))
  )

  stopifnot(
    "You have supplied more than one values to the `level` or `by` parameter" =
      length(level) == 1 && length(by) == 1
  )



  ### by == "sex"
  if (by == "sex" || by == "gender") {
    gender <- forcats::fct_collapse(data$sex,
      "Male" = "M",
      "Female" = "F",
      other_level = "unknown"
    )

    dat <- dplyr::mutate(data, sex = gender)

    if (level == "ip" || level == "country") {
      dt <- janitor::adorn_totals(
        tidyr::pivot_wider(
          dplyr::count(dat, ip, sex, .drop = TRUE),
          names_from = sex,
          values_from = n
        ),
        where = "col"
      )
    } else if (level == "state") {
      dt <- janitor::adorn_totals(
        tidyr::pivot_wider(
          dplyr::count(dat, ip, state, sex, .drop = TRUE),
          names_from = sex,
          values_from = n
        ),
        where = c("row", "col")
      )

      dt[is.na(dt)] <- 0 ## replace NAs with Zero
    } else if (level == "lga") {
      dt <- janitor::adorn_totals(
        tidyr::pivot_wider(
          dplyr::count(dat, ip, state, lga, sex, .drop = TRUE),
          names_from = sex,
          values_from = n
        ),
        where = "col"
      )

      dt[is.na(dt)] <- 0 ## replace NAs with Zero
    } else if (level == "facility") {
      dt <- janitor::adorn_totals(
        tidyr::pivot_wider(
          dplyr::count(dat, ip, state, facility, sex, .drop = TRUE),
          names_from = sex,
          values_from = n
        ),
        where = "col"
      )

      dt[is.na(dt)] <- 0 ## replace NAs with Zero
    }
  }


  ### by == "pregnancy status"
  if (by == "pregnancy status" || by == "pregnancy_status") {
    preg_status <- forcats::fct_collapse(data$pregnancy_status,
      pregnant = "P",
      breastfeeding = "BF",
      not_pregnant = "NP",
      other_level = "missing_or_unknown"
    )

    dat <- dplyr::mutate(data, pregnancy_status = preg_status)

    if (level == "ip" || level == "country") {
      dt <- janitor::adorn_totals(tidyr::pivot_wider(
        dplyr::count(dat, ip, pregnancy_status, .drop = TRUE),
        names_from = pregnancy_status,
        values_from = n
      ),
      where = "col"
      )
    } else if (level == "state") {
      dt <- janitor::adorn_totals(tidyr::pivot_wider(
        dplyr::count(dat, ip, state, pregnancy_status, .drop = TRUE),
        names_from = pregnancy_status,
        values_from = n
      ),
      where = c("row", "col")
      )

      dt[is.na(dt)] <- 0 ## replace NAs with Zero
    } else if (level == "lga") {
      dt <- janitor::adorn_totals(tidyr::pivot_wider(
        dplyr::count(dat, ip, state, lga, pregnancy_status, .drop = TRUE),
        names_from = pregnancy_status,
        values_from = n
      ),
      where = "col"
      )

      dt[is.na(dt)] <- 0 ## replace NAs with Zero
    } else if (level == "facility") {
      dt <- janitor::adorn_totals(tidyr::pivot_wider(
        dplyr::count(dat, ip, state, facility, pregnancy_status, .drop = TRUE),
        names_from = pregnancy_status,
        values_from = n
      ),
      where = "col"
      )

      dt[is.na(dt)] <- 0 ## replace NAs with Zero
    }
  }

  ### by == "current_age"
  if (by == "age" || by == "current_age" || by == "current age") {
    age <- dplyr::case_when(
      dplyr::between(data$current_age, 0, 1) ~ "<1",
      dplyr::between(data$current_age, 1, 4) ~ "1-4",
      dplyr::between(data$current_age, 5, 9) ~ "5-9",
      dplyr::between(data$current_age, 10, 14) ~ "10-14",
      dplyr::between(data$current_age, 15, 19) ~ "15-19",
      dplyr::between(data$current_age, 20, 24) ~ "20-24",
      dplyr::between(data$current_age, 25, 29) ~ "25-29",
      dplyr::between(data$current_age, 30, 34) ~ "30-34",
      dplyr::between(data$current_age, 35, 39) ~ "35-39",
      dplyr::between(data$current_age, 40, 44) ~ "40-44",
      dplyr::between(data$current_age, 45, 49) ~ "45-49",
      data$current_age >= 50 ~ "50+",
      data$current_age < 0 ~ "neg_age",
      is.na(data$current_age) ~ "missing"
    )



    dat <- dplyr::mutate(data, current_age = age)

    if (level == "ip" || level == "country") {
      dt <- janitor::adorn_totals(tidyr::pivot_wider(
        dplyr::count(dat, ip, current_age, .drop = TRUE),
        names_from = current_age,
        values_from = n
      ),
      where = "col"
      )
    } else if (level == "state") {
      dt <- janitor::adorn_totals(tidyr::pivot_wider(
        dplyr::count(dat, ip, state, current_age, .drop = TRUE),
        names_from = current_age,
        values_from = n
      ),
      where = c("row", "col")
      )

      dt[is.na(dt)] <- 0 ## replace NAs with Zero
    } else if (level == "lga") {
      dt <- janitor::adorn_totals(tidyr::pivot_wider(
        dplyr::count(dat, ip, state, lga, current_age, .drop = TRUE),
        names_from = current_age,
        values_from = n
      ),
      where = "col"
      )

      dt[is.na(dt)] <- 0 ## replace NAs with Zero
    } else if (level == "facility") {
      dt <- janitor::adorn_totals(tidyr::pivot_wider(
        dplyr::count(dat, ip, state, facility, current_age, .drop = TRUE),
        names_from = current_age,
        values_from = n
      ),
      where = "col"
      )

      dt[is.na(dt)] <- 0 ## replace NAs with Zero
    }

    dt <- dplyr::relocate(dt, `5-9`, .after = `1-4`)
  }
  tibble::as_tibble(dt)
}



utils::globalVariables(
  c("lga", "n", "pregnancy_status", "sex", "5-9", "1-4")
)
