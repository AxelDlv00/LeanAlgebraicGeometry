---
author: sync
content_type: definition
created: '2026-07-30T12:49:24'
decl: AlgebraicGeometry.JointlyInjective
docstring: '**Joint injectivity of a chart family**: over every test, the disjoint
  union of the chart

  sources injects into the Σ-sheaf.


  For a one-element family this is per-test injectivity of the single chart map; for
  a general

  family it is strictly stronger (`jointlyInjective_iff`, `not_indexSeparated_duplicated`),
  and it

  is exactly the statement the multi-index coverage argument refutes.'
file: AlgebraicJacobian/Picard/Pic0ChartMultiIndexInterval.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.JointlyInjective
type: lean
updated: '2026-07-30T12:49:24'
---
def JointlyInjective {ι : Type u} {X : ι → Scheme.{u}}
    (f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1) : Prop :=
  ∀ (S : Scheme.{u}ᵒᵖ) (i j : ι) (x : (yoneda.obj (X i)).obj S)
    (y : (yoneda.obj (X j)).obj S),
    (f i).app S x = (f j).app S y →
      (⟨i, x⟩ : Σ i, (yoneda.obj (X i)).obj S) = ⟨j, y⟩

variable (C) in