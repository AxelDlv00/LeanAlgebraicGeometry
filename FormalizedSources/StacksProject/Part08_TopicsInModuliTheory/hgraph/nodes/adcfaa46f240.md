---
author: sync
content_type: theorem
created: '2026-08-28T04:17:28'
decl: StacksPart08.NumericalSituation.mem_profileLocus_iff
file: StacksPart08Lib/Numerical.lean
generated: lean
lean_status: lean_ok
title: StacksPart08.NumericalSituation.mem_profileLocus_iff
type: lean
updated: '2026-08-28T04:17:28'
---
theorem mem_profileLocus_iff {X I : Type*} [TopologicalSpace X]
    (s : NumericalSituation X I) (P : I → ℤ) (x : X) :
    x ∈ s.profileLocus P ↔
      ∀ i, (s.invariant i).value x = P i := by
  constructor
  · intro h i
    exact congrFun h i
  · intro h
    funext i
    exact h i