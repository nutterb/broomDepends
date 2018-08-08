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
