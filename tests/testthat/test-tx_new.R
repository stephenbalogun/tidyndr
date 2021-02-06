test_that("tx_new captures all and only new clients", {
  expect_identical(
    tx_new(
      ndr_example,
      lubridate::ymd("2020-10-01"),
      lubridate::ymd("2020-12-31")
    ),
    ndr_example %>%
      dplyr::filter(dplyr::between(
        art_start_date,
        lubridate::ymd("2020-10-01"),
        lubridate::ymd("2020-12-31")
      ))
  )
})
