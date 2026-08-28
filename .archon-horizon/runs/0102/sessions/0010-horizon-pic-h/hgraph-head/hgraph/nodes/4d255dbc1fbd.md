---
author: sync
content_type: lemma
created: '2026-07-19T15:31:13'
decl: AlgebraicGeometry.top_le_preimage_of_closedPoint_mem
docstring: 'A morphism from the spectrum of a field lands inside any open containing
  the image

  of the closed point.'
file: AlgebraicJacobian/Curve/SepPointsDenseKit.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.top_le_preimage_of_closedPoint_mem
type: lean
updated: '2026-08-01T09:44:10'
---
lemma top_le_preimage_of_closedPoint_mem {K : Type u} [Field K] {X : Scheme.{u}}
    (p : Spec (.of K) ⟶ X) {U : X.Opens}
    (hmem : p.base (IsLocalRing.closedPoint K) ∈ U) : ⊤ ≤ p ⁻¹ᵁ U := by
  intro y _
  have hy : y = (IsLocalRing.closedPoint K) := Subsingleton.elim _ _
  subst hy
  exact hmem