test_that("tx_pvls_den works", {
  expect_identical(
    tx_pvls_den(
      ndr_example,
      status = "default",
      ref = lubridate::ymd("2021-03-31")
    ),
    ndr_example %>%
      subset(current_status_28_days == "Active" &
        !patient_has_died %in% TRUE &
          lubridate::`%m+%`(art_start_date, lubridate::period(6, "months")) <= lubridate::ymd("2021-03-31") &
        dplyr::if_else(
          current_age < 20,
          lubridate::`%m+%`(date_of_current_viral_load, lubridate::period(6, "months")) > lubridate::ymd("2021-03-31"),
          lubridate::`%m+%`(date_of_current_viral_load, lubridate::period(1, "year")) > lubridate::ymd("2021-03-31")
        ))
  )
})
