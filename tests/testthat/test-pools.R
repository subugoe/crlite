# integration tests ====

test_that("by default, public pool is used", {
  # knock out mailto
  withr::local_options(crlite.mailto = NULL)
  # knock out mdplus token
  withr::local_envvar(c("CR_MDPLUS_TOKEN" = NA))
  expect_true(can_pool("public"))
})
test_that("with mailto, polite pool is used", {
  skip("in dev")
  # knock out mdplus token
  withr::local_envvar(c("CR_MDPLUS_TOKEN" = NA))
  withr::local_options(
    crlite.mailto = "metacheck-support@sub.uni-goettingen.de"
  )
  expect_true(can_pool("polite"))
})
