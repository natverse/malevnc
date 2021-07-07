test_that("manc_body_annotations works", {
  skip_if(inherits(try(clio_token(), silent = T), 'try-error'),
          message = "no clio token available")
  expect_s3_class(mba <- manc_body_annotations(ids=11442), 'data.frame')
  expect_equal(mba$bodyid, 11442)
})

test_that("compute_clio_delta works", {
  skip_if(inherits(try(clio_token(), silent = T), 'try-error'),
          message = "no clio token available")
  tstlist <- list()
  tstlist[[1]] <- list(bodyid=12345780)
  tstlist[[2]] <- list(bodyid=12345770)
  expect_equal(length(compute_clio_delta(tstlist)), 2)
})

test_that("manc_annotate_body works", {
  # just enough randomness to make collisions unlikely
  rid=12345678+sample(1:300, size=1)
  json=sprintf('[{"last_modified_by":"lisa.marin@gmail.com","class":"Descending","soma_side":"TBD","description":"Giant fiber","status":"Prelim Roughly traced","hemilineage":"NA","bodyid":%s,"user":"lisa.marin@gmail.com"}]',rid)

  skip_if(inherits(try(clio_token(), silent = T), 'try-error'),
          message = "no clio token available")

  manc_annotate_body(json, test = TRUE)
  expect_match(manc_body_annotations(rid, test=T, json = T), "Giant fiber")
  manc_annotate_body(list(bodyid=rid, soma_side='L'), test = TRUE)
  expect_equal(manc_body_annotations(rid, test=T)$soma_side, "L")

  seedpt=nat::xyzmatrix(cbind(23217, 35252, 67070))
  seedpt_char=paste(seedpt, collapse = ',')
  df=data.frame(bodyid=c(rid, rid+2))
  df$position=c(seedpt_char, NA)
  df2=df
  df2$position=list(seedpt, list())
  expect_silent(manc_annotate_body(df))
  expect_silent(manc_annotate_body(df2))
  # equivalent because of rownames (maybe xyzmatrix should drop them)
  expect_equivalent(nat::xyzmatrix(manc_body_annotations(rid, test=T)$position),
                    nat::xyzmatrix(seedpt))

  # neither NA nor "" should overwrite
  manc_annotate_body(data.frame(bodyid=rid, soma_side=""), test = TRUE, write_empty_fields = FALSE)
  expect_equal(manc_body_annotations(rid, test=T)$soma_side, "L")
  manc_annotate_body(data.frame(bodyid=rid, soma_side=NA), test = TRUE, write_empty_fields = FALSE)
  expect_equal(manc_body_annotations(rid, test=T)$soma_side, "L")

  # overwrite when write_empty_fields
  manc_annotate_body(data.frame(bodyid=rid, soma_side=""), test = TRUE, write_empty_fields = TRUE)
  expect_equal(manc_body_annotations(rid, test=T)$soma_side, "")

  # check that list overwrites
  manc_annotate_body(list(bodyid=rid, soma_side='L'), test = TRUE)
  manc_annotate_body(list(bodyid=rid, soma_side=""), test = TRUE)
  expect_equal(manc_body_annotations(rid, test=T)$soma_side,"")

  # check that protect works
  manc_annotate_body(list(bodyid=rid, class='DN'), test = TRUE)
  expect_equal(manc_body_annotations(rid, test=T)$class,"DN")
  manc_annotate_body(list(bodyid=rid, soma_side='rhubarb'), test = TRUE, protect = 'class')
  expect_equal(manc_body_annotations(rid, test=T)$class,"DN")
  manc_annotate_body(list(bodyid=rid, class='rhubarb'), test = TRUE, protect = T)
  expect_equal(manc_body_annotations(rid, test=T)$class,"DN")
  manc_annotate_body(list(bodyid=rid, class='Descending'), test = TRUE, protect = F)
  expect_equal(manc_body_annotations(rid, test=T)$class,"Descending")
})

test_that("manc_point_annotations/clioannotationdf2list works", {
  ansforuploadsample <- structure(
    list(
      bodyid = c(11633, 10223, 10382, 10397),
      class = c(
        "Ascending Interneuron",
        "Ascending Interneuron",
        "Ascending Interneuron",
        "Ascending Interneuron"
      ),
      entry_nerve = c("None", "None", "None", "None"),
      exit_nerve = c("CvC",
                     "CvC", "CvC", "CvC"),
      group = c(NA, 10223, 10223, 10245),
      user = c(
        "jefferis@gmail.com",
        "jefferis@gmail.com",
        "jefferis@gmail.com",
        "jefferis@gmail.com"
      ),
      last_modified_by = c(
        "jefferis@gmail.com",
        "jefferis@gmail.com",
        "jefferis@gmail.com",
        "jefferis@gmail.com"
      ),
      x = c(20652L, 21742L,
            24812L, 20124L),
      y = c(34920L, 37945L, 38155L, 36234L),
      z = c(67070L,
            67070L, 67070L, 67070L)
    ),
    row.names = c(NA,-4L),
    class = c("tbl_df",
              "tbl", "data.frame")
  )

 expect_known_hash(cliolist <- clioannotationdf2list(ansforuploadsample),
                    "76f0ba44b7")
  # a row with only bodyid should be dropped
  ansforuploadsample[5,'bodyid']=1
  expect_equal(clioannotationdf2list(ansforuploadsample), cliolist)
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
