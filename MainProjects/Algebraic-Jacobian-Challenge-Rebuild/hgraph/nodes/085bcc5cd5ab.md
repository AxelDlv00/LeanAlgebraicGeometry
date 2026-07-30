---
author: sync
content_type: definition
created: '2026-07-30T12:49:24'
decl: AlgebraicGeometry.JointlyInjective
docstring: '**Joint injectivity of a chart family**: over every nonempty test, the
  disjoint union of the

  chart sources injects into the Σ-sheaf.


  For a one-element family this is per-test injectivity of the single chart map; for
  a general

  family it is strictly stronger (`jointlyInjective_iff`, `not_indexSeparated_duplicated`),
  and it

  is exactly the statement the multi-index coverage argument refutes.


  Restricted to nonempty tests for the same reason as `IndexSeparated`: at an empty
  test the

  Σ-sheaf is a subsingleton, so the unrestricted version would carry `Subsingleton
  ι` as a free

  consequence and say nothing about `f`.'
file: AlgebraicJacobian/Picard/Pic0ChartMultiIndexInterval.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.JointlyInjective
type: lean
updated: '2026-07-30T15:46:05'
---
def JointlyInjective {ι : Type u} {X : ι → Scheme.{u}}
    (f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1) : Prop :=
  ∀ (S : Scheme.{u}) (_ : Nonempty S) (i j : ι) (x : (yoneda.obj (X i)).obj (op S))
    (y : (yoneda.obj (X j)).obj (op S)),
    (f i).app (op S) x = (f j).app (op S) y →
      (⟨i, x⟩ : Σ i, (yoneda.obj (X i)).obj (op S)) = ⟨j, y⟩