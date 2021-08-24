#' Diagnosing API pools
#' @name pools
#' @family authentication functions
NULL

#' @describeIn pools Show the API pool which served a request
#' @inheritParams httr2::resp_header
#' @family authentication functions
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
