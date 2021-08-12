# integration tests

# polite pool
test_that("polite pool can be used", {
  expect_equal(
    httr::headers(head_cr(path = "members/98"))[["x-api-pool"]],
    "public"
  )
  with_contact <- httr::headers(
    head_cr(path = "members/98", .contact = "held@sub.uni-goettingen.de")
  )
  expect_equal(with_contact[["x-api-pool"]], "polite")
})

test_that("contact option is used", {
  withr::local_options(crlite.contact = "held@sub.uni-goettingen.de")
  expect_equal(
    httr::headers(head_cr(path = "members/98"))[["x-api-pool"]],
    "polite"
  )
})

test_that("HEAD requests work", {
  expect_equal(httr::status_code(head_cr(path = "members/98")), 200L)
})
