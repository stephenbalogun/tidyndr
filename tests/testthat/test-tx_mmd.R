test_that("tx_mmd works", {
  expect_identical(
    tx_mmd(ndr_example, status = "default"),
    ndr_example %>%
      dplyr::mutate(months_dispensed = floor(days_of_arv_refill / 30)) %>%
      subset(current_status_28_days == "Active" &
        months_dispensed %in% c(3, 4, 5, 6))
  )
})
