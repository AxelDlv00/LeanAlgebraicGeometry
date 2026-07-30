---
author: sync
content_type: definition
created: '2026-07-30T12:49:24'
decl: AlgebraicGeometry.IndexSeparated
docstring: '**Index separation**: two charts with different indices never take the
  same value on a

  common test.


  This is the half of joint injectivity that has no one-chart counterpart, and the
  whole content

  of the gap between the one-chart no-go and the multi-index case.'
file: AlgebraicJacobian/Picard/Pic0ChartMultiIndexInterval.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.IndexSeparated
type: lean
updated: '2026-07-30T12:49:24'
---
def IndexSeparated {ι : Type u} {X : ι → Scheme.{u}}
    (f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1) : Prop :=
  ∀ (S : Scheme.{u}ᵒᵖ) (i j : ι) (x : (yoneda.obj (X i)).obj S)
    (y : (yoneda.obj (X j)).obj S), (f i).app S x = (f j).app S y → i = j