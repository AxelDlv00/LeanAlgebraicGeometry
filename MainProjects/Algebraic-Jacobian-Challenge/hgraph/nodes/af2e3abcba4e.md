---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.pushPullObj_coverInter_baseChange_spec
docstring: '**Per-intersection-open base change over literal `Spec` bases.**  The
  assembly of the

  four sorry-free bricks over `S = Spec R`, `S'' = Spec R''`: LHS → tilde

  (`pushPullObj_coverInter_pushforward_iso_tilde`), the affine base change

  `affinePushforwardPullbackBaseChange` for the carved ring pushout

  (`coverInter_ring_isPushout`), the tensor rewrite of the base-changed sections

  (`coverInter_baseChanged_sections_tensor_rewrite`), and RHS → tilde

  (`pushPullObj_coverInter_baseChanged_pushforward_iso_tilde`).  Project-local.'
file: AlgebraicJacobian/Cohomology/CechHigherDirectImageUnconditional.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pushPullObj_coverInter_baseChange_spec
type: lean
updated: '2026-07-24T03:02:09'
---
noncomputable def pushPullObj_coverInter_baseChange_spec
    (h : IsPullback g' f' f g) [IsSeparated f] [IsSeparated f']
    (𝒰 : X.OpenCover) [∀ i, IsAffine (𝒰.X i)]
    [∀ i, IsAffine (((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso
      h.isoPullback.symm.hom).X i)]
    (F : X.Modules) (hF : F.IsQuasicoherent)
    {κ : Type} [Finite κ] [Nonempty κ] (σ : κ → 𝒰.I₀) :
    (Scheme.Modules.pullback g).obj
        ((Scheme.Modules.pushforward f).obj
          (pushPullObj F (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ))))) ≅
      (Scheme.Modules.pushforward f').obj
        ((Scheme.Modules.pullback g').obj
          (pushPullObj F (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ))))) :=
  (Scheme.Modules.pullback g).mapIso
      (pushPullObj_coverInter_pushforward_iso_tilde f 𝒰 F hF σ) ≪≫
    (Scheme.Modules.pullbackCongr (Spec.map_preimage g).symm).app _ ≪≫
    affinePushforwardPullbackBaseChange
      (Spec.preimage ((coverInterOpen_isAffine f 𝒰 σ).fromSpec ≫ f))
      (Spec.preimage g)
      (coverInterCornerRingMap f g f' g' h 𝒰 σ)
      (Spec.preimage ((coverInterOpen_isAffine f'
        ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso h.isoPullback.symm.hom)
        σ).fromSpec ≫ f'))
      (coverInter_ring_isPushout f g f' g' h 𝒰 σ)
      (moduleSpecΓFunctor.obj
        ((Scheme.Modules.pushforward (coverInterOpen_isAffine f 𝒰 σ).isoSpec.hom).obj
          ((Scheme.Modules.pullback (Scheme.Opens.ι (coverInterOpen 𝒰 σ))).obj F))) ≪≫
    (Scheme.Modules.pushforward (Spec.map (Spec.preimage ((coverInterOpen_isAffine f'
        ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso h.isoPullback.symm.hom)
        σ).fromSpec ≫ f')))).mapIso
      (pullback_spec_tilde_iso (coverInterCornerRingMap f g f' g' h 𝒰 σ) _ ≪≫
        (tilde.functor _).mapIso
          (coverInter_baseChanged_sections_tensor_rewrite f g f' g' h 𝒰 F hF σ).symm) ≪≫
    (pushPullObj_coverInter_baseChanged_pushforward_iso_tilde f g f' g' h 𝒰 F hF σ).symm

end LiteralSpec2

-- The long `≪≫`-chains of sheaf-of-modules isos here elaborate through the instance wall
-- slowly; the default heartbeat limit is not enough.
set_option maxHeartbeats 800000 in