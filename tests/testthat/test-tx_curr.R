test_that("tx_curr filters only active clients", {
  expect_identical(
    tx_curr(ndr_example, status = "default"),
    ndr_example %>%
      subset(current_status_28_days == "Active")
  )
})
