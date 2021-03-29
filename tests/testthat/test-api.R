test_that("HEAD requests work", {
  expect_equal(httr::status_code(head_cr(path = "members/98")), 200L)
})
