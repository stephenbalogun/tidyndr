#' Count the Number of Outcomes Based on a Specified Level
#'
#' The \code{summarize_ndr()} function counts the number of occurrence of
#' specified level for each of the supplied dataframe. It then combines the
#' given dataframes into a single table. It also adds a "Total" roll that
#' adds all the rows for each of the numeric columns.
#'
#' @param ... Dataframes to be summarized.
#' @param level The level at which the summary should be performed. The options
#' are "ip" (or "country"), "state", "lga" or "facility".
#' @param names The names to be passed to the summary columns created in
#' the output
#'
#' @return summarize_ndr
#' @export
#'
#' @examples
#' new <- tx_new(ndr_example, from = "2021-03-01")
#' curr <- tx_curr(ndr_example)
#'
#' summarize_ndr(
#'   new,
#'   curr,
#'   level = "state",
#'   names = c("tx_new", "tx_curr")
#' )
#'
#' ### summarize for only one dataframe (defaults data name when name is not specified)
#' summarize_ndr(
#'   data = new,
#'   level = "ip"
#' )
summarize_ndr <- function(..., level = "state", names = NULL) {
  data <- rlang::dots_list(..., .named = TRUE)

  validate_summary(data, level, names)

  get_summary_ndr(data, level, names)
}



validate_summary <- function(data, level, names) {
  if (length(unique(level)) > 1) {
    rlang::abort('You have supplied more than one type of levels to the
                 "level" argument')
  }

  if (!any(level %in% c("ip", "country", "state", "lga", "facility"))) {
    rlang::abort("level must be one of 'ip', 'country', 'state', 'lga', or 'facility'")
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


get_summary_ndr <- function(data, level, names){


  if (is.null(names)) {

    names <- names(data)

  }

  if (length(data) == 1) {
    return(my_summary(data[[1]], l = level, n = names[[1]]))
  }


  i <- 1

  df <- vector("list", length(data)) # create a holder for output

  while (i <= length(data)) {
    df[[i]] <- my_summary(data[[i]], l = level, n = names[[i]])

    i <- i + 1
  }


  dt <- switch(level,
               "state" = purrr::reduce(df, dplyr::left_join, by = c("ip", "state")),
               "facility" = purrr::reduce(df, dplyr::left_join, by = c("ip", "state", "lga", "facility")),
               "country" = purrr::reduce(df, dplyr::left_join, by = "ip"),
               "ip" = purrr::reduce(df, dplyr::left_join, by = "ip"),
               "lga" = purrr::reduce(df, dplyr::left_join, by = c("ip", "state", "lga"))
  )

  dt[is.na(dt)] <- 0 ## replace NAs with Zero

  tibble::as_tibble(dt)
}



utils::globalVariables(
  "ip"
)
