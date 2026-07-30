---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: CategoryTheory.Over.mkCongr_rfl
file: AlgebraicJacobian/Picard/OverSigmaExtension.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.Over.mkCongr_rfl
type: lean
updated: '2026-07-30T15:46:05'
---
lemma mkCongr_rfl {T : C} (a : T ⟶ S) : mkCongr (rfl : a = a) = 𝟙 (Over.mk a) := by
  ext
  rfl