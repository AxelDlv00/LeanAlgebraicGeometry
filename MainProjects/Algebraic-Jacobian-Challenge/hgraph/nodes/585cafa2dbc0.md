---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.smulIter_zero_right
docstring: The iterated action annihilates zero.
file: AlgebraicJacobian/Picard/InvertibleSectionLocalization.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.smulIter_zero_right
type: lean
updated: '2026-07-24T03:02:11'
---
lemma smulIter_zero_right (F L : X.Modules) (s : sectionDeg L 1) (U : X.Opens)
    (N : ℕ) {j : ℕ} :
    smulIter F L s U N (0 : Γ(moduleTensorPow F L j, U)) = 0 := by
  induction N with
  | zero => rfl
  | succ N ih =>
      rw [smulIter_succ, ih]
      exact twistedSMul_zero_right F L 1 (smulIterDeg N j) U _