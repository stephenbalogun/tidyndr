#' Subset Clients who are Currently on Treatment
#'
#' \code{tx_curr} pulls up the line-list of clients who are active
#'    on treatment using the calculated `current_status` column. You can specify
#'    the state(s) and/or facilit(ies) of interest using the \code{region} or
#'    \code{site} arguments.
#' @param status Determines how the number of active clients is calculated.
#'  The options are to either to use the NDR current_status_28_days column
#'  or the derived current_status column ("calculated").
#'
#' @param quarter the quarter of the fiscal year (based on the PEPFAR calendar) for which the TX_CURR should be calculated.
#' @param ref the referenced date for the analysis. If this is not set (i.e. `NULL`) it will be assumed to be the last day of the quarter.
#' @inheritParams tx_new
#'
#' @return TX_CURR
#' @export
#'
#' @examples
#' # Calculated active clients using the derived current status
#' tx_curr(ndr_example)
#'
#' # Calculate the active clients using the NDR `current_status_28_days` column
#' tx_curr(ndr_example, status = "default")
#'
#' # generate the TX_CURR for two states (e.g. "Arewa" and "Okun" in the ndr_example file)
#' tx_curr(ndr_example,
#'   states = c("Okun", "Arewa")
#' )
#'
#' # determine the active clients in two facilities ("Facility1", and "Facility2) in "Abaji"
#' tx_curr(ndr_example,
#'   states = "Abaji",
#'   facilities = c("Facility1", "Facility2")
#' )
tx_curr <- function(data,
                    states = NULL,
                    facilities = NULL,
                    status = "default",
                    remove_duplicates = FALSE,
                    quarter = NULL,
                    ref = NULL) {


  states <- states %||% unique(data$state)

  facilities <- facilities %||% unique(subset(data, state %in% states)$facility)

  validate_curr(data, states, facilities, status, remove_duplicates, quarter, ref)

  get_tx_curr(data, states, facilities, status, remove_duplicates, quarter, ref)
}


validate_curr <- function(data, states, facilities, status, remove_duplicates, quarter, ref) {
  if (!all(states %in% unique(data$state))) {
    rlang::abort("state(s) is/are not contained in the supplied data. Check the spelling and/or case.")
  }

  if (!all(facilities %in% unique(subset(data, state %in% states)$facility))) {
    rlang::abort("facilit(ies) is/are not found in the data or state supplied.
                 Check that the facility is correctly spelt and located in the state.")
  }

  if (!status %in% c("default", "calculated")) {
    rlang::abort("`status` can only be one of 'default' or 'calculated'. Check that you did not mispell, include CAPS or forget to quotation marks!")
  }

  if (!is.logical(remove_duplicates)) {
    rlang::abort("The `remove_duplicates` argument is a logical variable and can only be set to `TRUE` or `FALSE`")
  }

  if (!is.null(quarter) && !is.numeric(quarter)) {
    rlang::abort("The supplied quarter is not an integer. Kindly a supply whole number")
  }

  if (!is.null(quarter) && quarter > 4) {
    rlang::abort("Kindly supply a whole number between 1 and 4 corresponding to the quarter of the fiscal year")
  }

  if (quarter == 1 && !is.null(ref) && !dplyr::between(lubridate::month(lubridate::ymd(ref)), 10, 12)) {
    rlang::abort("The date referenced appears not to be in Quarter 1 of the PEPFAR FY")
  }


  if (quarter == 2 && !is.null(ref) && !dplyr::between(lubridate::month(lubridate::ymd(ref)), 1, 3)) {
    rlang::abort("The date referenced appears not to be in Quarter 2 of the PEPFAR FY")
  }

  if (quarter == 3 && !is.null(ref) && !dplyr::between(lubridate::month(lubridate::ymd(ref)), 4, 6)) {
    rlang::abort("The date referenced appears not to be in Quarter 3 of the PEPFAR FY")
  }


  if (quarter == 4 && !is.null(ref) && !dplyr::between(lubridate::month(lubridate::ymd(ref)), 7, 9)) {
    rlang::abort("The date referenced appears not to be in Quarter 4 of the PEPFAR FY")
  }


  if (!is.null(ref) && is.na(lubridate::ymd(ref))) {
    rlang::abort("The supplied date to the `ref` argument is not in the right format. Did you remember to
                 enter the date in 'yyyy-mm-dd' or forget the quotation marks?")
  }

  if (status == "calculated" && is.null(ref)) {
    rlang::abort("Kindly supply a `ref` argument in the format 'yyyy-mm-dd'")
  }
}

get_tx_curr <- function(data,
                        states,
                        facilities,
                        status,
                        remove_duplicates,
                        quarter = NULL,
                        ref = NULL) {

  ref_date <- lubridate::ymd(ref)

  if(is.null(quarter)) {

    df <- switch(status,
                 "calculated" = dplyr::filter(
                   data,
                   current_status == "Active",
                   patient_deceased_date <= ref_date | is.na(patient_deceased_date),
                   state %in% states,
                   facility %in% facilities,
                   art_start_date <= ref_date,
                   transferred_in_date <= ref_date | is.na(transferred_in_date),
                   transferred_out_date <= ref_date | is.na(transferred_out_date),
                 ),
                 "default" = dplyr::filter(
                   data,
                   current_status_28_days == "Active",
                   state %in% states,
                   facility %in% facilities
                 )
    )

  } else {

    df <-  switch(quarter,
                  `1` = {

                    switch(status,
                           "calculated" = dplyr::filter(
                             data,
                             current_status == "Active",
                             patient_deceased_date <= ref_date | is.na(patient_deceased_date),
                             state %in% states,
                             facility %in% facilities,
                             art_start_date <= ref_date,
                             transferred_in_date <= ref_date | is.na(transferred_in_date),
                             transferred_out_date <= ref_date | is.na(transferred_out_date),
                             current_status_q1_28_days == "Active",
                           ),
                           "default" = dplyr::filter(
                             data,
                             current_status_q1_28_days == "Active",
                             state %in% states,
                             facility %in% facilities
                           )
                    )

                  },

                  `2` = {

                    switch(status,
                           "calculated" = dplyr::filter(
                             data,
                             current_status == "Active",
                             patient_deceased_date <= ref_date | is.na(patient_deceased_date),
                             state %in% states,
                             facility %in% facilities,
                             art_start_date <= ref_date,
                             transferred_in_date <= ref_date | is.na(transferred_in_date),
                             transferred_out_date <= ref_date | is.na(transferred_out_date),
                             current_status_q2_28_days == "Active",
                             state %in% states,
                             facility %in% facilities
                           ),
                           "default" = dplyr::filter(
                             data,
                             current_status_q2_28_days == "Active",
                             state %in% states,
                             facility %in% facilities
                           )
                    )

                  },

                  `3` = {

                    switch(status,
                           "calculated" = dplyr::filter(
                             data,
                             current_status == "Active",
                             patient_deceased_date <= ref_date | is.na(patient_deceased_date),
                             state %in% states,
                             facility %in% facilities,
                             art_start_date <= ref_date,
                             transferred_in_date <= ref_date | is.na(transferred_in_date),
                             transferred_out_date <= ref_date | is.na(transferred_out_date),
                             current_status_q3_28_days == "Active",
                             state %in% states,
                             facility %in% facilities
                           ),
                           "default" = dplyr::filter(
                             data,
                             current_status_q3_28_days == "Active",
                             state %in% states,
                             facility %in% facilities
                           )
                    )

                  },

                  `4` = {

                    switch(status,
                           "calculated" = dplyr::filter(
                             data,
                             current_status == "Active",
                             patient_deceased_date <= ref_date | is.na(patient_deceased_date),
                             state %in% states,
                             facility %in% facilities,
                             art_start_date <= ref_date,
                             transferred_in_date <= ref_date | is.na(transferred_in_date),
                             transferred_out_date <= ref_date | is.na(transferred_out_date),
                             current_status_q4_28_days == "Active",
                             state %in% states,
                             facility %in% facilities
                           ),
                           "default" = dplyr::filter(
                             data,
                             current_status_q4_28_days == "Active",
                             state %in% states,
                             facility %in% facilities
                           )
                    )

                  }
    )


  }



  if (remove_duplicates) {
    df <- dplyr::distinct(df, facility, patient_identifier, .keep_all = TRUE)
  }

  return(df)
}

utils::globalVariables(
  c(
    "current_status",
    "patient_has_died",
    "patient_transferred_out",
    "patient_deceased_date",
    "transferred_in_date",
    "transferred_out_date"
  )
)
