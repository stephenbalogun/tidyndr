test_that("tx_ml_outcome works", {
  expect_identical(
    tx_ml(
      new_data = ndr_example,
      from = lubridate::ymd("2020-10-01"),
      to = lubridate::ymd("2021-01-31")
    ) %>%
      tx_ml_outcomes("dead"),
    ndr_example %>%
      dplyr::filter(
        dplyr::between(
          date_lost,
          lubridate::as_date("2020-10-01"),
          lubridate::as_date("2021-01-31")
        ),
        patient_has_died == TRUE
      )
  )
})
