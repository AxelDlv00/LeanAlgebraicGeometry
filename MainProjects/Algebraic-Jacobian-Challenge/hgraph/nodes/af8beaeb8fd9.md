---
author: sync
content_type: lemma
created: '2026-07-24T17:02:56'
decl: CategoryTheory.InjectiveResolution.horseshoeι_f_zero
file: AlgebraicJacobian/Cohomology/AcyclicResolution.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.InjectiveResolution.horseshoeι_f_zero
type: lean
updated: '2026-07-24T17:02:56'
---
lemma horseshoeι_f_zero : (horseshoeι hses I_A I_C).f 0 = horseshoeβ hses I_A I_C := by
  simp [horseshoeι, CochainComplex.fromSingle₀Equiv]