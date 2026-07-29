---
author: sync
content_type: theorem
created: '2026-07-24T17:02:46'
decl: AlgebraicGeometry.isLocalizedModule_secResₗ_glued
docstring: '**The RE-0 bridge fired on a piece** (DAT-1 (1c)): on an affine chart
  `V`, the

  restriction `F(V) → F(D(h i))` exhibits the piece sections as the localization of
  the

  chart sections at the powers of `h i`. The abstract bridge

  (`Scheme.QcohOn.isLocalizedModule_secResₗ`) produces this at `V ⊓ D(h i)` — its

  `map_units` hypothesis is the trivialization conjugation `isUnit_algebraMap_end_glued`
  —

  and `IsLocalizedModule.of_linearEquiv` transports across the opens equality

  `V ⊓ D(h i) = D(h i)`.'
file: AlgebraicJacobian/Cohomology/GluedSheafModule.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.isLocalizedModule_secResₗ_glued
type: lean
updated: '2026-07-29T15:26:32'
---
theorem isLocalizedModule_secResₗ_glued (hV : IsAffineOpen V)
    (hc : Scheme.IsGluingCocycle U g)
    (hq : ∀ {W : X.Opens} (hW : W ≤ V) (r : Γ(X, V)) (s : ↥(gluedSubmodule k U g W)),
      Scheme.QcohOn.qsmul (F := gluedSheaf k U g) hW r s = gluedQsmul k U g hW r s)
    (hP : ∀ i : ι, X.basicOpen (h i) ≤ U (σ i)) (i : ι) :
    letI := Scheme.QcohOn.moduleOfLE (F := gluedSheaf k U g) (le_refl V)
    letI := Scheme.QcohOn.moduleOfLE (F := gluedSheaf k U g) (X.basicOpen_le (h i))
    IsLocalizedModule (Submonoid.powers (h i))
      (Scheme.QcohOn.secResₗ (F := gluedSheaf k U g)
        (X.basicOpen_le (h i)) (le_refl V)) := by
  letI := Scheme.QcohOn.moduleOfLE (F := gluedSheaf k U g) (le_refl V)
  letI := Scheme.QcohOn.moduleOfLE (F := gluedSheaf k U g) (X.basicOpen_le (h i))
  letI := Scheme.QcohOn.moduleOfLE (F := gluedSheaf k U g)
    (inf_le_left : V ⊓ X.basicOpen (h i) ≤ V)
  -- the unit-action hypothesis on `V ⊓ D(h i)`, an open below the piece `U (σ i)`
  have hru : IsUnit (X.resHom (inf_le_left : V ⊓ X.basicOpen (h i) ≤ V) (h i)) := by
    have h1 : IsUnit (X.resHom (X.basicOpen_le (h i)) (h i)) :=
      X.toRingedSpace.isUnit_res_basicOpen (h i)
    have h2 : X.resHom (inf_le_left : V ⊓ X.basicOpen (h i) ≤ V) (h i) =
        X.resHom (inf_le_right : V ⊓ X.basicOpen (h i) ≤ X.basicOpen (h i))
          (X.resHom (X.basicOpen_le (h i)) (h i)) := by
      rw [Scheme.resHom_resHom]
    rw [h2]
    exact (X.resHom
      (inf_le_right : V ⊓ X.basicOpen (h i) ≤ X.basicOpen (h i))).isUnit_map h1
  -- the abstract bridge at `V ⊓ D(h i)`
  haveI hbridge := Scheme.QcohOn.isLocalizedModule_secResₗ (F := gluedSheaf k U g)
    hV (h i)
    (isUnit_algebraMap_end_glued k U g hc hq
      (inf_le_left : V ⊓ X.basicOpen (h i) ≤ V)
      (inf_le_right.trans (hP i)) (h i) hru)
  -- transport across the opens equality `V ⊓ D(h i) = D(h i)`
  let e : ((gluedSheaf k U g).obj.obj (op (V ⊓ X.basicOpen (h i)))) ≃ₗ[Γ(X, V)]
      ((gluedSheaf k U g).obj.obj (op (X.basicOpen (h i)))) :=
    LinearEquiv.ofLinear
      (Scheme.QcohOn.secResₗ (F := gluedSheaf k U g)
        (le_inf (X.basicOpen_le (h i)) le_rfl :
          X.basicOpen (h i) ≤ V ⊓ X.basicOpen (h i))
        (inf_le_left : V ⊓ X.basicOpen (h i) ≤ V))
      (Scheme.QcohOn.secResₗ (F := gluedSheaf k U g)
        (inf_le_right : V ⊓ X.basicOpen (h i) ≤ X.basicOpen (h i))
        (X.basicOpen_le (h i)))
      (LinearMap.ext fun m => by
        change gluedRes k U g (le_inf (X.basicOpen_le (h i)) le_rfl)
          (gluedRes k U g
            (inf_le_right : V ⊓ X.basicOpen (h i) ≤ X.basicOpen (h i)) m) = m
        rw [gluedRes_gluedRes]
        exact gluedRes_self k U g _ m)
      (LinearMap.ext fun m => by
        change gluedRes k U g
          (inf_le_right : V ⊓ X.basicOpen (h i) ≤ X.basicOpen (h i))
          (gluedRes k U g (le_inf (X.basicOpen_le (h i)) le_rfl) m) = m
        rw [gluedRes_gluedRes]
        exact gluedRes_self k U g _ m)
  have heq : (e : ((gluedSheaf k U g).obj.obj (op (V ⊓ X.basicOpen (h i)))) →ₗ[Γ(X, V)]
        ((gluedSheaf k U g).obj.obj (op (X.basicOpen (h i))))) ∘ₗ
      Scheme.QcohOn.secResₗ (F := gluedSheaf k U g)
        (inf_le_left : V ⊓ X.basicOpen (h i) ≤ V) (le_refl V) =
      Scheme.QcohOn.secResₗ (F := gluedSheaf k U g)
        (X.basicOpen_le (h i)) (le_refl V) := by
    refine LinearMap.ext fun m => ?_
    change gluedRes k U g (le_inf (X.basicOpen_le (h i)) le_rfl)
        (gluedRes k U g (inf_le_left : V ⊓ X.basicOpen (h i) ≤ V) m) =
      gluedRes k U g (X.basicOpen_le (h i)) m
    rw [gluedRes_gluedRes]
  rw [← heq]
  exact IsLocalizedModule.of_linearEquiv _ _ _

/-! ## The chart-module properties -/