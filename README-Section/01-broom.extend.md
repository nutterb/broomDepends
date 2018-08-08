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
