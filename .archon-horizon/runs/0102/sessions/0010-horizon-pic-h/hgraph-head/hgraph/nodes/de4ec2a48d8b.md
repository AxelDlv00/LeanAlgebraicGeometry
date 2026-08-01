---
author: sync
chapter: The \'etale plus construction of the relative Picard functor
content_type: definition
created: '2026-07-16T21:33:29'
generated: blueprint
label: def:unitsCorrCochain
lean_status: lean_ok
order: 840
title: The corrected witness cochain
type: tex
updated: '2026-07-17T18:01:33'
---
The \emph{corrected witness value} at a point \(y \in Y\) is the unit on
  \(\mathcal C_y \cap D\)
  \[
    (\mathrm{corr}\,c)_y := r_1^{\sharp}\gamma_Z(a,\, r_1 y) \cdot (c_y)^{-1} \cdot
      r_2^{\sharp}\gamma_Z(r_2 y,\, b) ,
  \]
  the two correction factors being the coprojection pullbacks of the cocycle values of
  \(\gamma_Z\) anchored \(a \to r_1 y\) on the left and \(r_2 y \to b\) on the right, with the
  witness entering inverted. This is the unique orientation whose coboundary cancels the
  coboundary of \(\theta^{-1}\), and which on the diagonal — where the coherent witness is
  \(1\) — telescopes to the cocycle value \(\gamma_Z(a, b)\).