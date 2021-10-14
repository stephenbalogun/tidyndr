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
<!-- badges: end -->

The goal of {tidyndr} is to provide a specialized, simple and easy to
use functions that wrap around existing functions in `R` for
manipulation of the [NDR](https://ndr.shieldnigeriaproject.com/) patient
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

You can install the released version of tidyndr from
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
tx_new(ndr_example)
#> Warning: One or more parsing issues, see `problems()` for details
#> # A tibble: 0 x 52
#> # ... with 52 variables: ip <fct>, state <fct>, lga <fct>, facility <fct>,
#> #   datim_code <fct>, sex <fct>, patient_identifier <chr>,
#> #   hospital_number <chr>, date_of_birth <date>, age_at_art_initiation <dbl>,
#> #   current_age <dbl>, art_start_date <date>, art_start_date_source <fct>,
#> #   last_drug_pickup_date <date>, last_drug_pickup_date_q1 <date>,
#> #   last_drug_pickup_date_q2 <date>, last_drug_pickup_date_q3 <date>,
#> #   last_drug_pickup_date_q4 <date>, last_regimen <fct>, ...

## Subset "TX_CURR" for a state
ndr_example %>%
  tx_curr(states = "State 1")
#> # A tibble: 3,726 x 52
#>    ip      state   lga    facility   datim_code     sex   patient_identif~ hospital_number
#>    <fct>   <fct>   <fct>  <fct>      <fct>          <fct> <chr>            <chr>          
#>  1 IP_name State 1 LGA002 Facility 2 datim_code0002 M     State 1001       0001           
#>  2 IP_name State 1 LGA006 Facility 6 datim_code0006 F     State 1002       0001           
#>  3 IP_name State 1 LGA006 Facility 6 datim_code0006 M     State 1004       0003           
#>  4 IP_name State 1 LGA006 Facility 6 datim_code0006 F     State 1005       0004           
#>  5 IP_name State 1 LGA003 Facility 3 datim_code0003 F     State 1009       0001           
#>  6 IP_name State 1 LGA001 Facility 1 datim_code0001 F     State 10010      0001           
#>  7 IP_name State 1 LGA001 Facility 1 datim_code0001 F     State 10011      0002           
#>  8 IP_name State 1 LGA006 Facility 6 datim_code0006 F     State 10014      0005           
#>  9 IP_name State 1 LGA006 Facility 6 datim_code0006 F     State 10022      0007           
#> 10 IP_name State 1 LGA002 Facility 2 datim_code0002 F     State 10027      00013          
#> # ... with 3,716 more rows, and 44 more variables: date_of_birth <date>,
#> #   age_at_art_initiation <dbl>, current_age <dbl>, art_start_date <date>,
#> #   art_start_date_source <fct>, last_drug_pickup_date <date>,
#> #   last_drug_pickup_date_q1 <date>, last_drug_pickup_date_q2 <date>,
#> #   last_drug_pickup_date_q3 <date>, last_drug_pickup_date_q4 <date>,
#> #   last_regimen <fct>, last_clinic_visit_date <date>,
#> #   days_of_arv_refill <dbl>, pregnancy_status <fct>, ...

## Generate line-list of clients with medication refill in January 2021 for a facility (Facility 1)
ndr_example %>%
  tx_appointment(from = "2021-01-01",
                 to = "2021-01-31",
                 facilities = "Facility 1")
#> # A tibble: 413 x 52
#>    ip      state   lga    facility   datim_code     sex   patient_identif~ hospital_number
#>    <fct>   <fct>   <fct>  <fct>      <fct>          <fct> <chr>            <chr>          
#>  1 IP_name State 2 LGA001 Facility 1 datim_code0001 F     State 2003       0002           
#>  2 IP_name State 3 LGA001 Facility 1 datim_code0001 M     State 3008       0003           
#>  3 IP_name State 2 LGA001 Facility 1 datim_code0001 M     State 20016      0004           
#>  4 IP_name State 3 LGA001 Facility 1 datim_code0001 M     State 30026      0007           
#>  5 IP_name State 1 LGA001 Facility 1 datim_code0001 F     State 10016      0003           
#>  6 IP_name State 2 LGA001 Facility 1 datim_code0001 M     State 20064      00010          
#>  7 IP_name State 2 LGA001 Facility 1 datim_code0001 F     State 200122     00020          
#>  8 IP_name State 2 LGA001 Facility 1 datim_code0001 M     State 200131     00021          
#>  9 IP_name State 1 LGA001 Facility 1 datim_code0001 F     State 100131     00019          
#> 10 IP_name State 2 LGA001 Facility 1 datim_code0001 F     State 200256     00045          
#> # ... with 403 more rows, and 44 more variables: date_of_birth <date>,
#> #   age_at_art_initiation <dbl>, current_age <dbl>, art_start_date <date>,
#> #   art_start_date_source <fct>, last_drug_pickup_date <date>,
#> #   last_drug_pickup_date_q1 <date>, last_drug_pickup_date_q2 <date>,
#> #   last_drug_pickup_date_q3 <date>, last_drug_pickup_date_q4 <date>,
#> #   last_regimen <fct>, last_clinic_visit_date <date>,
#> #   days_of_arv_refill <dbl>, pregnancy_status <fct>, ...

## Generate list of clients who were active at the beginning of FY21 but became inactive at the end of Q1 of FY21.
  tx_ml(new_data = ndr_example,
        from = "2020-10-01",
        to = "2020-12-31")
#> # A tibble: 2,593 x 52
#>    ip      state   lga    facility   datim_code     sex   patient_identif~ hospital_number
#>    <fct>   <fct>   <fct>  <fct>      <fct>          <fct> <chr>            <chr>          
#>  1 IP_name State 1 LGA002 Facility 2 datim_code0002 F     State 1007       0003           
#>  2 IP_name State 3 LGA006 Facility 6 datim_code0006 F     State 30025      0008           
#>  3 IP_name State 2 LGA005 Facility 5 datim_code0005 F     State 20041      0002           
#>  4 IP_name State 2 LGA002 Facility 2 datim_code0002 M     State 20050      00020          
#>  5 IP_name State 3 LGA006 Facility 6 datim_code0006 F     State 300107     00040          
#>  6 IP_name State 2 LGA006 Facility 6 datim_code0006 M     State 20090      00025          
#>  7 IP_name State 3 LGA006 Facility 6 datim_code0006 F     State 300111     00042          
#>  8 IP_name State 1 LGA001 Facility 1 datim_code0001 M     State 10065      00011          
#>  9 IP_name State 2 LGA002 Facility 2 datim_code0002 M     State 200118     00047          
#> 10 IP_name State 1 LGA006 Facility 6 datim_code0006 M     State 10073      00023          
#> # ... with 2,583 more rows, and 44 more variables: date_of_birth <date>,
#> #   age_at_art_initiation <dbl>, current_age <dbl>, art_start_date <date>,
#> #   art_start_date_source <fct>, last_drug_pickup_date <date>,
#> #   last_drug_pickup_date_q1 <date>, last_drug_pickup_date_q2 <date>,
#> #   last_drug_pickup_date_q3 <date>, last_drug_pickup_date_q4 <date>,
#> #   last_regimen <fct>, last_clinic_visit_date <date>,
#> #   days_of_arv_refill <dbl>, pregnancy_status <fct>, ...
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
  tx_vl_eligible()
#> # A tibble: 16,695 x 52
#>    ip      state   lga    facility   datim_code     sex   patient_identif~ hospital_number
#>    <fct>   <fct>   <fct>  <fct>      <fct>          <fct> <chr>            <chr>          
#>  1 IP_name State 1 LGA002 Facility 2 datim_code0002 M     State 1001       0001           
#>  2 IP_name State 2 LGA001 Facility 1 datim_code0001 F     State 2001       0001           
#>  3 IP_name State 3 LGA006 Facility 6 datim_code0006 M     State 3001       0001           
#>  4 IP_name State 1 LGA006 Facility 6 datim_code0006 F     State 1002       0001           
#>  5 IP_name State 3 LGA007 Facility 7 datim_code0007 F     State 3005       0001           
#>  6 IP_name State 2 LGA002 Facility 2 datim_code0002 F     State 2005       0001           
#>  7 IP_name State 1 LGA006 Facility 6 datim_code0006 M     State 1004       0003           
#>  8 IP_name State 3 LGA006 Facility 6 datim_code0006 F     State 3006       0002           
#>  9 IP_name State 1 LGA006 Facility 6 datim_code0006 F     State 1005       0004           
#> 10 IP_name State 3 LGA001 Facility 1 datim_code0001 F     State 3009       0004           
#> # ... with 16,685 more rows, and 44 more variables: date_of_birth <date>,
#> #   age_at_art_initiation <dbl>, current_age <dbl>, art_start_date <date>,
#> #   art_start_date_source <fct>, last_drug_pickup_date <date>,
#> #   last_drug_pickup_date_q1 <date>, last_drug_pickup_date_q2 <date>,
#> #   last_drug_pickup_date_q3 <date>, last_drug_pickup_date_q4 <date>,
#> #   last_regimen <fct>, last_clinic_visit_date <date>,
#> #   days_of_arv_refill <dbl>, pregnancy_status <fct>, ...

## Generate list of clients that will be expected to have a viral load test done in Q2 of FY21 for "State 2"
ndr_example %>%
  tx_vl_eligible("2021-03-31",
                 states = "State 2",
                 sample = TRUE)
#> # A tibble: 2,360 x 52
#>    ip      state   lga    facility   datim_code     sex   patient_identif~ hospital_number
#>    <fct>   <fct>   <fct>  <fct>      <fct>          <fct> <chr>            <chr>          
#>  1 IP_name State 2 LGA006 Facility 6 datim_code0006 F     State 20012      0001           
#>  2 IP_name State 2 LGA001 Facility 1 datim_code0001 M     State 20016      0004           
#>  3 IP_name State 2 LGA006 Facility 6 datim_code0006 F     State 20018      0004           
#>  4 IP_name State 2 LGA002 Facility 2 datim_code0002 M     State 20021      0008           
#>  5 IP_name State 2 LGA002 Facility 2 datim_code0002 F     State 20025      0009           
#>  6 IP_name State 2 LGA006 Facility 6 datim_code0006 M     State 20027      0008           
#>  7 IP_name State 2 LGA006 Facility 6 datim_code0006 M     State 20033      00011          
#>  8 IP_name State 2 LGA002 Facility 2 datim_code0002 F     State 20034      00012          
#>  9 IP_name State 2 LGA002 Facility 2 datim_code0002 F     State 20035      00013          
#> 10 IP_name State 2 LGA002 Facility 2 datim_code0002 F     State 20037      00015          
#> # ... with 2,350 more rows, and 44 more variables: date_of_birth <date>,
#> #   age_at_art_initiation <dbl>, current_age <dbl>, art_start_date <date>,
#> #   art_start_date_source <fct>, last_drug_pickup_date <date>,
#> #   last_drug_pickup_date_q1 <date>, last_drug_pickup_date_q2 <date>,
#> #   last_drug_pickup_date_q3 <date>, last_drug_pickup_date_q4 <date>,
#> #   last_regimen <fct>, last_clinic_visit_date <date>,
#> #   days_of_arv_refill <dbl>, pregnancy_status <fct>, ...

### Calculate the Viral Load Coverage for State 3
no_of_vl_results <- tx_pvls_den(ndr_example,
                                states = "State 3") %>%
  nrow()
no_of_vl_eligible <- tx_vl_eligible(ndr_example,
                                    states = "State 3") %>%
  nrow()

vl_coverage <- scales::percent(no_of_vl_results / no_of_vl_eligible)

print(vl_coverage)
#> [1] "13%"
```

For all the ‘Treatment’ and ‘Viral Suppression’ indicators (except
`tx_ml_outcomes()`, which should be use with `tx_ml()`), you have
control over the level of action (state or facility) by supplying to the
`states` and/or `facilities` arguments the values of interest . For more
than one state or facility, combine the values with the `c()` e.g.

``` r
## subset clients that have medication appointment in Q2 of FY21 for "State 1" and "State 3" and are also due for viral load
ndr_example %>%
  tx_appointment(from = "2021-01-01",
                 to = "2021-03-31",
                 states = c("State 1", "State 3")) %>%
  tx_vl_eligible(sample = TRUE)
#> # A tibble: 5,038 x 52
#>    ip      state   lga    facility   datim_code     sex   patient_identif~ hospital_number
#>    <fct>   <fct>   <fct>  <fct>      <fct>          <fct> <chr>            <chr>          
#>  1 IP_name State 1 LGA002 Facility 2 datim_code0002 M     State 1001       0001           
#>  2 IP_name State 3 LGA007 Facility 7 datim_code0007 F     State 3005       0001           
#>  3 IP_name State 3 LGA006 Facility 6 datim_code0006 F     State 3006       0002           
#>  4 IP_name State 3 LGA001 Facility 1 datim_code0001 F     State 3009       0004           
#>  5 IP_name State 3 LGA006 Facility 6 datim_code0006 F     State 30014      0005           
#>  6 IP_name State 3 LGA006 Facility 6 datim_code0006 F     State 30027      0009           
#>  7 IP_name State 1 LGA001 Facility 1 datim_code0001 F     State 10011      0002           
#>  8 IP_name State 3 LGA006 Facility 6 datim_code0006 F     State 30031      00010          
#>  9 IP_name State 3 LGA002 Facility 2 datim_code0002 M     State 30032      00012          
#> 10 IP_name State 3 LGA006 Facility 6 datim_code0006 F     State 30034      00011          
#> # ... with 5,028 more rows, and 44 more variables: date_of_birth <date>,
#> #   age_at_art_initiation <dbl>, current_age <dbl>, art_start_date <date>,
#> #   art_start_date_source <fct>, last_drug_pickup_date <date>,
#> #   last_drug_pickup_date_q1 <date>, last_drug_pickup_date_q2 <date>,
#> #   last_drug_pickup_date_q3 <date>, last_drug_pickup_date_q4 <date>,
#> #   last_regimen <fct>, last_clinic_visit_date <date>,
#> #   days_of_arv_refill <dbl>, pregnancy_status <fct>, ...
```

### Summarising your Indicators

You might want to generate a summary table of all the indicators you
have pulled out. The `summarise_ndr()` (or `summarize_ndr()`) allows you
to do this with ease. It accepts all the line-lists you are interested
in creating a summary table for, the level at which you want the summary
to be created (country/ip, state or facility), and the names you want to
give to each of your summary column.

``` r
new <- tx_new(ndr_example)  ## generates line-list of TX_NEW for the FY
curr <- tx_curr(ndr_example) ## generates line-list of currently active clients
ml <- tx_ml(new_data = ndr_example) ## generates line-list of clients who were active at the beginning of the FY but currently inactive

summarise_ndr(new, curr, ml,
              level = "state",
              names = c("tx_new", "tx_curr", "tx_ml"))
#> # A tibble: 1 x 5
#>   ip    state tx_new tx_curr tx_ml
#>   <chr> <chr>  <int>   <int> <int>
#> 1 Total -          0   16696     0
```

The `disaggregate()` allows you to summarise an indicator of interest
into finer details based on “age”, “sex” or “pregnancy status”. These
are supplied to the `by` parameter of the function. The default
disaggregates the variable of interest at the level of “states” but can
also do this at “country/ip”, “lga” or “facility” level when any of this
is supplied to the `level` parameter.

``` r
new_clients <- tx_new(ndr_example, from = "2021-01-01", to = "2021-03-31")  ## generates line-list of TX_NEW for the FY

disaggregate(new_clients,
             by = "current_age")
#> # A tibble: 4 x 13
#>   ip      state   `1-4` `5-9` `15-19` `20-24` `25-29` `30-34` `35-39` `40-44`
#>   <chr>   <chr>   <int> <int>   <int>   <int>   <int>   <int>   <int>   <int>
#> 1 IP_name State 1     2     0      11      37      83      63      36      24
#> 2 IP_name State 2     1     1       4      46      86      86      35      25
#> 3 IP_name State 3     1     4      50     129     206     188     136     126
#> 4 Total   -           4     5      65     212     375     337     207     175
#> # ... with 3 more variables: 45-49 <int>, 50+ <int>, Total <dbl>

## disaggregate 'TX_CURR' by sex

ndr_example %>%
  tx_curr() %>%
  disaggregate(by = "sex")
#> # A tibble: 4 x 6
#>   ip      state    Male Female unknown Total
#>   <chr>   <chr>   <int>  <int>   <int> <dbl>
#> 1 IP_name State 1  1102   2624       0  3726
#> 2 IP_name State 2  1606   3451       1  5058
#> 3 IP_name State 3  3386   4526       0  7912
#> 4 Total   -        6094  10601       1 16696
```

## Code of Conduct

Please note that the tidyndr project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
