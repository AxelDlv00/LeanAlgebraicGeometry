---
author: sync
content_type: theorem
created: '2026-07-28T22:23:01'
decl: AlgebraicGeometry.DivFamZarAff.mapAlgHom_eq_mapAlg
docstring: '**The face-change bridge**: `mapAlgHom` along an algebra map that agrees
  with the structure

  map of a scalar tower in scope is the instance-based `DivFamZarAff.mapAlg` of the
  tower.


  This is how the widened vehicle statements (spelled at `Over.resAlgHom`) consume
  the widened

  S5b keystones (spelled at localization instance packs) — and in the reverse direction,
  how

  `eq_of_away_eq` becomes usable from the vehicle.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffFace.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivFamZarAff.mapAlgHom_eq_mapAlg
type: lean
updated: '2026-08-01T09:44:13'
---
theorem mapAlgHom_eq_mapAlg [Algebra A A'] [IsScalarTower k A A'] (φ : A →ₐ[k] A')
    (hφ : ∀ a, φ a = algebraMap A A' a) (F : DivFamZarAff C A n) :
    mapAlgHom φ F = DivFamZarAff.mapAlg A' n F := by
  unfold mapAlgHom
  exact mapAlg_congr (Algebra.algebra_ext _ _ hφ) _ _ F

/-! ### The Abel hook on the explicit face -/