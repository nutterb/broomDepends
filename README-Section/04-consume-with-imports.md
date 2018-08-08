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
