---
author: sync
content_type: definition
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.appLEAlgEquiv
docstring: 'The section-ring isomorphism of an open immersion of tests: pullback of
  sections

  from an open inside the range onto its preimage, as a `k`-algebra isomorphism.'
file: AlgebraicJacobian/Picard/PicEtCoverBridge.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Over.appLEAlgEquiv
type: lean
updated: '2026-07-30T15:28:05'
---
noncomputable def appLEAlgEquiv {T T' : Over (Spec (.of k))} (f : T' ⟶ T)
    [IsOpenImmersion f.left] (V : T.left.Opens) (hV : V ≤ f.left.opensRange) :
    Γ(T.left, V) ≃ₐ[k] Γ(T'.left, f.left ⁻¹ᵁ V) :=
  AlgEquiv.ofBijective (appLEAlgHom f V (f.left ⁻¹ᵁ V) le_rfl)
    (bijective_appLEAlgHom f V (f.left ⁻¹ᵁ V) le_rfl hV le_rfl)