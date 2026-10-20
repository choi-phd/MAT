# Convergence plots for multidimensional adaptive tests: the path of the successive trait estimates in
# three dimensions (in the style of Diao & Reckase, 2009) and the distance to the true position.
# Base graphics only. See man/plot_mcat_paths.Rd.

# One examinee's history from a MAT result: steps x traits, with unused steps (NA) removed.
mat_history <- function(res, j = 1) {
  h <- res$theta.history[j, , , drop = TRUE]
  if (is.null(dim(h))) h <- matrix(h, nrow = 1)       # single-step or single-trait edge case
  h[rowSums(is.na(h)) < ncol(h), , drop = FALSE]
}

# Pick three traits out of p and drop rows that are all NA (steps not yet reached).
.prep_history <- function(history, true_theta, dims) {
  history <- as.matrix(history)
  stopifnot(ncol(history) == length(true_theta))
  history <- history[rowSums(is.na(history)) < ncol(history), , drop = FALSE]
  list(h = history[, dims, drop = FALSE], tt = true_theta[dims])
}

# --- (1) One 3-D path panel -------------------------------------------------------------------
# Drawn with base graphics only (no extra packages) so the box, grids, and view can be controlled:
# a cube with grid lines on the three back walls, tick labels on the front edges, thin axes through
# the origin, a gray line through the origin and the true position, the red estimation path, a black
# start dot, and a blue dot at the true position (the layout of the Diao & Reckase figures).
#
# history     steps x p matrix of estimates
# true_theta  numeric vector of length p (true position)
# start       starting estimate, drawn as a black dot (default: the origin)
# dims        which three traits to show
# lim         axis limits, the same for all three axes (the path is clipped to the box)
# az, el      viewing azimuth and elevation in degrees (az < 0 turns the second axis to the right)

# Orthographic projection of points (n x 3, scaled to [-1, 1]) for a given azimuth and elevation.
# Returns screen x, screen y, and depth (larger depth = farther from the viewer).
.proj3d <- function(P, az, el) {
  a <- az * pi / 180
  e <- el * pi / 180
  x1 <- P[, 1] * cos(a) - P[, 2] * sin(a)
  y1 <- P[, 1] * sin(a) + P[, 2] * cos(a)
  cbind(sx = x1, sy = y1 * sin(e) + P[, 3] * cos(e), depth = y1 * cos(e) - P[, 3] * sin(e))
}

plot_mcat_path <- function(history, true_theta, main = '', dims = 1:3, start = c(0, 0, 0),
                           lim = c(-2, 3), az = -35, el = 25, path_col = 'red3',
                           tick_cex = 0.65, lab_cex = 0.8) {
  stopifnot(length(dims) == 3)
  d <- .prep_history(history, true_theta, dims)
  h <- rbind(start, d$h)                                   # the path begins at the start value
  h <- pmin(pmax(h, lim[1]), lim[2])                       # clip to the box
  tt <- pmin(pmax(d$tt, lim[1]), lim[2])
  nm <- function(v) 2 * (v - lim[1]) / (lim[2] - lim[1]) - 1   # data units -> [-1, 1]
  S <- function(M) .proj3d(matrix(M, ncol = 3), az, el)         # project rows of M
  ticks <- pretty(lim)
  ticks <- ticks[ticks >= lim[1] & ticks <= lim[2]]
  tn <- nm(ticks)

  par_old <- par(mar = c(0.5, 0.5, 2, 0.5))
  on.exit(par(par_old), add = TRUE)
  plot(NA, xlim = c(-2.1, 2.1), ylim = c(-1.9, 1.9), asp = 1, axes = FALSE, xlab = '', ylab = '',
       main = main, cex.main = 0.9)

  # camera: direction toward the viewer in the rotated frame; a face is a BACK face when its
  # outward normal points away from the viewer
  a <- az * pi / 180
  e <- el * pi / 180
  is_back <- function(axis, side) {
    n <- c(0, 0, 0)
    n[axis] <- side
    nx <- n[1] * cos(a) - n[2] * sin(a)
    ny <- n[1] * sin(a) + n[2] * cos(a)
    (-ny * cos(e) + n[3] * sin(e)) < 0
  }
  # grid lines on the three back walls
  for (axis in 1:3) for (side in c(-1, 1)) if (is_back(axis, side)) {
    ob <- setdiff(1:3, axis)
    for (v in tn) for (k in 1:2) {            # one line along each of the two other axes
      p1 <- p2 <- c(0, 0, 0)
      p1[axis] <- p2[axis] <- side
      p1[ob[k]] <- p2[ob[k]] <- v
      p1[ob[3 - k]] <- -1
      p2[ob[3 - k]] <- 1
      s <- S(rbind(p1, p2))
      lines(s[, 1], s[, 2], col = 'gray85')
    }
  }
  # the 12 edges of the cube
  corners <- as.matrix(expand.grid(c(-1, 1), c(-1, 1), c(-1, 1)))
  for (i in 1:7) for (j in (i + 1):8) {
    if (sum(corners[i, ] != corners[j, ]) == 1) {
      s <- S(corners[c(i, j), ])
      lines(s[, 1], s[, 2], col = 'gray45')
    }
  }
  # thin axes through the origin
  o <- nm(0)                                               # the origin in box coordinates
  for (k in 1:3) {
    p <- rbind(rep(o, 3), rep(o, 3))
    p[1, k] <- -1
    p[2, k] <- 1
    s <- S(p)
    lines(s[, 1], s[, 2], col = 'gray40')
  }
  # reference line through the origin and the true position
  if (any(tt != 0)) {
    u <- nm(tt) - o                                    # direction of the true point from the origin
    kk <- 1 / max(abs(u))                                  # extend until the line reaches the box
    s <- S(rbind(o - kk * u, o + kk * u))
    lines(s[, 1], s[, 2], col = 'gray60')
  }
  # estimation path, start value, and true position
  hn <- cbind(nm(h[, 1]), nm(h[, 2]), nm(h[, 3]))
  s <- S(hn)
  lines(s[, 1], s[, 2], col = path_col, lwd = 1.5)
  points(s[1, 1], s[1, 2], pch = 16, cex = 0.8)
  st <- S(matrix(nm(tt), 1))
  points(st[1, 1], st[1, 2], pch = 16, col = 'blue', cex = 1.1)

  # tick labels and axis titles on the front-bottom edges and the leftmost vertical edge
  near <- function(p_a, p_b) if (S(p_a)[, 3] <= S(p_b)[, 3]) p_a else p_b
  y_near <- near(c(0, -1, -1), c(0, 1, -1))[2]               # y of the nearest x-axis edge
  x_near <- near(c(-1, 0, -1), c(1, 0, -1))[1]               # x of the nearest y-axis edge
  vc <- as.matrix(expand.grid(c(-1, 1), c(-1, 1)))           # vertical edges (x, y)
  vx <- S(cbind(vc, 0))[, 1]
  vl <- vc[which.min(vx), ]                                  # leftmost vertical edge
  for (i in seq_along(ticks)) {
    p <- S(c(tn[i], y_near * 1.12, -1.12))
    text(p[1], p[2], ticks[i], cex = tick_cex)
    p <- S(c(x_near * 1.12, tn[i], -1.12))
    text(p[1], p[2], ticks[i], cex = tick_cex)
    p <- S(c(vl[1] * 1.12, vl[2] * 1.12, tn[i]))
    text(p[1], p[2], ticks[i], cex = tick_cex)
  }
  p <- S(c(0, y_near * 1.38, -1.38))
  text(p[1], p[2], paste0('theta ', dims[1]), cex = lab_cex)
  p <- S(c(x_near * 1.38, 0, -1.38))
  text(p[1], p[2], paste0('theta ', dims[2]), cex = lab_cex)
  p <- S(c(vl[1] * 1.38, vl[2] * 1.38, 0))
  text(p[1], p[2], paste0('theta ', dims[3]), cex = lab_cex, srt = 90)
  invisible(NULL)
}

# --- (2) Several panels on one page ------------------------------------------------------------
# histories  a NAMED list of steps x p matrices, one per method; names become the panel titles
plot_mcat_paths <- function(histories, true_theta, ncol = 3, ...) {
  n <- length(histories)
  old <- par(mfrow = c(ceiling(n / ncol), ncol))
  on.exit(par(old))
  for (nm in names(histories)) plot_mcat_path(histories[[nm]], true_theta, main = nm, ...)
  invisible(NULL)
}

# --- (3) Distance to the true position, step by step -------------------------------------------
# Euclidean distance over ALL p traits (set dims to use a subset). Step 0 is the start value.
mcat_distance <- function(history, true_theta, start = rep(0, length(true_theta)), dims = NULL) {
  history <- as.matrix(history)
  history <- history[rowSums(is.na(history)) < ncol(history), , drop = FALSE]
  history <- rbind(start, history)
  if (is.null(dims)) dims <- seq_along(true_theta)
  sqrt(rowSums(sweep(history[, dims, drop = FALSE], 2, true_theta[dims])^2))
}

plot_mcat_distance <- function(histories, true_theta, ncol = 3, ylim = NULL, ...) {
  n <- length(histories)
  d <- lapply(histories, mcat_distance, true_theta = true_theta, ...)
  if (is.null(ylim)) ylim <- c(0, max(unlist(d), na.rm = TRUE))
  old <- par(mfrow = c(ceiling(n / ncol), ncol), mar = c(4, 4, 2.5, 1))
  on.exit(par(old))
  for (nm in names(d)) {
    plot(seq_along(d[[nm]]) - 1, d[[nm]], type = 'l', ylim = ylim, main = nm,
         xlab = 'Number of items', ylab = 'Distance')
    abline(h = 0, col = 'red')
  }
  invisible(d)
}
