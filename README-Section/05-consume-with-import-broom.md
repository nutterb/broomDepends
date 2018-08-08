### Reliance on Explicit Imports

    # build objects
    library(redcapAPI)
    rcon <- redcapConnection(url = "https://not-a-valid-url.org",
                             token = "Not-a-Valid-Token")
    fit <- lm(mpg ~ qsec, data = mtcars)

This solution breaks down when packages are not included in the
`Imports:`. While the previous example had a package that imported both
`broom` and `broom.extend`, the following example only imports `broom`.
Thus, `consume` will fail for the `rcon` object.

    library(broom.consumeUseImportBroom)
    consume(fit)

    ##          term  estimate  std.error  statistic    p.value
    ## 1 (Intercept) -5.114038 10.0295433 -0.5098974 0.61385436
    ## 2        qsec  1.412125  0.5592101  2.5252133 0.01708199

    consume(rcon)

    ## Error: No tidy method for objects of class redcapApiConnection
