test_that("tx_regimen works", {
  expect_identical(
    tx_regimen(ndr_example, status = "default"),
    ndr_example %>%
      subset(current_status_28_days == "Active" &
               !patient_has_died %in% TRUE &
             !patient_transferred_out %in% TRUE &
        dplyr::if_else(
          current_age <= 3,
          last_regimen %in% c(
            "ABC-3TC-LPV/r",
            "AZT-3TC-LPV/r"
          ),
          last_regimen %in% c(
            "ABC-3TC-DTG",
            "TDF-3TC-DTG"
          ) &
            dplyr::between(
              current_age,
              0, Inf
            )
        ))
  )
})
