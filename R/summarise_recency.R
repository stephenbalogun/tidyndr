#' Count the Number of Recency Outcomes Based on a Specified Level
#'
#' The \code{summarise_recency()} function counts the number of occurrence of
#' specified level for each of the supplied dataframe. It then combines the
#' given dataframes into a single table. It also adds a "Total" roll that
#' adds all the rows for each of the numeric columns.
#'
#' @inheritParams summarise_ndr
#' @param level The level at which the summary should be performed. The options
#' are "ip" (or "country"), "facility_state", "facility_lga", "facility", "client_state", or "client_lga".
#'
#' @return summary dataframe of recency indicators
#' @export summarise_recency
#'
#' @examples
#' hts_pos <- hts_tst_pos(recency_example, from = "2021-01-01") # positive clients from January 2021
#' hts_recent <- hts_recent(hts_pos) # positive clients from above who had recency testing done
#' rtri_recent <- rtri_recent(hts_recent) # hts_recent clients who were presumed recent from RTRI
#'
#' summarise_recency(
#'   hts_pos,
#'   hts_recent,
#'   rtri_recent,
#'   level = "facility_state",
#'   names = c("positives", "recency_testing", "rtri_recent")
#' )
#'
#' ### If the `names` argument is not supplied, the names of the supplied data will be used instead
#' summarise_recency(
#'   hts_pos,
#'   hts_recent
#' )

summarise_recency <- function(..., level = "facility_state", names = NULL) {
  data <- rlang::dots_list(..., .named = TRUE)

  validate_summary2(data, level, names)

  get_summary_recency(data, level, names)
}



validate_summary2 <- function(data, level, names) {
  if (length(unique(level)) > 1) {
    rlang::abort('You have supplied more than one type of levels to the
                 "level" argument')
  }

  if (!any(level %in% c("ip", "country", "facility_state", "facility_lga", "facility", "client_state", "client_lga"))) {
    rlang::abort("level must be one of 'ip', 'country', 'facility_state', 'facility_lga', 'facility', 'client_state' or 'client_lga'")
  }

  if (!is.null(names) && length(data) != length(names)) {
    rlang::abort(
      'the number of dataframes supplied is not equal to the number of names supplied to the "names" argument'
    )
  }


  if (!is.null(names) && !is.character(names)) {
    rlang::abort(
      "names must be supplied as characters. Did you forget to put the names in quotes?"
    )
  }

}


get_summary_recency <- function(data, level, names){


  if (is.null(names)) {

    names <- names(data)

  }

  if (length(data) == 1) {
    return(my_summary2(data[[1]], l = level, n = names[[1]]))
  }


  i <- 1

  df <- vector("list", length(data)) # create a holder for output

  while (i <= length(data)) {
    df[[i]] <- my_summary2(data[[i]], l = level, n = names[[i]])

    i <- i + 1
  }


  dt <- switch(level,
               "facility_state" = purrr::reduce(df, dplyr::left_join, by = c("ip", "facility_state")),
               "facility" = purrr::reduce(df, dplyr::left_join, by = c("ip", "facility_state", "facility_lga", "facility")),
               "country" = purrr::reduce(df, dplyr::left_join, by = "ip"),
               "ip" = purrr::reduce(df, dplyr::left_join, by = "ip"),
               "lga" = purrr::reduce(df, dplyr::left_join, by = c("ip", "facility_state", "facility_lga")),
               "client_state" = purrr::reduce(df, dplyr::left_join, by = c("ip", "client_state")),
               "client_lga" = purrr::reduce(df, dplyr::left_join, by = c("ip", "client_state", "client_lga"))
  )

  dt[is.na(dt)] <- 0 ## replace NAs with Zero

  tibble::as_tibble(dt)
}



utils::globalVariables(
  "ip"
)
