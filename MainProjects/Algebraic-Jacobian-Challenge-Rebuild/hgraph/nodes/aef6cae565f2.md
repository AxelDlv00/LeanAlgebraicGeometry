---
author: sync
content_type: theorem
created: '2026-07-30T12:49:24'
decl: AlgebraicGeometry.not_indexSeparated_duplicated
docstring: '**INDEX SEPARATION IS NOT FREE, AND NOT IMPLIED BY PER-CHART INJECTIVITY.**


  The duplicated family has both charts injective on every test (`injective_duplicated`)
  and is

  *not* index separated: the identity point of `Spec k` has the same value in both
  components.


  This is the negative answer to the multi-index question.  The one-chart refutation
  of the

  `V`-interval concludes per-chart injectivity, and per-chart injectivity does not
  give the

  index-separation premise that

  `not_injective_of_pointwiseCoverage_of_indexSeparated_of_ne_top` needs — so the
  no-go has no

  multi-index analogue, and a glueing atlas, whose charts overlap by construction,
  is precisely

  the shape that evades it.'
file: AlgebraicJacobian/Picard/Pic0ChartMultiIndexInterval.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.not_indexSeparated_duplicated
type: lean
updated: '2026-07-30T12:49:24'
---
theorem not_indexSeparated_duplicated :
    ¬ IndexSeparated C (duplicatedSpecFamily C) := by
  intro hsep
  have hne : (⟨false⟩ : ULift.{u} Bool) ≠ ⟨true⟩ := by simp
  exact hne (hsep (op (Spec (CommRingCat.of k))) ⟨false⟩ ⟨true⟩
    (𝟙 (Spec (CommRingCat.of k))) (𝟙 (Spec (CommRingCat.of k))) rfl)

variable (C) in