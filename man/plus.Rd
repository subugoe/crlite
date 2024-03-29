% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pools.R
\name{plus}
\alias{plus}
\alias{get_cr_token}
\title{Accessing the plus API pool}
\usage{
get_cr_token(service = "https://api.crossref.org", ...)
}
\arguments{
\item{service}{Service name, a character scalar.}

\item{...}{
  Arguments passed on to \code{\link[keyring:key_get]{keyring::key_get}}
  \describe{
    \item{\code{username}}{Username, a character scalar, or \code{NULL} if the key
is not associated with a username.}
    \item{\code{keyring}}{For systems that support multiple keyrings, specify
the name of the keyring to use here. If \code{NULL}, then the default
keyring is used. See also \code{\link[keyring:has_keyring_support]{has_keyring_support()}}.}
  }}
}
\description{
Accessing the plus API pool
}
\section{Related Functions and Methods}{
\subsection{Functions}{
\itemize{
\item \code{get_cr_token}: Get the token to authenticate into the plus tool.

In this order, returns the first hit of:
\enumerate{
\item \code{CR_MD_PLUS_TOKEN} environment variable
(recommended only for secure environment variables in the cloud),
\item an entry in the OS keychain manager for \code{service} and \code{username},
\item \code{NULL} with a warning.
}
}}}

\seealso{
Other api pool access functions: 
\code{\link{polite}},
\code{\link{pools}()}
}
\concept{api pool access functions}
