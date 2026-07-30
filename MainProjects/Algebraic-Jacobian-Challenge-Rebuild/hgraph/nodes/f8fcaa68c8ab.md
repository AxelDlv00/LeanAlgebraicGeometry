---
author: sync
content_type: definition
created: '2026-07-30T03:30:39'
decl: AlgebraicGeometry.AffAdaptation.ovlStalkColEval
docstring: 'The overlap variant: `Γ(pieces i ⊓ pieces j)/(f_i, f_j) →ₐ[K] 𝒪_z ⧸ I_d(z)`
  at a point of

  the overlap — both overlap generators germ into the stalk ideal.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffStalkEval.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.ovlStalkColEval
type: lean
updated: '2026-07-30T15:46:03'
---
noncomputable def ovlStalkColEval (i j : D.index) {z : relCurve C K}
    (hz : z ∈ D.pieces i ⊓ D.pieces j) :
    A.ovlColength i j →ₐ[K] ((relCurve C K).presheaf.stalk z ⧸ d.stalkIdeal z) :=
  Ideal.Quotient.liftₐ (A.ovlIdeal i j)
    ((Ideal.Quotient.mkₐ K (d.stalkIdeal z)).comp (Scheme.germAlgHom K hz))
    (by
      intro a ha
      have hgen : ∀ x ∈ ({relResAlgHom C K
            (inf_le_left : D.pieces i ⊓ D.pieces j ≤ D.pieces i) (A.eqn i),
          relResAlgHom C K
            (inf_le_right : D.pieces i ⊓ D.pieces j ≤ D.pieces j) (A.eqn j)} :
            Set Γ(relCurve C K, D.pieces i ⊓ D.pieces j)),
          ((Ideal.Quotient.mkₐ K (d.stalkIdeal z)).comp (Scheme.germAlgHom K hz)) x = 0 := by
        rintro x hx
        simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at hx
        rcases hx with rfl | rfl
        · have hmem : ((relCurve C K).presheaf.germ (D.pieces i) z hz.1).hom (A.eqn i)
              ∈ d.stalkIdeal z := by
            rw [← A.span_germ_eqn_eq_stalkIdeal i hz.1]
            exact Ideal.mem_span_singleton_self _
          rw [AlgHom.comp_apply,
            show (Scheme.germAlgHom K hz) (relResAlgHom C K inf_le_left (A.eqn i))
              = ((relCurve C K).presheaf.germ (D.pieces i ⊓ D.pieces j) z hz).hom
                  (((relCurve C K).presheaf.map (homOfLE inf_le_left).op).hom (A.eqn i))
              from rfl,
            TopCat.Presheaf.germ_res_apply, Ideal.Quotient.mkₐ_eq_mk,
            Ideal.Quotient.eq_zero_iff_mem.mpr hmem]
        · have hmem : ((relCurve C K).presheaf.germ (D.pieces j) z hz.2).hom (A.eqn j)
              ∈ d.stalkIdeal z := by
            rw [← A.span_germ_eqn_eq_stalkIdeal j hz.2]
            exact Ideal.mem_span_singleton_self _
          rw [AlgHom.comp_apply,
            show (Scheme.germAlgHom K hz) (relResAlgHom C K inf_le_right (A.eqn j))
              = ((relCurve C K).presheaf.germ (D.pieces i ⊓ D.pieces j) z hz).hom
                  (((relCurve C K).presheaf.map (homOfLE inf_le_right).op).hom (A.eqn j))
              from rfl,
            TopCat.Presheaf.germ_res_apply, Ideal.Quotient.mkₐ_eq_mk,
            Ideal.Quotient.eq_zero_iff_mem.mpr hmem]
      have hle : A.ovlIdeal i j ≤ RingHom.ker
          ((Ideal.Quotient.mkₐ K (d.stalkIdeal z)).comp (Scheme.germAlgHom K hz)) := by
        rw [Ideal.span_le]
        intro x hx
        rw [SetLike.mem_coe, RingHom.mem_ker]
        exact hgen x hx
      exact hle ha)

omit [IsIntegral (relCurve C K)]
  [SmoothOfRelativeDimension 1 (relCurve C K ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (relCurve C K ↘ Spec (CommRingCat.of K))] in