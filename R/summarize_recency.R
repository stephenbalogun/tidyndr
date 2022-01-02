#' Count the Number of Recency Outcomes Based on a Specified Level
#'
#' The \code{summarize_recency()} function counts the number of occurrence of
#' specified level for each of the supplied dataframe. It then combines the
#' given dataframes into a single table. It also adds a "Total" roll that
#' adds all the rows for each of the numeric columns.
#'
#' @inheritParams summarize_ndr
#' @param level The level at which the summary should be performed. The options
#' are "ip" (or "country"), "facility_state", "facility_lga", "facility", "client_state", or "client_lga".
#'
#' @return summary dataframe of recency indicators
#' @export summarize_recency
#'
#' @examples
#' hts_pos <- hts_tst_pos(recency_example, from = "2021-01-01") # positive clients from January 2021
#' hts_recent <- hts_recent(hts_pos) # positive clients from above who had recency testing done
#' rtri_recent <- rtri_recent(hts_recent) # hts_recent clients who were presumed recent from RTRI
#'
#' summarize_recency(
#'   hts_pos,
#'   hts_recent,
#'   rtri_recent,
#'   level = "facility_state",
#'   names = c("positives", "recency_testing", "rtri_recent")
#' )
#'
#' ### If the `names` argument is not supplied, the names of the supplied data will be used instead
#' summarize_recency(
#'   hts_pos,
#'   hts_recent
#' )

summarize_recency <- function(..., level = "facility_state", names = NULL) {
  data <- rlang::dots_list(..., .named = TRUE)

  validate_summary2(data, level, names)

  get_summary_recency(data, level, names)
}



utils::globalVariables(
  "ip"
)
