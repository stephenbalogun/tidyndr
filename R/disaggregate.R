#' Summarise an indicator into finer details by the specified variable
#'
#' Counts the number of occurrence of an outcome based on the category of
#' interest. It also provides "Totals" at the end of the columns or rows (or both)
#' where appropriate.
#'
#' @param data Data containing the indicator to be disaggregated.
#' @param by The variable of interest to be used for the disaggregation. The
#' options are any of: \code{"sex"}, \code{"current_age"} and \code{"pregnancy_status"}.
#' @param level The level at which the disaggregation should be performed.
#' The options are "ip" (or "country"), "state", "lga" or "facility". The default
#' value is "state".
#'
#' @return disaggregate
#' @export
#'
#' @examples
#' ### Disaggregate "TX_NEW" clients into age categories for each state
#' new_clients <- tx_new(ndr_example, from = "2021-01-01", to = "2021-03-31")
#' disaggregate(new_clients, by = "current_age") # default value of level is "state"
#'
#' ### Disaggregate "TX_CURR" by gender for each facility
#' curr_clients <- tx_curr(ndr_example)
#' disaggregate(curr_clients, by = "sex", level = "facility")
disaggregate <- function(data, by, level = "state") {
  if (!any(by %in% c(
    "sex", "current_age", "pregnancy_status"
  ))) {
    rlang::abort("the value supplied to the `by` parameter is invalid. Please check! \nDid you make a spelling mistake or capitalise the first letter?")
  }

  if (!any(level %in% c("ip", "country", "state", "lga", "facility"))) {
    rlang::abort("the value supplied to the `level` parameter is invalid! \nDid you make a spelling mistake or capitalise the first letter?")
  }

  if (length(level) != 1 || length(by) != 1) {
    rlang::abort("You have supplied more than one values to the `level` or `by` parameter.")
  }

  ### by == "sex"
  if (by == "sex") {
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
    } else if (level == "lga") {
      dt <- janitor::adorn_totals(
        tidyr::pivot_wider(
          dplyr::count(dat, ip, state, lga, sex, .drop = TRUE),
          names_from = sex,
          values_from = n
        ),
        where = c("row", "col")
      )
    } else if (level == "facility") {
      dt <- janitor::adorn_totals(
        tidyr::pivot_wider(
          dplyr::count(dat, ip, state, lga, facility, sex, .drop = TRUE),
          names_from = sex,
          values_from = n
        ),
        where = c("row", "col")
      )
    }
  }


  ### by == "pregnancy status"
  if (by == "pregnancy_status") {
    preg_status <- forcats::fct_collapse(data$pregnancy_status,
      pregnant = "P",
      breastfeeding = "BF",
      not_pregnant = "NP",
      other_level = "missing_or_unknown"
    )

    dat <- dplyr::filter(
      dplyr::mutate(
        data,
        pregnancy_status = preg_status
      ),
      sex == "F", current_age > 10
    )

    if (level == "ip" || level == "country") {
      dt <- janitor::adorn_totals(tidyr::pivot_wider(
        dplyr::count(dat, ip, pregnancy_status, .drop = TRUE),
        names_from = pregnancy_status,
        values_from = n
      ),
      where = c("row", "col")
      )
    } else if (level == "state") {
      dt <- janitor::adorn_totals(tidyr::pivot_wider(
        dplyr::count(dat, ip, state, pregnancy_status, .drop = TRUE),
        names_from = pregnancy_status,
        values_from = n
      ),
      where = c("row", "col")
      )
    } else if (level == "lga") {
      dt <- janitor::adorn_totals(tidyr::pivot_wider(
        dplyr::count(dat, ip, state, lga, pregnancy_status, .drop = TRUE),
        names_from = pregnancy_status,
        values_from = n
      ),
      where = c("row", "col")
      )
    } else if (level == "facility") {
      dt <- janitor::adorn_totals(tidyr::pivot_wider(
        dplyr::count(dat, ip, state, lga, facility, pregnancy_status, .drop = TRUE),
        names_from = pregnancy_status,
        values_from = n
      ),
      where = c("row", "col")
      )
    }
  }


  ### by == "current_age"
  if (by == "current_age") {
    age <- dplyr::case_when(
      data$current_age < 1 ~ "<1",
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
      dplyr::between(data$current_age, 50, 54) ~ "50-54",
      dplyr::between(data$current_age, 55, 59) ~ "55-59",
      dplyr::between(data$current_age, 60, 64) ~ "60-64",
      data$current_age >= 65 ~ "65+", data$current_age <
        0 ~ "neg_age", is.na(data$current_age) ~
      "missing"
    )

    dat <- dplyr::mutate(data, current_age = age)

    if (level == "ip" || level == "country") {
      dt <- janitor::adorn_totals(tidyr::pivot_wider(
        dplyr::count(dat, ip, current_age, .drop = TRUE),
        names_from = current_age,
        values_from = n
      ),
      where = c("row", "col")
      )
    } else if (level == "state") {
      dt <- janitor::adorn_totals(tidyr::pivot_wider(
        dplyr::count(dat, ip, state, current_age, .drop = TRUE),
        names_from = current_age,
        values_from = n
      ),
      where = c("row", "col")
      )
    } else if (level == "lga") {
      dt <- janitor::adorn_totals(tidyr::pivot_wider(
        dplyr::count(dat, ip, state, lga, current_age, .drop = TRUE),
        names_from = current_age,
        values_from = n
      ),
      where = c("row", "col")
      )
    } else if (level == "facility") {
      dt <- janitor::adorn_totals(tidyr::pivot_wider(
        dplyr::count(dat, ip, state, lga, facility, current_age, .drop = TRUE),
        names_from = current_age,
        values_from = n
      ),
      where = c("row", "col")
      )
    }

    dt <- dplyr::relocate(dt, `5-9`, .after = `1-4`)
  }

  dt[is.na(dt)] <- 0 ## replace NAs with Zero
  tibble::as_tibble(dt)
}



utils::globalVariables(
  c("lga", "n", "pregnancy_status", "sex", "5-9", "1-4")
)
