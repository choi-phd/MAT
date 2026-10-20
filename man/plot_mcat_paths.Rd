\name{plot_mcat_paths}
\alias{plot_mcat_paths}
\alias{plot_mcat_path}
\alias{plot_mcat_distance}
\alias{mcat_distance}
\alias{mat_history}
\title{
  Convergence Plots for Multidimensional Adaptive Tests
}
\description{
  Plots the path of the successive trait estimates of one examinee in three dimensions, from the
  starting value to the true position, and the distance between the estimate and the true position
  after each item (in the style of Diao & Reckase, 2009).
}
\usage{
  mat_history(res, j = 1)

  plot_mcat_path(history, true_theta, main = "", dims = 1:3, start = c(0, 0, 0),
                 lim = c(-2, 3), az = -35, el = 25, path_col = "red3",
                 tick_cex = 0.65, lab_cex = 0.8)

  plot_mcat_paths(histories, true_theta, ncol = 3, ...)

  mcat_distance(history, true_theta, start = rep(0, length(true_theta)), dims = NULL)

  plot_mcat_distance(histories, true_theta, ncol = 3, ylim = NULL, ...)
}
\arguments{
  \item{res}{an object of class "MAT" returned by \code{\link{MAT}}}
  \item{j}{the row (examinee) of \code{res$theta.history} to extract}
  \item{history}{a matrix of trait estimates with one row per item administered and one column per
    dimension, e.g., the value returned by \code{mat_history}}
  \item{histories}{a \emph{named} list of such matrices, one per method; the names are used as panel titles}
  \item{true_theta}{the true trait vector of the examinee (length equal to the number of dimensions)}
  \item{main}{panel title}
  \item{dims}{the three dimensions to show in \code{plot_mcat_path}; for \code{mcat_distance}, the dimensions
    used to compute the distance (default: all dimensions)}
  \item{start}{the starting estimate, drawn as a black dot (default: the origin); for \code{mcat_distance}
    the starting vector of length equal to the number of dimensions}
  \item{lim}{axis limits, the same for the three axes; the path is clipped to the box}
  \item{az, el}{viewing azimuth and elevation in degrees}
  \item{path_col}{color of the path}
  \item{tick_cex, lab_cex}{text sizes of the tick labels and axis titles}
  \item{ncol}{number of panels per row}
  \item{ylim}{y-axis limits of the distance plots (default: from 0 to the largest distance)}
  \item{...}{further arguments passed to \code{plot_mcat_path} (\code{plot_mcat_paths}) or to
    \code{mcat_distance} (\code{plot_mcat_distance})}
}
\details{
  \code{plot_mcat_path} draws a cube with grid lines on the three back walls, thin axes through the origin,
  a gray line through the origin and the true position (blue dot), the estimation path (red) and the
  starting value (black dot). Only base graphics are used. Three dimensions are shown at a time, so for tests
  with more dimensions choose them with \code{dims}.

  \code{theta.history} in a "MAT" object is an array with dimensions examinee, step, and dimension;
  \code{mat_history} extracts one examinee as a matrix of steps by dimensions and drops the steps that were
  not administered.
}
\value{
  \code{mat_history} returns a matrix of trait estimates and \code{mcat_distance} a numeric vector of
  distances (step 0 is the starting value). \code{plot_mcat_distance} returns the list of distance vectors
  invisibly; the other functions are called for their side effect of drawing.
}
\references{
  Diao, Q., & Reckase, M. D. (2009). Comparison of ability estimation and item selection methods in
  multidimensional computerized adaptive testing. Paper presented at the GMAC Conference on Computerized
  Adaptive Testing.
}
\author{
  Seung W. Choi
}
\seealso{
  \code{\link{MAT}}, \code{\link{simM3PL}}
}
\examples{
  data(sample.ipar)
  vcv1 <- diag(3)
  vcv1[lower.tri(vcv1, diag = FALSE)] <- c(.5, .6, .7)
  sim <- simM3PL(sample.ipar, vcv1, 3, n.simulee = 1, seed = 1)
  res <- MAT(sample.ipar, sim$resp, vcv1, p = 3,
             selectionMethod = "D", selectionType = "BAYESIAN",
             minNI = 30, maxNI = 30, plot.audit.trail = FALSE)
  h <- mat_history(res, 1)
  plot_mcat_path(h, sim$theta[1, ], main = "D-optimality, Bayesian selection", lim = c(-3, 3))
  plot_mcat_distance(list("D, Bayesian" = h), sim$theta[1, ], ncol = 1)
}
