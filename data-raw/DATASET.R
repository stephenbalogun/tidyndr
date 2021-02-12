## code to prepare `DATASET` dataset goes here

usethis::use_data(DATASET, overwrite = TRUE)


ndr <- vroom::vroom("C:/Users/stephenbalogun/Documents/My R/my files/2021-02-07 patient_line_listing.csv")


examp <- vroom::vroom("C:/Users/stephenbalogun/Documents/My R/my_packages/tidyndr/ndr_example.csv")

library(tidyverse)

set.seed(0012)
ndr_example <- ndr %>%
  dplyr::sample_n(50000)

ndr_example <- ndr_example %>%
  mutate(
    IP = "IP_name",
    State = factor(State,
      levels = c("Nasarawa", "FCT", "Katsina", "Rivers"),
      labels = c("State 1", "State 2", "State 2", "State 3")
    )
  )

ndr_example <- ndr_example %>%
  mutate(
    Facility = examp$facility,
    `DATIM Code` = factor(examp$facility,
      labels = str_c(
        "datim_code000",
        1:length(unique(examp$facility))
      )
    ),
    LGA = factor(Facility,
      labels = str_c(
        "LGA00",
        1:length(unique(examp$facility))
      )
    )
  ) %>%
  group_by(State) %>%
  mutate(`Patient Identifier` = str_c(State, "00", row_number(), sep = "")) %>%
  ungroup() %>%
  group_by(State, Facility) %>%
  mutate(`Hospital Number` = str_c("000", row_number(), sep = "")) %>%
  ungroup() %>%
  mutate(
    `Age at ART Initiation` = sample(ndr$`Age at ART Initiation`, 50000),
    `Last Drug Pickup date` = sample(ndr$`Last Drug Pickup date`, 50000),
    `Current Viral Load` = sample(ndr$`Current Viral Load`, 50000)
  )

### save the ndr_example csv file (n = 5000) for shipping with the package
write_csv(sample_n(ndr_example, 5000),
          "C:/Users/stephenbalogun/Documents/My R/tidyndr/inst/extdata/ndr_example.csv",
          na = "")

### save the ndr_example csv file for pushing to github (n = 50, 000)e
path <- "C:/Users/stephenbalogun/Documents/My R/example_files/ndr_example.csv"

write_csv(ndr_example, path, na = "")

#### read the ndr_example (n = 50, 000) for package as .rda file
ndr_example <- tidyndr::read_ndr(path)
usethis::use_data(ndr_example, overwrite = TRUE)



