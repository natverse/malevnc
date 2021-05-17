test_that("manc_mutations", {
  expect_s3_class(muts <- manc_mutations('956250c3062245f9b63a000dfe05289c'),
                  'data.frame')
})
