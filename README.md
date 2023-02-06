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

The functions presented are similar to the PEPFAR Monitoring Evaluation
and Reporting Indicators and are currently grouped into four categories:

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
tx_new(ndr_example, from = "2021-01-01", to = "2021-03-31")
#> # A tibble: 1,556 × 52
#>    ip      state  lga   facil…¹ datim…² sex   patie…³ hospi…⁴ date_of_…⁵ age_a…⁶
#>    <fct>   <fct>  <fct> <fct>   <fct>   <fct> <chr>   <chr>   <date>       <dbl>
#>  1 IP_name State… LGA0… Facili… datim_… M     State … 0003    1990-02-07      31
#>  2 IP_name State… LGA0… Facili… datim_… M     State … 0003    1986-04-06      39
#>  3 IP_name State… LGA0… Facili… datim_… F     State … 0003    1988-05-05      27
#>  4 IP_name State… LGA0… Facili… datim_… F     State … 0003    1992-01-01      NA
#>  5 IP_name State… LGA0… Facili… datim_… F     State … 0008    1996-01-01      38
#>  6 IP_name State… LGA0… Facili… datim_… M     State … 0007    2002-01-01      37
#>  7 IP_name State… LGA0… Facili… datim_… M     State … 0002    1980-01-11      31
#>  8 IP_name State… LGA0… Facili… datim_… F     State … 00035   1983-01-01      30
#>  9 IP_name State… LGA0… Facili… datim_… F     State … 00042   1995-09-14      41
#> 10 IP_name State… LGA0… Facili… datim_… M     State … 0001    1987-01-01      32
#> # … with 1,546 more rows, 42 more variables: current_age <dbl>,
#> #   art_start_date <date>, art_start_date_source <fct>,
#> #   last_drug_pickup_date <date>, last_drug_pickup_date_q1 <date>,
#> #   last_drug_pickup_date_q2 <date>, last_drug_pickup_date_q3 <date>,
#> #   last_drug_pickup_date_q4 <date>, last_regimen <fct>,
#> #   last_clinic_visit_date <date>, days_of_arv_refill <dbl>,
#> #   pregnancy_status <fct>, current_viral_load <dbl>, …


## Generate line-list of clients with medication refill in October 2021
ndr_example %>%
  tx_appointment(from = "2021-01-01",
                 to = "2021-01-31"
                 )
#> # A tibble: 3,512 × 52
#>    ip      state  lga   facil…¹ datim…² sex   patie…³ hospi…⁴ date_of_…⁵ age_a…⁶
#>    <fct>   <fct>  <fct> <fct>   <fct>   <fct> <chr>   <chr>   <date>       <dbl>
#>  1 IP_name State… LGA0… Facili… datim_… F     State … 0002    1980-03-27      40
#>  2 IP_name State… LGA0… Facili… datim_… M     State … 0003    1986-04-06      39
#>  3 IP_name State… LGA0… Facili… datim_… F     State … 0002    1971-02-04      27
#>  4 IP_name State… LGA0… Facili… datim_… F     State … 0001    1973-02-02      35
#>  5 IP_name State… LGA0… Facili… datim_… M     State … 0004    1965-05-13      23
#>  6 IP_name State… LGA0… Facili… datim_… M     State … 0007    2002-01-01      37
#>  7 IP_name State… LGA0… Facili… datim_… F     State … 0009    1992-10-24      34
#>  8 IP_name State… LGA0… Facili… datim_… M     State … 0006    1980-05-02      70
#>  9 IP_name State… LGA0… Facili… datim_… F     State … 0005    1990-01-01      39
#> 10 IP_name State… LGA0… Facili… datim_… F     State … 0003    1981-08-08      24
#> # … with 3,502 more rows, 42 more variables: current_age <dbl>,
#> #   art_start_date <date>, art_start_date_source <fct>,
#> #   last_drug_pickup_date <date>, last_drug_pickup_date_q1 <date>,
#> #   last_drug_pickup_date_q2 <date>, last_drug_pickup_date_q3 <date>,
#> #   last_drug_pickup_date_q4 <date>, last_regimen <fct>,
#> #   last_clinic_visit_date <date>, days_of_arv_refill <dbl>,
#> #   pregnancy_status <fct>, current_viral_load <dbl>, …

## Generate list of clients who were active at the beginning of October 2021 but became inactive at the end of December 2021.
  tx_ml(new_data = ndr_example,
        from = "2021-01-01",
        to = "2021-03-31")
#> # A tibble: 10,307 × 52
#>    ip      state  lga   facil…¹ datim…² sex   patie…³ hospi…⁴ date_of_…⁵ age_a…⁶
#>    <fct>   <fct>  <fct> <fct>   <fct>   <fct> <chr>   <chr>   <date>       <dbl>
#>  1 IP_name State… LGA0… Facili… datim_… F     State … 0002    1980-03-27      40
#>  2 IP_name State… LGA0… Facili… datim_… F     State … 0002    1984-07-14      35
#>  3 IP_name State… LGA0… Facili… datim_… F     State … 0002    1980-01-01      37
#>  4 IP_name State… LGA0… Facili… datim_… M     State … 0003    1986-04-06      39
#>  5 IP_name State… LGA0… Facili… datim_… F     State … 0004    1972-01-01      NA
#>  6 IP_name State… LGA0… Facili… datim_… F     State … 0001    1980-01-01      NA
#>  7 IP_name State… LGA0… Facili… datim_… F     State … 0002    1971-02-04      27
#>  8 IP_name State… LGA0… Facili… datim_… F     State … 0001    1973-02-02      35
#>  9 IP_name State… LGA0… Facili… datim_… M     State … 0004    1965-05-13      23
#> 10 IP_name State… LGA0… Facili… datim_… M     State … 0008    1988-01-01      26
#> # … with 10,297 more rows, 42 more variables: current_age <dbl>,
#> #   art_start_date <date>, art_start_date_source <fct>,
#> #   last_drug_pickup_date <date>, last_drug_pickup_date_q1 <date>,
#> #   last_drug_pickup_date_q2 <date>, last_drug_pickup_date_q3 <date>,
#> #   last_drug_pickup_date_q4 <date>, last_regimen <fct>,
#> #   last_clinic_visit_date <date>, days_of_arv_refill <dbl>,
#> #   pregnancy_status <fct>, current_viral_load <dbl>, …
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
#>    ip      state  lga   facil…¹ datim…² sex   patie…³ hospi…⁴ date_of_…⁵ age_a…⁶
#>    <fct>   <fct>  <fct> <fct>   <fct>   <fct> <chr>   <chr>   <date>       <dbl>
#>  1 IP_name State… LGA0… Facili… datim_… M     State … 0001    1988-06-05      25
#>  2 IP_name State… LGA0… Facili… datim_… F     State … 0001    1975-05-15      22
#>  3 IP_name State… LGA0… Facili… datim_… F     State … 0001    1985-03-23      46
#>  4 IP_name State… LGA0… Facili… datim_… M     State … 0002    1957-05-11      18
#>  5 IP_name State… LGA0… Facili… datim_… F     State … 0002    1982-12-22      30
#>  6 IP_name State… LGA0… Facili… datim_… F     State … 0001    1985-06-10      NA
#>  7 IP_name State… LGA0… Facili… datim_… F     State … 0001    1960-05-19      25
#>  8 IP_name State… LGA0… Facili… datim_… M     State … 0003    1990-02-07      31
#>  9 IP_name State… LGA0… Facili… datim_… F     State … 0002    1982-01-01      22
#> 10 IP_name State… LGA0… Facili… datim_… F     State … 0004    1983-06-01      NA
#> # … with 27,010 more rows, 42 more variables: current_age <dbl>,
#> #   art_start_date <date>, art_start_date_source <fct>,
#> #   last_drug_pickup_date <date>, last_drug_pickup_date_q1 <date>,
#> #   last_drug_pickup_date_q2 <date>, last_drug_pickup_date_q3 <date>,
#> #   last_drug_pickup_date_q4 <date>, last_regimen <fct>,
#> #   last_clinic_visit_date <date>, days_of_arv_refill <dbl>,
#> #   pregnancy_status <fct>, current_viral_load <dbl>, …

## Generate list of clients that will be expected to have a viral load test done by March 2022
ndr_example %>%
  tx_vl_eligible("2022-03-31",
                 sample = TRUE)
#> # A tibble: 27,020 × 52
#>    ip      state  lga   facil…¹ datim…² sex   patie…³ hospi…⁴ date_of_…⁵ age_a…⁶
#>    <fct>   <fct>  <fct> <fct>   <fct>   <fct> <chr>   <chr>   <date>       <dbl>
#>  1 IP_name State… LGA0… Facili… datim_… M     State … 0001    1988-06-05      25
#>  2 IP_name State… LGA0… Facili… datim_… F     State … 0001    1975-05-15      22
#>  3 IP_name State… LGA0… Facili… datim_… F     State … 0001    1985-03-23      46
#>  4 IP_name State… LGA0… Facili… datim_… M     State … 0002    1957-05-11      18
#>  5 IP_name State… LGA0… Facili… datim_… F     State … 0002    1982-12-22      30
#>  6 IP_name State… LGA0… Facili… datim_… F     State … 0001    1985-06-10      NA
#>  7 IP_name State… LGA0… Facili… datim_… F     State … 0001    1960-05-19      25
#>  8 IP_name State… LGA0… Facili… datim_… M     State … 0003    1990-02-07      31
#>  9 IP_name State… LGA0… Facili… datim_… F     State … 0002    1982-01-01      22
#> 10 IP_name State… LGA0… Facili… datim_… F     State … 0004    1983-06-01      NA
#> # … with 27,010 more rows, 42 more variables: current_age <dbl>,
#> #   art_start_date <date>, art_start_date_source <fct>,
#> #   last_drug_pickup_date <date>, last_drug_pickup_date_q1 <date>,
#> #   last_drug_pickup_date_q2 <date>, last_drug_pickup_date_q3 <date>,
#> #   last_drug_pickup_date_q4 <date>, last_regimen <fct>,
#> #   last_clinic_visit_date <date>, days_of_arv_refill <dbl>,
#> #   pregnancy_status <fct>, current_viral_load <dbl>, …

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
  tx_appointment(from = "2021-01-01",
                 to = "2021-03-31",
                 ) %>%
  tx_vl_eligible(sample = TRUE)
#> # A tibble: 7,038 × 52
#>    ip      state  lga   facil…¹ datim…² sex   patie…³ hospi…⁴ date_of_…⁵ age_a…⁶
#>    <fct>   <fct>  <fct> <fct>   <fct>   <fct> <chr>   <chr>   <date>       <dbl>
#>  1 IP_name State… LGA0… Facili… datim_… F     State … 0001    1985-06-10      NA
#>  2 IP_name State… LGA0… Facili… datim_… F     State … 0001    1960-05-19      25
#>  3 IP_name State… LGA0… Facili… datim_… M     State … 0003    1986-04-06      39
#>  4 IP_name State… LGA0… Facili… datim_… F     State … 0004    1972-01-01      NA
#>  5 IP_name State… LGA0… Facili… datim_… F     State … 0001    1980-01-01      NA
#>  6 IP_name State… LGA0… Facili… datim_… F     State … 0005    1990-05-25      32
#>  7 IP_name State… LGA0… Facili… datim_… F     State … 0002    1971-02-04      27
#>  8 IP_name State… LGA0… Facili… datim_… M     State … 0005    1976-01-26      26
#>  9 IP_name State… LGA0… Facili… datim_… M     State … 0007    2002-01-01      37
#> 10 IP_name State… LGA0… Facili… datim_… F     State … 0002    1997-06-01      21
#> # … with 7,028 more rows, 42 more variables: current_age <dbl>,
#> #   art_start_date <date>, art_start_date_source <fct>,
#> #   last_drug_pickup_date <date>, last_drug_pickup_date_q1 <date>,
#> #   last_drug_pickup_date_q2 <date>, last_drug_pickup_date_q3 <date>,
#> #   last_drug_pickup_date_q4 <date>, last_regimen <fct>,
#> #   last_clinic_visit_date <date>, days_of_arv_refill <dbl>,
#> #   pregnancy_status <fct>, current_viral_load <dbl>, …
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
new <- tx_new(ndr_example, from = "2021-01-01", to = "2021-03-31")

## generates line-list of currently active clients
curr <- tx_curr(ndr_example)

## generates line-list of clients who were active at the beginning of the October but inactive at end of December 2021
ml <- tx_ml(new_data = ndr_example, from = "2021-01-01", to = "2021-03-31") 

summarise_ndr(new, curr, ml,
              level = "state",
              names = c("tx_new", "tx_curr", "tx_ml"))
#> # A tibble: 4 × 5
#>   ip      state   tx_new tx_curr tx_ml
#>   <chr>   <chr>    <int>   <int> <int>
#> 1 IP_name State 1    272    5647  2595
#> 2 IP_name State 2    300    7931  4152
#> 3 IP_name State 3    984   13446  3560
#> 4 Total   -         1556   27024 10307
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
new_clients <- tx_new(ndr_example, from = "2021-01-01", to = "2021-03-30")

disaggregate(new_clients,
             by = "current_age", pivot_wide = FALSE)
#> # A tibble: 49 × 4
#>    ip      state   current_age number
#>    <chr>   <chr>   <chr>        <int>
#>  1 IP_name State 1 <1               0
#>  2 IP_name State 1 1-4              2
#>  3 IP_name State 1 5-9              0
#>  4 IP_name State 1 10-14            0
#>  5 IP_name State 1 15-19           11
#>  6 IP_name State 1 20-24           37
#>  7 IP_name State 1 25-29           83
#>  8 IP_name State 1 30-34           63
#>  9 IP_name State 1 35-39           36
#> 10 IP_name State 1 40-44           24
#> # … with 39 more rows

## disaggregate 'TX_CURR' by sex

ndr_example %>%
  tx_curr() %>%
  disaggregate(by = "sex")
#> # A tibble: 4 × 5
#>   ip      state    Male Female unknown
#>   <chr>   <chr>   <int>  <int>   <int>
#> 1 IP_name State 1  1662   3985       0
#> 2 IP_name State 2  2335   5596       0
#> 3 IP_name State 3  5894   7552       0
#> 4 Total   -        9891  17133       0
```

## Code of Conduct

Please note that the {tidyndr} project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
