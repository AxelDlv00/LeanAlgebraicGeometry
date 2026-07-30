---
author: sync
content_type: definition
created: '2026-07-30T12:49:24'
decl: AlgebraicGeometry.IndexSeparated
docstring: '**Index separation, at tests that have a point**: two charts with different
  indices never

  take the same value on a *nonempty* test.


  The nonemptiness restriction is what makes this a hypothesis about `f` rather than
  about `ι`:

  without it the condition collapses to `Subsingleton ι`

  (`indexSeparatedAll_iff_subsingleton`), and with it an overlapping family genuinely
  refutes it

  (`not_indexSeparated_duplicated`).  It is also exactly the form the coverage argument
  consumes,

  since the test the argument produces contains the point it started from.


  This is the half of joint injectivity that has no one-chart counterpart, and the
  content of the

  gap between the one-chart no-go and the multi-index case.'
file: AlgebraicJacobian/Picard/Pic0ChartMultiIndexInterval.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.IndexSeparated
type: lean
updated: '2026-07-30T13:25:27'
---
def IndexSeparated {ι : Type u} {X : ι → Scheme.{u}}
    (f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1) : Prop :=
  ∀ (S : Scheme.{u}) (_ : Nonempty S) (i j : ι) (x : (yoneda.obj (X i)).obj (op S))
    (y : (yoneda.obj (X j)).obj (op S)),
    (f i).app (op S) x = (f j).app (op S) y → i = j

variable (C) in