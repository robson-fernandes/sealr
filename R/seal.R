#' Sealing the test results
#'
#' @description Recording the state of the object
#'
#' @param test test
#' @param load_testthat include `library(testthat)` when *TRUE*
#' @param clip If *TRUE* will overwrite the system clipboard.
#' When clipr is not available, The clip arguments is forcibly *FALSE*.
#' @param ts include comments that timestamp?
#' @param mask_seal Whether to comment out after executing the function.
#' Default *FALSE*. This option is effective only when using RStudio.
#'
#' @name seal
#' @examples
#' \dontrun{
#' x <- 3.14
#' tests <- transcribe(x, seal = FALSE)
#' seal(tests, load_testthat = TRUE)
#' seal(tests, load_testthat = FALSE)
#' seal(tests, load_testthat = FALSE, clip = FALSE)
#' }
NULL

#' @rdname seal
#' @export
seal <- function(test, load_testthat = FALSE, clip = TRUE, ts = TRUE, mask_seal = FALSE) {

  test_char <- test

  if (load_testthat == TRUE) {

    load_testthat_char <- "library(testthat)"

    test_char <- paste(load_testthat_char, test_char, sep = "\n")
  }

  res <- styler::style_text(
    test_char
  )

  if (clip == TRUE)
    if (clipr::clipr_available() == FALSE) {
      rlang::warn("clipr not available. check clipr configuration.") # nocov
    } else {
      res <- clipr::write_clip(res, "character", return_new = FALSE) # nocov
    }

  if (ts == TRUE) {
    res <- paste(sealr_timestamp(quiet = TRUE),
                 test_char,
                 sep = "\n") %>%
      styler::style_text()
  }

  if (rlang::is_true(rstudioapi::isAvailable()))
    if (rlang::is_true(mask_seal))
      put(all = FALSE)

  return(res)
}
