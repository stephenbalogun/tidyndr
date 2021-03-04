#' Read NDR "csv" file
#'
#' Import your NDR patient-level line-list downloaded as ".csv" format from the
#' NDR front-end into R in a nicely formatted table. The function also creates two
#' additional variables - `date_ltfu` and `current_status` for ease of referencing
#' during analysis.
#'
#' @param path Path to the csv file on computer. The file path should be specified in the
#' format "C:/users/Desktop/yourfile" or something similar.
#' @param path Path to the csv file on computer.
#' @param time_stamp The date stamp for the downloaded line-list.
#' @param cols The column types of the downloaded NDR line-lists. The default sets the columns
#'  based on the NDR line-list specifications between October 2020 and March 2021.
#'  If the default fails, you can supply your column specifications following the instructions
#'   in `?vroom::cols` documentation.
#' @param quiet Logical, to determine if the message about creating new columns should be printed or not.
#' @param ... passes other arguments supplied to the `vroom::vroom()` used
#'   behind the hood.
#'
#' @return read_ndr
#' @export
#'
#' @examples
#' # Read \code{ndr_example.csv} from a path
#' file_path <- system.file("extdata", "ndr_example.csv", package = "tidyndr")
#' read_ndr(file_path, time_stamp = "2021-02-15")
#'
#' ## Not run:
#' # Read using a link to the NDR csv file on the internet
#' file_path <- "https://raw.githubusercontent.com/stephenbalogun/example_files/main/ndr_example.csv"
#' read_ndr(file_path, time_stamp = "2021-02-15")
read_ndr <- function(path,
                     time_stamp,
                     cols = NULL,
                     quiet = FALSE,
                     ...) {
  if (rlang::is_missing(time_stamp)) {
    rlang::abort("time_stamp value is missing. Please supply a date to the `time_stamp` argument")
  }

  if (rlang::is_na(lubridate::as_date(time_stamp))) {
    rlang::abort("the date supplied to time_stamp is not in the 'yyyy-mm-dd' format.")
  }

  if (lubridate::as_date(time_stamp) > Sys.Date()) {
    rlang::abort("The date supplied to the `time_stamp` argument cannot be in the future!")
  }

  df <- tryCatch(
    error = function(cnd) {
      vroom::vroom(path, col_types = old_cols(), ...)
    },
    vroom::vroom(path, col_types = cols %||% current_cols(), ...)
  )

  df <- dplyr::mutate(
    janitor::clean_names(df),
    date_lost = last_drug_pickup_date +
      lubridate::days(days_of_arv_refill) +
      lubridate::days(28),
    current_status = dplyr::if_else(
      date_lost > lubridate::as_date(time_stamp),
      "Active", "Inactive"
    )
  )

  if (quiet == FALSE) {
    message("\nTwo new variables created: \n[1] `date_lost` \n[2] `current_status \n")
  }
  df
}
