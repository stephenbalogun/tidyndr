test_that("vl_cascade works fine", {
  expect_identical(
    vl_cascade(
      ndr_example,
      ref = "2021-12-31"
    ),
    {
      vl_eligible <- tx_vl_eligible(ndr_example, ref = "2021-12-31")

      vl_result <- tx_pvls_den(ndr_example, ref = "2021-12-31")

      vl_suppressed <- tx_pvls_num(ndr_example, ref = "2021-12-31")


      summarise_ndr(
        vl_eligible,
        vl_result,
        vl_suppressed
      ) %>%
        dplyr::mutate(
          vl_coverage = janitor::round_half_up(vl_result / vl_eligible * 100, digits = 3),
          vl_suppression_rate = janitor::round_half_up(vl_suppressed / vl_result * 100, digits = 3)
        )
    }
  )
})
