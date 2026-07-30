---
author: sync
content_type: definition
created: '2026-07-30T10:26:46'
decl: AlgebraicJacobian.GaloisDescent.SemilinearAction.awayAutHom
docstring: '**The `Γ`-action on a localization at an invariant element**, as a `MonoidHom`

  into `RingAut S`.


  Both laws are `IsLocalization.ringHom_ext` against `awayAut_algebraMap`: two

  automorphisms of a localization agreeing on the image of `A` are equal, and there

  they are `one_smul` and `mul_smul` of the action on `A`.'
file: AlgebraicJacobian/Picard/GaloisDescent/InvariantsLocalization.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.SemilinearAction.awayAutHom
type: lean
updated: '2026-07-30T10:26:46'
---
noncomputable def awayAutHom : (L ≃ₐ[K] L) →* RingAut S where
  toFun γ := awayAut K L N hN S γ
  map_one' := by
    apply RingEquiv.toRingHom_injective
    apply IsLocalization.ringHom_ext (Submonoid.powers N)
    ext a
    change awayAut K L N hN S 1 (algebraMap A S a) = algebraMap A S a
    rw [awayAut_algebraMap, one_smul]
  map_mul' γ τ := by
    apply RingEquiv.toRingHom_injective
    apply IsLocalization.ringHom_ext (Submonoid.powers N)
    ext a
    change awayAut K L N hN S (γ * τ) (algebraMap A S a)
        = awayAut K L N hN S γ (awayAut K L N hN S τ (algebraMap A S a))
    rw [awayAut_algebraMap, awayAut_algebraMap, awayAut_algebraMap, mul_smul]