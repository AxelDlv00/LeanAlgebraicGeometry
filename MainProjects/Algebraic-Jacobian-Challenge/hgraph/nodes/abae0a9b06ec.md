---
author: sync
content_type: definition
created: '2026-07-29T04:25:58'
decl: AlgebraicGeometry.twistedPerSigmaTarget
docstring: 'The per-σ isomorphisms of the twisted leaf, as a target family for

  `sigmaAssembledComponent` — `twisted_cech_nerve_per_sigma` read as data.  Witnesses
  that the

  abstract σ-calculus above applies to the real base-change situation and is not vacuous.


  Note the target: `coverInterOpen 𝒰'' σ` for a tuple `σ` into `𝒰.I₀`, with **no transport**,
  which

  typechecks by `baseChangedCover_I₀`.'
file: AlgebraicJacobian/Cohomology/CechHigherDirectImageUnconditional.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.twistedPerSigmaTarget
type: lean
updated: '2026-07-29T04:25:58'
---
noncomputable def twistedPerSigmaTarget
    (f : X ⟶ S) (g : S' ⟶ S) (f' : X' ⟶ S') (g' : X' ⟶ X)
    (h : IsPullback g' f' f g) (𝒰 : X.OpenCover) [IsSeparated f] [IsAffine S]
    [∀ i, IsAffine (𝒰.X i)] (F : X.Modules) (hF : F.IsQuasicoherent) (n : ℕ) :
    ∀ σ : Fin (n + 1) → 𝒰.I₀, (Scheme.Modules.pullback g').obj
        (pushPullObj F (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ))))
      ≅ pushPullObj ((Scheme.Modules.pullback g').obj F)
          (Over.mk (Scheme.Opens.ι (coverInterOpen
            ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso
              h.isoPullback.symm.hom) σ))) :=
  fun σ => twisted_cech_nerve_per_sigma f g f' g' h 𝒰 F hF σ