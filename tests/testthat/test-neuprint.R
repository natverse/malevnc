test_that("manc neuprint works", {
  vncc=try(manc_neuprint())
  skip_if(inherits(vncc, 'try-error'))

  expect_s3_class(vncc, "neuprint_connection")
  expect_s3_class(gf <- neuprintr::neuprint_get_meta(10000), 'data.frame')
  expect_equal(gf$type,"Giant Fiber")
  expect_equal(gf$soma, FALSE)

  expect_true(10085 %in% manc_connection_table(10000, partners = 'out')$partner)
})
