---
author: sync
chapter: The \'etale plus construction of the relative Picard functor
content_type: definition
created: '2026-07-16T21:33:29'
generated: blueprint
label: def:pieceTrivialization
lean_status: lean_ok
order: 951
title: A piece trivialization
type: tex
updated: '2026-07-24T17:02:48'
---
A \emph{piece trivialization} of a representing cocycle \(\gamma\) on a pointed cover \(\mathcal N\)
  of \(X_B\), over a piece \(V \subseteq X_A\), is a trivializing \(0\)-cochain \(t\) of \(\gamma\)
  on the \(\mathrm{cg}^{-1}V\)-trimmed opens: units \(t_b \in \Gamma(X_B, \mathcal N(b) \cap
  \mathrm{cg}^{-1}V)^{\times}\) with \(t_b \cdot \gamma_{b b'} = t_{b'}\) on the trimmed pairwise
  overlaps. It is the cochain witness that the class \(L = [\gamma]\) is trivial on the cover piece
  \(\mathrm{cg}^{-1}V\) (\ref{cor:cechPic_mk_eq_one}); its existence over a covering family of pieces
  is the piece-selection input consumed by the final splice. The two coprojections both lie over the
  cover inclusions, \(u_1 \circ \mathrm{cg} = \mathrm{cgq} = u_2 \circ \mathrm{cg}\) as maps to
  \(X_A\), so the double piece is bounded by each coprojection preimage of the piece,
  \(\mathrm{cgq}^{-1}V \le u_i^{-1}(\mathrm{cg}^{-1}V)\).