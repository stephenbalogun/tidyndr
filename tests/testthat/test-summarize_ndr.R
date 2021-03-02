test_that("summarize_ndr works as planned", {
  expect_identical(
    {
      curr <- tx_curr(ndr_example)
      summarize_ndr(curr, level = "state", names = "tx_curr")
    },
    janitor::adorn_totals(dplyr::count(tx_curr(ndr_example), ip, state, name = "tx_curr"))
  )
})
