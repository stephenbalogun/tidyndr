test_that("hts_tst_pos identified are also eligible for recency testing", {
  expect_identical(
    recent_eligible(recency_example, from = "2020-01-01"),
    recency_example %>%
      dplyr::filter(!is.na(recency_test_date),
               !opt_out %in% c("Yes", "yes", "YES", TRUE, "true"),
             age >= 15,
               hts_result %in% c("R", "Pos", "Positive", "Reactive", "POSITIVE", "REACTIVE", "pos"),
               hts_confirmatory_result %in% c("R", "Pos", "Positive", "Reactive", "POSITIVE", "REACTIVE", "pos") |
               hts_tie_breaker_result %in% c("R", "Pos", "Positive", "Reactive", "POSITIVE", "REACTIVE", "pos")
      )
  )
})
