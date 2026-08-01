---
author: sync
chapter: Cohomology of sheaves of modules
content_type: definition
created: '2026-07-16T21:33:29'
generated: blueprint
label: def:constAdjHomEquiv
lean_status: lean_ok
order: 286
title: The adjunction, linearly
type: tex
updated: '2026-07-17T16:57:15'
---
Assume the category \(\mathcal C\) has a terminal object \(\top\). For every \(R\)-module
  \(M\) and every sheaf \(F\) of \(R\)-modules there is an \(R\)-linear equivalence
  \[
    \Hom\bigl(\underline{M},\, F\bigr) \;\cong\; \Hom_R\bigl(M,\, F(\top)\bigr),
  \]
  where \(\underline{M}\) denotes the constant sheaf with value \(M\); it is the hom-bijection
  of the adjunction between the constant-sheaf functor and evaluation at \(\top\).