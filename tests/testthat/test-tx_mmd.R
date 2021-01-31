test_that("tx_mmd works", {
  expect_identical(tx_mmd(ndr_example),
                   ndr_example %>%
                     dplyr::mutate(months_dispensed = round(days_of_arv_refill / 30, 0)) %>%
                     subset(current_status_28_days == "Active" &
                              months_dispensed %in% c(3, 4, 5, 6)))
})
