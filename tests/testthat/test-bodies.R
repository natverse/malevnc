test_that("manc_mutations", {
  skip("Skipping due to a regression in the MANC DVID setup.")
  withr::local_options(choose_malevnc_dataset('VNC', set = F))
  expect_s3_class(muts <- manc_mutations('956250c3062245f9b63a000dfe05289c'),
                  'data.frame')
  expect_equal(manc_size(10000, node = '19fdf756b8c9477bbba4432482348c47'),
               38743961712)

  expect_equal(manc_size(c(10000,10002)),
               manc_size(c(10000,10002),chunksize = 1))

})

test_that("manc_mutations handles ragged mutation fields", {
  testthat::local_mocked_bindings(
    manc_nodespec=function(nodes, include_first=NA, several.ok=TRUE) "node-uuid",
    manc_get=function(path, urlargs=list(), ..., simplifyVector=TRUE) {
      expect_false(simplifyVector)
      list(
        list(
          Action="merge",
          App="NeuTu",
          Labels=list("1", "2"),
          Empty=character(0),
          MutationID="mut-1",
          SVSplits=list(c("10", "11")),
          Timestamp="2024-01-01 00:00:00 +0000 m=+1"
        ),
        list(
          Action="supervoxel-split",
          App="Neu3",
          Labels=list("3"),
          Empty="",
          MutationID="mut-2",
          SVSplits=list("12", "13", "14"),
          Timestamp="2024-01-01 00:00:02 +0000 m=+2"
        )
      )
    }
  )

  muts <- manc_mutations("node-uuid")

  expect_s3_class(muts, "data.frame")
  expect_equal(nrow(muts), 2)
  expect_equal(muts$SVSplits, c("10,11", "12,13,14"))
  expect_equal(muts$Labels, c("1,2", "3"))
  expect_equal(muts$Empty, c(NA_character_, NA_character_))
  expect_equal(muts$Reltimestamp, c(1, 2))
})

test_that("list2df can keep list fields and opt in to numeric conversion", {
  x <- list(
    list(id="1", values=list(c("10", "11"))),
    list(id="2", values=list("12"))
  )

  collapsed <- list2df(x, convert_numeric=TRUE)
  listed <- list2df(x, lists="list", convert_numeric=TRUE)

  expect_equal(collapsed$id, c(1, 2))
  expect_equal(collapsed$values, c("10,11", "12"))
  expect_type(listed$values, "list")
  expect_equal(lengths(listed$values), c(1, 1))
})
