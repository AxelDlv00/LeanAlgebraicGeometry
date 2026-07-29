---
author: sync
content_type: lemma
created: '2026-07-16T21:33:27'
decl: TwoLatticePair.modelHomOverlap_apply
file: AlgebraicJacobian/Cohomology/RigidEngineLatticeModelHom.lean
generated: lean
lean_status: lean_ok
private: true
stale: true
title: TwoLatticePair.modelHomOverlap_apply
type: lean
updated: '2026-07-29T15:26:37'
---
private lemma modelHomOverlap_apply (c : ι → N) (n : ι → R[T;T⁻¹]) :
    modelHomOverlap P ι c n = ∑ i : ι, P.laurentToEnd (n i) (c i) := by
  simp [modelHomOverlap]

variable {ι}