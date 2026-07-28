---
author: sync
content_type: theorem
created: '2026-07-28T20:09:16'
decl: AlgebraicGeometry.isQuasicoherent_pi_of_isAffine
docstring: '**Quasi-coherence is closed under finite products over an ABSTRACT affine
  base.**  The

  `isoSpec`-conjugated form of `isQuasicoherent_pi_of_isAffineBase`, which is stated
  over a literal

  `Spec R` while the Čech consumer carries `[IsAffine S]` with `S` abstract.


  Pushforward along the *iso* `S.isoSpec` is an equivalence, so it carries the product
  to the

  product (`PreservesProduct.iso`) and moves quasi-coherence in both directions

  (`pushforward_iso_preserves_qcoh`, `Cohomology/OpenImmersionPushforward.lean`).  Project-local.'
file: AlgebraicJacobian/Cohomology/CechHigherDirectImageUnconditional.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.isQuasicoherent_pi_of_isAffine
type: lean
updated: '2026-07-28T20:09:16'
---
theorem isQuasicoherent_pi_of_isAffine {B : Scheme.{u}} [IsAffine B] {J : Type u} [Finite J]
    (A : J → B.Modules) (hA : ∀ j, (A j).IsQuasicoherent) : (∏ᶜ A).IsQuasicoherent := by
  haveI : Fintype J := Fintype.ofFinite J
  have hA' : ∀ j, ((Scheme.Modules.pushforward B.isoSpec.hom).obj (A j)).IsQuasicoherent :=
    fun j => pushforward_iso_preserves_qcoh B.isoSpec (A j) (hA j)
  have hprod : (∏ᶜ fun j => (Scheme.Modules.pushforward B.isoSpec.hom).obj (A j)
      ).IsQuasicoherent :=
    isQuasicoherent_pi_of_isAffineBase _ hA'
  haveI : (Scheme.Modules.pushforward B.isoSpec.hom).IsEquivalence :=
    (Scheme.Modules.pushforwardEquivOfIso B.isoSpec).isEquivalence_functor
  have hback : ((Scheme.Modules.pushforward B.isoSpec.hom).obj (∏ᶜ A)).IsQuasicoherent :=
    (SheafOfModules.isQuasicoherent.{u} (Spec Γ(B, ⊤)).ringCatSheaf).prop_of_iso
      (Limits.PreservesProduct.iso (Scheme.Modules.pushforward B.isoSpec.hom) A).symm hprod
  refine (SheafOfModules.isQuasicoherent.{u} B.ringCatSheaf).prop_of_iso ?_
    (pushforward_iso_preserves_qcoh B.isoSpec.symm _ hback)
  exact ((Scheme.Modules.pushforwardComp B.isoSpec.hom B.isoSpec.inv).app _) ≪≫
    (Scheme.Modules.pushforwardCongr B.isoSpec.hom_inv_id).app _ ≪≫
    (Scheme.Modules.pushforwardId B).app _