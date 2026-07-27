---
author: sync
content_type: lemma
created: '2026-07-27T17:35:58'
decl: HomogeneousLocalization.algebraMap_val
file: AlgebraicJacobian/Picard/RigidPushforwardP1ChartRing.lean
generated: lean
lean_status: lean_ok
title: HomogeneousLocalization.algebraMap_val
type: lean
updated: '2026-07-27T17:35:58'
---
lemma algebraMap_val (r : R) :
    (algebraMap R (HomogeneousLocalization 𝒜 x) r).val =
      algebraMap A (Localization x) (algebraMap R A r) := by
  rw [algebraMap_eq_comp, RingHom.comp_apply, val_fromZeroRingHom,
    SetLike.GradeZero.coe_algebraMap]

end BaseAlgebra

end HomogeneousLocalization

namespace AlgebraicGeometry.Adelic

/-! ## The chart ring of `ℙ¹` over a general commutative ring -/

section ChartRing

variable (R : Type u) [CommRing R]

/-! ### Generalities on the two-element index type -/