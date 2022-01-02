test_that("rtri_recent subsets only clients who are presumed to be recent based on Rapid testing", {
  expect_identical(
    rtri_recent(recency_example, from = "2020-01-01"),
    recency_example %>%
      subset(recency_interpretation %in% c("Recent", "recent", "RECENT") &
               !is.na(recency_test_date)
      )
  )
})
