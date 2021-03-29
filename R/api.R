#' Use the [Crossref REST API](https://github.com/CrossRef/rest-api-doc)
#' 
#' @section Warning:
#' If you are using this in your own package, or create a lot of traffic,
#' please set your own [httr::user_agent()].
#' 
#' @family api
#' @name api
NULL

#' VERB the Crossref REST API
#' @inheritDotParams httr::VERB
#' @noRd
verb_cr <- function(...) {
  httr::VERB(
    url = "https://api.crossref.org/",
    httr::user_agent("http://github.com/subugoe/crlite"),
    ...
  )
}

#' GET the Crossref REST API
#' @noRd
get_cr <- function(...) verb_cr(verb = "GET", ...)

#' HEAD the Crossref REST API
#' @noRd
head_cr <- function(...) verb_cr(verb = "HEAD", ...)
