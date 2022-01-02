test_that("rita_result subsets RTRI_recent with complete documentation of viral load result", {
  expect_identical(
    rita_result(recency_example, from = "2020-01-01"),
    recency_example %>%
      subset(recency_interpretation %in% c("Recent", "recent", "RECENT") &
               !is.na(viral_load_result) &
               !is.na(date_of_viral_load_result)
      )
  )
})
