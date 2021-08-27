# testing ====
#' Diagnosing API pools
#' @name pools
#' @family api pool access functions
NULL

#' @describeIn pools Show the API pool which served a request
#' @inheritParams httr2::resp_header
#' @family api pool access functions
#' @export
resp_cr_pool <- function(resp) {
  httr2::resp_header(resp, "x-api-pool")
}

#' @describeIn pools Was the request served by the expected pool?
#' @param pool giving the name of the expected pool.
#' Listed in order of increasing performance.
#' @export
was_pool <- function(resp, pool = c("public", "polite", "plus")) {
  pool <- rlang::arg_match(pool)
  resp_cr_pool(resp) == pool
}

#' @describeIn pools Can the request be served by an expected pool?
#' @export
can_pool <- function(pool = c("public", "polite", "plus")) {
  pool <- rlang::arg_match(pool)
  resp_cr_pool(httr2::req_perform(req_head_cr())) == pool
}

# mailto for polite ====
#' Accessing the polite API pool
#' @name polite
#' @family api pool access functions
NULL

#' @describeIn polite
#' Get the email address to authenticate into the polite pool
#'
#' Whenever possible, API calls should be identified by an email address
#' to reach the human responsible for making the call.
#' In this order, returns the first hit of:
#'
#' 1. The `CR_MD_MAILTO` environment variable
#'     (recommended only for secure environment variables in the cloud).
#'
#'     On GitHub Actions, you can set the `CR_MD_MAILTO` environment variable
#'     to the email of the committer by retrieving the
#'     [pusher email](https://docs.github.com/en/developers/webhooks-and-events/webhooks/webhook-events-and-payloads#push)
#'     thus:
#'
#'    ```yaml
#'    env:
#'      CR_MD_MAILTO: ${{ github.event.pusher.email }}
#'    ```
#' 1. The git user email address for the repo at the working directory.
#'    This
#'
#' Or errors out.
#' @export
get_cr_mailto <- function() {
  mailto <- Sys.getenv("CR_MD_MAILTO")
  if (is_email_address(mailto)) {
    rlang::inform(c(
      "i" = paste(
        "Using",
        mailto,
        "from environment variable `CR_MD_MAILTO` as a Crossref user."
      )
    ))
    return(mailto)
  }
  if (requireNamespace("gert", quietly = TRUE)) {
    mailto <- try(gert::git_signature_parse(gert::git_signature_default
    ())$email)
    if (is_email_address(mailto)) {
      rlang::inform(
        c(
          "i" = paste(
            "Using", mailto, "from your git config as a Crossref user."
          )
        ),
        .frequency = "once",
        .frequency_id = "get_cr_mailto"
      )
      return(mailto)
    }
  } else {
    rlang::abort(c("x" = "Could not find a Crossref user."))
  }
}

# token for plus ====
#' Accessing the plus API pool
#' @name plus
#' @family api pool access functions
NULL


#' @describeIn plus Get the token to authenticate into the plus tool.
#'
#' In this order, returns the first hit of:
#'
#' 1. `CR_MD_PLUS_TOKEN` environment variable
#'     (recommended only for secure environment variables in the cloud),
#' 1. an entry in the OS keychain manager for `service` and `username`,
#' 1. `NULL` with a warning.
#'
#' @param service,username
#' A character string giving the service and username
#' under which the token can be found in the OS keychain.
#'
#' @export
get_cr_token <- function(service = "https://api.crossref.org",
                         username = get_cr_mailto()) {
  if (Sys.getenv("CR_MD_PLUS_TOKEN") != "") {
    return(Sys.getenv("CR_MD_PLUS_TOKEN"))
  } else {
    tryCatch(
      expr = keyring::key_get(service = service, username = username),
      error = function(x) {
        warning(
          "No crossref plus token could be found. ",
          "Performance may be degraded."
        )
      }
    )
  }
}
