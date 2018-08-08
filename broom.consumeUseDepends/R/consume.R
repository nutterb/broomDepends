#' @name consume
#' @title Consume an Arbitrary Tidier
#' 
#' @description Tidy an object, and then return it as a data frame
#' 
#' @param x an object to tidy
#' @param ... Arguments to pass to other tidy methods
#' 
#' @export

consume <- function(x, ...){
  tidied <- modelgenerics::tidy(x, ...)

  as.data.frame(tidied)
}
