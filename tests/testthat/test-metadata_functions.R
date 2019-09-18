context("test-metadata_functions")

# --- Setup ---
df       <- data.frame(from       = c("a", "a", "b"),
                       to         = c("a", "b", "c"),
                       from_class = "agent",
                       to_class   = "agent",
                       edge_type  = c("foo", "foo", "bar")
                       )
g        <- igraph::graph_from_data_frame(df)
listed_g <- COREnets::unnest_edge_types(g              = g,
                                        edge_type_name = "edge_type")
codebook <- data.frame(
  `edge_type` = c("foo",
                  "bar"),
  is_bimodal  = c(FALSE,
                  TRUE),
  is_directed = c(TRUE,
                  FALSE),
  is_dynamic  = c(FALSE,
                  FALSE),
  is_weighted = c(FALSE,
                  FALSE),
  definition  = c("",
                  ""),
  stringsAsFactors = FALSE
)

# --- Tests ---
test_that("unnest_edge_types() works", {
  # Output is list?
  expect_type(listed_g,
              "list")
  # Each item in list is igraph class?
  expect_equal(
    sapply(
      listed_g,
      class),
    rep("igraph",
        length(listed_g)
        )
    )
  # Contains edge_type field?
  expect_true(
    "edge_type" %in% names(
      igraph::edge_attr(
        listed_g[[1]]
        )
      )
    )
})

test_that("get_codebook_fields() works", {
  # Returns data.frame?
  expect_s3_class(
    get_codebook_fields(
      codebook,
      "foo"),
    "data.frame")
  # Returns expected headers?
  expect_equal(
    names(
      get_codebook_fields(
        codebook,
        "foo")
      ),
    c("edge_type",
      "is_bimodal",
      "is_directed",
      "is_dynamic",
      "is_weighted",
      "definition")
    )
  # Returns expected dims?
  expect_equal(
    dim(
      get_codebook_fields(
        codebook,
        "foo")
      ),
    c(1,
      6)
  )
  # Returns expected types?
  expect_equal(
    sapply(get_codebook_fields(
      codebook,
      "foo"),
      typeof),
    c(edge_type   = "character",
      is_bimodal  = "logical",
      is_directed = "logical",
      is_dynamic  = "logical",
      is_weighted = "logical",
      definition  = "character")
  )
})

test_that("generate_graph_metadata() works", {
  # Is the output a list?
  expect_type(
    purrr::map(listed_g,
           ~ generate_graph_metadata(.x,
                                     codebook = codebook)),
    "list")
  # Each item on that is three in lenght?
  expect_equal(
    length(
      purrr::map(
        listed_g,
        ~ generate_graph_metadata(.x,
                                 codebook = codebook))[[1]][[1]])
    ,
    3)
  # List names match expectations?
  expect_equal(
    names(
      purrr::map(
        listed_g,
        ~ generate_graph_metadata(.x,
                                  codebook = codebook))[[1]][[1]]
      ),
    c("graph_metadata",
      "edges_metadata",
      "nodes_metadata")
    )
  # Names of those graph_metadata match expectation?
  expect_equal(
    sapply(
      purrr::map(
        listed_g,
        ~ generate_graph_metadata(.x,
                                  codebook = codebook))[[1]][[1]][["graph_metadata"]],
      typeof),
    c(is_bimodal   = "logical",
      is_directed  = "logical",
      is_dynamic   = "logical",
      is_weighted  = "logical",
      has_loops    = "logical",
      has_isolates = "logical")
  )
  # Names of those edges_metadata match expectation?
  expect_equal(
    sapply(
      purrr::map(
        listed_g,
        ~ generate_graph_metadata(.x,
                                  codebook = codebook))[[1]][[1]][["edges_metadata"]],
      typeof),
    c(count       = "double",
      are_dynamic = "logical")
  )
  # Names of those nodes_metadata match expectation?
  expect_equal(
    sapply(
      purrr::map(
        listed_g,
        ~ generate_graph_metadata(.x,
                                  codebook = codebook))[[1]][[1]][["nodes_metadata"]],
      typeof),
    c(count         = "integer",
      classes       = "character",
      classes_count = "integer")
  )
})

test_that("test_loops() works", {
  expect_true(
    test_loops(g)
    )
  expect_false(
    test_loops(
      igraph::simplify(g, remove.loops = TRUE)
    )
    )
})

test_that("test_isolates() works", {
  expect_true(
    test_isolates(
      igraph::add_vertices(g,
                           1,
                           name = "d")
      )
  )
  expect_false(
    test_isolates(g)
  )
})
