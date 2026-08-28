---
author: sync
chapter: Cohomology of sheaves of modules
content_type: definition
created: '2026-07-16T21:33:29'
generated: blueprint
label: def:HModule'_mapCoeff
lean_status: lean_ok
order: 298
title: Functoriality in the coefficient sheaf
type: tex
updated: '2026-07-17T16:57:15'
---
A morphism of sheaves of \(R\)-modules \(f : F \to G\) induces, for every object \(U\) of
  \(\mathcal C\) and every \(n\), an \(R\)-linear map \(H'^n(U, F) \to H'^n(U, G)\),
  \(x \mapsto x \cdot f\): composition (Yoneda product) with the degree-zero class of \(f\), i.e.\
  covariant functoriality of \(\Ext^n(R[U], -)\) in the coefficient variable. This is the
  coefficient-variable analogue of the restriction \ref{def:HModule'_res} (functoriality in the
  object of the site). The identity induces the identity, and a composite \(g \circ f\) induces the
  composite of the induced maps.