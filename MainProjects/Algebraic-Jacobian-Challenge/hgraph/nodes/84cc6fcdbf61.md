---
author: sync
content_type: theorem
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.coverInterOpen_baseChange_eq
docstring: "**The base-changed cover intersection is the preimage of the intersection**\
  \ (Stacks 02KG;\ncarved block `lem:coverinteropen_basechange_eq`).  For the base-changed\
  \ cover\n`\U0001D4B0' = (openCoverOfLeft \U0001D4B0 f g).pushforwardIso h.isoPullback.symm.hom`\
  \ of `X' = X ×_S S'` and a\n*finite* index family `σ : κ → \U0001D4B0.I₀`, the Čech\
  \ intersection open of `\U0001D4B0'` is the `g'`-preimage of\nthe intersection open\
  \ of `\U0001D4B0`:\n```\n  coverInterOpen \U0001D4B0' σ = (g')⁻¹(coverInterOpen\
  \ \U0001D4B0 σ).\n```\nPer member `coverOpen_baseChange_eq` gives the preimage identity,\
  \ and preimage commutes with the\nfinite intersection (`coe_iInf_of_finite` + `Set.preimage_iInter`).\
  \  Finiteness of `κ` is genuinely\nneeded (the `Opens.map` frame hom preserves only\
  \ *finite* meets); the Čech use is over\n`Fin (n+1)`.  Project-local; blueprint\
  \ `lem:coverinteropen_basechange_eq`."
file: AlgebraicJacobian/Cohomology/CechHigherDirectImageUnconditional.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.coverInterOpen_baseChange_eq
type: lean
updated: '2026-07-16T21:14:26'
---
theorem coverInterOpen_baseChange_eq (f : X ⟶ S) (g : S' ⟶ S) (f' : X' ⟶ S') (g' : X' ⟶ X)
    (h : IsPullback g' f' f g) (𝒰 : X.OpenCover) {κ : Type} [Finite κ] (σ : κ → 𝒰.I₀) :
    coverInterOpen ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso h.isoPullback.symm.hom) σ
      = g' ⁻¹ᵁ coverInterOpen 𝒰 σ := by
  apply TopologicalSpace.Opens.ext
  rw [coverInterOpen, coverInterOpen, coe_iInf_of_finite, TopologicalSpace.Opens.map_coe,
    coe_iInf_of_finite, Set.preimage_iInter]
  refine Set.iInter_congr fun k => ?_
  have hk := coverOpen_baseChange_eq f g f' g' h 𝒰 (σ k)
  simp only [coverOpen]
  rw [hk, TopologicalSpace.Opens.map_coe]