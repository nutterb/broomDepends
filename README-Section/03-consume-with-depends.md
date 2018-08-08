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
