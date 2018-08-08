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
