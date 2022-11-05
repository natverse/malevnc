test_that("manc_scene works", {
  expect_is(manc_scene(), 'character')

  # check we can set ids for all scenes
  basescenes=eval(formals(manc_scene)$basescene)
  for(bs in basescenes) {
    # very first scene doesn't accept dvid nodes
    message(bs)
    if (bs == "2021-02-01")
      expect_match(manc_scene(ids = 45678, basescene = bs), '45678')
    else
      expect_match(
        manc_scene(
          ids = 87654321,
          node = "1ec355123bf94e588557a4568d26d258",
          basescene = bs
        ),
        '1ec355123bf94e588557a4568d26d258.*87654321'
      )
  }
  expect_warning(manc_scene(ids = 87654321,
                            show_synapse_layer = TRUE,
                            basescene = "2021-05-04"))

  url <- manc_scene(ids = 87654321, show_synapse_layer = TRUE)
  expect_false(manc_scene(ids = 87654321) == url)
  url <- manc_scene(ids = 87654321, show_sidebar = FALSE)
  expect_false(manc_scene(ids = 87654321) == url)

  expect_match(manc_scene(server='appspot'), "^https://neuroglancer-demo.appspot.com")
})
