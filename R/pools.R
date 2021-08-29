# testing ====
#' Accessing different Crossref API pools
#'
#' In increasing order of performance: `r pools()`.
#'
#' @family api pool access functions
#' @export
pools <- function() c("public", "polite", "plus")

#' @describeIn pools Try to authenticate into the highest performing pool
#' 
#' Function checks whether a higher performance pool is possible,
#' using [could_pool()].
#' Only when that test passes, is the request authenticated.
#' The function thus gracefully recovers from bad `mailto` and `token`s.
#' The function emits intermittent messages about the chosen API pool.
#'
#' @inheritParams req_user_agent_cr
req_auth_pool <- function(req, mailto = get_cr_mailto()) {
  if (could_pool("polite")) {
    inform_pool("polite")
    req <- req_user_agent_cr(req, mailto = mailto)
  } else {
    inform_pool("public")
  }
  req
}

#' Inform user about email source
#' @noRd
inform_pool <- function(pool) {
  rlang::inform(
    c(
      "i" = paste(
        "Requesting the", pool, "API pool."
      )
    ),
    .frequency = "once",
    .frequency_id = "inform_pool"
  )
}


#' @describeIn pools Show the API pool which served a request
#' @inheritParams httr2::resp_header
#' @family api pool access functions
#' @export
resp_cr_pool <- function(resp) httr2::resp_header(resp, "x-api-pool")

#' @describeIn pools Was the request served by the expected pool?
#' Inspects the response header "x-api-pool" of an *existing* response
#' to see if it matches the expected pool.
#' @param pool giving the name of the expected pool
#' @export
was_pool <- function(resp, pool = pools()) {
  pool <- rlang::arg_match(pool)
  resp_cr_pool(resp) == pool
}

#' @describeIn pools Can requests be served by an expected pool?
#' Performs a request to the API and inspects the response header.
#' @export
can_pool <- function(pool = pools()) {
  pool <- rlang::arg_match(pool)
  resp_cr_pool(httr2::req_perform(req_head_cr())) == pool
}

#' @describeIn pools Could the request be served by an expected pool?
#' Checks whether the necessary credentials can be found
#' for higher performance pools.
#' @export
could_pool <- function(pool = pools()) {
  pool <- rlang::arg_match(pool)
  expected_rank <- match(pool, pools())
  actual_rank <- match(best_pool(), pools())
  expected_rank <= actual_rank
}

#' @describeIn pools What is the highest performing pool available?
#' Checks the necessary credentials for the highest performing pool.
#' @export
best_pool <- function(mailto = get_cr_mailto()) {
  res <- "public"
  mailto <- try(mailto, silent = TRUE)
  if (!inherits(mailto, "try-error") && is_email_address(mailto)) {
    res <- "polite"
  }
  res
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
#' In this order, returns the first valid email found in:
#'
#' 1. The `crlite.mailto` option.
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
#' Otherwise, the function errors out.
#' @export
get_cr_mailto <- function() {
  mailto <- getOption("crlite.mailto")
  if (!is.null(mailto)) {
    inform_mailto_source(mailto = mailto, from = "`crlite.mailto` option")
    return(mailto)
  }
  mailto <- Sys.getenv("CR_MD_MAILTO")
  if (mailto != "") {
    inform_mailto_source(mailto = mailto, from = "`CR_MD_MAILTO` env var")
    return(mailto)
  }
  if (requireNamespace("gert", quietly = TRUE)) {
    mailto <- try(
      gert::git_signature_parse(gert::git_signature_default())$email,
      silent = TRUE
    )
    if (!inherits(mailto, "try-error")) {
      inform_mailto_source(mailto = mailto, from = "your git config")
      return(mailto)
    }
  }
  rlang::abort(c("x" = "Could not find a Crossref user."))
}

#' Inform user about email source
#' @noRd
inform_mailto_source <- function(mailto, from) {
  rlang::inform(
    c(
      "i" = paste(
        "Using", mailto, "from", from, "as a Crossref user."
      )
    ),
    .frequency = "once",
    .frequency_id = "get_cr_mailto"
  )
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
