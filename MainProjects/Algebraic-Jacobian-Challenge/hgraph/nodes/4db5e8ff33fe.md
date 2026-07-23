---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.coverInterOpen_baseChange_restrictedMap
docstring: 'The restriction of `g''` over the intersection open: `V''_σ ⟶ V_σ`.'
file: AlgebraicJacobian/Cohomology/CechHigherDirectImageUnconditional.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.coverInterOpen_baseChange_restrictedMap
type: lean
updated: '2026-07-24T03:02:09'
---
noncomputable def coverInterOpen_baseChange_restrictedMap
    (f : X ⟶ S) (g : S' ⟶ S) (f' : X' ⟶ S') (g' : X' ⟶ X)
    (h : IsPullback g' f' f g) (𝒰 : X.OpenCover)
    {κ : Type} [Finite κ] (σ : κ → 𝒰.I₀) :
    (↑(coverInterOpen ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso
        h.isoPullback.symm.hom) σ) : Scheme.{u}) ⟶
      ↑(coverInterOpen 𝒰 σ) :=
  (coverInterOpen_baseChange_sliceIso f g f' g' h 𝒰 σ).inv ≫
    pullback.snd g' (Scheme.Opens.ι (coverInterOpen 𝒰 σ))