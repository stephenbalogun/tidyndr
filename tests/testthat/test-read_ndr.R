test_that("read_ndr() reads-in NDR '.csv' patient-level line-list", {
  cols <- vroom::cols_only(
    IP = vroom::col_factor(),
    State = vroom::col_factor(),
    LGA = vroom::col_factor(),
    Facility = vroom::col_factor(),
    `DATIM Code` = vroom::col_factor(),
    Sex = vroom::col_factor(),
    `Patient Identifier` = vroom::col_character(),
    `Hospital Number` = vroom::col_character(),
    `Date Of Birth` = vroom::col_date(format = "%d-%m-%y"),
    `Age at ART Initiation` = vroom::col_double(),
    `Current Age` = vroom::col_double(),
    `ART Start Date` = vroom::col_date(format = "%d-%b-%y"),
    `ART Start Date Source` = vroom::col_factor(),
    `Last Drug Pickup date` = vroom::col_date(format = "%d-%b-%y"),
    `Last Drug Pickup date Q1` = vroom::col_date(format = "%d-%b-%y"),
    `Last Drug Pickup date Q2` = vroom::col_date(format = "%d-%b-%y"),
    `Last Drug Pickup date Q3` = vroom::col_date(format = "%d-%b-%y"),
    `Last Drug Pickup date Q4` = vroom::col_date(format = "%d-%b-%y"),
    `Last Regimen` = vroom::col_factor(),
    `Last Clinic Visit Date` = vroom::col_date(format = "%d-%b-%y"),
    `Days Of ARV Refill` = vroom::col_double(),
    `Pregnancy Status` = vroom::col_factor(),
    `Current Viral Load` = vroom::col_double(),
    `Date Of Current Viral Load` = vroom::col_date(format = "%d-%b-%y"),
    `Current Viral Load Q1` = vroom::col_double(),
    `Date Of Current Viral Load Q1` = vroom::col_date(format = "%d-%b-%y"),
    `Current Viral Load Q2` = vroom::col_double(),
    `Date Of Current Viral Load Q2` = vroom::col_date(format = "%d-%b-%y"),
    `Current Viral Load Q3` = vroom::col_double(),
    `Date Of Current Viral Load Q3` = vroom::col_date(format = "%d-%b-%y"),
    `Current Viral Load Q4` = vroom::col_double(),
    `Date Of Current Viral Load Q4` = vroom::col_date(format = "%d-%b-%y"),
    `Current Status (28 Days)` = vroom::col_factor(),
    `Current Status (90 Days)` = vroom::col_factor(),
    `Current Status Q1 (28 Days)` = vroom::col_factor(),
    `Current Status Q1 (90 Days)` = vroom::col_factor(),
    `Current Status Q2 (28 Days)` = vroom::col_factor(),
    `Current Status Q2 (90 Days)` = vroom::col_factor(),
    `Current Status Q3 (28 Days)` = vroom::col_factor(),
    `Current Status Q3 (90 Days)` = vroom::col_factor(),
    `Current Status Q4 (28 Days)` = vroom::col_factor(),
    `Current Status Q4 (90 Days)` = vroom::col_factor(),
    `Patient Has Died` = vroom::col_logical(),
    `Patient Deceased Date` = vroom::col_date(format = "%d-%b-%y"),
    `Patient Transferred Out` = vroom::col_logical(),
    `Transferred Out Date` = vroom::col_date(format = "%d-%b-%y"),
    `Patient Transferred In` = vroom::col_logical(),
    `Transferred In Date` = vroom::col_date(format = "%d-%b-%y")
  )

  file_path <- "C:/Users/stephenbalogun/Documents/My R/tidyndr/ndr_example.csv"

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
