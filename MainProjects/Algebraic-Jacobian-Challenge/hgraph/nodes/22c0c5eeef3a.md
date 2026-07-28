---
author: sync
content_type: theorem
created: '2026-07-29T04:25:58'
decl: AlgebraicGeometry.twistedNerve_δ_square_concrete
docstring: '**The twisted leaf''s coface square at the ACTUAL base-change data**,
  with the target family and

  the target-side restriction both the real ones — not abstract placeholders.


  The restriction is `pushPullMap (g''^*F) (interLegHom 𝒰'' σ'' k)`, i.e. exactly
  the base-changed

  intersection-open inclusion, and the target is `twistedPerSigmaTarget`.  The remaining
  hypothesis is

  `TwistedPerSigmaDeltaCompat` in a per-degree form.  So the twisted leaf''s coface
  obligation is fully

  reduced: no product, no nerve, no cosimplicial vocabulary and no abstraction left
  in it — only the

  commutation of the per-σ Beck–Chevalley isomorphisms with the intersection-open
  inclusions.

  Project-local.'
file: AlgebraicJacobian/Cohomology/CechHigherDirectImageUnconditional.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.twistedNerve_δ_square_concrete
type: lean
updated: '2026-07-29T04:25:58'
---
theorem twistedNerve_δ_square_concrete
    (f : X ⟶ S) (g : S' ⟶ S) (f' : X' ⟶ S') (g' : X' ⟶ X)
    (h : IsPullback g' f' f g) (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    [IsSeparated f] [IsAffine S] [∀ i, IsAffine (𝒰.X i)]
    (F : X.Modules) (hF : F.IsQuasicoherent) (n : ℕ) (k : Fin (n + 2))
    (hcompat : ∀ σ' : Fin (n + 2) → 𝒰.I₀,
      (twistedPerSigmaTarget f g f' g' h 𝒰 F hF n
            (σ' ∘ (SimplexCategory.δ k).toOrderHom)).hom ≫
          pushPullMap ((Scheme.Modules.pullback g').obj F)
            (interLegHom ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso
              h.isoPullback.symm.hom) σ' k)
        = (Scheme.Modules.pullback g').map (pushPullMap F (interLegHom 𝒰 σ' k)) ≫
            (twistedPerSigmaTarget f g f' g' h 𝒰 F hF (n + 1) σ').hom) :
    (sigmaAssembledComponent g' 𝒰 F n _ (twistedPerSigmaTarget f g f' g' h 𝒰 F hF n)).hom ≫
        Limits.Pi.lift (fun σ' : Fin (n + 2) → 𝒰.I₀ =>
          Limits.Pi.π _ (σ' ∘ (SimplexCategory.δ k).toOrderHom) ≫
            pushPullMap ((Scheme.Modules.pullback g').obj F)
              (interLegHom ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso
                h.isoPullback.symm.hom) σ' k))
      = (Scheme.Modules.pullback g').map
            (pushPullMap F ((coverCechNerveOver 𝒰).map ((SimplexCategory.δ k).op))) ≫
          (sigmaAssembledComponent g' 𝒰 F (n + 1) _
            (twistedPerSigmaTarget f g f' g' h 𝒰 F hF (n + 1))).hom :=
  sigmaAssembled_δ_square g' 𝒰 F n _ _
    (twistedPerSigmaTarget f g f' g' h 𝒰 F hF n)
    (twistedPerSigmaTarget f g f' g' h 𝒰 F hF (n + 1)) k _ hcompat