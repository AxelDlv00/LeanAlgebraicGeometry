---
author: sync
content_type: theorem
created: '2026-07-29T04:25:58'
decl: AlgebraicGeometry.sigmaAssembled_δ_square
docstring: '**The coface square for the assembled components, from the per-σ compatibility
  alone.**


  This is the reduction, stated over an abstract target cover.  The hypothesis `hcompat`
  is

  "base-change-then-restrict = restrict-then-base-change" for the intersection-open
  inclusions; the

  conclusion is that the assembled degreewise components commute with the two Čech
  cofaces, after the

  target-side σ-decomposition.


  Why `Pi.hom_ext` fires here and did not for the original `NatIso.ofComponents` obligation:
  the

  earlier diagnosis was that the σ-decomposition sits mid-chain behind pushforward/pullback

  applications, so the projections cannot be pushed through.  With `cechNerve_drop_δ_sigma`
  the coface

  *is* reindex-then-restrict in σ-coordinates, so both sides reduce to per-σ'' statements
  and `hcompat`

  closes each.'
file: AlgebraicJacobian/Cohomology/CechHigherDirectImageUnconditional.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.sigmaAssembled_δ_square
type: lean
updated: '2026-07-29T04:25:58'
---
theorem sigmaAssembled_δ_square (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (F : X.Modules) (n : ℕ)
    (T : (Fin (n + 1) → 𝒰.I₀) → Y.Modules) (T' : (Fin (n + 2) → 𝒰.I₀) → Y.Modules)
    (e : ∀ σ, (Scheme.Modules.pullback q).obj
        (pushPullObj F (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ)))) ≅ T σ)
    (e' : ∀ σ, (Scheme.Modules.pullback q).obj
        (pushPullObj F (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ)))) ≅ T' σ)
    (k : Fin (n + 2))
    -- the target-side restriction maps, indexed by the top tuple
    (r : ∀ σ' : Fin (n + 2) → 𝒰.I₀, T (σ' ∘ (SimplexCategory.δ k).toOrderHom) ⟶ T' σ')
    (hcompat : ∀ σ' : Fin (n + 2) → 𝒰.I₀,
      (e (σ' ∘ (SimplexCategory.δ k).toOrderHom)).hom ≫ r σ'
        = (Scheme.Modules.pullback q).map (pushPullMap F (interLegHom 𝒰 σ' k)) ≫ (e' σ').hom) :
    (sigmaAssembledComponent q 𝒰 F n T e).hom ≫
        Limits.Pi.lift (fun σ' : Fin (n + 2) → 𝒰.I₀ =>
          Limits.Pi.π T (σ' ∘ (SimplexCategory.δ k).toOrderHom) ≫ r σ')
      = (Scheme.Modules.pullback q).map
            (pushPullMap F ((coverCechNerveOver 𝒰).map ((SimplexCategory.δ k).op))) ≫
          (sigmaAssembledComponent q 𝒰 F (n + 1) T' e').hom := by
  -- Compare σ'-projections of the target product.
  refine Limits.Pi.hom_ext _ _ (fun σ' => ?_)
  rw [Category.assoc, Limits.Pi.lift_π]
  -- LHS: the σ'-leg is "project at the OMITTED tuple, then restrict"; feed it to `hcompat`.
  rw [← Category.assoc, sigmaAssembledComponent_π, Category.assoc, hcompat σ']
  -- RHS: project the assembled component at σ', then the σ-coordinate coface formula closes it.
  rw [Category.assoc, sigmaAssembledComponent_π, ← Category.assoc, ← Functor.map_comp,
    ← Category.assoc, ← Functor.map_comp, ← cechNerve_backbone_δ_sigma 𝒰 F n k σ',
    Category.assoc]