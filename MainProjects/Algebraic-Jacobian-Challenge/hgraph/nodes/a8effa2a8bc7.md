---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.homEquiv_comp_pushforwardCongr
docstring: '**Congruence-cast transpose**: postcomposing a transpose along `e` with
  the

  `pushforwardCongr` cast of an equality `e = e''` is the transpose along `e''` of
  the

  `pullbackCongr`-reindexed morphism. Generic `subst` lemma. Project-local.'
file: AlgebraicJacobian/Picard/GlueDescent.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.homEquiv_comp_pushforwardCongr
type: lean
updated: '2026-07-16T21:14:27'
---
lemma homEquiv_comp_pushforwardCongr {V X : Scheme.{u}} {e e' : V ⟶ X} (h : e = e')
    {W : X.Modules} {N : V.Modules} (y : (Scheme.Modules.pullback e).obj W ⟶ N) :
    (Scheme.Modules.pullbackPushforwardAdjunction e).homEquiv W N y ≫
        (Scheme.Modules.pushforwardCongr h).hom.app N
      = (Scheme.Modules.pullbackPushforwardAdjunction e').homEquiv W N
          ((Scheme.Modules.pullbackCongr h).inv.app W ≫ y) := by
  subst h
  have h1 : (Scheme.Modules.pushforwardCongr (rfl : e = e)).hom.app N = 𝟙 _ := by
    ext U
    simp
  have h2 : (Scheme.Modules.pullbackCongr (rfl : e = e)).inv.app W = 𝟙 _ := by
    simp [Scheme.Modules.pullbackCongr]
  rw [h1, h2, Category.comp_id, Category.id_comp]