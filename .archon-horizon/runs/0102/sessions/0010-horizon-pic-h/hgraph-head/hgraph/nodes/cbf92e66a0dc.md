---
author: sync
chapter: Cohomology of sheaves of modules
content_type: definition
created: '2026-07-16T21:33:29'
generated: blueprint
label: def:moduleDelta
lean_status: lean_ok
order: 333
title: The connecting map
type: tex
updated: '2026-07-17T16:57:15'
---
For a Mayer--Vietoris square \(S\) and a sheaf \(F\) of \(R\)-modules, the connecting map
  \(F(X_1) \to H'^1(X_4, F)\): the identification
  \(F(X_1) \cong H'^0(X_1,F) = \Ext^0(R[X_1], F)\) of \ref{def:HModule'_linearEquiv0},
  followed by the map \(\delta \cdot (-) : \Ext^0(R[X_1],F) \to \Ext^1(R[X_4],F) = H'^1(X_4,F)\)
  of \ref{lem:ext_contravariant_les} for the short exact sequence of
  \ref{thm:moduleShortComplex_shortExact} (\(A = R[X_1]\), \(B = R[X_2] \oplus R[X_3]\),
  \(C = R[X_4]\)).