---
author: sync
content_type: theorem
created: '2026-08-01T05:12:59'
decl: AlgebraicGeometry.AffAdaptation.cartierIdeal_ideal_eq_span_eqn
docstring: 'The widened Cartier ideal is principal on every adapted affine piece,
  with the

  recorded adapted equation as generator.'
file: AlgebraicJacobian/Picard/DivisorIdealSheaf.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.cartierIdeal_ideal_eq_span_eqn
type: lean
updated: '2026-08-01T09:44:14'
---
theorem cartierIdeal_ideal_eq_span_eqn [IsProper C.hom]
    (A : AffAdaptation D d) (i : D.index) :
    A.cartierIdeal.ideal ⟨D.pieces i, D.isAffineOpen i⟩ =
      Ideal.span {A.eqn i} := by
  rw [cartierIdeal, Scheme.IdealSheafData.ideal_iInf, iInf_apply]
  apply le_antisymm
  · exact (iInf_le _ i).trans_eq (A.localCartierIdeal_map_ideal_self i)
  · exact le_iInf fun j => A.span_eqn_le_localCartierIdeal_map_ideal i j