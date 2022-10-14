test_that("summarise_ndr works", {
  expect_identical(
    {
      new <- tx_new(ndr_example, from = "2021-01-01", to = "2021-01-31")
      summarise_ndr(new, level = "state", names = "tx_new")
    },
    janitor::adorn_totals(dplyr::count(tx_new(ndr_example, from = "2021-01-01", to = "2021-01-31"), ip, state, name = "tx_new")) %>%
      tibble::as_tibble()
  )
})
