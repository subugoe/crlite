# unit tests ====

test_that("user agent is properly set", {
  expect_equal(
    req_cr()$options$useragent,
    "crlite/0.0.0.9000(https://github.com/subugoe/crlite/)"
  )
})


# integration tests ====
test_that("api can be reached", {
  skip_if_offline()
  expect_true(can_api())
})
