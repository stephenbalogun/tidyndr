#' Summarize an indicator into finer details by the specified variable
#'
#' Counts the number of occurrence of an outcome based on the category of
#' interest. It also provides "Totals" at the end of the columns or rows (or both)
#' where appropriate.
#'
#' @param data Data containing the indicator to be disaggregated.
#' @param by The variable of interest to be used for the disaggregation. The
#' options are any of: \code{"sex"}, \code{"current_age"}, \code{"pregnancy_status"}, \code{"art_duration"},
#' \code{"months_dispensed"} (of ARV), and \code{"age_sex"}.
#' @param ... Other parameters to be passed based on the \code{by} supplied. These are: 1) the \code{`level`} of disaggregation,
#' ("ip" or "country", "state", "lga" and "facility"). 2) \code{`pivot_wide`} TRUE or FALSE, used to determine how the tabular data should be presented.
#' The default options are "state" for  \code{by} and TRUE for \code{pivot_wide}.
#' value is "state".
#'
#' @return disaggregated data
#' @export disaggregate
#'
#' @examples
#' ### Disaggregate "TX_NEW" clients into age categories for each state
#' new_clients <- tx_new(ndr_example, from = "2021-01-01")
#' disaggregate(new_clients, by = "current_age") # default value of level is "state"
#'
#' ### Disaggregate "TX_CURR" by gender for each facility
#' curr_clients <- tx_curr(ndr_example)
#' disaggregate(curr_clients, by = "sex", level = "facility")

disaggregate <- function(data, by, ...) {


  df <- structure(data, "class" = c(class(data), by))


  disagg_ndr(df, ...)
}



disagg_ndr <- function(df, ...) {
  UseMethod("disagg_ndr")
}


### sex disaggregation
disagg_ndr.sex <- function(df, level = "state", pivot_wide = TRUE, ...){

  gender <- forcats::fct_collapse(df$sex,
                                  "Male" = "M",
                                  "Female" = "F",
                                  other_level = "unknown")

  get_disagg(df, by = "sex", by_value = gender, pivot_wide = pivot_wide, level = level)

}




### pregnancy status
disagg_ndr.pregnancy_status <- function(df, level = "state", pivot_wide = TRUE, ...){

  preg_status <- forcats::fct_collapse(df$pregnancy_status,
                                         pregnant = "P",
                                         breastfeeding = "BF",
                                         not_pregnant = "NP",
                                         other_level = "missing_or_unknown"
  )

  get_disagg(df, by = "pregnancy_status", by_value = preg_status, pivot_wide = pivot_wide, level = level)


}



### current_age
disagg_ndr.current_age <- function(df, level = "state", pivot_wide = TRUE, ...){

  age <- dplyr::case_when(
    df$current_age < 1 ~ "<1",
    dplyr::between(df$current_age, 1, 4) ~ "1-4",
    dplyr::between(df$current_age, 5, 9) ~ "5-9",
    dplyr::between(df$current_age, 10, 14) ~ "10-14",
    dplyr::between(df$current_age, 15, 19) ~ "15-19",
    dplyr::between(df$current_age, 20, 24) ~ "20-24",
    dplyr::between(df$current_age, 25, 29) ~ "25-29",
    dplyr::between(df$current_age, 30, 34) ~ "30-34",
    dplyr::between(df$current_age, 35, 39) ~ "35-39",
    dplyr::between(df$current_age, 40, 44) ~ "40-44",
    dplyr::between(df$current_age, 45, 49) ~ "45-49",
    dplyr::between(df$current_age, 50, 54) ~ "50-54",
    dplyr::between(df$current_age, 55, 59) ~ "55-59",
    dplyr::between(df$current_age, 60, 64) ~ "60-64",
    df$current_age >= 65 ~ "65+", df$current_age <
      0 ~ "neg_age", is.na(df$current_age) ~
      "missing"
  )

  age <- factor(
    age,
    levels = c("<1", "1-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49", "50-54", "55-59", "60-64", "65+", "missing"),
    ordered = TRUE)

  get_disagg(df, by = "current_age", by_value = age, pivot_wide = pivot_wide, level = level)


}



### duration
disagg_ndr.art_duration <- function(df, level = "state", pivot_wide = TRUE, ...){

  df$art_duration <-  as.integer(df$appointment_date - df$art_start_date)

  art_duration <- dplyr::case_when(
    df$art_duration < 90 ~ "<3 months",
    dplyr::between(df$art_duration, 90, 179) ~ "3-5 months",
    df$art_duration >= 180 ~ "6 months+",
    is.na(df$art_duration) ~ "missing"
  )

  art_duration <- factor(art_duration, levels = c("missing", "<3 months", "3-5 months", "6 months+"), ordered = TRUE)

  get_disagg(df, by = "art_duration", by_value = art_duration, pivot_wide = pivot_wide, level = level)


}




### duration of ARV Dispensed
disagg_ndr.months_dispensed <- function(df, level = "state", pivot_wide = TRUE, ...){

  if (!any(names(df) %in% "months_dispensed")) {
    df$months_dispensed <- floor(df$days_of_arv_refill / 28)
  }


  mmd <- dplyr::case_when(
    df$months_dispensed < 3 ~ "<3 months",
    dplyr::between(df$months_dispensed, 3, 5) ~ "3-5 months",
    df$months_dispensed >= 6 ~ "6 months+",
    TRUE ~ "missing"
  )

  mmd <- factor(mmd, levels = c("missing", "<3 months", "3-5 months", "6 months+"), ordered = TRUE)

  get_disagg(df, by = "months_dispensed", by_value = mmd, pivot_wide = pivot_wide, level = level)


}



### disaggregate by age and sex
disagg_ndr.age_sex <- function(df, level = "state", pivot_wide = TRUE){

  age <- dplyr::case_when(
    df$current_age < 1 ~ "<1",
    dplyr::between(df$current_age, 1, 4) ~ "1-4",
    dplyr::between(df$current_age, 5, 9) ~ "5-9",
    dplyr::between(df$current_age, 10, 14) ~ "10-14",
    dplyr::between(df$current_age, 15, 19) ~ "15-19",
    dplyr::between(df$current_age, 20, 24) ~ "20-24",
    dplyr::between(df$current_age, 25, 29) ~ "25-29",
    dplyr::between(df$current_age, 30, 34) ~ "30-34",
    dplyr::between(df$current_age, 35, 39) ~ "35-39",
    dplyr::between(df$current_age, 40, 44) ~ "40-44",
    dplyr::between(df$current_age, 45, 49) ~ "45-49",
    dplyr::between(df$current_age, 50, 54) ~ "50-54",
    dplyr::between(df$current_age, 55, 59) ~ "55-59",
    dplyr::between(df$current_age, 60, 64) ~ "60-64",
    df$current_age >= 65 ~ "65+", df$current_age <
      0 ~ "neg_age", is.na(df$current_age) ~
      "missing"
  )

  age <- factor(
    age,
    levels = c("<1", "1-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49", "50-54", "55-59", "60-64", "65+", "missing"),
    ordered = TRUE)

  gender <- forcats::fct_collapse(df$sex,
                                  "Male" = "M",
                                  "Female" = "F",
                                  other_level = "unknown")


  get_disagg_(df, by = c("sex", "current_age"), by_value = list(gender, age), pivot_wide = pivot_wide, level = level)

}


# for disaggregation by one variable
get_disagg <- function(df, by, by_value, level = "state", pivot_wide = TRUE, ...){

  df[by] <- by_value

  by_c <- rlang::sym(by)
  dt <- switch(
    level,
    "ip"= dplyr::count(df, ip, !!by_c, .drop = TRUE, name = "number"),

    "country"= dplyr::count(df, ip, !!by_c, .drop = TRUE, name = "number"),

    "state" = dplyr::count(df, ip, state, !!by_c, .drop = TRUE, name = "number"),

    "lga" = dplyr::count(df, ip, state, lga, !!by_c, .drop = TRUE, name = "number"),

    "facility" = dplyr::count(df, ip, state, lga, facility, !!by_c, .drop = TRUE, name = "number")
  )

  dt <- structure(dt, "class" = c("spec_tbl_df", "tbl_df", "tbl", "data.frame"))

  if(pivot_wide) {

    dt <- tidyr::pivot_wider(
      dt,
      names_from = tidyselect::all_of(by),
      values_from = "number"
    )
  }

  dt[is.na(dt)] <- 0 ## replace NAs with Zero



  tibble::as_tibble(janitor::adorn_totals(dt))

}



## for disaggregation by two variables
get_disagg_ <- function(df, by, by_value, level = level, pivot_wide = pivot_wide) {


  df[by[1]] <- by_value[[1]]

  df[by[2]] <- by_value[[2]]

  by_c <- rlang::syms(by)

  dt <- switch(
    level,
    "ip"= dplyr::count(df, ip, !!!by_c, .drop = TRUE, name = "number"),

    "country"= dplyr::count(df, ip, !!!by_c, .drop = TRUE, name = "number"),

    "state" = dplyr::count(df, ip, state, !!!by_c, .drop = TRUE, name = "number"),

    "lga" = dplyr::count(df, ip, state, lga, !!!by_c, .drop = TRUE, name = "number"),

    "facility" = dplyr::count(df, ip, state, lga, facility, !!!by_c, .drop = TRUE, name = "number")
  )

  dt <- structure(dt, "class" = c("spec_tbl_df", "tbl_df", "tbl", "data.frame"))

  if(pivot_wide) {

    dt <- tidyr::pivot_wider(
      dt,
      names_from = by[2],
      values_from = "number"
    )
  }

  dt[is.na(dt)] <- 0 ## replace NAs with Zero



  tibble::as_tibble(janitor::adorn_totals(dt))
}



utils::globalVariables(
  c("lga", "pregnancy_status", "sex")
)
