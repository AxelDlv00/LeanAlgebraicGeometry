---
author: sync
content_type: lemma
created: '2026-07-16T21:33:27'
decl: HomogeneousLocalization.algebraMap_val
file: AlgebraicJacobian/Curve/P1.lean
generated: lean
lean_status: lean_ok
title: HomogeneousLocalization.algebraMap_val
type: lean
updated: '2026-07-16T21:33:27'
---
lemma algebraMap_val (r : R) :
    (algebraMap R (HomogeneousLocalization 𝒜 x) r).val =
      algebraMap A (Localization x) (algebraMap R A r) := by
  rw [algebraMap_eq', RingHom.comp_apply, val_fromZeroRingHom,
    SetLike.GradeZero.coe_algebraMap]

end HomogeneousLocalization

end GenericLemmas

namespace AlgebraicGeometry

open MvPolynomial HomogeneousLocalization