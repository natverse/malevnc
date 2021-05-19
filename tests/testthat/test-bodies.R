test_that("manc_mutations", {
  expect_s3_class(muts <- manc_mutations('956250c3062245f9b63a000dfe05289c'),
                  'data.frame')
  expect_equal(manc_size(10000, node = '19fdf756b8c9477bbba4432482348c47'),
               38743961712)
})
