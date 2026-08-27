---
author: sync
content_type: theorem
created: '2026-08-28T04:17:28'
decl: StacksPart08.NumericalSituation.profileLocus_prescribed_eq_locus
file: StacksPart08Lib/Numerical.lean
generated: lean
lean_status: lean_ok
title: StacksPart08.NumericalSituation.profileLocus_prescribed_eq_locus
type: lean
updated: '2026-08-28T04:17:28'
---
theorem profileLocus_prescribed_eq_locus {X I : Type*} [TopologicalSpace X]
    (s : NumericalSituation X I) :
    s.profileLocus s.prescribed = s.locus := by
  ext x
  exact s.mem_profileLocus_iff s.prescribed x