test_that("summarize_recency works", {
  expect_identical(
    {
      rtri_recent <- rtri_recent(recency_example)
      summarize_recency(rtri_recent)
    },
    janitor::adorn_totals(dplyr::count(rtri_recent(recency_example), ip, facility_state, name = "rtri_recent"))
  )
})
