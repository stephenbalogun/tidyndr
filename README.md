Tidyndr
================

<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- <a href='https://github.com/stephenbalogun/tidyndr/tree/master/man/figures/logo.svg'><img src="man/figures/logo.svg" align="right" height="139"/></a> -->
<!-- badges: start -->

[![R-CMD-check](https://github.com/stephenbalogun/tidyndr/workflows/R-CMD-check/badge.svg)](https://github.com/stephenbalogun/tidyndr/actions)
[![Codecov test
coverage](https://codecov.io/gh/stephenbalogun/tidyndr/branch/master/graph/badge.svg)](https://app.codecov.io/gh/stephenbalogun/tidyndr?branch=master/)
[![CRAN
status](https://www.r-pkg.org/badges/version/tidyndr)](https://CRAN.R-project.org/package=tidyndr)
[![Total CRAN
downloads](https://cranlogs.r-pkg.org/badges/grand-total/tidyndr?color=blue)](https://cranlogs.r-pkg.org/#badges)
[![Monthly CRAN
downloads](https://cranlogs.r-pkg.org/badges/tidyndr)](https://cranlogs.r-pkg.org/#badges)

<!-- badges: end -->

The goal of {tidyndr} is to provide a specialized, simple and easy to
use functions that wrap around existing functions in `R` for
manipulation of the [NDR](https://ndr.phis3project.org.ng/) patient
line-list file allowing the user to focus on the tasks to be completed
rather than the code/formula details.

The functions presented are similar to the [PEPFAR MER
indicators](https://datim.zendesk.com/hc/en-us/articles/360000084446-MER-Indicator-Reference-Guides)
and are currently grouped into four categories:

-   The `read_ndr` function for reading the patient-level line-list
    downloaded from the front-end of the NDR in ‘csv’ format.

-   The PEPFAR treatment group of indicators that can be performed on
    the NDR line-list.

-   The ‘Viral Load’ indicators (`tx_vl_eligible()`, `tx_pvls_den()`
    `tx_pvls_num()` and `tx_vl_unsuppressed()`).

-   The summary functions (`summarise_ndr()` and `disaggregrate()`)
    provides a tabular summary for the tasks that have been completed
    using any of the functions above.

## Installation

You can install the released version of {tidyndr} from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("tidyndr")
```

Or the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("stephenbalogun/tidyndr",
build_vignette = TRUE)
```

## Usage

``` r
library(tidyndr)
#> Attaching package: 'tidyndr' 
#> A package for analysis of the front-end patient-level data from the Nigeria National Data Repository.
```

### read_ndr

`read_ndr()` reads the downloaded “.csv” file into
[`R`](https://cran.r-project.org) using
[`vroom::vroom()`](https://vroom.r-lib.org/) behind the scene and
passing appropriate column types to the `col_types` argument. It also
formats the variable names using the
[`snakecase`](https://en.wikipedia.org/wiki/Snake_case) style.

``` r
## read from a local file path (not run)

# file_path <- system.file("extdata", "ndr_example.csv", package = "tidyndr")

# read_ndr(file_path, time_stamp = "2021-02-15")

### read line-list available on the internet
path <- "https://raw.githubusercontent.com/stephenbalogun/example_files/main/ndr_example.csv"

ndr_example <- read_ndr(path, time_stamp = "2021-02-20")
#> 
#> Three new variables created: 
#> [1] `date_lost` 
#> [2] `appointment_date 
#> [2] `current_status
```

### Treatment Indicators

The functions included in this group are:

-   `tx_new()`

-   `tx_curr()`

-   `tx_ml()` and `tx_ml_outcomes()`

-   `tx_rtt()`

-   Other supporting functions are: `tx_mmd()`, `tx_regimen()` and
    `tx_appointment()`

``` r
## Subset "TX_NEW"
tx_new(ndr_example, from = "2021-07-01", to = "2021-09-30")
#> Warning: One or more parsing issues, see `problems()` for details
#> # A tibble: 0 × 52
#> # … with 52 variables: ip <fct>, state <fct>, lga <fct>, facility <fct>,
#> #   datim_code <fct>, sex <fct>, patient_identifier <chr>,
#> #   hospital_number <chr>, date_of_birth <date>, age_at_art_initiation <dbl>,
#> #   current_age <dbl>, art_start_date <date>, art_start_date_source <fct>,
#> #   last_drug_pickup_date <date>, last_drug_pickup_date_q1 <date>,
#> #   last_drug_pickup_date_q2 <date>, last_drug_pickup_date_q3 <date>,
#> #   last_drug_pickup_date_q4 <date>, last_regimen <fct>, …


## Generate line-list of clients with medication refill in October 2021
ndr_example %>%
  tx_appointment(from = "2021-10-01",
                 to = "2021-10-31"
                 )
#> # A tibble: 0 × 52
#> # … with 52 variables: ip <fct>, state <fct>, lga <fct>, facility <fct>,
#> #   datim_code <fct>, sex <fct>, patient_identifier <chr>,
#> #   hospital_number <chr>, date_of_birth <date>, age_at_art_initiation <dbl>,
#> #   current_age <dbl>, art_start_date <date>, art_start_date_source <fct>,
#> #   last_drug_pickup_date <date>, last_drug_pickup_date_q1 <date>,
#> #   last_drug_pickup_date_q2 <date>, last_drug_pickup_date_q3 <date>,
#> #   last_drug_pickup_date_q4 <date>, last_regimen <fct>, …

## Generate list of clients who were active at the beginning of October 2021 but became inactive at the end of December 2021.
  tx_ml(new_data = ndr_example,
        from = "2021-10-01",
        to = "2021-12-31")
#> # A tibble: 0 × 52
#> # … with 52 variables: ip <fct>, state <fct>, lga <fct>, facility <fct>,
#> #   datim_code <fct>, sex <fct>, patient_identifier <chr>,
#> #   hospital_number <chr>, date_of_birth <date>, age_at_art_initiation <dbl>,
#> #   current_age <dbl>, art_start_date <date>, art_start_date_source <fct>,
#> #   last_drug_pickup_date <date>, last_drug_pickup_date_q1 <date>,
#> #   last_drug_pickup_date_q2 <date>, last_drug_pickup_date_q3 <date>,
#> #   last_drug_pickup_date_q4 <date>, last_regimen <fct>, …
```

### Viral Suppression Indicators

The `tx_vl_eligible()`, `tx_pvls_den()` and the `tx_pvls_num()`
functions come in handy when you need to generate the line-list of
clients who are eligible for viral load test at a given point for a
given facility/state, those who have a valid viral load result (not more
than 1 year for people aged 20 years and above and not more than 6
months for paediatrics and adolescents less or equal to 19 years), and
those who are virally suppressed (out of those with valid viral load
results). When the `sample = TRUE` attribute is supplied to the
`tx_vl_eligible()` function, it generates the line-list of only those
who are due for a viral load test out of all those who are eligible.

``` r
## Generate list of clients who are eligible for VL (i.e. expected to have a documented VL result)
ndr_example %>%
  tx_vl_eligible(ref = "2021-12-31")
#> # A tibble: 27,020 × 52
#>    ip     state lga   facility datim_code sex   patient_identif… hospital_number
#>    <fct>  <fct> <fct> <fct>    <fct>      <fct> <chr>            <chr>          
#>  1 IP_na… Stat… LGA0… Facilit… datim_cod… M     State 3001       0001           
#>  2 IP_na… Stat… LGA0… Facilit… datim_cod… F     State 1002       0001           
#>  3 IP_na… Stat… LGA0… Facilit… datim_cod… F     State 3003       0001           
#>  4 IP_na… Stat… LGA0… Facilit… datim_cod… M     State 1003       0002           
#>  5 IP_na… Stat… LGA0… Facilit… datim_cod… F     State 2004       0002           
#>  6 IP_na… Stat… LGA0… Facilit… datim_cod… F     State 3005       0001           
#>  7 IP_na… Stat… LGA0… Facilit… datim_cod… F     State 2005       0001           
#>  8 IP_na… Stat… LGA0… Facilit… datim_cod… M     State 1004       0003           
#>  9 IP_na… Stat… LGA0… Facilit… datim_cod… F     State 3007       0002           
#> 10 IP_na… Stat… LGA0… Facilit… datim_cod… F     State 1005       0004           
#> # … with 27,010 more rows, and 44 more variables: date_of_birth <date>,
#> #   age_at_art_initiation <dbl>, current_age <dbl>, art_start_date <date>,
#> #   art_start_date_source <fct>, last_drug_pickup_date <date>,
#> #   last_drug_pickup_date_q1 <date>, last_drug_pickup_date_q2 <date>,
#> #   last_drug_pickup_date_q3 <date>, last_drug_pickup_date_q4 <date>,
#> #   last_regimen <fct>, last_clinic_visit_date <date>,
#> #   days_of_arv_refill <dbl>, pregnancy_status <fct>, …

## Generate list of clients that will be expected to have a viral load test done by March 2022
ndr_example %>%
  tx_vl_eligible("2022-03-31",
                 sample = TRUE)
#> # A tibble: 27,020 × 52
#>    ip     state lga   facility datim_code sex   patient_identif… hospital_number
#>    <fct>  <fct> <fct> <fct>    <fct>      <fct> <chr>            <chr>          
#>  1 IP_na… Stat… LGA0… Facilit… datim_cod… M     State 3001       0001           
#>  2 IP_na… Stat… LGA0… Facilit… datim_cod… F     State 1002       0001           
#>  3 IP_na… Stat… LGA0… Facilit… datim_cod… F     State 3003       0001           
#>  4 IP_na… Stat… LGA0… Facilit… datim_cod… M     State 1003       0002           
#>  5 IP_na… Stat… LGA0… Facilit… datim_cod… F     State 2004       0002           
#>  6 IP_na… Stat… LGA0… Facilit… datim_cod… F     State 3005       0001           
#>  7 IP_na… Stat… LGA0… Facilit… datim_cod… F     State 2005       0001           
#>  8 IP_na… Stat… LGA0… Facilit… datim_cod… M     State 1004       0003           
#>  9 IP_na… Stat… LGA0… Facilit… datim_cod… F     State 3007       0002           
#> 10 IP_na… Stat… LGA0… Facilit… datim_cod… F     State 1005       0004           
#> # … with 27,010 more rows, and 44 more variables: date_of_birth <date>,
#> #   age_at_art_initiation <dbl>, current_age <dbl>, art_start_date <date>,
#> #   art_start_date_source <fct>, last_drug_pickup_date <date>,
#> #   last_drug_pickup_date_q1 <date>, last_drug_pickup_date_q2 <date>,
#> #   last_drug_pickup_date_q3 <date>, last_drug_pickup_date_q4 <date>,
#> #   last_regimen <fct>, last_clinic_visit_date <date>,
#> #   days_of_arv_refill <dbl>, pregnancy_status <fct>, …

### Calculate the Viral Load Coverage as of December 2021
no_of_vl_results <- tx_pvls_den(ndr_example,
                                ref = "2021-12-31") %>%
  nrow()
no_of_vl_eligible <- tx_vl_eligible(ndr_example,
                                    ref = "2021-12-31") %>%
  nrow()

vl_coverage <- scales::percent(no_of_vl_results / no_of_vl_eligible)

print(vl_coverage)
#> [1] "2%"
```

For all the ‘Treatment’ and ‘Viral Suppression’ indicators (except
`tx_ml_outcomes()`, which should be use with `tx_ml()`), you have
control over the level of action (state or facility) by supplying to the
`states` and/or `facilities` arguments the values of interest . For more
than one state or facility, combine the values with the `c()` e.g.

``` r
## subset clients that have medication appointment in between January and March of 2021 in 
## and are also due for viral load
ndr_example %>%
  tx_appointment(from = "2022-01-01",
                 to = "2022-03-31",
                 ) %>%
  tx_vl_eligible(sample = TRUE)
#> # A tibble: 0 × 52
#> # … with 52 variables: ip <fct>, state <fct>, lga <fct>, facility <fct>,
#> #   datim_code <fct>, sex <fct>, patient_identifier <chr>,
#> #   hospital_number <chr>, date_of_birth <date>, age_at_art_initiation <dbl>,
#> #   current_age <dbl>, art_start_date <date>, art_start_date_source <fct>,
#> #   last_drug_pickup_date <date>, last_drug_pickup_date_q1 <date>,
#> #   last_drug_pickup_date_q2 <date>, last_drug_pickup_date_q3 <date>,
#> #   last_drug_pickup_date_q4 <date>, last_regimen <fct>, …
```

### Summarising your Indicators

You might want to generate a summary table of all the indicators you
have pulled out. The `summarise_ndr()` (or `summarize_ndr()`) allows you
to do this with ease. It accepts all the line-lists you are interested
in creating a summary table for, the level at which you want the summary
to be created (country/ip, state or facility), and the names you want to
give to each of your summary column.

``` r
## generates line-list of TX_NEW between July and December 2021
new <- tx_new(ndr_example, from = "2021-07-01", to = "202112-31")

## generates line-list of currently active clients
curr <- tx_curr(ndr_example)

## generates line-list of clients who were active at the beginning of the October but inactive at end of December 2021
ml <- tx_ml(new_data = ndr_example, from = "2021-10-01", to = "2021-12-31") 

summarise_ndr(new, curr, ml,
              level = "state",
              names = c("tx_new", "tx_curr", "tx_ml"))
#> # A tibble: 4 × 5
#>   ip      state   tx_new tx_curr tx_ml
#>   <chr>   <chr>    <int>   <int> <int>
#> 1 Total   -            0   27020     0
#> 2 IP_name State 1      0    5645     0
#> 3 IP_name State 2      0    7929     0
#> 4 IP_name State 3      0   13446     0
```

The `disaggregate()` allows you to summarise an indicator of interest
into finer details based on “current_age”, “sex” “pregnancy_status”,
“art_duration”, “months_dispensed (of ARV)” or “age_sex”. These are
supplied to the `by` parameter of the function. The default
disaggregates the variable of interest at the level of “states” but can
also do this at “country/ip”, “lga” or “facility” level when any of this
is supplied to the `level` parameter.

``` r
## generates line-list of TX_NEW between July and September 2021
new_clients <- tx_new(ndr_example, from = "2021-07-01", to = "2021-09-30")

disaggregate(new_clients,
             by = "current_age", pivot_wide = FALSE)
#> # A tibble: 65 × 4
#>    ip      state   current_age number
#>    <chr>   <chr>   <chr>        <int>
#>  1 IP_name State 1 <1               0
#>  2 IP_name State 1 1-4              0
#>  3 IP_name State 1 5-9              0
#>  4 IP_name State 1 10-14            0
#>  5 IP_name State 1 15-19            0
#>  6 IP_name State 1 20-24            0
#>  7 IP_name State 1 25-29            0
#>  8 IP_name State 1 30-34            0
#>  9 IP_name State 1 35-39            0
#> 10 IP_name State 1 40-44            0
#> # … with 55 more rows

## disaggregate 'TX_CURR' by sex

ndr_example %>%
  tx_curr() %>%
  disaggregate(by = "sex")
#> # A tibble: 5 × 5
#>   ip      state      Male Female unknown
#>   <chr>   <chr>     <int>  <int>   <int>
#> 1 IP_name "State 1"  1661   3984       0
#> 2 IP_name "State 2"  2335   5594       0
#> 3 IP_name "State 3"  5894   7552       0
#> 4 IP_name ""            0      0       0
#> 5 Total   "-"        9890  17130       0
```

## Code of Conduct

Please note that the {tidyndr} project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
