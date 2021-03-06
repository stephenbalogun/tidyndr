% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tx_appointment.R
\name{tx_appointment}
\alias{tx_appointment}
\title{Subset rows of clients who have clinic appointment/medication pick-up within
a particular period}
\usage{
tx_appointment(
  data,
  from = get("fy_start")(),
  to = get("Sys.Date")(),
  states = .s,
  facilities = .f
)
}
\arguments{
\item{data}{An NDR dataframe imported using the `read_ndr().}

\item{from}{The start date in ISO8601 format (i.e. "yyyy-mm-dd").
The default is to start at the beginning of the current Fiscal Year (i.e. 1st of October).}

\item{to}{The end date written in ISO8601 format (i.e. "yyyy-mm-dd").
The default is the date of analysis.}

\item{states}{The name(s) of the State(s) of interest. The default utilizes all
the states in the dataframe. If specifying more than one state, combine the
states using the \code{c()} e.g. \code{c("State 1", "State 2")}.}

\item{facilities}{The name(s) of the facilit(ies) of interest. Default is to utilize
all the facilities contained in the dataframe. If specifying more than one
facility, combine the facilities using the \code{c()} e.g.
\code{c("Facility 1", "Facility 2")}.}
}
\value{
tx_appointment
}
\description{
\code{tx_appointment} generates the line-list of clients who have clinic
appointment/medication refill for the specified state(s) and/or facilit(ies).
The default is to generate the appointment list for all the
states/facilities.
}
\examples{
# Determine clients who have medication refill in Q2 of FY21
tx_appointment(ndr_example,
  from = "2021-01-01",
  to = "2021-03-30"
)

# Determine clients who have medication refill in March 2021 using the 'default' status
tx_appointment(ndr_example,
  from = "2021-03-01",
  to = "2021-03-31",
)

# Determine clients with medication refill in January 2021 for a particular facility
tx_appointment(ndr_example,
  from = "2021-01-01",
  to = "2021-01-31",
  states = "State 1",
  facilities = "Facility 1"
)
}
