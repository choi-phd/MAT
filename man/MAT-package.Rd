\name{MAT-package}
\alias{MAT-package}
\docType{package}
\title{
Multidimensional Adaptive Testing (MAT)
}
\description{
  MAT is a package to simulate Multidimensional Adaptive Testing (MAT) for the Multidimensional
  3-Parameter Logistic (M3PL) Model  as described in Segall (1996), Reckase (2009), and Mulder & van der Linden (2009).
}
\author{
Seung W. Choi and David R. King

Maintainer: Seung W. Choi <s-choi@northwestern.edu>
}
\references{
  \enumerate{
    \item Choi, S. W., & King, D. R. (2015). R Package MAT: Simulation of multidimensional adaptive testing for dichotomous IRT models. Applied Psychological Measurement, 39(3), 239-240.
    \item Segall, D. O. (1996). Multidimensional adaptive testing, Psychometrika, 61(2), 331-354
    \item van der Linden, W. J. (1999). Multidimensional adaptive testing with a minimum error-variance criterion,
          Journal of Educational and Behavioral Statistics, 24(4), 398-412.
    \item Mulder, J., & van der Linden, W. J. (2009). Multidimensional adaptive testing with optimal design criteria
          for item selection, Psychometrika, 74(2), 273-296.
    \item Reckase, M. D. (2009). Multidimensional Item Response Theory. New York: Springer.
  }
}

\keyword{ package }
\examples{
  #load sample item parameters containing 180 items measuring three dimensions
  data(sample.ipar)
  #create a variance-covariance (correlation) matrix
  vcv1<-diag(3); vcv1[lower.tri(vcv1,diag=FALSE)]<-c(.5,.6,.7)
  #simulate item responses
  resp1<-simM3PL(sample.ipar, vcv1, 3, n.simulee = 100)$resp
  #specify target content distributions
  target.content.dist1<-c(1/3,1/3,1/3)
  #content category designations for items
  content.cat1<-rep(1:3,rep(60,3))
  #simulate multidimensional adaptive testing
  MCAT.1<-MAT(sample.ipar,
              resp1,
              vcv1,
              target.content.dist=target.content.dist1,
              content.cat=content.cat1,
              ncc=3,
              p=3,
              selectionMethod="A",
              topN=1,
              selectionType="FISHER",
              stoppingCriterion="CONJUNCTIVE",
              minNI=10,
              maxNI=30)
	}
