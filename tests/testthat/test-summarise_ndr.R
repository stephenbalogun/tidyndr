test_that("summarise_ndr works", {
  expect_identical(
    {
      new <- tx_new(ndr_example)
      summarise_ndr(new, level = "state", names = "tx_new")
    },
    janitor::adorn_totals(dplyr::count(tx_new(ndr_example), ip, state, name = "tx_new"))
  )
})
