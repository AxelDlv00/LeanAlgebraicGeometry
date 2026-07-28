---
author: sync
content_type: definition
created: '2026-07-29T04:25:58'
decl: AlgebraicGeometry.sigmaAssembledComponent
docstring: 'The degreewise component of a twisted-nerve-style identification, assembled
  from a family of

  per-σ isomorphisms and the source σ-product decomposition.


  The target is an **arbitrary** family `T` of `𝒪_Y`-modules indexed by tuples, not
  the base-changed

  cover''s push–pull objects.  Two reasons, both mechanical.  First, the real target
  cover is

  `(openCoverOfLeft 𝒰 f g).pushforwardIso h.isoPullback.symm.hom`, whose `IsIso` instance
  is keyed on

  the spelling `h.isoPullback.symm.hom`; any `rw`/`simp` normalising that to `h.isoPullback.inv`

  (`Iso.symm_hom` does) makes the goal fail to typecheck, reported as "motive is not
  type correct".

  Second — **and this half is retracted, see `baseChangedCover_I₀`** — an earlier
  revision of this

  section believed that cover''s index type agreed with `𝒰.I₀` only *propositionally*
  and threaded a

  transport `hI ▸ σ l` through every statement.  It is `rfl`, and the transport was
  the thing making

  the reindexed tuple and the tuple-then-reindexed disagree as terms.  The first reason
  stands on its

  own and is why the abstraction is kept: the real data is supplied at the application
  site, where

  nothing is rewritten.'
file: AlgebraicJacobian/Cohomology/CechHigherDirectImageUnconditional.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.sigmaAssembledComponent
type: lean
updated: '2026-07-29T05:40:30'
---
noncomputable def sigmaAssembledComponent (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (F : X.Modules) (n : ℕ) (T : (Fin (n + 1) → 𝒰.I₀) → Y.Modules)
    (e : ∀ σ, (Scheme.Modules.pullback q).obj
        (pushPullObj F (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ)))) ≅ T σ) :
    (Scheme.Modules.pullback q).obj
        (pushPullObj F ((coverCechNerveOver 𝒰).obj (Opposite.op (SimplexCategory.mk n))))
      ≅ ∏ᶜ T :=
  (Scheme.Modules.pullback q).mapIso (pushPull_sigma_iso 𝒰 F n) ≪≫
    Limits.PreservesProduct.iso (Scheme.Modules.pullback q) _ ≪≫
    Limits.Pi.mapIso e