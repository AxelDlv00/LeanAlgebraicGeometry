---
author: sync
content_type: theorem
created: '2026-07-29T07:08:52'
decl: AlgebraicGeometry.bcNerve_drop_δ_sigma
docstring: '**The target-side σ-decomposition of the base-changed nerve''s coface.**

  `cechNerve_drop_δ_sigma` at the base-changed cover `𝒰''` and the base-changed module
  `g''^*F`,

  with the index type silently `𝒰.I₀` (`baseChangedCover_I₀`, `rfl`).


  Read it as: `sigma_iso(𝒰'',n) ≫ π_{σ''∘δᵏ} ≫ restrict = nerve''.δ k ≫ sigma_iso(𝒰'',n+1)
  ≫ π_{σ''}` —

  so post-composing with `(pushPull_sigma_iso 𝒰'' _ n).symm` turns the `Pi.lift` produced
  by

  `sigmaAssembled_δ_square` into the nerve''s own coface.  Project-local.'
file: AlgebraicJacobian/Cohomology/CechHigherDirectImageUnconditional.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.bcNerve_drop_δ_sigma
type: lean
updated: '2026-07-29T07:08:52'
---
theorem bcNerve_drop_δ_sigma (f : X ⟶ S) (g : S' ⟶ S) (f' : X' ⟶ S') (g' : X' ⟶ X)
    (h : IsPullback g' f' f g) (𝒰 : X.OpenCover)
    [Finite (bcCover f g f' g' h 𝒰).I₀] (F : X.Modules) (n : ℕ) (k : Fin (n + 2))
    (σ' : Fin (n + 2) → 𝒰.I₀) :
    (pushPull_sigma_iso (bcCover f g f' g' h 𝒰) ((Scheme.Modules.pullback g').obj F) n).hom ≫
        Pi.π (fun τ : Fin (n + 1) → 𝒰.I₀ =>
          pushPullObj ((Scheme.Modules.pullback g').obj F)
            (Over.mk (Scheme.Opens.ι (coverInterOpen (bcCover f g f' g' h 𝒰) τ))))
          (σ' ∘ (SimplexCategory.δ k).toOrderHom) ≫
        pushPullMap ((Scheme.Modules.pullback g').obj F)
          (interLegHom (bcCover f g f' g' h 𝒰) σ' k)
      = (CosimplicialObject.Augmented.drop.obj
            (CechNerve (bcCover f g f' g' h 𝒰) ((Scheme.Modules.pullback g').obj F))).δ k ≫
          (pushPull_sigma_iso (bcCover f g f' g' h 𝒰)
            ((Scheme.Modules.pullback g').obj F) (n + 1)).hom ≫
          Pi.π (fun τ : Fin (n + 2) → 𝒰.I₀ =>
            pushPullObj ((Scheme.Modules.pullback g').obj F)
              (Over.mk (Scheme.Opens.ι (coverInterOpen (bcCover f g f' g' h 𝒰) τ)))) σ' :=
  cechNerve_drop_δ_sigma (bcCover f g f' g' h 𝒰)
    ((Scheme.Modules.pullback g').obj F) n k σ'