#' Count the number of outcomes based on a specified level
#'
#' The \code{summarise_ndr()} function counts the number of occurrence of
#' specified level for each of the supplied dataframe. It then combines the
#' given dataframes into a single table. It also adds a "Total" roll that
#' adds all the rows for each of the numeric columns.
#'
#' @param data A list of dataframes to be summarised
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
#'   data = list(new, curr),
#'   level = "state",
#'   names = c("tx_new", "tx_curr")
#' )
#'
#' ### summarise for only one dataframe
#' summarise_ndr(
#'   data = list(new),
#'   level = "ip",
#'   names = "tx_new"
#' )
summarise_ndr <- function(data, level, names) {
  stopifnot(
    'Please supply the "data" argument as a `list`' =
      is.list(data)
  )

  stopifnot(
    "At least one of your listed data is not a dataframe" =
      any(is.data.frame(data[[1]]))
  )

  stopifnot(
    'You have supplied more than one value to the "level" argument' =
      length(level) == 1
  )

  if (!any(level %in% c("ip", "country", "state", "lga", "facility"))) {
    stop("level must be one of 'ip', 'country', 'state', 'lga', or 'facility'")
  }

  stopifnot(
    'the number of dataframes supplied is not equal to the number of names supplied to the "names" argument' =
      length(data) == length(names)
  )

  stopifnot(
    "the `names` argument must be supplied as character. Did you omit the quotation marks?" =
      is.character(names)
  )


  # helper function ---------------------------------------------------------

  my_summary <- function(data, l, n) {
    if (l == "state") {
      data %>%
        dplyr::count(ip, state, name = n, .drop = TRUE) %>%
        janitor::adorn_totals()
    } else if (l == "facility") {
      data %>%
        dplyr::count(ip, state, facility, name = n, .drop = TRUE) %>%
        janitor::adorn_totals()
    } else if (l == "country" | l == "ip") {
      data %>%
        dplyr::count(ip, name = n, .drop = TRUE)
    } else if (l == "lga") {
      data %>%
        dplyr::count(ip, state, lga, name = n, .drop = TRUE)
    }
  }
  #################################################

  if (length(data) == 1) {
    return(my_summary(data[[1]], l = level, n = names[[1]]))
  }


  if (level == "state") {
    i <- 1

    df <- vector("list", length(data)) # create a holder for output

    while (i <= length(data)) {
      df[[i]] <- my_summary(data[[i]], l = level, n = names[[i]])

      i <- i + 1
    }

    # join all the the outputs together
    dt <- purrr::reduce(df, dplyr::left_join, by = c("ip", "state"))

  } else if (level == "facility") {
    i <- 1

    df <- vector("list", length(data))

    while (i <= length(data)) {
      df[[i]] <- my_summary(data[[i]], l = level, n = names[[i]])

      i <- i + 1
    }

    dt <- purrr::reduce(df, dplyr::left_join, by = c("ip", "state", "facility"))

    dt[is.na(dt)] <- 0 ## replace NAs with Zero

  } else if (level == "country" | level == "ip") {
    i <- 1

    df <- vector("list", length(data))

    while (i <= length(data)) {
      df[[i]] <- my_summary(data[[i]], l = level, n = names[[i]])

      i <- i + 1
    }

    dt <- purrr::reduce(df, dplyr::left_join, by = "ip")
  } else if (level == "lga") {
    i <- 1

    df <- vector("list", length(data))

    while (i <= length(data)) {
      df[[i]] <- my_summary(data[[i]], l = level, n = names[[i]])

      i <- i + 1
    }

    dt <- purrr::reduce(df, dplyr::left_join, by = c("ip", "state", "lga"))
  }

  dt
}


utils::globalVariables(
  "ip"
)
