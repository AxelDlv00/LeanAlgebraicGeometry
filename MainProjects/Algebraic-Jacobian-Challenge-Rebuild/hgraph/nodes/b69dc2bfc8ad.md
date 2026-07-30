---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Scheme.Hom.unitsRestrict_unitsPreimageEquiv_symm
docstring: The inverse transport commutes with restriction on the base.
file: AlgebraicJacobian/Picard/OpenImmersionUnits.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.Hom.unitsRestrict_unitsPreimageEquiv_symm
type: lean
updated: '2026-07-30T15:28:03'
---
lemma unitsRestrict_unitsPreimageEquiv_symm {V V' : Y.Opens} (hV : V ≤ w.opensRange)
    (h : V' ≤ V) (v : Γ(Z, w ⁻¹ᵁ V)ˣ) :
    Y.unitsRestrict h ((unitsPreimageEquiv w hV).symm v)
      = (unitsPreimageEquiv w (h.trans hV)).symm
          (Z.unitsRestrict (w.preimage_mono h) v) := by
  apply (unitsPreimageEquiv w (h.trans hV)).injective
  rw [(unitsPreimageEquiv w (h.trans hV)).apply_symm_apply,
    unitsPreimageEquiv_apply]
  have h₁ := w.map_unitsAppLE (le_rfl : w ⁻¹ᵁ V' ≤ w ⁻¹ᵁ V') (homOfLE h).op
    ((unitsPreimageEquiv w hV).symm v)
  rw [unitsAppLE_unitsPreimageEquiv_symm w hV
    ((le_rfl : w ⁻¹ᵁ V' ≤ w ⁻¹ᵁ V').trans
      ((TopologicalSpace.Opens.map w.base).map (homOfLE h)).le) v] at h₁
  exact h₁