#' Count the number of outcomes based on a specified level
#'
#' The \code{summarize_ndr()} function counts the number of occurrence of
#' specified level for each of the supplied dataframe. It then combines the
#' given dataframes into a single table. It also adds a "Total" roll that
#' adds all the rows for each of the numeric columns.
#'
#'
#' @inheritParams summarise_ndr
#'
#' @return
#' @export
#'
#' @examples
#' curr <- tx_curr(ndr_example)
#' vl_eligible <- tx_vl_eligible(ndr_example)
#' vl_result <- tx_pvls_den(ndr_example)
#'
#' summarize_ndr(
#'   data = list(curr, vl_eligible, vl_result),
#'   level = "state",
#'   names = c("tx_curr", "vl_eligible", "tx_pvls_den")
#' )
summarize_ndr <- function(data, level, names) {
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
    invisible(df)

    # join all the the outputs together
    purrr::reduce(df, dplyr::left_join, by = c("ip", "state"))
  } else if (level == "facility") {
    i <- 1

    df <- vector("list", length(data))

    while (i <= length(data)) {
      df[[i]] <- my_summary(data[[i]], l = level, n = names[[i]])

      i <- i + 1
    }
    invisible(df)

    dt <- purrr::reduce(df, dplyr::left_join, by = c("ip", "state", "facility"))

    dt[is.na(dt)] <- 0 ## replace NAs with Zero

    print(dt)
  } else if (level == "country" | level == "ip") {
    i <- 1

    df <- vector("list", length(data))

    while (i <= length(data)) {
      df[[i]] <- my_summary(data[[i]], l = level, n = names[[i]])

      i <- i + 1
    }

    invisible(df)

    purrr::reduce(df, dplyr::left_join, by = "ip")
  }
}


utils::globalVariables(
  "ip"
)
