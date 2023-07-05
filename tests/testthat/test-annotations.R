context("annotations")

test_that("manc_meta", {
  skip_if(inherits(try(clio_token(), silent = T), 'try-error'),
          message = "no clio token available")
  res <- manc_meta('DNp01')
  expect_true(is.data.frame(res))
  expect_true("dvid_group" %in% colnames(res))
  expect_true("predicted_nt" %in% colnames(res))

  expect_true(is.data.frame(res2 <- manc_meta(2200014)))
  expect_true(is.na(res2$dvid_status))
})

test_that("parse_query", {
  # default behavior when all args empty
  expect_null(parse_query(FALSE, version=NULL))
  # default query values
  expect_true(is.list(parse_query(TRUE, version=NULL)))
  # custom query
  expect_error(parse_query(c(A), version=NULL))
  res=parse_query(list(version='v9.9.9', abc='abc'), version=NULL)
  expect_equal(res$version, "v9.9.9")
  expect_true("abc" %in% names(res))
})
