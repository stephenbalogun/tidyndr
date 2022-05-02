test_that("read_ndr() reads-in NDR '.csv' patient-level line-list", {
  cols <- vroom::cols_only(
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_character(),
    vroom::col_character(),
    vroom::col_date(format = "%d-%m-%y"),
    vroom::col_double(),
    vroom::col_double(),
    vroom::col_date(format = "%d-%b-%y"),
    vroom::col_factor(),
    vroom::col_date(format = "%d-%b-%y"),
    vroom::col_date(format = "%d-%b-%y"),
    vroom::col_date(format = "%d-%b-%y"),
    vroom::col_date(format = "%d-%b-%y"),
    vroom::col_date(format = "%d-%b-%y"),
    vroom::col_factor(),
    vroom::col_date(format = "%d-%b-%y"),
    vroom::col_double(),
    vroom::col_factor(),
    vroom::col_double(),
    vroom::col_date(format = "%d-%b-%y"),
    vroom::col_double(),
    vroom::col_date(format = "%d-%b-%y"),
    vroom::col_double(),
    vroom::col_date(format = "%d-%b-%y"),
    vroom::col_double(),
    vroom::col_date(format = "%d-%b-%y"),
    vroom::col_double(),
    vroom::col_date(format = "%d-%b-%y"),
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_factor(),
    vroom::col_logical(),
    vroom::col_date(format = "%d-%b-%y"),
    vroom::col_logical(),
    vroom::col_date(format = "%d-%b-%y"),
    vroom::col_logical(),
    vroom::col_date(format = "%d-%b-%y"),
    vroom::col_character()
  )


  file_path <- system.file("extdata", "ndr_example.csv", package = "tidyndr")

  expect_identical(
    names(read_ndr(file_path, time_stamp = "2021-02-15", quiet = TRUE)),
    names(
      suppressWarnings(
        vroom::vroom(file_path, col_types = cols) %>%
          janitor::clean_names() %>%
          dplyr::mutate(
            date_lost = last_drug_pickup_date +
              lubridate::days(days_of_arv_refill) +
              lubridate::days(28),
            appointment_date = last_drug_pickup_date +
              lubridate::days(days_of_arv_refill),
            current_status = dplyr::if_else(
              date_lost >
                lubridate::as_date("2021-02-15"),
              "Active", "Inactive"
            )
          )
      )
    )
  )
})
