---
author: sync
content_type: theorem
created: '2026-07-30T16:21:12'
decl: AlgebraicGeometry.Scheme.PicScheme.galoisActionRestricted_inv_app
docstring: 'The inverse action component is `picEt C` applied to the forward comparison

  between the restricted tests. This is the orientation used by `twistMor`.'
file: AlgebraicJacobian/Picard/GaloisDescent/PicEtGaloisAction.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.galoisActionRestricted_inv_app
type: lean
updated: '2026-07-30T16:21:12'
---
theorem galoisActionRestricted_inv_app (γ : k' ≃ₐ[k] k')
    (T : Over (Spec (CommRingCat.of k'))) :
    (galoisActionRestricted C γ).inv.app (Opposite.op T)
      = (picEt C).map ((restrictTest_twistTestFunctor_iso (k := k) γ).hom.app T).op := by
  change _ ≫ 𝟙 _ = _
  rw [Category.comp_id]
  rfl