test_that("rita_sample subsets only RTRI recent clients whose viral load samples were collected", {
  expect_identical(
    rita_sample(recency_example, from = "2020-01-01"),
    recency_example %>%
      subset(recency_interpretation %in% c("Recent", "recent", "RECENT") &
               !is.na(date_sample_collected)
      )
  )
})
