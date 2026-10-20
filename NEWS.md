# MAT 2.3.3

* New functions for convergence plots: `plot_mcat_path()` and `plot_mcat_paths()` draw the path of one
  examinee's trait estimates in three dimensions (box with back-wall grids, start value, true position),
  `plot_mcat_distance()` and `mcat_distance()` give the distance to the true position after each item,
  and `mat_history()` extracts one examinee's history from a `MAT()` result. Base graphics only.
* `MAT()` gains `plot.summary` (default `plot.audit.trail`). The summary plots (CAT versus full-bank
  thetas and the content distribution) were drawn on every call, even with `plot.audit.trail = FALSE`,
  opening graphics windows during simulations. They now appear only when requested.
* `MAT()`: with `topN > 1` (randomesque exposure control), unavailable items (already administered or
  outside the targeted content area) could be ranked first and selected. Only available items are
  ranked now.
* `MAT()`: `content.order` is now checked against `ncc` (the number of content categories) instead of `p`.
* `MAT()`: no error or warning from the summary plot when only one examinee is simulated (`r = NA`).
* `simM3PL()`: the correlation structure is now always applied. Previously, if any off-diagonal element
  of `cors` was exactly 0 (for example one uncorrelated pair), all traits were generated as independent.
* Documentation: removed the stale `requires MASS` note; `DESCRIPTION` now lists `grDevices`, `graphics`
  and `stats` in `Imports`, matching `NAMESPACE`; updated the package date.
