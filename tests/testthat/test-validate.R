test_that("all data sets pass validation routine", {
  expect_error(
    validate_all_proto_nets(),
    NA
  )
})