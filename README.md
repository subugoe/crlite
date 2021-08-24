# crlite

<!-- badges: start -->
[![Main](https://github.com/subugoe/crlite/workflows/.github/workflows/main.yaml/badge.svg)](https://github.com/subugoe/biblids/actions)
[![Codecov test coverage](https://codecov.io/gh/subugoe/crlite/branch/master/graph/badge.svg)](https://codecov.io/gh/subugoe/biblids?branch=master)
[![CRAN status](https://www.r-pkg.org/badges/version/crlite)](https://CRAN.R-project.org/package=biblids)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

TL,DR: You should probably be using the [rcrossref](https://github.com/ropensci/rcrossref) client instead.

The goal of crlite is to make it easier to use the [Crossref REST API](https://api.crossref.org/swagger-ui/index.html) from R in production.
To that end, it differs from the existing (and much more mature and comprehensive) [rcrossref](https://github.com/ropensci/rcrossref) in several ways:

1. crlite is a **minimalistic wrapper** in the spirit of [gh](https://github.com/r-lib/gh):
    It handles the API requests (authentication etc.) but otherwise leaves users to write their own queries.
    In production use, this may make the package more stable because it cuts a layer of complexity and allows more tightly focused queries and smaller data structures.
    In interactive use, this can cause more work.
    crlite also aims to be more stable, and require less maintenance,
    because it does not replicate the crossref API.
    Callers will be responsible for adapting their code to changes in the API.
1. crlite provides some **type- and length-stable field accessors**.
    The crossref API itself is, unfortunately, [not type- and length-stable](https://github.com/CrossRef/rest-api-doc/issues/551).
    This instability is (unavoidably) imported into the rcrossref client, as it wrangles unstable API results into useful R objects.
    For example, in `rcrossref::cr_works()`, the order and number of columns [may differ](https://github.com/subugoe/metacheck/issues/183), depending on whether some field is included in the JSON returned from the corresponding `/works` endpoint.
    This is not the fault of rcrossref, but a necessary result of wrapping an unstable API in R dataframes (unless you want to reimplement the entire API spec in R to reassert stability).
    In interactive use, the instability may be a minor concern, outweighted by the convenience of ready-made R objects.
    In production use, type- and length-instability can cause unexpected, hard to debug errors or requires ugly and non-idiomatic workarounds.

    By accessing only single *fields*, crlite can safely assert the type and content of the returned JSON, and return a type- and length-stable `NA` otherwise.
    These accessors, will, however remain tightly limited.
1. crlite caches all requests transparently.
    In production, this allows for greater separation of concerns.
    Instead of worrying about efficient API usage, production code can call crlite depending on what makes idiomatic sense.
1. crlite uses **[httr2](https://httr2.r-lib.org)**, not [crul](https://github.com/ropensci/crul) under the hood.
1. crlite provides extensive support for the **higher-performance `polite` and `plus` API pools**.
