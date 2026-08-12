---
author: sync
content_type: instance
created: '2026-08-12T15:42:08'
decl: AlgebraicJacobian.GaloisDescent.fieldSelfSection_isOpenImmersion
file: AlgebraicJacobian/Descent/GaloisKernelCover.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.fieldSelfSection_isOpenImmersion
type: lean
updated: '2026-08-12T15:42:08'
---
instance fieldSelfSection_isOpenImmersion (γ : k' ≃ₐ[k] k') :
    IsOpenImmersion (fieldSelfSection (k := k) (k' := k') γ) := by
  haveI : IsOpenImmersion
      (Limits.Sigma.ι (fun _ : k' ≃ₐ[k] k' => Spec (CommRingCat.of k')) γ) :=
    (AlgebraicGeometry.sigmaOpenCover
      (fun _ : k' ≃ₐ[k] k' => Spec (CommRingCat.of k'))).map_prop γ
  unfold fieldSelfSection
  infer_instance