---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.genus
docstring: The genus of a smooth proper curve.
file: AlgebraicJacobian/Genus.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.genus
type: lean
updated: '2026-07-16T21:14:26'
---
noncomputable def genus {k : Type u} [Field k] (C : Over (Spec (.of k)))
    [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] : ℕ :=
  Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)