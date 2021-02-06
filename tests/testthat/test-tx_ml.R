test_that("tx_ml subsets only inactive clients within a period", {
  expect_identical(
    tx_ml(
      ndr_example,
      lubridate::ymd("2020-10-01"),
      lubridate::ymd("2021-01-31")
    ),
    ndr_example %>%
      dplyr::mutate(date_lost = last_drug_pickup_date +
        lubridate::days(days_of_arv_refill) +
        lubridate::days(28)) %>%
      dplyr::filter(dplyr::between(
        date_lost,
        lubridate::as_date("2020-10-01"),
        lubridate::as_date("2021-01-31")
      ))
  )
})
