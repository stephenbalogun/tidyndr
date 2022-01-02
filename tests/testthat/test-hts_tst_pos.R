test_that("hts_tst_pos identifies only confirmed HIV positive clients", {
  expect_identical(
    hts_tst_pos(recency_example, from = "2020-01-01"),
    recency_example %>%
      subset(!is.na(visit_date) &
               hts_result %in% c("R", "Pos", "Positive", "Reactive", "POSITIVE", "REACTIVE", "pos") &
               hts_confirmatory_result %in% c("R", "Pos", "Positive", "Reactive", "POSITIVE", "REACTIVE", "pos") |
               hts_tie_breaker_result %in% c("R", "Pos", "Positive", "Reactive", "POSITIVE", "REACTIVE", "pos")
              )
    )
  })
