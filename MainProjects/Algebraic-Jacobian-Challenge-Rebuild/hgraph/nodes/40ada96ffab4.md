---
author: sync
content_type: theorem
created: '2026-07-27T01:04:30'
decl: AlgebraicGeometry.quasiCompact_gluedHom
docstring: '**Quasi-compactness descends from a finite family of quasi-compact charts**:
  the base

  `Spec k` is affine, so quasi-compactness of the structure morphism is compactness
  of the space

  of the glued object, and that space is the union of the finitely many compact chart
  images.'
file: AlgebraicJacobian/Picard/JacobianDataCharts.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.quasiCompact_gluedHom
type: lean
updated: '2026-07-29T15:31:46'
---
theorem quasiCompact_gluedHom [Finite ι] (hcpt : ∀ i, CompactSpace (X i)) :
    QuasiCompact (gluedHom C f hf) := by
  haveI : Finite (Scheme.LocalRepresentability.glueData hf).openCover.I₀ := ‹Finite ι›
  haveI : ∀ i, CompactSpace ((Scheme.LocalRepresentability.glueData hf).openCover.X i) := hcpt
  haveI : CompactSpace (Scheme.LocalRepresentability.glueData hf).glued :=
    (Scheme.LocalRepresentability.glueData hf).openCover.compactSpace
  exact HasAffineProperty.iff_of_isAffine.mpr ‹_›

/-! ## The producer -/