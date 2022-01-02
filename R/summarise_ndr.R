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
#' new <- tx_new(ndr_example, from = "2021-03-01")
#' curr <- tx_curr(ndr_example)
#'
#' summarise_ndr(
#'   new,
#'   curr,
#'   level = "state",
#'   names = c("tx_new", "tx_curr")
#' )
#'
#' ### summarise for only one dataframe (defaults data name when name is not specified)
#' summarise_ndr(
#'   data = new,
#'   level = "ip"
#' )
summarise_ndr <- function(..., level = "state", names = NULL) {
  data <- rlang::dots_list(..., .named = TRUE)

  validate_summary(data, level, names)

  get_summary_ndr(data, level, names)

}


utils::globalVariables(
  "ip"
)
