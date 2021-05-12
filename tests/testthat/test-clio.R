test_that("manc_body_annotations works", {
  skip_if(inherits(try(clio_token(), silent = T), 'try-error'),
          message = "no clio token available")
  expect_s3_class(mba <- manc_body_annotations(ids=11442), 'data.frame')
  expect_equal(mba$bodyid, 11442)
})

test_that("manc_point_annotations works", {
  skip_if(inherits(try(clio_token(), silent = T), 'try-error'),
          message = "no clio token available")
  expect_s3_class(mpa <- manc_point_annotations(), 'data.frame')
})

