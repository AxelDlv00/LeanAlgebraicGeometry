---
author: sync
content_type: lemma
created: '2026-07-16T21:33:27'
decl: CategoryTheory.Sheaf.HModule'.mapCoeff_id_apply
file: AlgebraicJacobian/Cohomology/RelativeTwoCover.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.Sheaf.HModule'.mapCoeff_id_apply
type: lean
updated: '2026-07-29T15:31:36'
---
@[simp] lemma HModule'.mapCoeff_id_apply {n : ℕ} (x : HModule' F U n) :
    HModule'.mapCoeff (𝟙 F) n x = x := by
  simp [mapCoeff_apply]