---
author: sync
content_type: theorem
created: '2026-07-29T04:25:58'
decl: AlgebraicGeometry.cechNerve_drop_δ_sigma
docstring: '`cechNerve_backbone_δ_sigma`, with the geometric coface replaced by the
  nerve''s own `δ`.


  Split from it because `CosimplicialObject C` and `SimplexCategory ⥤ C` are `rfl`-equal
  spellings

  that make `rw` report a motive failure ("not type-correct under `instances` transparency")
  when the

  coface is rewritten inside the σ-projection composite — the geometric statement
  carries no

  cosimplicial vocabulary, so it has no such boundary.'
file: AlgebraicJacobian/Cohomology/CechHigherDirectImageUnconditional.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.cechNerve_drop_δ_sigma
type: lean
updated: '2026-07-29T04:25:58'
---
theorem cechNerve_drop_δ_sigma (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (F : X.Modules) (p : ℕ)
    (k : Fin (p + 2)) (σ' : Fin (p + 2) → 𝒰.I₀) :
    (pushPull_sigma_iso 𝒰 F p).hom ≫
        Pi.π (fun τ : Fin (p + 1) → 𝒰.I₀ =>
          pushPullObj F (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 τ))))
          (σ' ∘ (SimplexCategory.δ k).toOrderHom) ≫
        pushPullMap F (interLegHom 𝒰 σ' k)
      = (CosimplicialObject.Augmented.drop.obj (CechNerve 𝒰 F)).δ k ≫
          (pushPull_sigma_iso 𝒰 F (p + 1)).hom ≫
          Pi.π (fun τ : Fin (p + 2) → 𝒰.I₀ =>
            pushPullObj F (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 τ)))) σ' :=
  (cechNerve_backbone_δ_sigma 𝒰 F p k σ').trans
    (congrArg (fun m => m ≫ (pushPull_sigma_iso 𝒰 F (p + 1)).hom ≫
      Pi.π (fun τ : Fin (p + 2) → 𝒰.I₀ =>
        pushPullObj F (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 τ)))) σ')
      (cechNerve_drop_δ 𝒰 F k).symm)

/-- **The base-changed nerve is the nerve of the base-changed data** (Stacks 02KG, the
mechanical half). Applying `(g')^*` (at the `X`-level) to the dropped Čech nerve of
`(𝒰, F)` yields the dropped Čech nerve of the base-changed data `(𝒰', (g')^* F)`, where
`𝒰' = (openCoverOfLeft 𝒰 f g).pushforwardIso h.isoPullback.symm.hom` is the base change of
`𝒰` along `g'`:
```
  g'^* ∘ drop(nerve 𝒰 F)  ≅  drop(nerve 𝒰' (g'^* F)).
```
The geometric backbone `coverCechNerve` of `𝒰` base-changes to that of `𝒰'`: the fibre
powers `U_{i₀} ×_X ⋯ ×_X U_{iₚ}` commute with the base change `g'` (pullback preserves fibre
products), so the preimages `(g')⁻¹(U_{i₀…iₚ})` are exactly the corresponding intersections
of `𝒰'`. The pullback then commutes with the push–pull functor `pushPullFunctor` termwise —
itself a Beck–Chevalley identification `g'^* (p_* p^* F) ≅ p'_* p'^* (g'^* F)` for the
restricted cartesian square — and the identifications are compatible with the cosimplicial