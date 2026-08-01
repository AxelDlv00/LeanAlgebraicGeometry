---
author: sync
content_type: theorem
created: '2026-07-31T18:43:04'
decl: AlgebraicGeometry.AffAdaptation.thetaPieceVanishing_iff_gluedTwist_cokernel_eq_zero
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaCokernelGlobal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.thetaPieceVanishing_iff_gluedTwist_cokernel_eq_zero
type: lean
updated: '2026-08-01T09:44:13'
---
theorem thetaPieceVanishing_iff_gluedTwist_cokernel_eq_zero
    {D : AffCoverData C R} {d : (relCurve C R).LocalEquations}
    {A : AffAdaptation D d} (B : DivisorAdaptation C R π d) (a : ℕ)
    (j : D.index) (v : A.ThetaPieceSections (π := π) a j) :
    v ∈ A.thetaPieceVanishing (π := π) a j ↔
      ((cokernel.π (B.thetaIdealIncl (a := a))).hom.app
        (op (D.pieces j))).hom
        (gluedTwistEquiv C R π a (D.pieces j) v) = 0 := by
  let W := D.pieces j
  constructor
  · intro hv
    have h := (A.mem_thetaPieceVanishing_iff_forall_germ (π := π) a j v).mp hv
    have hx :
        (∀ (z : relCurve C R) (hz : z ∈ W ⊓
          (relCover C R (fiberTwoCover π)).V₀),
          ((relCurve C R).presheaf.germ (W ⊓
            (relCover C R (fiberTwoCover π)).V₀) z hz).hom
              (gluedTwistEquiv C R π a W v).val.1 ∈ d.stalkIdeal z) ∧
        (∀ (z : relCurve C R) (hz : z ∈ W ⊓
          (relCover C R (fiberTwoCover π)).V₁),
          ((relCurve C R).presheaf.germ (W ⊓
            (relCover C R (fiberTwoCover π)).V₁) z hz).hom
              (gluedTwistEquiv C R π a W v).val.2 ∈ d.stalkIdeal z) := by
      constructor
      · intro z hz
        have hswap :
            ((relCurve C R).presheaf.germ
              (W ⊓ (relCover C R (fiberTwoCover π)).V₀) z hz).hom
                ((relCurve C R).resHom
                  (inf_le_inf_left W
                    (thetaChartCover_pieces_inl C R π PUnit.unit).ge)
                  (v.val (Sum.inl PUnit.unit))) =
              ((relCurve C R).presheaf.germ
                (W ⊓ (thetaChartDatum C R π a).pieces (Sum.inl PUnit.unit)) z
                ⟨hz.1, (thetaChartCover_pieces_inl C R π PUnit.unit).ge hz.2⟩).hom
                  (v.val (Sum.inl PUnit.unit)) :=
          TopCat.Presheaf.germ_res_apply _ _ _ _ _
        change ((relCurve C R).presheaf.germ
          (W ⊓ (relCover C R (fiberTwoCover π)).V₀) z hz).hom
            ((relCurve C R).resHom
              (inf_le_inf_left W (thetaChartCover_pieces_inl C R π PUnit.unit).ge)
              (v.val (Sum.inl PUnit.unit))) ∈ d.stalkIdeal z
        rw [hswap]
        exact h (Sum.inl PUnit.unit) z
          ⟨hz.1, (thetaChartCover_pieces_inl C R π PUnit.unit).ge hz.2⟩
      · intro z hz
        have hswap :
            ((relCurve C R).presheaf.germ
              (W ⊓ (relCover C R (fiberTwoCover π)).V₁) z hz).hom
                ((relCurve C R).resHom
                  (inf_le_inf_left W
                    (thetaChartCover_pieces_inr C R π PUnit.unit).ge)
                  (v.val (Sum.inr PUnit.unit))) =
              ((relCurve C R).presheaf.germ
                (W ⊓ (thetaChartDatum C R π a).pieces (Sum.inr PUnit.unit)) z
                ⟨hz.1, (thetaChartCover_pieces_inr C R π PUnit.unit).ge hz.2⟩).hom
                  (v.val (Sum.inr PUnit.unit)) :=
          TopCat.Presheaf.germ_res_apply _ _ _ _ _
        change ((relCurve C R).presheaf.germ
          (W ⊓ (relCover C R (fiberTwoCover π)).V₁) z hz).hom
            ((relCurve C R).resHom
              (inf_le_inf_left W (thetaChartCover_pieces_inr C R π PUnit.unit).ge)
              (v.val (Sum.inr PUnit.unit))) ∈ d.stalkIdeal z
        rw [hswap]
        exact h (Sum.inr PUnit.unit) z
          ⟨hz.1, (thetaChartCover_pieces_inr C R π PUnit.unit).ge hz.2⟩
    exact DivisorAdaptation.cokernelπ_app_eq_zero_of_germ_mem C R π B
      (gluedTwistEquiv C R π a W v) hx.1 hx.2
  · intro hv
    have hker :
        gluedTwistEquiv C R π a W v ∈
          LinearMap.ker (((cokernel.π (B.thetaIdealIncl (a := a))).hom.app
            (op W)).hom) := (LinearMap.mem_ker).mpr hv
    rw [CategoryTheory.Sheaf.ker_cokernelπ_app_eq_range
      (B.thetaIdealIncl (a := a)) (op W)] at hker
    rw [DivisorAdaptation.thetaIdealIncl_app] at hker
    have hgerm :=
      (B.mem_range_thetaIdealInclApp_iff_germ_mem
        (a := a) (gluedTwistEquiv C R π a W v)).mp hker
    apply (A.mem_thetaPieceVanishing_iff_forall_germ (π := π) a j v).mpr
    rintro (q | q) z hz
    · cases q
      have hswap :
          ((relCurve C R).presheaf.germ
            (W ⊓ (relCover C R (fiberTwoCover π)).V₀) z
              ⟨hz.1, thetaChartCover_pieces_le_inl C R π PUnit.unit hz.2⟩).hom
              ((relCurve C R).resHom
                (inf_le_inf_left W
                  (thetaChartCover_pieces_inl C R π PUnit.unit).ge)
                (v.val (Sum.inl PUnit.unit))) =
            ((relCurve C R).presheaf.germ
              (W ⊓ (thetaChartDatum C R π a).pieces (Sum.inl PUnit.unit))
              z hz).hom (v.val (Sum.inl PUnit.unit)) :=
        TopCat.Presheaf.germ_res_apply _ _ _ _ _
      rw [← hswap]
      exact hgerm.1 z
        ⟨hz.1, thetaChartCover_pieces_le_inl C R π PUnit.unit hz.2⟩
    · cases q
      have hswap :
          ((relCurve C R).presheaf.germ
            (W ⊓ (relCover C R (fiberTwoCover π)).V₁) z
              ⟨hz.1, thetaChartCover_pieces_le_inr C R π PUnit.unit hz.2⟩).hom
              ((relCurve C R).resHom
                (inf_le_inf_left W
                  (thetaChartCover_pieces_inr C R π PUnit.unit).ge)
                (v.val (Sum.inr PUnit.unit))) =
            ((relCurve C R).presheaf.germ
              (W ⊓ (thetaChartDatum C R π a).pieces (Sum.inr PUnit.unit))
              z hz).hom (v.val (Sum.inr PUnit.unit)) :=
        TopCat.Presheaf.germ_res_apply _ _ _ _ _
      rw [← hswap]
      exact hgerm.2 z
        ⟨hz.1, thetaChartCover_pieces_le_inr C R π PUnit.unit hz.2⟩

omit [IsProper C.hom] in