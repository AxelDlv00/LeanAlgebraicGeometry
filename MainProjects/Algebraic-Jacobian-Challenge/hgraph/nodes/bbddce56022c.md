---
author: sync
content_type: theorem
created: '2026-07-30T16:21:12'
decl: AlgebraicGeometry.Scheme.PicScheme.twistMor_mul
docstring: 'The canonical twist morphisms satisfy the Galois group law in the slice.

  The product-twist comparison is the only bookkeeping map in the formula.'
file: AlgebraicJacobian/Picard/GaloisDescent/PicEtGaloisAction.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.twistMor_mul
type: lean
updated: '2026-07-30T16:21:12'
---
theorem twistMor_mul (γ τ : k' ≃ₐ[k] k') :
    twistMor C rep (γ * τ) =
      (twistTestFunctor_mulIso (k := k) γ τ).hom.app X' ≫
        (twistTestFunctor (k := k) γ).map (twistMor C rep τ) ≫
        twistMor C rep γ := by
  apply rep.homEquiv.injective
  rw [homEquiv_twistMor, rep.homEquiv_comp, rep.homEquiv_comp,
    homEquiv_twistMor]
  change _ = (picEt (Scheme.baseChangeField C k')).map
    ((twistTestFunctor_mulIso (k := k) γ τ).hom.app X').op
      (((twistTestFunctor (k := k) γ).op ⋙
        picEt (Scheme.baseChangeField C k')).map (twistMor C rep τ).op
          ((galoisActionPicEt C γ).inv.app (Opposite.op X')
            (rep.homEquiv (𝟙 X'))))
  rw [← NatTrans.naturality_apply (galoisActionPicEt C γ).inv
    (twistMor C rep τ).op (rep.homEquiv (𝟙 X'))]
  rw [← rep.homEquiv_eq, homEquiv_twistMor]
  exact galoisActionPicEt_mul_inv_app C γ τ X' (rep.homEquiv (𝟙 X'))