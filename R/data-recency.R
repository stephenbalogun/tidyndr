#' Line-list of 10,000 Simulated Clients Provided in the NDR Format.
#'
#' A dataset of randomly generated HIV-1 recent infection line-list to simulate
#' the NDR patient recency line-list.
#'
#' @format A data frame with 10000 rows and 36 variables:
#' \describe{
#'   \item{ip}{Implementing Partner}
#'   \item{facility_state}{State of registration of recency facility}
#'   \item{facility_lga}{Local Government Area where client was registered}
#'   \item{facility}{Facility where the recent infection testing took place}
#'   \item{datim_code}{'DATIM CODE' of the facility of registration}
#'   \item{client_state}{State of resident of client}
#'   \item{client_lga}{Local Government Area where client is resident}
#'   \item{client_code}{registration number assigned to client at testing point}
#'   \item{sex}{The gender that the client identified as, "M" or "F"}
#'   \item{date_of_birth}{Birth day of client, in "yyyy-dd-mm"}
#'   \item{age}{Age of client as at when the recent infection testing took place}
#'   \item{age_group}{age-band of clients based on the MER classification}
#'   \item{client_id}{unique identifier assigned to client}
#'   \item{visit_date}{Date when HIV testing services was offered}
#'   \item{hts_screening_result}{Outcome of the first HIV testing offered}
#'   \item{hts_result}{interpretation of the HTS screening}
#'   \item{hts_confirmatory_result}{Outcome of second HIV testing offered}
#'   \item{hts_tie_breaker_result}{Outcome of third HIV testing offered (when required)}
#'   \item{testing_point}{Place where the HIV testing was conducted}
#'   \item{index_client}{is the client a result of Index Testing Services}
#'   \item{opt_out}{Did the client opt out of recency testing?}
#'   \item{recency_test_name}{Name of testing kit used for the recent infection testing}
#'   \item{recency_test_date}{Date when the recency testing was conducted}
#'   \item{recency_number}{Number assigned during recency testing}
#'   \item{control_line}{Was the control line visible on the Asante kit during testing?}
#'   \item{verification_line}{Was the verification_line visible during testing?}
#'   \item{longterm_line}{Was the longterm line visible during testing?}
#'   \item{recency_interpretation}{Interpretation of the rapid testing for recency}
#'   \item{final_recency_result}{The final recency outcome following Viral Load}
#'   \item{viral_load_requested}{Was the viral load of the client requested?}
#'   \item{viral_load_result}{The viral load count of the client}
#'   \item{date_of_viral_load_result}{The date the viral load result was released}
#'   \item{date_sample_collected}{The date of viral load sample collection}
#'   \item{date_sample_sent}{The date the collected viral load sample was sent for assay}
#'   \item{pcr_lab}{laboratory where recency viral load is analyzed}
#'   \item{x36}{column missing column name and containing negligible entries}
#'   }
#' @note for more information, kindly visit \url{https://ndr.phis3project.org.ng/}
"recency_example"
