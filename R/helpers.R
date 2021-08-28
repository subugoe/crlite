#' Validate email
#' @export
#' @keywords internal
is_email_address <- function(x) {
  stopifnot(rlang::is_scalar_character(x))
  grepl(
    "^\\s*[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}\\s*$",
    as.character(x),
    ignore.case = TRUE
  )
}
