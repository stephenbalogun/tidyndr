test_that("tx_rtt works", {
  file_path <- "https://raw.githubusercontent.com/stephenbalogun/example_files/main/ndr_example.csv"

  old_data <- read_ndr(file_path, time_stamp = "2021-02-15")

  losses <- dplyr::filter(
    old_data,
    current_status_28_days == "Inactive"
  )

  expect_identical(
    tx_rtt(new_data = ndr_example, old_data, status = "default"),
    ndr_example %>%
      subset(current_status_28_days == "Active" &
               !patient_has_died %in% TRUE &
             !patient_transferred_out %in% TRUE &
        patient_identifier %in% losses$patient_identifier)
  )
})
