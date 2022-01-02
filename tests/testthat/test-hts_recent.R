test_that("hts_recent subset only positive clients who had recency testing", {
  expect_identical(
    hts_recent(recency_example, from = "2020-01-01"),
    recency_example %>%
      subset(!is.na(recency_test_date) &
               !is.na(recency_test_name)
             )
  )
})
