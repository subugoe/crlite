#' Use the [Crossref REST API](https://api.crossref.org/swagger-ui/index.html)
#'
#' @family api functions
#' @export
req_cr <- function() {
  httr2::request("https://api.crossref.org/") %>%
    req_ua_cr()
}

#' Set a user agent
#'
#' @inheritParams httr2::req_user_agent
#' @noRd
req_ua_cr <- function(req) {
  httr2::req_user_agent(
    req = req,
    string = paste0(
      "crlite/",
      utils::packageVersion("crlite"),
      "(https://github.com/subugoe/crlite/)"
    )
  )
}

#' Test whether API can be reached
#' @family api functions
#' @export
can_api <- function() {
  !httr2::resp_is_error(httr2::req_perform(req_head_cr()))
}

#' HEAD request
#' @noRd
req_head_cr <- function() req_cr() %>% httr2::req_method("HEAD")
