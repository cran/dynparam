% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/distribution_normal.R
\name{normal_distribution}
\alias{normal_distribution}
\title{Normal distribution}
\usage{
normal_distribution(mean, sd, lower = -Inf, upper = Inf)
}
\arguments{
\item{mean}{Mean of the distribution}

\item{sd}{Standard deviation of the distribution.}

\item{lower}{An optional lower limit.}

\item{upper}{An optional upper limit.}
}
\description{
Distributions are used for defining the domain of an \code{\link[=integer_parameter]{integer_parameter()}} or \code{\link[=numeric_parameter]{numeric_parameter()}}.
}
\examples{
normal_distribution(mean = 0, sd = 1)

normal_distribution(mean = 5, sd = 1, lower = 1, upper = 10)
}
\seealso{
\link{dynparam} for an overview of all dynparam functionality.
}
