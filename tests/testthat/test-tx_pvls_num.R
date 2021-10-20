test_that("tx_pvls_num works", {
  expect_identical(
    tx_pvls_num(
      ndr_example,
      status = "default",
      lubridate::ymd("2021-03-31")
    ),
    ndr_example %>%
      subset(current_status_28_days == "Active" &
               !patient_has_died %in% TRUE &
             !patient_transferred_out %in% TRUE &
        lubridate::as_date("2021-03-31") - art_start_date >=
          lubridate::period(6, "months") &
        dplyr::if_else(
          current_age < 20,
          lubridate::as_date("2021-03-31") -
            date_of_current_viral_load <=
            lubridate::period(6, "months"),
          lubridate::as_date("2021-03-31") -
            date_of_current_viral_load <=
            lubridate::period(1, "year")
        ) &
        current_viral_load < 1000)
  )
})
