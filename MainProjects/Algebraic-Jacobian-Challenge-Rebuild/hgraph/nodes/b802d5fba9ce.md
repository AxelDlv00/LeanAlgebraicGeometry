---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Scheme.Hom.isIso_appLE_of_le_opensRange
docstring: 'For an open immersion `w` and an open `V` inside its image, pullback of
  sections is

  an isomorphism onto the sections of the preimage.'
file: AlgebraicJacobian/Picard/OpenImmersionUnits.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.Hom.isIso_appLE_of_le_opensRange
type: lean
updated: '2026-07-29T15:26:32'
---
theorem isIso_appLE_of_le_opensRange {V : Y.Opens} (hV : V ≤ w.opensRange) :
    IsIso (w.appLE V (w ⁻¹ᵁ V) le_rfl) := by
  have h : w.appLE V (w ⁻¹ᵁ V) le_rfl = w.app V := Scheme.Hom.appLE_eq_app w
  rw [h]
  exact w.isIso_app V hV