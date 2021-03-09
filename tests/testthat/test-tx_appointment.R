test_that("tx_appointment works", {
  expect_identical(
    tx_appointment(ndr_example,
      from = lubridate::ymd("2021-01-01"),
      to = lubridate::ymd("2021-02-28")
    ),
    ndr_example %>%
      dplyr::filter(
        dplyr::between(
          date_lost - 28,
          lubridate::ymd("2021-01-01"),
          lubridate::ymd("2021-02-28")
        )
      )
  )
})
