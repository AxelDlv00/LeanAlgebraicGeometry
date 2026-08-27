---
author: sync
content_type: theorem
created: '2026-08-28T05:38:51'
decl: StacksPart08.NumericalSituation.locusOn_reindex_image
file: StacksPart08Lib/Numerical.lean
generated: lean
lean_status: lean_ok
title: StacksPart08.NumericalSituation.locusOn_reindex_image
type: lean
updated: '2026-08-28T05:38:51'
---
theorem locusOn_reindex_image {X I J : Type*} [TopologicalSpace X]
    (s : NumericalSituation X I) (f : J → I) (K : Set J) :
    (s.reindex f).locusOn K = s.locusOn (f '' K) := by
  ext x
  constructor
  · intro hx i hi
    rcases hi with ⟨j, hj, rfl⟩
    exact hx j hj
  · intro hx j hj
    exact hx (f j) ⟨j, hj, rfl⟩