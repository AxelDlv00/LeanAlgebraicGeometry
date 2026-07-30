---
author: sync
content_type: definition
created: '2026-07-28T13:42:17'
decl: AlgebraicGeometry.AffAdaptation.toOvlLeft
docstring: Restrict-then-quotient, from the `i` component.
file: AlgebraicJacobian/Picard/DivisorFamilyAffAdaptation.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.toOvlLeft
type: lean
updated: '2026-07-30T15:46:03'
---
noncomputable def toOvlLeft (i j : D.index) : A.colength i →ₐ[R] A.ovlColength i j :=
  Ideal.Quotient.liftₐ (Ideal.span {A.eqn i})
    ((Ideal.Quotient.mkₐ R (A.ovlIdeal i j)).comp (relResAlgHom C R inf_le_left))
    (by
      intro a ha
      rw [Ideal.mem_span_singleton] at ha
      obtain ⟨c, rfl⟩ := ha
      simp only [AlgHom.comp_apply, map_mul]
      have hmem : relResAlgHom C R
          (inf_le_left : D.pieces i ⊓ D.pieces j ≤ D.pieces i) (A.eqn i)
          ∈ A.ovlIdeal i j :=
        Ideal.subset_span (Set.mem_insert _ _)
      rw [Ideal.Quotient.mkₐ_eq_mk, Ideal.Quotient.eq_zero_iff_mem.mpr hmem, zero_mul])