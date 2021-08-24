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

test_check("manc_check_group_complete", {
  expect_true(manc_check_group_complete(10501, c(10501, 10507, 10627)))
  expect_false(manc_check_group_complete(10501, c(10501, 10507)))
})

test_that("manc_set_lrgroup", {
  expect_error(manc_set_lrgroup(c(501, 502), Force = T, dryrun = T, clio=FALSE))
  # this is not a real pair, just a neuron on L and R
  expect_output(manc_set_lrgroup(c(10501, 10507), Force = T, dryrun = T, clio=FALSE),
                "10501_R")
  # errors without user argument set
  expect_error(
    manc_set_lrgroup(c(10501, 10507), Force = T, dryrun = F, clio=FALSE),
    "Please specify a user"
  )
})

