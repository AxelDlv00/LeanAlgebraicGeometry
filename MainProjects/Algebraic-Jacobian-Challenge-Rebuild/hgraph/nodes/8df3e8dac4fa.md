---
author: sync
content_type: definition
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.genus
docstring: 'The genus of a smooth proper curve: the `k`-dimension of the first cohomology
  group

  `H¹(C, 𝒪_C)` of the structure sheaf, viewed as a sheaf of `k`-modules on the small
  Zariski

  site of `C` (`Scheme.moduleKSheaf`), with cohomology the `Ext` from the constant
  sheaf

  (`CategoryTheory.Sheaf.HModule`). Finite-dimensionality of `H¹` is proved downstream.'
file: AlgebraicJacobian/Challenge.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.genus
type: lean
updated: '2026-07-29T15:26:28'
---
noncomputable def genus (C : Over (Spec (.of k))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom] : ℕ :=
  letI : C.left.Over (Spec (.of k)) := .ofHom C.hom
  Module.finrank k (Sheaf.HModule (C.left.moduleKSheaf k) 1)

-- data