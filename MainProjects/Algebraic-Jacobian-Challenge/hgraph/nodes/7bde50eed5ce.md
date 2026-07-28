---
author: sync
content_type: lemma
created: '2026-07-27T17:35:58'
decl: HomogeneousLocalization.algebraMap_val
file: AlgebraicJacobian/RiemannRoch/Ledger/P1.lean
generated: lean
lean_status: lean_ok
private: true
title: HomogeneousLocalization.algebraMap_val
type: lean
updated: '2026-07-28T20:03:00'
---
private lemma algebraMap_val (r : R) :
    (algebraMap R (HomogeneousLocalization 𝒜 x) r).val =
      algebraMap A (Localization x) (algebraMap R A r) := by
  rw [algebraMap_eq', RingHom.comp_apply, val_fromZeroRingHom,
    SetLike.GradeZero.coe_algebraMap]

end HomogeneousLocalization

end GenericLemmas

namespace AlgebraicGeometry

open MvPolynomial HomogeneousLocalization