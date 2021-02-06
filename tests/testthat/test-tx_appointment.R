test_that("tx_appointment works", {
  expect_identical(
    tx_appointment(ndr_example,
      from = lubridate::ymd("2020-10-01"),
      to = lubridate::ymd("2021-01-31")
    ),
    ndr_example %>%
      dplyr::mutate(appointment_date = last_drug_pickup_date +
        lubridate::days(days_of_arv_refill)) %>%
      dplyr::filter(
        current_status_28_days == "Active",
        dplyr::between(
          appointment_date,
          lubridate::ymd("2020-10-01"),
          lubridate::ymd("2021-01-31")
        )
      )
  )
})
