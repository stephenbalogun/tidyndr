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
#' @return
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

  ### by == "sex"
  if (by == "sex" || by == "gender") {
    if (level == "ip" || level == "country") {
      dt <- janitor::adorn_totals(
        tidyr::pivot_wider(
          dplyr::mutate(
            dplyr::filter(
              dplyr::count(data, ip, sex, .drop = TRUE),
              sex %in% c("F", "M")
            ),
            sex = factor(sex, labels = c("Female", "Male"))
          ),
          names_from = sex,
          values_from = n
        ),
        where = "col"
      )
    } else if (level == "state") {
      dt <- janitor::adorn_totals(
        tidyr::pivot_wider(
          dplyr::mutate(
            dplyr::filter(
              dplyr::count(data, ip, state, sex, .drop = TRUE),
              sex %in% c("F", "M")
            ),
            sex = factor(sex, labels = c("Female", "Male"))
          ),
          names_from = sex,
          values_from = n
        ),
        where = c("row", "col")
      )

      dt[is.na(dt)] <- 0 ## replace NAs with Zero
    } else if (level == "lga") {
      dt <- janitor::adorn_totals(
        tidyr::pivot_wider(
          dplyr::mutate(
            dplyr::filter(
              dplyr::count(data, ip, state, lga, sex, .drop = TRUE),
              sex %in% c("F", "M")
            ),
            sex = factor(sex, labels = c("Female", "Male"))
          ),
          names_from = sex,
          values_from = n
        ),
        where = "col"
      )

      dt[is.na(dt)] <- 0 ## replace NAs with Zero
    } else if (level == "facility") {
      dt <- janitor::adorn_totals(
        tidyr::pivot_wider(
          dplyr::mutate(
            dplyr::filter(
              dplyr::count(data, ip, state, facility, sex, .drop = TRUE),
              sex %in% c("F", "M")
            ),
            sex = factor(sex, labels = c("Female", "Male"))
          ),
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
  }
  tibble::as_tibble(dt)
}



utils::globalVariables(
  c("lga", "n", "pregnancy_status", "sex")
)
