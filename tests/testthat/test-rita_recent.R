test_that("rita_recent subsets only clients who are confirmed RITA Recent", {
  expect_identical(
    rita_recent(recency_example, from = "2020-01-01"),
    recency_example %>%
      subset(recency_interpretation %in% c("Recent", "recent", "RECENT") &
                    viral_load_result >= 1000 &
               final_recency_result %in% c("RitaRecent", "RITARecent", "RITARECENT", "Ritarecent", "RitaRECENT") &
               !is.na(date_of_viral_load_result)
      )
  )
})
