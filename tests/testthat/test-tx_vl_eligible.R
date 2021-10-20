test_that("tx_vl_eligible filters only clients eligible for VL", {
  expect_identical(
    tx_vl_eligible(
      ndr_example,
      status = "default",
      lubridate::ymd("2021-03-31")
    ),
    ndr_example %>%
      subset(current_status_28_days == "Active" &
               !patient_has_died %in% TRUE &
               !patient_transferred_out %in% TRUE &
        lubridate::as_date("2021-03-31") - art_start_date >=
          lubridate::period(6, "months"))
  )
})
