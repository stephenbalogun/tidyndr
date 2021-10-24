#' Import NDR Line-lists into R
#'
#' Import the basic NDR patient-level line lists (treatment, recent infection, and HTS) into R. Column names and types are appropriately formatted using the \code{type} argument.
#' @param path Path to the csv file on your computer. The file path should be specified in the
#' format "C:/users/Desktop/your file.csv" or something similar.
#' @param type type of line list to be imported. Currently, the `read_ndr()` supports any of `treatment`, `recency` or `hts` line-lists.
#' @param ... passes other arguments supplied based on the specific NDR line-list to be read. NDR treatment line-list requires the
#' \code{time_stamp} argument for the day of reference of the treatment line-list, and an optional \code{quiet} argument (which
#' defaults to FALSE) denoting if R should also print the message about the new columns created. An optional \code{cols} can also
#' be used to supply specific column type to allow the user control over the variable types should the default satisfy the user need.
#' @return nicely formatted line-list
#' @export read_ndr
#'
#' @examples
#' # Read \code{ndr_example.csv} from a path
#' \donttest{
#' file_path <- system.file("extdata", "ndr_example.csv", package = "tidyndr")
#' read_ndr(file_path, time_stamp = "2021-02-15")
#' }
#' # Read using a link to the NDR csv file on the internet
#' \donttest{
#' file_path <- "https://raw.githubusercontent.com/stephenbalogun/example_files/main/ndr_example.csv"
#' read_ndr(file_path, time_stamp = "2021-02-15")
#' }

read_ndr <-  function(
  path,
  type = "treatment",
  ...
  ) {

  if (!any(ndr_types() == type)) {
    rlang::abort("line list type  is not one of 'recency', 'hts' or 'treatment'. Check for spelling mistakes or wrong capitalization")
  }

  class(path) <- type

  read(path, ...)
}



read <- function(path, ...) {
  UseMethod("read")
}



read.treatment <- function (path, time_stamp, cols = NULL, quiet = FALSE,  ...) {
  df <- tryCatch(error = function(cnd) {
    vroom::vroom(path, col_types = old_cols(), ...)
  }, vroom::vroom(path, col_types = cols %||% current_cols(),
                  ...))
  df <- dplyr::mutate(janitor::clean_names(df), date_lost = last_drug_pickup_date +
                        lubridate::days(days_of_arv_refill) + lubridate::days(28),
                      appointment_date = last_drug_pickup_date + lubridate::days(days_of_arv_refill),
                      current_status = dplyr::case_when(date_lost >= lubridate::as_date(time_stamp) ~
                                                          "Active", date_lost < lubridate::as_date(time_stamp) ~
                                                          "Inactive", is.na(time_stamp) ~ "skipped"))
  if (!quiet) {
    message("\nThree new variables created: \n[1] `date_lost` \n[2] `appointment_date \n[2] `current_status\n")
  }


  return(df)
}




read.hts <- function(path, cols = NULL, ...) {
  df <- tryCatch(error = function(cnd) {
    vroom::vroom(path)
  },
  vroom::vroom(path, col_types = cols %||% hts_cols(), na = c("NULL", ""), ...))

  return(janitor::clean_names(df))

}



read.recency <- function(path, cols = NULL, ...) {
  df <- tryCatch(error = function(cnd) {
    vroom::vroom(path)
  },
  vroom::vroom(path, col_types = cols %||% recency_cols(), ...)) %>%
    purrr::modify_if(is.factor, ~dplyr::na_if(., "NULL")) %>%
    purrr::modify_if(is.factor, forcats::fct_drop)

  return(janitor::clean_names(df))
}
