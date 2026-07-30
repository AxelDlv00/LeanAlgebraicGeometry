---
author: sync
content_type: theorem
created: '2026-07-30T16:21:12'
decl: AlgebraicGeometry.Scheme.PicScheme.galoisActionRestricted_one_inv_app
docstring: 'The inverse restricted action at the identity is induced by the canonical

  identity-twist comparison.'
file: AlgebraicJacobian/Picard/GaloisDescent/PicEtGaloisAction.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.galoisActionRestricted_one_inv_app
type: lean
updated: '2026-07-30T16:21:12'
---
theorem galoisActionRestricted_one_inv_app
    (T : Over (Spec (CommRingCat.of k')))
    (x : ((restrictTest k k').op ⋙ picEt C).obj (Opposite.op T)) :
    (galoisActionRestricted C (1 : k' ≃ₐ[k] k')).inv.app (Opposite.op T) x =
      (((restrictTest k k').op ⋙ picEt C).map
        ((twistTestFunctor_oneIso (k := k) (k' := k')).hom.app T).op) x := by
  rw [galoisActionRestricted_inv_app,
    restrictTest_twistTestFunctor_iso_one_hom_app]
  rfl