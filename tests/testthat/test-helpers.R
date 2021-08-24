test_that("emails can be validated", {
  expect_true(is_email_address("foo@example.com"))
  expect_false(is_email_address("baz"))
})
