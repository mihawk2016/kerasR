library(kerasR)

context("Testing constraints")

check_keras_available <- function() {
  if (!keras_available(silent = TRUE)) {
    skip("Keras is not available on this system.")
  }
}

test_that("dense model", {
  skip_on_cran()
  check_keras_available()

  X_train <- matrix(rnorm(100 * 10), nrow = 100)
  Y_train <- to_categorical(matrix(sample(0:2, 100, TRUE), ncol = 1), 3)

  max_norm()
  unit_norm()
  non_neg()

  mod <- Sequential()
  mod$add(Dense(units = 50, input_shape = dim(X_train)[2]))
  mod$add(Activation("relu"))
  mod$add(Dense(units = 3, kernel_constraint = max_norm(),
                bias_constraint = non_neg()))
  mod$add(Dense(units = 3, kernel_constraint = unit_norm()))
  mod$add(Activation("softmax"))
  keras_compile(mod,  loss = 'categorical_crossentropy', optimizer = RMSprop())

  keras_fit(mod, X_train, Y_train, batch_size = 32, epochs = 5, verbose = 0)

  testthat::expect_false(mod$stateful)
})
