---
author: sync
chapter: Closed points, divisors and skyscraper cohomology
content_type: definition
created: '2026-07-16T21:33:29'
generated: blueprint
label: def:functionFieldOverAlgebraMap
lean_status: lean_ok
order: 521
title: The \(K\)-structure on the function field
type: tex
updated: '2026-07-17T16:57:16'
---
For \(X\) over \(\Spec K\), the function field \(K(X)\) carries a canonical \(K\)-algebra structure
  through the structure morphism: the composite
  \[
    K \longrightarrow \Gamma(X, \struct X) \longrightarrow K(X)
  \]
  of the global algebra map \ref{def:overAlgebraMap} with the germ at the generic point. By
  restriction of scalars along it, \(K(X)\) is a \(K\)-module (as with the residue field, this is
  used as an explicit map rather than a global instance).