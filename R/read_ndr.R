read_ndr <- function(path,
                     suppress = FALSE,
                     cols = cols_only(
                       IP = col_factor(),
                       State = col_factor(),
                       LGA = col_factor(),
                       Facility = col_factor(),
                       `DATIM Code` = col_factor(),
                       Sex = col_factor(),
                       `Patient Identifier` = col_character(),
                       `Hospital Number` = col_character(),
                       `Date Of Birth` = col_date(format = "%d-%m-%y"),
                       `Age at ART Initiation` = col_double(),
                       `Current Age` = col_double(),
                       `ART Start Date` = col_date(format = "%d-%b-%y"),
                       `ART Start Date Source` = col_factor(),
                       `Last Drug Pickup date` = col_date(format = "%d-%b-%y"),
                       `Last Drug Pickup date Q1` = col_date(format = "%d-%b-%y"),
                       `Last Drug Pickup date Q2` = col_date(format = "%d-%b-%y"),
                       `Last Drug Pickup date Q3` = col_date(format = "%d-%b-%y"),
                       `Last Drug Pickup date Q4` = col_date(format = "%d-%b-%y"),
                       `Last Regimen` = col_factor(),
                       `Last Clinic Visit Date` = col_date(format = "%d-%b-%y"),
                       `Days Of ARV Refill` = col_double(),
                       `Pregnancy Status` = col_factor(),
                       `Current Viral Load` = col_double(),
                       `Date Of Current Viral Load` = col_date(format = "%d-%b-%y"),
                       `Current Viral Load Q1` = col_double(),
                       `Date Of Current Viral Load Q1` = col_date(format = "%d-%b-%y"),
                       `Current Viral Load Q2` = col_double(),
                       `Date Of Current Viral Load Q2` = col_date(format = "%d-%b-%y"),
                       `Current Viral Load Q3` = col_double(),
                       `Date Of Current Viral Load Q3` = col_date(format = "%d-%b-%y"),
                       `Current Viral Load Q4` = col_double(),
                       `Date Of Current Viral Load Q4` = col_date(format = "%d-%b-%y"),
                       `Current Status (28 Days)` = col_factor(),
                       `Current Status (90 Days)` = col_factor(),
                       `Current Status Q1 (28 Days)` = col_factor(),
                       `Current Status Q1 (90 Days)` = col_factor(),
                       `Current Status Q2 (28 Days)` = col_factor(),
                       `Current Status Q2 (90 Days)` = col_factor(),
                       `Current Status Q3 (28 Days)` = col_factor(),
                       `Current Status Q3 (90 Days)` = col_factor(),
                       `Current Status Q4 (28 Days)` = col_factor(),
                       `Current Status Q4 (90 Days)` = col_factor(),
                       `Patient Has Died` = col_logical(),
                       `Patient Deceased Date` = col_date(format = "%d-%b-%y"),
                       `Patient Transferred Out` = col_logical(),
                       `Transferred Out Date` = col_date(format = "%d-%b-%y"),
                       `Patient Transferred In` = col_logical(),
                       `Transferred In Date` = col_date(format = "%d-%b-%y")
                     ), ...) {

  stopifnot(
    "suppress argument is neither 'TRUE' nor 'FALSE'" = is_logical(suppress)
  )

  stopifnot("attempted file is not a '.csv' format" =
              str_detect(path, ".csv$"))

  if (suppress == FALSE) {

    vroom(path, col_types = cols, ...) %>%
      clean_names()

  } else {

    suppressWarnings(
      vroom(path, col_types = cols, ...) %>%
        clean_names()
    )

  }
}
