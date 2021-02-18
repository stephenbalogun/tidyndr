#' Read NDR "csv" file
#'
#' Import your NDR patient-level line-list downloaded as ".csv" format from the
#' NDR front-end into R in a nicely formatted table.
#'
#' @param path Path to the csv file on computer.
#' @param file_type One of three options to specify if an old, a current version
#' or a new(er) version of the ndr line-list will be used. The old version was changed
#' to the current version at about the beginning of Fiscal Year 2021.
#' @param cols Sets the column types so that the columns are assigned the
#'   appropriate class. You can supply this argument following the instructions
#'   in `?vroom::cols` documentation.
#' @param ... passes other arguments supplied to the `vroom::vroom()` used
#'   behind the hood.
#'
#' @return read_ndr
#' @export
#'
#' @examples
#' # Read \code{ndr_example.csv} from a path
#' file_path <- system.file("extdata", "ndr_example.csv", package = "tidyndr")
#' read_ndr(file_path)
#'
#' ## Not run:
#' # Read using a link to the NDR csv file on the internet
#' file_path <- "https://raw.githubusercontent.com/stephenbalogun/example_files/main/ndr_example.csv"
#' read_ndr(file_path)
read_ndr <- function(path,
                     file_type = "current",
                     cols = ndr_cols,
                     ...) {
  current_cols <- vroom::cols_only(
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_character(),
    vroom::col_character(),
    vroom::col_date(),
    vroom::col_double(),
    vroom::col_double(),
    vroom::col_date(format = "%d-%b-%Y"),
    vroom::col_factor(),
    vroom::col_date(format = "%d-%b-%Y"),
    vroom::col_date(format = "%d-%b-%Y"),
    vroom::col_date(format = "%d-%b-%Y"),
    vroom::col_date(format = "%d-%b-%Y"),
    vroom::col_date(format = "%d-%b-%Y"),
    vroom::col_factor(),
    vroom::col_date(format = "%d-%b-%Y"),
    vroom::col_double(),
    vroom::col_factor(),
    vroom::col_double(),
    vroom::col_date(format = "%d-%b-%Y"),
    vroom::col_double(),
    vroom::col_date(format = "%d-%b-%Y"),
    vroom::col_double(),
    vroom::col_date(format = "%d-%b-%Y"),
    vroom::col_double(),
    vroom::col_date(format = "%d-%b-%Y"),
    vroom::col_double(),
    vroom::col_date(format = "%d-%b-%Y"),
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_logical(),
    vroom::col_date(format = "%d-%b-%Y"),
    vroom::col_logical(),
    vroom::col_date(format = "%d-%b-%Y"),
    vroom::col_logical(),
    vroom::col_date(format = "%d-%b-%Y"),
    vroom::col_skip()
  )


  old_cols <- vroom::cols_only(
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_character(),
    vroom::col_character(),
    vroom::col_date(),
    vroom::col_double(),
    vroom::col_double(),
    vroom::col_date(format = "%d-%b-%Y"),
    vroom::col_date(format = "%d-%b-%Y"),
    vroom::col_date(format = "%d-%b-%Y"),
    vroom::col_date(format = "%d-%b-%Y"),
    vroom::col_date(format = "%d-%b-%Y"),
    vroom::col_factor(),
    vroom::col_date(format = "%d-%b-%Y"),
    vroom::col_double(),
    vroom::col_factor(),
    vroom::col_double(),
    vroom::col_date(format = "%d-%b-%Y"),
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_logical(),
    vroom::col_date(format = "%d-%b-%Y"),
    vroom::col_logical(),
    vroom::col_date(format = "%d-%b-%Y"),
    vroom::col_date(format = "%d-%b-%Y"),
    vroom::col_skip()
  )

  if (file_type == "current") {
    ndr_cols <- current_cols
  } else if (file_type == "old") {
    ndr_cols <- old_cols
  } else if (file_type == "new") {
    ndr_cols <- cols
  }

  if (any(!file_type %in% c("current", "old", "new"))) {
    stop("`file_type` must be set to either 'current', 'old' or 'new")
  }


  if (file_type != "new") {
    janitor::clean_names(
      vroom::vroom(path, col_types = cols, ...)
    )
  } else {
    janitor::clean_names(
      vroom::vroom(path, ...)
    )
  }
}
