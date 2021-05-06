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
          node = "123456789",
          basescene = bs
        ),
        '123456789.*87654321'
      )
  }

})
