---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.coverInterProdIso
docstring: 'The slice-product of the cover legs over a multi-index `σ` is the intersection
  open

  `coverInterOpen 𝒰 σ`, as objects of `Over X`: combine `widePullback_overX_eq_prod`
  (slice product =

  wide fibre power) with `widePullback_openImm_inter` (wide fibre power of open immersions
  =

  intersection open).  Project-local σ-component of the Stub-1 backbone decomposition.'
file: AlgebraicJacobian/Cohomology/CechSectionIdentificationBase.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.coverInterProdIso
type: lean
updated: '2026-07-24T03:02:09'
---
noncomputable def coverInterProdIso (𝒰 : X.OpenCover) {p : ℕ} (σ : Fin (p + 1) → 𝒰.I₀) :
    (∏ᶜ fun k : Fin (p + 1) => Over.mk (𝒰.f (σ k))) ≅
    Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ)) := by
  refine (widePullback_overX_eq_prod (fun k : Fin (p + 1) => 𝒰.f (σ k))).symm ≪≫
    Over.isoMk (widePullback_openImm_inter (fun k : Fin (p + 1) => 𝒰.f (σ k))) ?_
  exact IsOpenImmersion.lift_fac (Scheme.Opens.ι (coverInterOpen 𝒰 σ))
    (WidePullback.base (fun k : Fin (p + 1) => 𝒰.f (σ k))) _