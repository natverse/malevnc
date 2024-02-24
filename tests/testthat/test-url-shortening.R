test_that("url shortening works", {
  skip_if_offline()

  expect_is(lu <- malevnc::flyem_expand_url('https://neuroglancer-demo.appspot.com/#!gs://flyem-user-links/short/2023-12-15.090703.json'), 'character')

  expect_equal(su <- flyem_shorten_url(c(lu,lu),
                                       title=c("test1", "test2"),
                                       method = 'md5'),
               c("https://neuroglancer-demo.appspot.com/#!gs://flyem-user-links/short/59a3c8a14ac42f1561713d5e3c609381.json",
                 "https://neuroglancer-demo.appspot.com/#!gs://flyem-user-links/short/8e0d1284e3af583db48d92dc02280eea.json"
               )
  )
})
