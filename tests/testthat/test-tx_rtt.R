test_that("tx_rtt works", {
  file_path <- "https://raw.githubusercontent.com/stephenbalogun/example_files/main/ndr_example.csv"

  old_data <- read_ndr(file_path, time_stamp = "2021-02-15")

  losses <- dplyr::filter(
    old_data,
    current_status_28_days == "Inactive"
  )

  expect_identical(
    tx_rtt(old_data, new_data = ndr_example, status = "default"),
    ndr_example %>%
      subset(current_status_28_days == "Active" &
        patient_identifier %in% losses$patient_identifier)
  )
})
