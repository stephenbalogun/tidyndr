test_that("tx_rtt works", {
  file_path <- system.file("extdata", "ndr_example.csv", package = "tidyndr")

  old_data <- read_ndr(file_path)

  losses <- dplyr::filter(
    old_data,
    current_status_28_days == "Inactive"
  )

  expect_identical(
    tx_rtt(old_data, ndr_example),
    ndr_example %>%
      subset(current_status_28_days == "Active" &
        patient_identifier %in% losses$patient_identifier)
  )
})
