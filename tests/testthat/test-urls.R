test_that("manc_scene works", {
  expect_is(manc_scene(), 'character')
  expect_match(manc_scene(ids = 45678), '45678')
  expect_match(manc_scene(ids = 456, node = "123456789"), '123456789')
})
