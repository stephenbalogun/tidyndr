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
          lubridate::`%m+%`(art_start_date, lubridate::period(6, "months")) <= lubridate::ymd("2021-03-31")
        )
  )
})


