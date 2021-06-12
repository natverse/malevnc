test_that("manc_body_annotations works", {
  skip_if(inherits(try(clio_token(), silent = T), 'try-error'),
          message = "no clio token available")
  expect_s3_class(mba <- manc_body_annotations(ids=11442), 'data.frame')
  expect_equal(mba$bodyid, 11442)
})

test_that("manc_annotate_body works", {
  json='[{"last_modified_by":"lisa.marin@gmail.com","class":"Descending","soma_side":"TBD","description":"Giant fiber","status":"Prelim Roughly traced","hemilineage":"NA","bodyid":10002,"user":"lisa.marin@gmail.com"}]'

  skip_if(inherits(try(clio_token(), silent = T), 'try-error'),
          message = "no clio token available")

  manc_annotate_body(json, test = TRUE)
  expect_match(manc_body_annotations(10002, test=T, json = T), "Giant fiber")
  manc_annotate_body(list(bodyid=10002, soma_side='L'), test = TRUE)
  expect_equal(manc_body_annotations(10002, test=T)$soma_side, "L")

  # neither NA nor "" should overwrite
  manc_annotate_body(data.frame(bodyid=10002, soma_side=""), test = TRUE, write_empty_fields = FALSE)
  expect_equal(manc_body_annotations(10002, test=T)$soma_side, "L")
  manc_annotate_body(data.frame(bodyid=10002, soma_side=NA), test = TRUE, write_empty_fields = FALSE)
  expect_equal(manc_body_annotations(10002, test=T)$soma_side, "L")

  # overwrite when write_empty_fields
  manc_annotate_body(data.frame(bodyid=10002, soma_side=""), test = TRUE, write_empty_fields = TRUE)
  expect_equal(manc_body_annotations(10002, test=T)$soma_side, "")

  # check that list overwrites
  manc_annotate_body(list(bodyid=10002, soma_side='L'), test = TRUE)
  manc_annotate_body(list(bodyid=10002, soma_side=""), test = TRUE)
  expect_equal(manc_body_annotations(10002, test=T)$soma_side,"")
})


test_that("manc_point_annotations works", {
  skip_if(inherits(try(clio_token(), silent = T), 'try-error'),
          message = "no clio token available")
  expect_s3_class(mpa <- manc_point_annotations(), 'data.frame')
})


test_that("clio url", {
  expect_equal(clio_url("v2/annotations/VNC"),
               "https://clio-store-vwzoicitea-uk.a.run.app/v2/annotations/VNC")

  expect_equal(clio_url("v2/annotations/VNC", test = T),
               "https://clio-test-7fdj77ed7q-uk.a.run.app/v2/annotations/VNC")

  expect_equal(clio_url("v2/server/token"),
               'https://clio-store-vwzoicitea-uk.a.run.app/v2/server/token')
})

test_that("validate_email", {
  expect_equal(validate_email("bozo@gmail.com"), "bozo@gmail.com")
  expect_error(validate_email("bozo@gmail"))
  expect_error(validate_email("bozogmail"))
  expect_error(clio_email("bozogmail"))
  expect_error(validate_email("bozogmail$@gmail.com"))
})

test_that("clio version/email", {
  skip_if(inherits(try(clio_token(), silent = T), 'try-error'),
          message = "no clio token available")
  expect_silent(clio_email())
  expect_match(clio_version(), regexp = '^v[0-9]\\.[0-9.]+')
  expect_error(clio_version('0.3.2'))
})
