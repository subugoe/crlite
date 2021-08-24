# unit tests ====

test_that("user agent is properly set", {
  expect_snapshot(req_cr()$options$useragent)
})

# integration tests ====

test_that("w/o mailto, public pool is used", {
  expect_equal(
    httr2::req_perform(req_cr())$headers[["x-api-pool"]],
    "public"
  )
})
test_that("with mailto, public pool is used", {
  withr::local_options(
    crlite.mailto = "metacheck-support@sub.uni-goettingen.de"
  )
  expect_equal(
    httr2::req_perform(req_cr())$headers[["x-api-pool"]],
    "polite"
  )
})
