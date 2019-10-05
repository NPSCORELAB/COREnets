test_that("core_as_igraph works", {
  expect_error(
    core_as_igraph(get_data("anabaptists")),
    NA
  )

  expect_error(
    core_as_igraph(get_data("cocaine_smuggling_acero")),
    NA
  )

  expect_error(
    core_as_igraph(get_data("cocaine_smuggling_jake")),
    NA
  )

  expect_error(
    core_as_igraph(get_data("cocaine_smuggling_juanes")),
    NA
  )
  
  expect_error(
    core_as_igraph(get_data("cocaine_smuggling_mambo")),
    NA
  )

  expect_error(
    core_as_igraph(get_data("drugnet")),
    NA
  )


  expect_error(
    core_as_igraph(get_data("harry_potter_death_eaters")),
    NA
  )

  expect_error(
    core_as_igraph(get_data("harry_potter_dumbledores_army")),
    NA
  )

  expect_error(
    core_as_igraph(get_data("montreal_street_gangs")),
    NA
  )

  expect_error(
    core_as_igraph(get_data("november17")),
    NA
  )

  expect_error(
    core_as_igraph(get_data("siren")),
    NA
  )

})