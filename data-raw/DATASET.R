## code to prepare `DATASET` dataset goes here

usethis::use_data(DATASET, overwrite = TRUE)


ndr <- vroom::vroom("C:/Users/stephenbalogun/Documents/My R/my files/2021-01-18 patient_line_listing.csv")


examp <- vroom::vroom("C:/Users/stephenbalogun/Documents/My R/my_packages/tidyndr/ndr_example.csv")


set.seed(0012)
ndr_example <- ndr %>%
  sample_n(50000)

ndr_example <- ndr_example %>%
  mutate(IP = "IP_name",
         State = factor(State,
                        levels = c("Nasarawa", "FCT", "Katsina", "Rivers"),
                        labels = c("State 1", "State 2", "State 2", "State 3")))

ndr_example <- ndr_example %>%
  mutate(Facility = examp$facility,
         `DATIM Code` = factor(examp$facility,
                               labels = str_c("datim_code000",
                                              1:length(unique(examp$facility)))),
         LGA = factor(Facility,
                      labels = str_c("LGA00",
                                     1:length(unique(examp$facility))))) %>%
  group_by(State) %>%
  mutate(`Patient Identifier` = str_c(State, "00", row_number(), sep = "")) %>%
  ungroup() %>%
  group_by(State, Facility) %>%
  mutate(`Hospital Number` = str_c("000", row_number(), sep = "")) %>%
  ungroup() %>%
  mutate(`Age at ART Initiation` = sample(ndr$`Age at ART Initiation`, 50000),
         `Last Drug Pickup date` = sample(ndr$`Last Drug Pickup date`, 50000),
         `Current Viral Load` = sample(ndr$`Current Viral Load`, 50000))
