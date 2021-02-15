test_that("disaggregation works", {
  expect_identical(disaggregate(ndr_example, by = "sex"), {
    dt <- janitor::adorn_totals(
      tidyr::pivot_wider(
        dplyr::mutate(
          dplyr::count(ndr_example, ip, state, sex, .drop = TRUE),
          sex = dplyr::recode_factor(sex,
            "F" = "Female",
            "M" = "Male",
            .default = "unknown"
          )
        ),
        names_from = sex,
        values_from = n
      ),
      where = c("row", "col")
    )
    dt[is.na(dt)] <- 0 ## replace NAs with Zero
    tibble::as_tibble(dt)
  })
})
