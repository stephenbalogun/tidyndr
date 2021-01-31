test_that("tx_regimen works", {
  expect_identical(tx_regimen(ndr_example),
                   ndr_example %>%
                     subset(current_status_28_days == "Active" &
                              ifelse(current_age <= 3,
                                     last_regimen %in% c("ABC-3TC-LPV/r",
                                                         "AZT-3TC-LPV/r"),
                                     last_regimen %in% c("ABC-3TC-DTG",
                                                         "TDF-3TC-DTG"))))
})
