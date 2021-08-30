# unit tests ====

test_that("email from env var can be found", {
  # testing git email from git config too hard;
  # many test envs won't have git available
  withr::local_envvar(
    c("CR_MD_MAILTO" = "metacheck-support@sub.uni-goettingen.de")
  )
  expect_true(is_email_address(suppressMessages(get_cr_mailto())))
})


# integration tests ====

test_that("by default, public pool is used", {
  # knock out mailto
  withr::local_options(crlite.mailto = NULL)
  withr::local_envvar(c("CR_MD_MAILTO" = NA))
  # knock out mdplus token
  withr::local_envvar(c("CR_MDPLUS_TOKEN" = NA))
  # knock out git email
  withr::local_dir(tempdir())
  expect_true(can_pool("public"))
})
test_that("with mailto, polite pool is used", {
  # knock out mdplus token
  withr::local_envvar(c("CR_MDPLUS_TOKEN" = NA))
  withr::local_options(
    crlite.mailto = "metacheck-support@sub.uni-goettingen.de"
  )
  expect_true(can_pool("polite"))
})
