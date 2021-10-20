#' Subset active clients based on months of ARV Dispensed
#'
#' Generates list of clients who had 3 - 6 months of ARV dispensed during the
#' medication refill. You can specify the number of month(s) of ARV dispensed
#' by changing the \code{month} argument.
#'
#'
#' @param data An NDR dataframe imported using the `read_ndr()`.
#' @param months The number(s) of months of interest of ARV dispensed. The default is to subset active
#'    clients who had 3 - 6 months of ARV dispensed.
#' @inheritParams tx_new
#' @inheritParams tx_curr
#'
#' @return tx_mmd
#' @export
#'
#' @examples
#' tx_mmd(ndr_example)
#'
#' # subset active clients who had 2 or 4 months of ARV dispensed at last encounter
#' tx_mmd(ndr_example,
#'   months = c(2, 4),
#'   status = "default"
#' )
tx_mmd <- function(data,
                   months = NULL,
                   states = NULL,
                   facilities = NULL,
                   status = "calculated") {

  months <- months %||% c(3, 4, 5, 6)

  states <- states %||% unique(data$state)

  facilities <- facilities %||% unique(subset(data, state %in% states)$facility)

  validate_mmd(data, months, states, facilities, status)

  get_tx_mmd(data, months, states, facilities, status)


}

validate_mmd <- function(data, months, states, facilities, status) {

  if (!is.numeric(months) || any(months < 0)) {
    rlang::abort("The number of months supplied must be numeric, and not a negative number.")
  }


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
}

get_tx_mmd <- function(data, months, states, facilities, status) {

  switch(status,
         "calculated" = dplyr::filter(
           dplyr::mutate(data,
                         months_dispensed = floor(days_of_arv_refill / 28)
           ),
           current_status == "Active",
           !patient_has_died %in% TRUE,
           !patient_transferred_out %in% TRUE,
           months_dispensed %in% months,
           state %in% states,
           facility %in% facilities
         ),
         "default" = dplyr::filter(
           dplyr::mutate(data,
                         months_dispensed = floor(days_of_arv_refill / 28)
           ),
           current_status_28_days == "Active",
           !patient_has_died %in% TRUE,
           !patient_transferred_out %in% TRUE,
           months_dispensed %in% months,
           state %in% states,
           facility %in% facilities
         )
  )
}

utils::globalVariables(c(
  "months_dispensed",
  "current_status"
))
