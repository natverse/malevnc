test_that("manc_leg_summary works", {
  expect_s3_class(mls <- manc_leg_summary(c(10126, 10118)), 'data.frame')
  expect_true(nrow(mls)==2)
  expect_true(ncol(mls)==13)

  expect_s3_class(mss <- manc_side_summary(c(10126, 10118)), 'data.frame')
})
