test_that("tx_pvls_num works", {
  expect_identical(
    tx_pvls_num(
      ndr_example,
      lubridate::ymd("2021-03-31")
    ),
    ndr_example %>%
      subset(current_status_28_days == "Active" &
        lubridate::as_date("2021-03-31") - art_start_date >=
          lubridate::period(6, "months") &
        ifelse(current_age < 20,
          date_of_current_viral_load >
            lubridate::as_date("2021-03-31") -
              lubridate::period(month = 6),
          date_of_current_viral_load >
            lubridate::as_date("2021-03-31") -
              lubridate::period(year = 1)
        ) &
        current_viral_load < 1000)
  )
})
