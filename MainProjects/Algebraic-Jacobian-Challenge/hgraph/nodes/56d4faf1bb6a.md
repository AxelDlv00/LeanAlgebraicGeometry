---
author: sync
chapter: The Jacobian as an abelian variety
content_type: remark
created: '2026-07-16T21:14:29'
generated: blueprint
label: rem:IsAlbanese_unique_iso
lean_status: empty
order: 556
title: rem:IsAlbanese_unique_iso
type: tex
updated: '2026-07-16T21:14:29'
---
The Lean proof of Theorem~\ref{thm:IsAlbanese_unique} internally produces an inverse morphism \(h \colon J_2 \to J_1\) and verifies \(g \circ h = \mathrm{id}_{J_1}\) and \(h \circ g = \mathrm{id}_{J_2}\) (the invertibility witnesses are computed as intermediate lemmas of the tactic block) before returning the triple \((g,\ \iota_2 = \iota_1 \circ g,\ \text{uniqueness})\). The invertibility witnesses are computed but not retained in the return type
  \[
    \exists! (e : J_1 \to J_2),\ \iota_2 = \iota_1 \circ e.
  \]
  The natural strengthening would be to return
  \[
    \exists! (e : J_1 \cong J_2),\ \iota_2 = \iota_1 \circ e.\mathtt{hom},
  \]
  packaging the produced morphism together with its inverse. Tightening the conclusion in this way is a Lean-side refactor of the signature of \texttt{IsAlbanese.unique} that the project may carry out in a future iteration. The downstream consumers of \texttt{IsAlbanese.unique} (the protected \texttt{AbelJacobi.Jacobian.*} interface) use only the morphism-and-uniqueness content of the conclusion, so the current weaker conclusion is sufficient for the present API.