---
author: sync
chapter: The \'etale plus construction of the relative Picard functor
content_type: definition
created: '2026-07-16T21:33:29'
generated: blueprint
label: def:picEt_LocalData
lean_status: lean_ok
order: 1075
title: Compatible local data on an open cover
type: tex
updated: '2026-07-24T17:02:48'
---
Let \(T\) be a test object and \((O_i)_{i \in \iota}\) an open cover of
  \(T_{\mathrm{left}}\). \emph{Compatible local data} on the cover is a family assigning to
  every index \(i\) and every affine open \(W \le O_i\) a plus class
  \(v_{i,W} \in \mathrm{PicEtAff}(C, \Gamma(T,W))\), such that
  (\emph{res}) within a member, \(v_{i,W}\) restricts to \(v_{i,W'}\) for \(W' \le W \le O_i\),
  and (\emph{glue}) across members, \(v_{i,W} = v_{j,W}\) whenever \(W \le O_i\) and
  \(W \le O_j\). A plus class \(z\) at an affine open \(W\) is a \emph{glue value} of the
  data when its restriction to every affine sub-open \(W_0 \le W\) contained in some member
  \(O_i\) equals \(v_{i,W_0}\).