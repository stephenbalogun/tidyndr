test_that("cot_cascade works fine", {
  expect_identical(
    cot_cascade(
      ndr_example,
      quarter = 1
    ),
    {
      tx_curr_prev <- dplyr::filter(ndr_example, current_status_q4_28_days == "Active")

      tx_new <- tx_new(ndr_example, from = "2021-10-01", to = "2021-12-31")

      tx_ml <- tx_ml(ndr_example, from = "2021-10-01", to = "2021-12-31")

      tx_ml_dead <- tx_ml_outcomes(tx_ml, outcome = "dead")

      tx_ml_to <- tx_ml_outcomes(tx_ml, outcome = "transferred out")

      summarise_ndr(
        tx_curr_prev,
        tx_new,
        tx_ml,
        tx_ml_dead,
        tx_ml_to
      ) %>%
        dplyr::mutate(
          tx_ml_iit = tx_ml - tx_ml_dead - tx_ml_to,
          iit_rate = janitor::round_half_up(tx_ml_iit / (tx_curr_prev + tx_new) * 100, digits = 3)
        )
    }
  )
})
