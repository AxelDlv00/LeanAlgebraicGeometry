---
author: sync
content_type: definition
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.gluedPieceEquiv
docstring: '**Each piece is `Aᵢ`-free of rank one**: the piece trivialization `tᵢ`,
  promoted to

  an `Aᵢ`-linear equivalence `Mᵢ ≃ₗ[Aᵢ] Aᵢ` for the `gluedPieceModule` structure.'
file: AlgebraicJacobian/Cohomology/GluedSheafModule.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.gluedPieceEquiv
type: lean
updated: '2026-08-01T09:44:09'
---
noncomputable def gluedPieceEquiv (hc : Scheme.IsGluingCocycle U g)
    (hP : ∀ i : ι, X.basicOpen (h i) ≤ U (σ i)) (i : ι) :
    letI := gluedPieceModule k U g hc hP i
    ↥(gluedSubmodule k U g (X.basicOpen (h i))) ≃ₗ[Γ(X, X.basicOpen (h i))]
      Γ(X, X.basicOpen (h i)) :=
  letI := gluedPieceModule k U g hc hP i
  { toFun := gluedTriv k hc (σ i) (hP i)
    map_add' := (gluedTriv k hc (σ i) (hP i)).map_add
    map_smul' := fun a m => by
      change gluedTriv k hc (σ i) (hP i)
          ((gluedTriv k hc (σ i) (hP i)).symm (a * gluedTriv k hc (σ i) (hP i) m)) =
        a • gluedTriv k hc (σ i) (hP i) m
      rw [LinearEquiv.apply_symm_apply, smul_eq_mul]
    invFun := (gluedTriv k hc (σ i) (hP i)).symm
    left_inv := (gluedTriv k hc (σ i) (hP i)).left_inv
    right_inv := (gluedTriv k hc (σ i) (hP i)).right_inv }

@[simp]