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
    vroom::col_skip()
  )


  file_path <- system.file("extdata", "ndr_example.csv", package = "tidyndr")

  expect_identical(
    names(read_ndr(file_path)),
    names(
      suppressWarnings(
        vroom::vroom(file_path, col_types = cols) %>%
          janitor::clean_names()
      )
    )
  )
})
