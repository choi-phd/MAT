# MAT

MAT is a package to simulate Multidimensional Adaptive Testing (MAT) for the Multidimensional 3-Parameter Logistic (M3PL) Model.

## Installation

Install the released version from CRAN:

```r
install.packages("MAT")
```

Install the development version (the latest changes on `main`) from GitHub:

```r
# install.packages("remotes")
remotes::install_github("choi-phd/MAT")
```

The package contains compiled code (Rcpp and RcppArmadillo), so installing from GitHub needs a C++ toolchain:
Xcode command line tools on macOS (`xcode-select --install`), Rtools on Windows, or `build-essential` on Linux.

## Example

```r
library(MAT)

data(sample.ipar)                                   # 180 items measuring three dimensions
vcv1 <- diag(3)
vcv1[lower.tri(vcv1, diag = FALSE)] <- c(.5, .6, .7)
sim <- simM3PL(sample.ipar, vcv1, 3, n.simulee = 1, seed = 1)

res <- MAT(sample.ipar, sim$resp, vcv1, p = 3,
           selectionMethod = "D", selectionType = "BAYESIAN",
           minNI = 30, maxNI = 30, plot.audit.trail = FALSE)

# path of the trait estimates (three dimensions) and distance to the true position
h <- mat_history(res, 1)
plot_mcat_path(h, sim$theta[1, ], main = "D-optimality, Bayesian selection", lim = c(-3, 3))
plot_mcat_distance(list("D, Bayesian" = h), sim$theta[1,], ncol = 1)
```

## Changes

See [NEWS.md](NEWS.md).

## Reporting problems

Please report bugs and questions at <https://github.com/choi-phd/MAT/issues>.
