---
author: sync
content_type: theorem
created: '2026-08-03T08:02:46'
decl: AlgebraicGeometry.divUniversalHighWindowRelation_one_eq_secondWindow_at
docstring: 'At independent Euler parameter `gamma ≤ g`, stage one is exactly the transported

  universal second window of divisor degree `g`.'
file: AlgebraicJacobian/Picard/DivSchemeHighWindowRelations.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divUniversalHighWindowRelation_one_eq_secondWindow_at
type: lean
updated: '2026-08-18T20:50:58'
---
theorem divUniversalHighWindowRelation_one_eq_secondWindow_at {gamma : ℕ}
    (hgamma : gamma ≤ g)
    (hchi : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (gamma : ℤ)) :
    divUniversalHighWindowRelation (C := C) (pi := pi)
      hpi g r1 r2 b1 b2 i j 1 =
      (divUniversalHighWindowStageOne (C := C) (pi := pi)
        hpi g r1 r2 b1 b2 i j).toSubmodule := by
  rw [divUniversalHighWindowRelation_one_transport,
    universalMulSpan_eq_divUniversalSndWindow_at
      (C := C) (pi := pi) hpi g r1 r2 b1 b2 i j hgamma hchi,
    divUniversalHighWindowStageOne_toSubmodule]