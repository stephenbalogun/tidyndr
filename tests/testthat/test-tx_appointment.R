test_that("tx_appointment works", {
  expect_identical(
    tx_appointment(ndr_example,
      from = lubridate::ymd("2021-01-01"),
      to = lubridate::ymd("2021-02-28"),
      status = "default"
    ),
    ndr_example %>%
      dplyr::filter(
        current_status_28_days == "Active",
        dplyr::between(
          date_lost - 28,
          lubridate::ymd("2021-01-01"),
          lubridate::ymd("2021-02-28")
        )
      )
  )
})
