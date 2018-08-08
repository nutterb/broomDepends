Consuming with Arbitrary Tidiers
--------------------------------

    # build objects
    library(redcapAPI)
    rcon <- redcapConnection(url = "https://not-a-valid-url.org",
                             token = "Not-a-Valid-Token")
    fit <- lm(mpg ~ qsec, data = mtcars)

    library(broom.consumeArbitrary)
    consume(rcon)

    ## Error in find_method("tidy", class(x)): Could not find a `tidy` method for the `redcapApiConnection` class. Either the package with the method is not loaded, or no such method has been written

    consume(fit)

    ## Error in find_method("tidy", class(x)): Could not find a `tidy` method for the `lm` class. Either the package with the method is not loaded, or no such method has been written

    library(broom.extend)
    consume(rcon)

    ##                           url             token
    ## 1 https://not-a-valid-url.org Not-a-Valid-Token

    consume(fit)

    ## Error in find_method("tidy", class(x)): Could not find a `tidy` method for the `lm` class. Either the package with the method is not loaded, or no such method has been written

    library(broom)
    consume(fit)

    ##          term  estimate  std.error  statistic    p.value
    ## 1 (Intercept) -5.114038 10.0295433 -0.5098974 0.61385436
    ## 2        qsec  1.412125  0.5592101  2.5252133 0.01708199

There's a dirty, and likely inadvisable, hack behind this dark sorcery.
There is a `find_method` function in `broom.consumeArbitrary` that
searches the packages on the search path for the tidier that applies to
the object type. The code for `find_method` is

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

It gets utilized in `consume` to define the `tidy` generic on the fly.
In this manner, the `tidy` generic exists only within the context of
`consume`.

    consume <- function(x, ...){
      tidied <- find_method("tidy", class(x))(x, ...)

      as.data.frame(tidied)
    }

The behaviors to note in this approach are

1.  `consume` may be run on any arbitrary object with a `tidy` method
    defined on the search path.
2.  The package containing the `tidy` method must be loaded using
    `library(package)`
3.  The order in which packages are loaded in unimportant. We may load
    `broom.consumeArbitrary` before loading `broom`, and `consume` will
    work.
4.  `broom.consumeArbitrary` need not `Depends:` nor `Imports:` any
    package at all. But it will fail to execute without an appropriate
    tidier installed. Thus, it may be prudent to `Depends:` at least one
    package (most commonly, `broom`).
