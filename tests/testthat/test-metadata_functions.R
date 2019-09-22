context("test-metadata_functions")

# --- Setup ---
df       <- data.frame(from       = c("a", "a", "b"),
                       to         = c("a", "b", "c"),
                       from_class = "agent",
                       to_class   = "agent",
                       edge_class = c("foo", "foo", "bar")
                       )
g        <- igraph::graph_from_data_frame(df)
listed_g <- COREnets:::unnest_edge_class(g              = g,
                                         edge_class_name = "edge_class")
codebook <- data.frame(
  `edge_class` = c("foo",
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
test_that("unnest_edge_classs() works", {
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
  # Contains edge_class field?
  expect_true(
    "edge_class" %in% names(
      igraph::edge_attr(
        listed_g[[1]]
        )
      )
    )
})

test_that("get_codebook_fields() works", {
  # Returns data.frame?
  expect_s3_class(
    COREnets:::get_codebook_fields(
      codebook,
      "foo"),
    "data.frame")
  # Returns expected headers?
  expect_equal(
    names(
      COREnets:::get_codebook_fields(
        codebook,
        "foo")
      ),
    c("edge_class",
      "is_bimodal",
      "is_directed",
      "is_dynamic",
      "is_weighted",
      "definition")
    )
  # Returns expected dims?
  expect_equal(
    dim(
      COREnets:::get_codebook_fields(
        codebook,
        "foo")
      ),
    c(1,
      6)
  )
  # Returns expected types?
  expect_equal(
    sapply(COREnets:::get_codebook_fields(
      codebook,
      "foo"),
      typeof),
    c(edge_class   = "character",
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
           ~ COREnets:::generate_graph_metadata(.x,
                                     codebook = codebook)),
    "list")
  # Each element is 10 in length?
  expect_equal(
    length(
      purrr::map(
        listed_g,
        ~ COREnets:::generate_graph_metadata(.x,
                                 codebook = codebook))[[1]])
    ,
    10)
  # List names match expectations?
  expect_equal(
    names(
      purrr::map(
        listed_g,
        ~ COREnets:::generate_graph_metadata(.x,
                                  codebook = codebook))[[1]]
      ),
    c("edge_class",
      "is_bimodal",
      "is_directed",
      "is_dynamic",
      "is_weighted",
      "has_loops",
      "has_isolates",
      "edge_count",
      "node_count",
      "node_classes"
      )
    )
  # Names of fields match type expectation?
  expect_equal(
    sapply(
      purrr::map(
        listed_g,
        ~ COREnets:::generate_graph_metadata(.x,
                                  codebook = codebook))[[1]],
      typeof),
    c(edge_class   = "character",
      is_bimodal   = "logical",
      is_directed  = "logical",
      is_dynamic   = "logical",
      is_weighted  = "logical",
      has_loops    = "logical",
      has_isolates = "logical",
      edge_count   = "double",
      node_count   = "double",
      node_classes = "double")
  )
})

test_that("test_loops() works", {
  expect_true(
    COREnets:::test_loops(g)
    )
  expect_false(
    COREnets:::test_loops(
      igraph::simplify(g, remove.loops = TRUE)
    )
    )
})

test_that("test_isolates() works", {
  expect_true(
    COREnets:::test_isolates(
      igraph::add_vertices(g,
                           1,
                           name = "d")
      )
  )
  expect_false(
    COREnets:::test_isolates(g)
  )
})
