---
author: sync
content_type: theorem
created: '2026-07-31T09:39:43'
decl: LaurentPolynomial.unitsHom_surjective
file: AlgebraicJacobian/Algebra/LaurentUnits.lean
generated: lean
lean_status: lean_ok
title: LaurentPolynomial.unitsHom_surjective
type: lean
updated: '2026-07-31T20:15:16'
---
theorem unitsHom_surjective : Function.Surjective (unitsHom (R := R)) := by
  intro u
  obtain ⟨c, n, hc, hu⟩ := exists_eq_C_mul_T_of_isUnit u.isUnit
  refine ⟨(hc.unit, Multiplicative.ofAdd n), Units.ext ?_⟩
  rw [unitsHom_coe, hu]
  simp