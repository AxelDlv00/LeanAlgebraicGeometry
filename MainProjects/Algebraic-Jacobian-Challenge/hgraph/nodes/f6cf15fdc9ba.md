---
author: sync
content_type: theorem
created: '2026-07-29T05:21:16'
decl: AlgebraicGeometry.finrank_cotangentSpace_eq_of_ringEquiv
docstring: '**The cotangent dimension is a ring-isomorphism invariant.**


  `spanFinrank_maximalIdeal_eq_of_ringEquiv` in cotangent currency, via Nakayama

  (`IsLocalRing.spanFinrank_maximalIdeal_eq_finrank_cotangentSpace`), which is where
  the

  Noetherian hypothesis enters.'
file: AlgebraicJacobian/Picard/GroupSchemeHomogeneity.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.finrank_cotangentSpace_eq_of_ringEquiv
type: lean
updated: '2026-07-29T05:21:16'
---
theorem finrank_cotangentSpace_eq_of_ringEquiv
    {A B : Type u} [CommRing A] [CommRing B] [IsLocalRing A] [IsLocalRing B]
    [IsNoetherianRing A] [IsNoetherianRing B] (e : A ≃+* B) :
    Module.finrank (IsLocalRing.ResidueField A) (IsLocalRing.CotangentSpace A)
      = Module.finrank (IsLocalRing.ResidueField B) (IsLocalRing.CotangentSpace B) := by
  rw [← IsLocalRing.spanFinrank_maximalIdeal_eq_finrank_cotangentSpace,
    ← IsLocalRing.spanFinrank_maximalIdeal_eq_finrank_cotangentSpace]
  exact spanFinrank_maximalIdeal_eq_of_ringEquiv e