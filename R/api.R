#' Use the [Crossref REST API](https://api.crossref.org/swagger-ui/index.html)
#'
#' @inheritDotParams req_ua_cr
#' 
#' @family api
#' @export
req_cr <- function(...) {
  httr2::request("https://api.crossref.org/") %>%
    req_ua_cr(...)
}

#' Set User Agent for HTTP requests
#'
#' @inheritParams httr2::req_user_agent
#' @param .mailto
#' a character string giving an email address to reach the user.
#' Passed on to Crossref as part of the user agent.
#' Used to contact the user if there are problems.
#' Defaults to `NULL`.
#' If provided, requests are served by a more performant
#' [polite pool](https://api.crossref.org/swagger-ui/index.html).
#' 
#' @family api
#' @keywords internal
#' @export
req_ua_cr <- function(req, .mailto = getOption("crlite.mailto", default = NULL)) {
  # input validation
  if (!is.null(.mailto)) stopifnot(is_email_address(.mailto))
  httr2::req_user_agent(
    req = req,
    string = paste0(
      "crlite/",
      utils::packageVersion("crlite"),
      paste0(
        "(",
        "https://github.com/subugoe/crlite/",
        if (!is.null(.mailto)) ";mailto:", .mailto,
        ")"
      )
    )
  )
}
