broomDepends
============

Experimenting with Dependency Structures for the `broom` Package Suite

Consumption of `tidy` methods
-----------------------------

The primary motivation for the examples in this repository is to
determine the correct process for configuring a package like
[`pixiedust`](https://www.github.com/nutterb/pixiedust) to operate as
intended for an arbitrary object with a `tidy` method. The challenge is
that, with `tidy` methods being distributed over multiple packages, I
can never be sure about the origin of the `tidy` method for any given
object.

This `README` file walks through the steps to reproduce my findings so
that I may solicit feedback and instruction on how to do this correctly.

Installation of test packages
-----------------------------

Run the following code to install the packages needed to run the scripts
below.

    devtools::install_github("tidymodels/modelgenerics")
    devtools::install_github("tidymodels/broom")
    devtools::install_github("nutterb/broomDepends/broom.extend")
    devtools::install_github("nutterb/broomDepends/broom.consumeSpecific")
    devtools::install_github("nutterb/broomDepends/broom.consumeUseDepends")
    devtools::install_github("nutterb/broomDepends/broom.consumeUseImports")
    devtools::install_github("nutterb/broomDepends/broom.consumeArbitrary")
    install.packages("redcapAPI")

-   `broom.extend` illustrates how to extend the `tidy` generic to a new
    object type.
-   `broom.consumeSpecific` illustrates how to consume a `tidy` method
    from a specific package that extends the `tidy` generic.
-   `broom.consumeArbitrary` illustrates how to consume any `tidy`
    method from any package that extends the `tidy` generic. In order to
    consume a method, the package with the method must exist on the
    search path.
-   `redcapAPI` is a package for downloading data from the REDCap
    database system. The `broom.extend` package provides a tidier for
    objects of class `redcapApiConnection`.

Demonstration of the `broom.extend` tidier
------------------------------------------

    # build objects
    library(redcapAPI)
    rcon <- redcapConnection(url = "https://not-a-valid-url.org",
                             token = "Not-a-Valid-Token")
    fit <- lm(mpg ~ qsec, data = mtcars)

By default, `rcon` returns a list with the `redcapApiConnection` class.
The tidier from the `broom.extend` package makes a tibble with columns
for the URL and the token used to access the API.

    library(broom.extend)
    tidy(rcon)

    ## # A tibble: 1 x 2
    ##   url                         token            
    ##   <chr>                       <chr>            
    ## 1 https://not-a-valid-url.org Not-a-Valid-Token

    tidy(fit)

    ## Error in UseMethod("tidy"): no applicable method for 'tidy' applied to an object of class "lm"

Consuming tidiers
-----------------

    # build objects
    library(redcapAPI)
    rcon <- redcapConnection(url = "https://not-a-valid-url.org",
                             token = "Not-a-Valid-Token")
    fit <- lm(mpg ~ qsec, data = mtcars)

Now suppose I wish to consume the `tidy.redcapApiConnection` method in
another package. This is accomplished easily enough by include
`broom.extend` in the `Imports:` of the package `broom.consumeSpecific`
and then calling the `tidy` method using the `broom.extend::tidy`
syntax. This is done in `broom.consumeSpecific`'s `consume` function.

Note, we can confirm this works because `consume` reverts the tidy
output from a tibble to a data frame.

    library(broom.consumeSpecific)
    consume(rcon)

    ##                           url             token
    ## 1 https://not-a-valid-url.org Not-a-Valid-Token

At this point, however, we are unable to run consume on objects that do
not have `tidy` methods defined in `broom.extend`. Since `broom.extend`
only defines the tidier for `redcapApiConnection` objects, `consume`
will fail when fun on `fit`

    consume(fit)

    ## Error in UseMethod("tidy"): no applicable method for 'tidy' applied to an object of class "lm"

Using Package Dependencies
--------------------------

    # build objects
    library(redcapAPI)
    rcon <- redcapConnection(url = "https://not-a-valid-url.org",
                             token = "Not-a-Valid-Token")
    fit <- lm(mpg ~ qsec, data = mtcars)

One way to get `consume` to work with methods from multiple packages is
to include each package with a tidier you wish to use in the `Depends:`
field of the `DESCRIPTION` file.

    library(broom.consumeUseDepends)

    ## Loading required package: broom

    ## Loading required package: broom.extend

    consume(fit)

    ##          term  estimate  std.error  statistic    p.value
    ## 1 (Intercept) -5.114038 10.0295433 -0.5098974 0.61385436
    ## 2        qsec  1.412125  0.5592101  2.5252133 0.01708199

    consume(rcon)

    ##                           url             token
    ## 1 https://not-a-valid-url.org Not-a-Valid-Token

While this approach works, it carries two major drawbacks

1.  I must know which packages have tidiers that I wish to utilize. The
    `consume` function cannot operate with any arbitrary tidier.
2.  It could require loading multiple packages into the search path,
    which is considered bad practice.

Using Package Imports
---------------------

    # build objects
    library(redcapAPI)
    rcon <- redcapConnection(url = "https://not-a-valid-url.org",
                             token = "Not-a-Valid-Token")
    fit <- lm(mpg ~ qsec, data = mtcars)

The natural inclination to avoid the second drawback of using `Depends:`
is to use `Imports` instead. Including `#' @import broom` and
`#' @import broom.extend` allows this to work for the tidiers in both
packages. However, it still requires explicitly naming packages for
which `consume` will work. That is, it is not an arbitrary solution.

    library(broom.consumeUseImports)
    consume(fit)

    ##          term  estimate  std.error  statistic    p.value
    ## 1 (Intercept) -5.114038 10.0295433 -0.5098974 0.61385436
    ## 2        qsec  1.412125  0.5592101  2.5252133 0.01708199

    consume(rcon)

    ##                           url             token
    ## 1 https://not-a-valid-url.org Not-a-Valid-Token

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
