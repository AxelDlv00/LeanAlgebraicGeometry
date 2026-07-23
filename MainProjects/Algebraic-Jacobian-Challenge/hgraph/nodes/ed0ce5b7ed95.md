---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.smulIter_sub
docstring: The iterated action is subtractive.
file: AlgebraicJacobian/Picard/InvertibleSectionLocalization.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.smulIter_sub
type: lean
updated: '2026-07-16T21:14:27'
---
lemma smulIter_sub (F L : X.Modules) (s : sectionDeg L 1) (U : X.Opens)
    (N : ℕ) {j : ℕ} (x y : Γ(moduleTensorPow F L j, U)) :
    smulIter F L s U N (x - y) = smulIter F L s U N x - smulIter F L s U N y := by
  have h := smulIter_add F L s U N (x - y) y
  rw [sub_add_cancel] at h
  rw [h]
  abel