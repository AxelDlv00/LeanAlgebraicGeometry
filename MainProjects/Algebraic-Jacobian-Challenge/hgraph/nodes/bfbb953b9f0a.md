---
author: sync
content_type: instance
created: '2026-07-31T04:59:29'
decl: AlgebraicJacobian.GaloisDescent.fieldSelfSection_isOpenImmersion
file: AlgebraicJacobian/Picard/GaloisDescent/GaloisKernelCover.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.fieldSelfSection_isOpenImmersion
type: lean
updated: '2026-07-31T06:25:52'
---
instance fieldSelfSection_isOpenImmersion (γ : k' ≃ₐ[k] k') :
    IsOpenImmersion (fieldSelfSection (k := k) (k' := k') γ) := by
  haveI : IsOpenImmersion
      (Limits.Sigma.ι (fun _ : k' ≃ₐ[k] k' => Spec (CommRingCat.of k')) γ) :=
    (AlgebraicGeometry.sigmaOpenCover
      (fun _ : k' ≃ₐ[k] k' => Spec (CommRingCat.of k'))).map_prop γ
  unfold fieldSelfSection
  infer_instance