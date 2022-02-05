test_that("disaggregation works", {
  expect_identical(
    disaggregate(ndr_example %>% tx_curr(), by = "sex"),
    {
      ndr_example %>%
        tx_curr() %>%
        dplyr::count(ip, state, sex, .drop = FALSE) %>%
        dplyr::mutate(sex = dplyr::recode_factor(sex, "F" = "Female", "M" = "Male", .default = "unknown")) %>%
        dplyr::count(ip, state, sex, wt = n, .drop = FALSE) %>%
        tidyr::pivot_wider(names_from = "sex", values_from = "n") %>%
        janitor::adorn_totals(where = "row") %>%
        tibble::as_tibble()
    }
  )
})
