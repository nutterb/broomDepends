#' @name find_method
#' @title Find Tidy Method
#' 
#' @description Find a tidy method for an object
#' 
#' @param generic One of \code{c("tidy", "glance", "augment")}
#' @param class character vector of object classes.
#' 
#' @export

find_method <- function(generic = c("tidy", "glance", "augment"), class){
  generic <- match.arg(generic, c("tidy", "glance", "augment"))
  
  method_to_find <- paste0(generic, ".", class)
  
  pkg <- utils::find(generic)

  method <- 
    vapply(pkg, 
           function(x) any(method_to_find %in% 
                             utils::.S3methods(generic, 
                                               envir = getNamespace(sub("^.+[:]", "", x)))),
           logical(1))
  method <- method[method]
  
  package_namespace <- 
    search()[match(names(method), search())][1]
  
  package_namespace <- sub("^.+[:]", "", package_namespace)
  
  if (is.na(package_namespace)){
    stop("Could not find a `", generic, "` method for the `", class[1], "` class. ",
         "Either the package with the method is not loaded, or no such method has been written")
  }
  
  get(generic, envir = getNamespace(package_namespace))
}
