---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.FreeCechEngine.combHomotopy
docstring: 'The contracting homotopy: prepend the fixed index `r`.  `(h u)(τ) = u
  (Fin.cons r τ)`.

  Free-side port of `CombinatorialCech.combHomotopy`.'
file: AlgebraicJacobian/Cohomology/FreePresheafComplex.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.FreeCechEngine.combHomotopy
type: lean
updated: '2026-07-24T03:02:09'
---
def combHomotopy (r : ι) (u : (Fin (n + 1) → ι) → M) : (Fin n → ι) → M :=
  fun τ => u (Fin.cons r τ)