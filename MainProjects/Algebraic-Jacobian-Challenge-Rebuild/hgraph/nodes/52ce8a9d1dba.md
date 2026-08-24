---
author: sync
content_type: definition
created: '2026-07-20T18:31:58'
decl: AlgebraicGeometry.universalMulSourceBaseChangeHom
docstring: 'The forward tensor map from the finite product source to its component

  fibres.  We use the linear map rather than the full equivalence so the

  component formula does not carry an unnecessary inverse proof.'
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivMulSpanFibre.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.universalMulSourceBaseChangeHom
type: lean
updated: '2026-07-20T20:01:54'
---
noncomputable def universalMulSourceBaseChangeHom
    (K : Type u) [CommRing K] [Algebra RZ K] [Algebra k K]
      [IsScalarTower k RZ K] :
    K ⊗[RZ] universalMulSource hπ g r₁ r₂ b₁ b₂ i j →ₗ[K]
      Fin (Module.finrank k HS) → (K ⊗[RZ] K₁) :=
  by
    change K ⊗[RZ] (Fin (Module.finrank k HS) → K₁) →ₗ[K]
      Fin (Module.finrank k HS) → (K ⊗[RZ] K₁)
    exact TensorProduct.piRightHom RZ K K (fun _ : Fin (Module.finrank k HS) => K₁)