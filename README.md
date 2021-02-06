
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tidyndr

<!-- badges: start -->
<!-- badges: end -->

The goal of {tidyndr} is to provide specialized, simple and easy to use
functions that wrap around existing functions in `R` for manipulation of
the [NDR](http://ndr.shieldnigeriaproject.com) patient line-list file
allowing the user to focus on the tasks to be completed rather than the
details of the code.

The functions presented are similar to the [PEPFAR MER
indicators](https://datim.zendesk.com/hc/en-us/articles/360000084446-MER-Indicator-Reference-Guides)
and are currently grouped into three categories:

-   The `read_ndr` function for reading the patient-level line-list
    downloaded from the front-end of the NDR in ‘csv’ format.

-   The PEPFAR treatment group of indicators that can be performed on
    the NDR line-list.

-   The ‘Viral Suppression’ indicators (`tx_vl_eligible()`,
    `tx_pvls_den()` and `tx_pvls_num()`).

## Installation

<!-- You can install the released version of tidyndr from [CRAN](https://CRAN.R-project.org) with: -->
<!-- ``` r -->
<!-- install.packages("tidyndr") -->
<!-- ``` -->

This package is currently not available on
[CRAN](https://CRAN.R-project.org) but you can install the development
version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("stephenbalogun/tidyndr")
```

## Usage

``` r
library(tidyndr)
```

### read\_ndr

`read_ndr()` reads the downloaded csv file into
[`R`](https:://cran.r-project.org) using
[`vroom::vroom()`](https://vroom.r-lib.org/) behind the scene and
passing appropriate column types to the `col_types` argument. It also
formats the variable names using the
[`snakecase`](https://en.wikipedia.org/wiki/Snake_case) style. It can
read from the local file or from a line-list placed on the internet.

``` r
## read from a local file path (not run)

# file_path <- system.file("extdata", "ndr_example.csv", package = "tidyndr")

# read_ndr(file_path)

### read line-list available on the internet
path <- "https://raw.githubusercontent.com/stephenbalogun/example_files/main/ndr_example.csv"

ndr_example <- read_ndr(path)
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
#> # A tibble: 4,398 x 48
#>    ip    state lga   facility datim_code sex   patient_identif~ hospital_number
#>    <fct> <fct> <fct> <fct>    <fct>      <fct> <chr>            <chr>          
#>  1 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 3006       0002           
#>  2 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 2008       0003           
#>  3 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ M     State 30015      0004           
#>  4 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ M     State 30033      0008           
#>  5 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ M     State 30040      00012          
#>  6 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ M     State 30044      00013          
#>  7 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ M     State 30046      00015          
#>  8 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ M     State 30049      00017          
#>  9 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ M     State 30051      00014          
#> 10 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 20038      00016          
#> # ... with 4,388 more rows, and 40 more variables: date_of_birth <date>,
#> #   age_at_art_initiation <dbl>, current_age <dbl>, art_start_date <date>,
#> #   art_start_date_source <fct>, last_drug_pickup_date <date>,
#> #   last_drug_pickup_date_q1 <date>, last_drug_pickup_date_q2 <date>,
#> #   last_drug_pickup_date_q3 <date>, last_drug_pickup_date_q4 <date>,
#> #   last_regimen <fct>, last_clinic_visit_date <date>,
#> #   days_of_arv_refill <dbl>, pregnancy_status <fct>, current_viral_load <dbl>,
#> #   date_of_current_viral_load <date>, current_viral_load_q1 <dbl>,
#> #   date_of_current_viral_load_q1 <date>, current_viral_load_q2 <dbl>,
#> #   date_of_current_viral_load_q2 <date>, current_viral_load_q3 <dbl>,
#> #   date_of_current_viral_load_q3 <date>, current_viral_load_q4 <dbl>,
#> #   date_of_current_viral_load_q4 <date>, current_status_28_days <fct>,
#> #   current_status_90_days <fct>, current_status_q1_28_days <fct>,
#> #   current_status_q1_90_days <fct>, current_status_q2_28_days <fct>,
#> #   current_status_q2_90_days <fct>, current_status_q3_28_days <fct>,
#> #   current_status_q3_90_days <fct>, current_status_q4_28_days <fct>,
#> #   current_status_q4_90_days <fct>, patient_has_died <lgl>,
#> #   patient_deceased_date <date>, patient_transferred_out <lgl>,
#> #   transferred_out_date <date>, patient_transferred_in <lgl>,
#> #   transferred_in_date <date>

## Subset "TX_CURR" for a state
ndr_example %>%
  tx_curr(states = "State 1")
#> # A tibble: 6,213 x 48
#>    ip    state lga   facility datim_code sex   patient_identif~ hospital_number
#>    <fct> <fct> <fct> <fct>    <fct>      <fct> <chr>            <chr>          
#>  1 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ M     State 1002       0001           
#>  2 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 1003       0002           
#>  3 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 1004       0003           
#>  4 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 1005       0004           
#>  5 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ M     State 1008       0001           
#>  6 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 10010      0006           
#>  7 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 10012      0004           
#>  8 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 10013      0007           
#>  9 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 10014      0008           
#> 10 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 10017      0005           
#> # ... with 6,203 more rows, and 40 more variables: date_of_birth <date>,
#> #   age_at_art_initiation <dbl>, current_age <dbl>, art_start_date <date>,
#> #   art_start_date_source <fct>, last_drug_pickup_date <date>,
#> #   last_drug_pickup_date_q1 <date>, last_drug_pickup_date_q2 <date>,
#> #   last_drug_pickup_date_q3 <date>, last_drug_pickup_date_q4 <date>,
#> #   last_regimen <fct>, last_clinic_visit_date <date>,
#> #   days_of_arv_refill <dbl>, pregnancy_status <fct>, current_viral_load <dbl>,
#> #   date_of_current_viral_load <date>, current_viral_load_q1 <dbl>,
#> #   date_of_current_viral_load_q1 <date>, current_viral_load_q2 <dbl>,
#> #   date_of_current_viral_load_q2 <date>, current_viral_load_q3 <dbl>,
#> #   date_of_current_viral_load_q3 <date>, current_viral_load_q4 <dbl>,
#> #   date_of_current_viral_load_q4 <date>, current_status_28_days <fct>,
#> #   current_status_90_days <fct>, current_status_q1_28_days <fct>,
#> #   current_status_q1_90_days <fct>, current_status_q2_28_days <fct>,
#> #   current_status_q2_90_days <fct>, current_status_q3_28_days <fct>,
#> #   current_status_q3_90_days <fct>, current_status_q4_28_days <fct>,
#> #   current_status_q4_90_days <fct>, patient_has_died <lgl>,
#> #   patient_deceased_date <date>, patient_transferred_out <lgl>,
#> #   transferred_out_date <date>, patient_transferred_in <lgl>,
#> #   transferred_in_date <date>

## Generate line-list of clients with medication refill in January 2021 for a facility (Facility 1)
ndr_example %>%
  tx_appointment(from = "2021-01-01",
                 to = "2021-01-31",
                 facilities = "Facility 1")
#> # A tibble: 316 x 49
#>    ip    state lga   facility datim_code sex   patient_identif~ hospital_number
#>    <fct> <fct> <fct> <fct>    <fct>      <fct> <chr>            <chr>          
#>  1 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 20023      0002           
#>  2 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ M     State 30044      00013          
#>  3 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 200140     00020          
#>  4 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 200249     00033          
#>  5 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 300310     00059          
#>  6 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ M     State 300504     00085          
#>  7 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 200457     00062          
#>  8 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 300565     00090          
#>  9 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ M     State 200641     00086          
#> 10 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 200656     00091          
#> # ... with 306 more rows, and 41 more variables: date_of_birth <date>,
#> #   age_at_art_initiation <dbl>, current_age <dbl>, art_start_date <date>,
#> #   art_start_date_source <fct>, last_drug_pickup_date <date>,
#> #   last_drug_pickup_date_q1 <date>, last_drug_pickup_date_q2 <date>,
#> #   last_drug_pickup_date_q3 <date>, last_drug_pickup_date_q4 <date>,
#> #   last_regimen <fct>, last_clinic_visit_date <date>,
#> #   days_of_arv_refill <dbl>, pregnancy_status <fct>, current_viral_load <dbl>,
#> #   date_of_current_viral_load <date>, current_viral_load_q1 <dbl>,
#> #   date_of_current_viral_load_q1 <date>, current_viral_load_q2 <dbl>,
#> #   date_of_current_viral_load_q2 <date>, current_viral_load_q3 <dbl>,
#> #   date_of_current_viral_load_q3 <date>, current_viral_load_q4 <dbl>,
#> #   date_of_current_viral_load_q4 <date>, current_status_28_days <fct>,
#> #   current_status_90_days <fct>, current_status_q1_28_days <fct>,
#> #   current_status_q1_90_days <fct>, current_status_q2_28_days <fct>,
#> #   current_status_q2_90_days <fct>, current_status_q3_28_days <fct>,
#> #   current_status_q3_90_days <fct>, current_status_q4_28_days <fct>,
#> #   current_status_q4_90_days <fct>, patient_has_died <lgl>,
#> #   patient_deceased_date <date>, patient_transferred_out <lgl>,
#> #   transferred_out_date <date>, patient_transferred_in <lgl>,
#> #   transferred_in_date <date>, appointment_date <date>

## Generate list of clients who were active at the beginning of FY21 but became inactive at the end of Q1 of FY21.
ndr_example %>%
  tx_ml(from = "2020-10-01",
        to = "2020-12-31")
#> # A tibble: 4,020 x 49
#>    ip    state lga   facility datim_code sex   patient_identif~ hospital_number
#>    <fct> <fct> <fct> <fct>    <fct>      <fct> <chr>            <chr>          
#>  1 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 2002       0001           
#>  2 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 2008       0003           
#>  3 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 30020      0001           
#>  4 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 20015      0007           
#>  5 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 20025      0001           
#>  6 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ M     State 20033      00014          
#>  7 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ M     State 20036      00013          
#>  8 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ M     State 30062      00023          
#>  9 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ M     State 20049      00021          
#> 10 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 20051      00022          
#> # ... with 4,010 more rows, and 41 more variables: date_of_birth <date>,
#> #   age_at_art_initiation <dbl>, current_age <dbl>, art_start_date <date>,
#> #   art_start_date_source <fct>, last_drug_pickup_date <date>,
#> #   last_drug_pickup_date_q1 <date>, last_drug_pickup_date_q2 <date>,
#> #   last_drug_pickup_date_q3 <date>, last_drug_pickup_date_q4 <date>,
#> #   last_regimen <fct>, last_clinic_visit_date <date>,
#> #   days_of_arv_refill <dbl>, pregnancy_status <fct>, current_viral_load <dbl>,
#> #   date_of_current_viral_load <date>, current_viral_load_q1 <dbl>,
#> #   date_of_current_viral_load_q1 <date>, current_viral_load_q2 <dbl>,
#> #   date_of_current_viral_load_q2 <date>, current_viral_load_q3 <dbl>,
#> #   date_of_current_viral_load_q3 <date>, current_viral_load_q4 <dbl>,
#> #   date_of_current_viral_load_q4 <date>, current_status_28_days <fct>,
#> #   current_status_90_days <fct>, current_status_q1_28_days <fct>,
#> #   current_status_q1_90_days <fct>, current_status_q2_28_days <fct>,
#> #   current_status_q2_90_days <fct>, current_status_q3_28_days <fct>,
#> #   current_status_q3_90_days <fct>, current_status_q4_28_days <fct>,
#> #   current_status_q4_90_days <fct>, patient_has_died <lgl>,
#> #   patient_deceased_date <date>, patient_transferred_out <lgl>,
#> #   transferred_out_date <date>, patient_transferred_in <lgl>,
#> #   transferred_in_date <date>, date_lost <date>
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
#> # A tibble: 22,741 x 48
#>    ip    state lga   facility datim_code sex   patient_identif~ hospital_number
#>    <fct> <fct> <fct> <fct>    <fct>      <fct> <chr>            <chr>          
#>  1 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 3001       0001           
#>  2 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 2001       0001           
#>  3 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ M     State 1002       0001           
#>  4 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 3004       0003           
#>  5 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 2005       0002           
#>  6 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 1003       0002           
#>  7 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 3007       0001           
#>  8 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ M     State 3008       0003           
#>  9 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ M     State 3009       0004           
#> 10 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 1004       0003           
#> # ... with 22,731 more rows, and 40 more variables: date_of_birth <date>,
#> #   age_at_art_initiation <dbl>, current_age <dbl>, art_start_date <date>,
#> #   art_start_date_source <fct>, last_drug_pickup_date <date>,
#> #   last_drug_pickup_date_q1 <date>, last_drug_pickup_date_q2 <date>,
#> #   last_drug_pickup_date_q3 <date>, last_drug_pickup_date_q4 <date>,
#> #   last_regimen <fct>, last_clinic_visit_date <date>,
#> #   days_of_arv_refill <dbl>, pregnancy_status <fct>, current_viral_load <dbl>,
#> #   date_of_current_viral_load <date>, current_viral_load_q1 <dbl>,
#> #   date_of_current_viral_load_q1 <date>, current_viral_load_q2 <dbl>,
#> #   date_of_current_viral_load_q2 <date>, current_viral_load_q3 <dbl>,
#> #   date_of_current_viral_load_q3 <date>, current_viral_load_q4 <dbl>,
#> #   date_of_current_viral_load_q4 <date>, current_status_28_days <fct>,
#> #   current_status_90_days <fct>, current_status_q1_28_days <fct>,
#> #   current_status_q1_90_days <fct>, current_status_q2_28_days <fct>,
#> #   current_status_q2_90_days <fct>, current_status_q3_28_days <fct>,
#> #   current_status_q3_90_days <fct>, current_status_q4_28_days <fct>,
#> #   current_status_q4_90_days <fct>, patient_has_died <lgl>,
#> #   patient_deceased_date <date>, patient_transferred_out <lgl>,
#> #   transferred_out_date <date>, patient_transferred_in <lgl>,
#> #   transferred_in_date <date>

## Generate list of clients that will be expected to have a viral load test done in Q2 of FY21 for "State 2"
ndr_example %>%
  tx_vl_eligible("2021-03-31",
                 states = "State 2",
                 sample = TRUE)
#> # A tibble: 1,551 x 48
#>    ip    state lga   facility datim_code sex   patient_identif~ hospital_number
#>    <fct> <fct> <fct> <fct>    <fct>      <fct> <chr>            <chr>          
#>  1 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 20023      0002           
#>  2 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 20028      0001           
#>  3 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 20032      00012          
#>  4 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 20048      0004           
#>  5 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 20058      0003           
#>  6 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 20061      0004           
#>  7 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ M     State 20085      00027          
#>  8 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 200102     00013          
#>  9 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 200107     00035          
#> 10 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ M     State 200120     00043          
#> # ... with 1,541 more rows, and 40 more variables: date_of_birth <date>,
#> #   age_at_art_initiation <dbl>, current_age <dbl>, art_start_date <date>,
#> #   art_start_date_source <fct>, last_drug_pickup_date <date>,
#> #   last_drug_pickup_date_q1 <date>, last_drug_pickup_date_q2 <date>,
#> #   last_drug_pickup_date_q3 <date>, last_drug_pickup_date_q4 <date>,
#> #   last_regimen <fct>, last_clinic_visit_date <date>,
#> #   days_of_arv_refill <dbl>, pregnancy_status <fct>, current_viral_load <dbl>,
#> #   date_of_current_viral_load <date>, current_viral_load_q1 <dbl>,
#> #   date_of_current_viral_load_q1 <date>, current_viral_load_q2 <dbl>,
#> #   date_of_current_viral_load_q2 <date>, current_viral_load_q3 <dbl>,
#> #   date_of_current_viral_load_q3 <date>, current_viral_load_q4 <dbl>,
#> #   date_of_current_viral_load_q4 <date>, current_status_28_days <fct>,
#> #   current_status_90_days <fct>, current_status_q1_28_days <fct>,
#> #   current_status_q1_90_days <fct>, current_status_q2_28_days <fct>,
#> #   current_status_q2_90_days <fct>, current_status_q3_28_days <fct>,
#> #   current_status_q3_90_days <fct>, current_status_q4_28_days <fct>,
#> #   current_status_q4_90_days <fct>, patient_has_died <lgl>,
#> #   patient_deceased_date <date>, patient_transferred_out <lgl>,
#> #   transferred_out_date <date>, patient_transferred_in <lgl>,
#> #   transferred_in_date <date>

### Calculate the Viral Load Coverage for State 3
no_of_vl_results <- tx_pvls_den(ndr_example, states = "State 3") %>%
  nrow()
no_of_vl_eligible <- tx_vl_eligible(ndr_example, states = "State 3") %>%
  nrow()

vl_coverage <- scales::percent(no_of_vl_results / no_of_vl_eligible)

print(vl_coverage)
#> [1] "74%"
```

For all the ‘Treatment’ and ‘Viral Suppression’ indicators (except
`tx_ml_outcomes()`, which should be use with `tx_ml()`), you have
control over the level of action (state or facility) by supplying to the
`state` and/or `facility` arguments the values of interest . For more
than one state or facility, combine the values with the `c()` with each
one in quotation and separated by a comma e.g.

``` r
## subset clients that have medication appointment in Q2 of FY21 for "State 1" and "State 3" and are also due for viral load
ndr_example %>%
  tx_appointment(from = "2021-01-01",
                 to = "2021-03-31",
                 states = c("State 1", "State 3")) %>%
  tx_vl_eligible(sample = TRUE)
#> # A tibble: 328 x 49
#>    ip    state lga   facility datim_code sex   patient_identif~ hospital_number
#>    <fct> <fct> <fct> <fct>    <fct>      <fct> <chr>            <chr>          
#>  1 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 1003       0002           
#>  2 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 30098      00034          
#>  3 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ M     State 10050      00017          
#>  4 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 10052      00024          
#>  5 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 300126     00047          
#>  6 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 300146     00054          
#>  7 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 10089      00029          
#>  8 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ M     State 300200     00066          
#>  9 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 100112     00051          
#> 10 IP_n~ Stat~ LGA0~ Facilit~ datim_cod~ F     State 100137     00061          
#> # ... with 318 more rows, and 41 more variables: date_of_birth <date>,
#> #   age_at_art_initiation <dbl>, current_age <dbl>, art_start_date <date>,
#> #   art_start_date_source <fct>, last_drug_pickup_date <date>,
#> #   last_drug_pickup_date_q1 <date>, last_drug_pickup_date_q2 <date>,
#> #   last_drug_pickup_date_q3 <date>, last_drug_pickup_date_q4 <date>,
#> #   last_regimen <fct>, last_clinic_visit_date <date>,
#> #   days_of_arv_refill <dbl>, pregnancy_status <fct>, current_viral_load <dbl>,
#> #   date_of_current_viral_load <date>, current_viral_load_q1 <dbl>,
#> #   date_of_current_viral_load_q1 <date>, current_viral_load_q2 <dbl>,
#> #   date_of_current_viral_load_q2 <date>, current_viral_load_q3 <dbl>,
#> #   date_of_current_viral_load_q3 <date>, current_viral_load_q4 <dbl>,
#> #   date_of_current_viral_load_q4 <date>, current_status_28_days <fct>,
#> #   current_status_90_days <fct>, current_status_q1_28_days <fct>,
#> #   current_status_q1_90_days <fct>, current_status_q2_28_days <fct>,
#> #   current_status_q2_90_days <fct>, current_status_q3_28_days <fct>,
#> #   current_status_q3_90_days <fct>, current_status_q4_28_days <fct>,
#> #   current_status_q4_90_days <fct>, patient_has_died <lgl>,
#> #   patient_deceased_date <date>, patient_transferred_out <lgl>,
#> #   transferred_out_date <date>, patient_transferred_in <lgl>,
#> #   transferred_in_date <date>, appointment_date <date>
```

### Summarising your indicators

You might want to generate a summary table of all the indicators you
have pulled out. The `summarise_ndr()` (or `summarize_ndr()`) allows you
to do this with ease. It accepts all the line-lists you are interested
in creating a summary table for, the level at which you want the summary
to be performed (country/ip, state or facility), and the names you want
to give to each of your summary column.

``` r
new <- tx_new(ndr_example)  ## generates line-list of TX_NEW for the FY
curr <- tx_curr(ndr_example) ## generates line-list of currently active clients
ml <- tx_ml(ndr_example) ## generates line-list of clients who were active at the beginning of the FY but currently inactive

summarise_ndr(data = list(new, curr, ml),
              level = "state",
              names = c("tx_new", "tx_curr", "tx_ml"))
#>       ip   state tx_new tx_curr tx_ml
#>  IP_name State 1    459    6213  2368
#>  IP_name State 3   2925   14393  2749
#>  IP_name State 2   1014    8592  3676
#>    Total       -   4398   29198  8793
```
