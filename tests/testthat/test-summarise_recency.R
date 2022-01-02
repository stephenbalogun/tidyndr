test_that("summarise_recency works", {
  expect_identical(
    {
      rtri_recent <- rtri_recent(recency_example)
      summarise_recency(rtri_recent)
    },
    janitor::adorn_totals(dplyr::count(rtri_recent(recency_example), ip, facility_state, name = "rtri_recent"))
  )
})
