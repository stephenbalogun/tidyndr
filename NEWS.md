# tidyndr 0.2.1

# tidyndr 0.1.0

-   Added a `NEWS.md` file to track changes to the package.

# tidyndr 0.1.1

## Bug fix

-   Fixed the error related to the `disaggregate()`

## Minor update

-   Disaggregated `current_age` column to align with the PEPFAR MER 2.6 guidance

# tidyndr 0.2.0

## New functions

-   Added HIV-1 recent infection indicators

    -   `hts_tst_pos()`

    -   `recent_eligible()`

    -   `hts_recent()`

    -   `rtri_recent()`

    -   `rita_sample()`

    -   `rita_result()`

    -   `rita_recent()`

    -   `summarise_recency()`

    -   `summarize_recency()`

## New dataset

-   Included a simulated dataset for the HIV-1 recent infection (recency) indicators

## Minor update

-   Updated `read_ndr()` to accommodate recency line-list

-   Modified `summarise_recency()` to make the `names` argument optional

-   Updated the `ndr_example` data set

-   Updated vignettes to reflect the new inclusions and modifications

# tidyndr 0.2.1

## New functions

-   Added two cascade functions

    -   `vl_cascade()`

    -   `cot_cascade()`

## Minor update

-   Modified functions such that transfer out patients are active until medications are exhausted

-   Changed default status to "default"

-   Viral load indicators now have an additional argument `use_six_months` which defaults to `TRUE`

-   Most functions that generate line lists now have an additional argument - `remove_duplicates` to determine if the outcome should be de-duplicated

-   Updated viral load indicators to accommodate varying length of months in the calculations
