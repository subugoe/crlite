#' Use the [Crossref REST API](https://api.crossref.org/swagger-ui/index.html)
#'
#' @details
#' Will always try to authenticate into the most performant API pool possible,
#' but gracefully downgrades to less performant pools,
#' when `mailto` or `token` cannot be found.
#' See [req_auth_pool()] for details.
#'
#' @inheritParams req_auth_pool
#' @family api functions
#' @export
req_cr <- function(mailto = get_cr_mailto()) {
  httr2::request("https://api.crossref.org/works") %>%
    req_user_agent_cr(mailto = NULL) %>%
    # below overwrites above ua, duplication is necessary 
    # because only req_auth_pool() gives feedback
    req_auth_pool(mailto = mailto)
}

#' Set a user agent
#'
#' @param mailto a character scalar giving a valid email address.
#' @inheritParams httr2::req_user_agent
#' @keywords internal
req_user_agent_cr <- function(req, mailto = NULL) {
  if (is.null(mailto)) {
    ua <- paste0(
      "crlite/",
      utils::packageVersion("crlite"),
      "(https://github.com/subugoe/crlite/)"
    )
  } else {
    ua <- paste0(
      "crlite/",
      utils::packageVersion("crlite"),
      "(https://github.com/subugoe/crlite/; ",
      "mailto:",
      mailto,
      ")"
    )
  }
  httr2::req_user_agent(req = req, string = ua)
}

#' Test whether API can be reached
#' @family api functions
#' @export
can_api <- function() !httr2::resp_is_error(httr2::req_perform(req_head_cr()))

#' HEAD request
#' @noRd
req_head_cr <- function() req_cr() %>% httr2::req_method("HEAD")
