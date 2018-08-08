#' @name redcapConnection_tidiers
#' @title Tidy a \code{redcapConnection} object
#' 
#' @description Makes a data frame containing the information used in a 
#'   REDCap API Connection.
#'
#' @param x An object with class \code{redcapApiConnection} or 
#'   \code{redcapDbConnection}.
#' @param ... Arguments to pass to other methods.
#' 
#' @export

tidy.redcapApiConnection <- function(x, ...){
  tibble::data_frame(
    url = x$url,
    token = x$token
  )
}
