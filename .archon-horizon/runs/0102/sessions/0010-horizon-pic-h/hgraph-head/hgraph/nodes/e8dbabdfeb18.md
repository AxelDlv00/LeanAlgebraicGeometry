---
author: sync
chapter: The \'etale plus construction of the relative Picard functor
content_type: theorem
created: '2026-07-16T21:33:29'
generated: blueprint
label: thm:pieceComparisonUnit
lean_status: lean_ok
order: 953
title: The per-piece comparison unit
type: tex
updated: '2026-07-17T18:01:33'
---
Let \(W\) be a \(\sigma\)-normalized comparison of \(\gamma\)
  (Definition~\ref{def:normalizedCechComparison}) with comparison cochain \(\theta\), and \(T\) a
  piece trivialization of \(\gamma\) on \(V\). The \emph{per-piece comparison unit}
  \[
    v_V \;\in\; \Gamma\bigl(X_{B \otimes_A B},\, \mathrm{cgq}^{-1}V\bigr)^{\times}
  \]
  is the global unit glued from the values \(\theta_x \cdot (u_2^{\sharp}T)(x) /
  (u_1^{\sharp}T)(x)\) on the trimmed comparison cover: on each member it restricts to that twisted
  witness value. It is the unique unit of the double piece with this restriction property.