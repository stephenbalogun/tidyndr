#' Count the Number of Outcomes Based on a Specified Level
#'
#' The \code{summarise_ndr()} function counts the number of occurrence of
#' specified level for each of the supplied dataframe. It then combines the
#' given dataframes into a single table. It also adds a "Total" roll that
#' adds all the rows for each of the numeric columns.
#'
#' @param ...  Data frames to be summarised.
#' @param level The level at which the summary should be performed. The options
#' are "ip" (or "country"), "state", "lga" or "facility".
#' @param names The names to be passed to the summary columns created in
#' the output
#'
#' @return summarise_ndr
#' @export
#'
#' @examples
#' new <- tx_new(ndr_example)
#' curr <- tx_curr(ndr_example)
#'
#' summarise_ndr(
#'   new,
#'   curr,
#'   level = "state",
#'   names = c("tx_new", "tx_curr")
#' )
#'
#' ### summarise for only one dataframe
#' summarise_ndr(
#'   data = new,
#'   level = "ip",
#'   names = "tx_new"
#' )
summarise_ndr <- function(..., level, names) {
  data <- rlang::list2(...)


  if (length(unique(level)) > 1) {
    rlang::abort('You have supplied more than one type of levels to the
                 "level" argument')
  }

  if (rlang::is_null(level)) {
    rlang::abort("Did you forget to pass a value to `level`?")
  }

  if (!any(level %in% c("ip", "country", "state", "lga", "facility"))) {
    rlang::abort("level must be one of 'ip', 'country', 'state', 'lga', or 'facility'")
  }

  if (length(data) != length(names)) {
    rlang::abort(
      'the number of dataframes supplied is not equal to the number of names supplied to the "names" argument'
    )
  }

  if (rlang::is_null(names)) {
    rlang::abort(
      "Did you forget to specify the name(s) for your summary?"
    )
  }


  if (!is.character(names)) {
    rlang::abort(
      "names must be supplied as characters. Did you forget to put the names in quotes?"
    )
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
