## code to prepare `DATASET` dataset goes here

usethis::use_data(DATASET, overwrite = TRUE)


# ndr <- vroom::vroom("C:/Users/stephenbalogun/Documents/My R/my files/2021-02-07 patient_line_listing.csv")


ndr <- vroom::vroom("C:/Users/DR. BALOGUN STEPHEN/OneDrive - Catholic Caritas Foundation/Documents/My R/my files/CCFN/raw/2021-12-15 Patient_Line_List.csv")


# examp <- vroom::vroom("C:/Users/stephenbalogun/Documents/My R/my_packages/tidyndr/ndr_example.csv")

examp2 <- vroom::vroom("C:/Users/DR. BALOGUN STEPHEN/OneDrive - Catholic Caritas Foundation/Documents/My R/my_packages/tidyndr/ndr_example2.csv")


library(tidyverse)
library(lubridate)

set.seed(0012)

ndr_example2 <- ndr %>%
  dplyr::sample_n(50000)

# ndr_example <- ndr_example2 %>%
#   mutate(
#     IP = "Ip_NAME",
#     State = factor(State,
#       levels = c("Nasarawa", "FCT", "Katsina", "Rivers"),
#       labels = c("State 1", "State 2", "State 2", "State 3")
#     )
#   )

ndr_example <- ndr_example2 %>%
  mutate(
    IP = "NGOHealth",
    State = examp2$state,
    Facility = examp2$facility,
    `DATIM Code` = factor(examp2$facility,
      labels = str_c(
        "datim_code000",
        1:length(unique(examp2$facility))
      )
    ),
    LGA = examp2$lga,
    `Patient Identifier` = examp2$patient_identifier
    # LGA = factor(Facility,
    #   labels = str_c(
    #     "LGA00",
    #     1:length(unique(examp$facility))
    #   )
    # )
  ) %>%
  # group_by(State) %>%
  # mutate(`Patient Identifier` = str_c(State, "00", row_number(), sep = "")) %>%
  # ungroup() %>%
  group_by(State, Facility) %>%
  mutate(`Hospital Number` = str_c("000", row_number(), sep = "")) %>%
  ungroup() %>%
  mutate(
    `ART Start Date` = sample(ndr$`ART Start Date`, 50000),
    `Last Drug Pickup date` = sample(ndr$`Last Drug Pickup date`, 50000),
    `Current Viral Load` = sample(ndr$`Current Viral Load`, 50000)
  )

### save the ndr_example csv file (n = 3000) for shipping with the package
write_csv(sample_n(ndr_example, 3000),
  "C:/Users/DR. BALOGUN STEPHEN/OneDrive - Catholic Caritas Foundation/Documents/My R/tidyndr/inst/extdata/ndr_example2.csv",
  na = ""
)

### save the ndr_example csv file for pushing to github (n = 50, 000)
path <- "C:/Users/DR. BALOGUN STEPHEN/OneDrive - Catholic Caritas Foundation/Documents/My R/example_files/ndr_example2.csv"

write_csv(ndr_example, path, na = "")

#### read the ndr_example (n = 50, 000) for package as .rda file
ndr_example <- tidyndr::read_ndr(path, time_stamp = "2021-12-15")
usethis::use_data(ndr_example, overwrite = TRUE)


path2 <- "C:/Users/DR. BALOGUN STEPHEN/OneDrive - Catholic Caritas Foundation/Documents/My R/example_files/ndr_example.csv"
ndr_example <- tidyndr::read_ndr(path2, time_stamp = "2021-02-20")
usethis::use_data(ndr_example, overwrite = TRUE)





# Recency dataset -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

library(naijR)


recency_df <- vroom::vroom("C:/Users/DR. BALOGUN STEPHEN/OneDrive - Catholic Caritas Foundation/Documents/My R/my files/CCFN/Recency/2021-12-03 recency_line_listing.csv")



recency_example <- recency_df %>%
  dplyr::sample_n(10000)

recency_example <- recency_example %>%
  mutate(
    IP = "NGOHealth",
    `Facility State` = sample(examp2$state, 10000, FALSE),
    `Client State` = sample(c(sample(states(), 10, FALSE), unique(examp2$state)), 10000, TRUE),
    `Client LGA` = sample(c(sample(lgas(), 50, FALSE), unique(examp2$lga)), 10000, TRUE),
    Facility = sample(examp2$facility, 10000, replace = FALSE),
    `DATIM Code` = factor(sample(examp2$facility, 10000, FALSE),
                          labels = str_c(
                            "datim_code000",
                            1:length(unique(examp2$facility))
                          )
    ),
    `Facility LGA` = sample(examp2$lga, 10000, FALSE),
    `Client ID` = sample(examp2$patient_identifier, 10000, FALSE)
  ) %>%
  group_by(`Facility State`) %>%
  mutate(`Recency Number` = str_c("300", row_number(), sep = ""),
         `Client Code` = str_c("CBO", sample(1:9, 1), sample(1:12, 1), 2021, `Facility State`, sep = "/")) %>%
  ungroup() %>%
  mutate(
    `Visit Date` = sample(recency_df$`Visit Date`, 10000, FALSE),
    Sex = sample(recency_df$Sex, 10000, FALSE)
    )

### save the ndr_example csv file (n = 5000) for shipping with the package
write_csv(sample_n(recency_example, 1000),
          "C:/Users/DR. BALOGUN STEPHEN/OneDrive - Catholic Caritas Foundation/Documents/My R/tidyndr/inst/extdata/recency_example.csv",
          na = ""
)

### save the ndr_example csv file for pushing to github (n = 50, 000)e
path <- "C:/Users/DR. BALOGUN STEPHEN/OneDrive - Catholic Caritas Foundation/Documents/My R/example_files/recency_example.csv"

write_csv(recency_example, path, na = "")

#### read the recency_example (n = 10, 000) for package as .rda file
recency_example <- tidyndr::read_ndr(path, type = "recency")
usethis::use_data(recency_example, overwrite = TRUE)


