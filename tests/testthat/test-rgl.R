test_that("multiplication works", {
  bl=list(userMatrix = structure(
    c(
      -1,0,0,0,
      0,0.3420201,0.9396926,0,
      0,0.9396926,-0.3420201,0,
      0,0,0,1
    ),
    .Dim = c(4L, 4L)
  ),
  FOV = 0)

  expect_equal(manc_view3d(returnparams = TRUE),
               bl, tolerance = 1e-4)
})
