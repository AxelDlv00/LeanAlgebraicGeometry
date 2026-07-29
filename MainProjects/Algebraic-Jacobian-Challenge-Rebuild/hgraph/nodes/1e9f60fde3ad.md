---
author: sync
content_type: lemma
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.isUnit_algebraMap_end_glued
docstring: '**Invertibility of the packaged action of a unit**: a chart section `r`
  restricting

  to a unit on an open `W` below a gluing piece acts invertibly on `F(W)` — the action
  is

  conjugate, through the piece trivialization, to multiplication by the unit `r↾_W`.
  This

  discharges the `map_units` hypothesis of the RE-0 bridge.'
file: AlgebraicJacobian/Cohomology/GluedSheafModule.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.isUnit_algebraMap_end_glued
type: lean
updated: '2026-07-29T15:31:35'
---
lemma isUnit_algebraMap_end_glued (hc : Scheme.IsGluingCocycle U g)
    (hq : ∀ {W : X.Opens} (hW : W ≤ V) (r : Γ(X, V)) (s : ↥(gluedSubmodule k U g W)),
      Scheme.QcohOn.qsmul (F := gluedSheaf k U g) hW r s = gluedQsmul k U g hW r s)
    {W : X.Opens} (hWV : W ≤ V) {j : J} (hWj : W ≤ U j) (r : Γ(X, V))
    (hr : IsUnit (X.resHom hWV r)) :
    letI := Scheme.QcohOn.moduleOfLE (F := gluedSheaf k U g) hWV
    IsUnit (algebraMap Γ(X, V)
      (Module.End Γ(X, V) ((gluedSheaf k U g).obj.obj (op W))) r) := by
  letI := Scheme.QcohOn.moduleOfLE (F := gluedSheaf k U g) hWV
  have hE : ⇑(algebraMap Γ(X, V)
      (Module.End Γ(X, V) ((gluedSheaf k U g).obj.obj (op W))) r) =
      fun m : ↥(gluedSubmodule k U g W) => gluedQsmul k U g hWV r m := by
    funext m
    rw [Module.algebraMap_end_apply]
    exact hq hWV r m
  rw [Module.End.isUnit_iff, hE]
  obtain ⟨v, hv⟩ := hr
  refine Function.bijective_iff_has_inverse.mpr
    ⟨fun m => (gluedTriv k hc j hWj).symm
      ((↑v⁻¹ : Γ(X, W)) * gluedTriv k hc j hWj m), fun m => ?_, fun m => ?_⟩
  · change (gluedTriv k hc j hWj).symm
      ((↑v⁻¹ : Γ(X, W)) * gluedTriv k hc j hWj (gluedQsmul k U g hWV r m)) = m
    rw [gluedTriv_gluedQsmul k U g hc hWV hWj r m, ← hv, Units.inv_mul_cancel_left,
      LinearEquiv.symm_apply_apply]
  · change gluedQsmul k U g hWV r
      ((gluedTriv k hc j hWj).symm ((↑v⁻¹ : Γ(X, W)) * gluedTriv k hc j hWj m)) = m
    apply (gluedTriv k hc j hWj).injective
    rw [gluedTriv_gluedQsmul k U g hc hWV hWj, LinearEquiv.apply_symm_apply, ← hv,
      Units.mul_inv_cancel_left]