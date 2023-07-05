op <- choose_malevnc_dataset('MANC')
on.exit(options(op))

for(ds in c("MANC", "VNC")) {
  choose_malevnc_dataset(ds)
test_that("manc neuprint works", {

  expect_equal(manc_ids(10000, as_character = T), "10000")
  expect_equal(manc_ids(10000, as_character = F), 10000)
  expect_equal(manc_ids(10000, integer64 = T), as.integer64(10000))
  expect_equal(manc_ids(as.integer64(10000), as_character=F), 10000)
  expect_equal(manc_ids(data.frame(bodyid=as.integer64(10000)), as_character=F), 10000)

  vncc=try(manc_neuprint())
  skip_if(inherits(vncc, 'try-error'))

  expect_s3_class(vncc, "neuprint_connection")

  expect_equal(sort(manc_ids("DNp01", integer64 = T)),
               as.integer64(c(10000, 10002)))

  expect_s3_class(gf <- neuprintr::neuprint_get_meta(10000), 'data.frame')
  expect_equal(gf$type,"DNp01")
  expect_equal(gf$soma, FALSE)

  expect_true(10085 %in% manc_connection_table(10000, partners = 'out')$partner)
})
}
