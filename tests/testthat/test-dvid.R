test_that("manc_nodespec", {
  mnc=manc_node_chain()
  expect_equal(manc_nodespec("clio"), manc_dvid_node('clio'))
  expect_equal(manc_nodespec("1ec355"), "1ec355123bf94e588557a4568d26d258")
  expect_equal(manc_nodespec("1ec355:c9c1d9", include_first = T), mnc[1:4])
  expect_equal(manc_nodespec("all"), mnc)

  expect_error(manc_nodespec("all", several.ok = F))
  expect_silent(manc_nodespec("all", several.ok = T))
  expect_silent(manc_nodespec("clio", several.ok = F))
})

test_that("manc_dvid_annotations", {
  expect_true(is.data.frame(manc_dvid_annotations('Giant Fiber')))
  expect_silent(df <- manc_dvid_annotations(1e9))
  expect_equal(df$bodyid, 1e9)
  expect_true(all(is.na(df[,-1])))
})
