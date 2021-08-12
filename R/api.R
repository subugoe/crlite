#' Use the [Crossref REST API](https://github.com/CrossRef/rest-api-doc)
#' 
#' @inheritDotParams httr::VERB
#' 
#' @param .contact
#' a character string giving an email address to reach the user.
#' Passed on to Crossref.
#' Used  to contact the user if there are problems.
#' Defaults to `NULL`.
#' If provided, requests are served by a more performant
#' [polite pool](https://github.com/CrossRef/rest-api-doc#good-manners--more-reliable-service).
#' 
#' @family api
verb_cr <- function(...,
                    .contact = getOption("crlite.contact", default = NULL)) {
  httr::VERB(
    url = "https://api.crossref.org/",
    httr::user_agent(paste0(
      "http://github.com/subugoe/crlite",
      if (!is.null(.contact)) paste0(" mailto:", .contact)
    )),
    ...
  )
}

#' GET the Crossref REST API
#' @noRd
get_cr <- function(...) verb_cr(verb = "GET", ...)

#' HEAD the Crossref REST API
#' @noRd
head_cr <- function(...) verb_cr(verb = "HEAD", ...)
