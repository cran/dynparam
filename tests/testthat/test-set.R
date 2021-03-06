context("test-set")

test_that("works with one parameter", {
  epsilon_p <- numeric_parameter(
    id = "epsilon",
    default = 0.05,
    distribution = expuniform_distribution(1e-5, 1),
    description = "Epsilon factor"
  )
  parameters <- parameter_set(
    epsilon_p
  )

  expect_is(parameters, "parameter_set")
  expect_null(parameters$forbidden)

  expect_true(is_parameter_set(parameters))
  expect_true(all(map_lgl(parameters$parameters, is_parameter)))

  expect_equal(parameters$parameters$epsilon, epsilon_p, check.environment = FALSE)

  # test to list conversion and back
  li <- as.list(parameters)

  ps <- as_parameter_set(li)

  expect_equal(parameters, ps, check.environment = FALSE)

  # test paramhelper conversion
  ph <- as_paramhelper(parameters)
  expect_equal(names(ph$pars), names(parameters$parameters), check.environment = FALSE)
  expect_equal(ph$pars$epsilon, as_paramhelper(epsilon_p), check.environment = FALSE)

  expect_length(as.character(ph$forbidden), 0)

  # test print
  expect_output(print(parameters), "epsilon.*numeric")

  expect_equal(get_defaults(parameters), list(epsilon = 0.05), check.environment = FALSE)
})

test_that("works with many parameters", {
  num_iter_p <- integer_parameter(
    id = "num_iter",
    default = 100L,
    distribution = expuniform_distribution(lower = 1L, upper = 10000L),
    description = "Number of iterations"
  )
  delta_p <- numeric_parameter(
    id = "delta",
    default = c(4.5, 2.4, 1.9),
    distribution = normal_distribution(mean = 5, sd = 1),
    description = "Multiplying factors"
  )
  method_p <- character_parameter(
    id = "method",
    default = "kendall",
    values = c("kendall", "spearman", "pearson"),
    description = "Correlation method"
  )
  inverse_p <- logical_parameter(
    id = "inverse",
    default = TRUE,
    description = "Inversion parameter"
  )
  dimred_p <- subset_parameter(
    id = "dimreds",
    default = c("pca", "mds"),
    values = c("pca", "mds", "tsne", "umap", "ica"),
    description = "Which dimensionality reduction methods to apply (can be multiple)"
  )
  ks_p <- integer_range_parameter(
    id = "ks",
    default = c(3L, 15L),
    lower_distribution = uniform_distribution(1L, 5L),
    upper_distribution = uniform_distribution(10L, 20L),
    description = "The numbers of clusters to be evaluated"
  )
  quantiles_p <- numeric_range_parameter(
    id = "quantiles",
    default = c(0.15, 0.90),
    lower_distribution = uniform_distribution(0, .4),
    upper_distribution = uniform_distribution(.6, 1),
    description = "Quantile cutoff range"
  )
  parameters <- parameter_set(
    num_iter_p,
    delta_p,
    method_p,
    inverse_p,
    dimred_p,
    ks_p,
    quantiles_p,
    forbidden = "inverse == (method == 'kendall')"
  )

  expect_is(parameters, "parameter_set")
  expect_equal(parameters$forbidden, "inverse == (method == 'kendall')", check.environment = FALSE)

  expect_true(is_parameter_set(parameters))
  expect_true(all(map_lgl(parameters$parameters, is_parameter)))

  expect_equal(parameters$parameters$num_iter, num_iter_p, check.environment = FALSE)
  expect_equal(parameters$parameters$delta, delta_p, check.environment = FALSE)
  expect_equal(parameters$parameters$method, method_p, check.environment = FALSE)
  expect_equal(parameters$parameters$inverse, inverse_p, check.environment = FALSE)
  expect_equal(parameters$parameters$dimred, dimred_p, check.environment = FALSE)
  expect_equal(parameters$parameters$ks, ks_p, check.environment = FALSE)
  expect_equal(parameters$parameters$quantiles, quantiles_p, check.environment = FALSE)

  # test to list conversion and back
  li <- as.list(parameters)

  ps <- as_parameter_set(li)

  expect_equal(parameters, ps, check.environment = FALSE)

  # test paramhelper conversion
  ph <- as_paramhelper(parameters)
  expect_equal(names(ph$pars), names(parameters$parameters), check.environment = FALSE)
  expect_equal(ph$pars$num_iter, as_paramhelper(num_iter_p), check.environment = FALSE)
  expect_equal(ph$pars$delta, as_paramhelper(delta_p), check.environment = FALSE)
  expect_equal(ph$pars$method, as_paramhelper(method_p), check.environment = FALSE)
  expect_equal(ph$pars$inverse, as_paramhelper(inverse_p), check.environment = FALSE)
  expect_equal(ph$pars$dimred, as_paramhelper(dimred_p), check.environment = FALSE)
  expect_equal(ph$pars$ks, as_paramhelper(ks_p), check.environment = FALSE)
  expect_equal(ph$pars$quantiles, as_paramhelper(quantiles_p), check.environment = FALSE)

  expect_match(as.character(ph$forbidden), "inverse == \\(method == \"kendall\"\\)")
  expect_match(as.character(ph$forbidden), "ks\\[1\\] > ks\\[2\\]")

  # test print
  expect_output(print(parameters), "num_iter.*integer")
  expect_output(print(parameters), "delta.*numeric")
  expect_output(print(parameters), "method.*character")
  expect_output(print(parameters), "inverse.*logical")
  expect_output(print(parameters), "dimreds.*subset")
  expect_output(print(parameters), "ks.*range")
  expect_output(print(parameters), "quantiles.*range")

  expect_equal(
    get_defaults(parameters),
    list(
      num_iter = 100L,
      delta = c(4.5, 2.4, 1.9),
      method = "kendall",
      inverse = TRUE,
      dimreds = c("pca", "mds"),
      ks = c(3L, 15L),
      quantiles = c(.15, .9)
    )
  )
})

test_that("wrong parse fails gracefully", {
  expect_error(parameter_set(a = 1), "parameter 1 is not a parameter")
  expect_error(parameter_set(logical_parameter(id = "a", default = TRUE), a = 1), "parameter 2 is not a parameter")
  expect_error(parameter_set(list(a = 1)), "parameter 1 is not a parameter")
  expect_error(parameter_set(forbidden = 10), "forbidden is not NULL or forbidden is not a character vector")
})

