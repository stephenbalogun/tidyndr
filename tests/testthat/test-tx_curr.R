test_that("tx_curr filters only active clients", {
  expect_identical(
    tx_curr(ndr_example, status = "default"),
    ndr_example %>%
      subset(current_status_28_days == "Active" &
               !patient_has_died %in% TRUE &
               !patient_transferred_out %in% TRUE)
  )
})
