test_that("tx_mmd works", {
  expect_identical(
    tx_mmd(ndr_example, status = "default"),
    ndr_example %>%
      dplyr::mutate(months_dispensed = floor(days_of_arv_refill / 28)) %>%
      subset(current_status_28_days == "Active" &
               !patient_has_died %in% TRUE &
               !patient_transferred_out %in% TRUE &
        months_dispensed %in% c(3, 4, 5, 6))
  )
})
