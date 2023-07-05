test_that("mirror_manc works", {
  skip_if(inherits(try(nat::cmtk.bindir(check = TRUE), silent = T), 'try-error'))
  hookr=cbind(33549, 45944, 50806)*c(8,8,8)/1000
  hookl=cbind(8718, 40794, 52140)*c(8,8,8)/1000
  hookrl=rbind(hookr, hookl)
  expect_is(hookrl.m <- mirror_manc(hookrl), 'matrix')
  ds=sqrt(rowSums((hookrl.m-hookrl[2:1, ])^2))
  expect_lt(mean(ds), 11)
})


test_that("xform_brain works", {
  skip_if(inherits(try(nat::cmtk.bindir(check = TRUE), silent = T), 'try-error'))
  hookr=cbind(33549, 45944, 50806)*c(8,8,8)/1000
  hookl=cbind(8718, 40794, 52140)*c(8,8,8)/1000
  hookrl=rbind(hookr, hookl)
  expect_is(hookrl.m <- mirror_manc(hookrl), 'matrix')
  ds=sqrt(rowSums((hookrl.m-hookrl[2:1, ])^2))
  expect_lt(mean(ds), 11)
})
