test_that("url shortening works", {
  skip_if_offline()

  expect_is(lu <- malevnc::flyem_expand_url('https://neuroglancer-demo.appspot.com/#!gs://flyem-user-links/short/2023-12-15.090703.json'), 'character')

  expect_length( flyem_shorten_url(c(lu,lu), title=c("test1", "test2")), 2)
})
