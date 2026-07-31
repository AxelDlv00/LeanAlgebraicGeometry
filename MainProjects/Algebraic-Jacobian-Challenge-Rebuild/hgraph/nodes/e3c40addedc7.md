---
author: sync
content_type: theorem
created: '2026-07-31T18:43:04'
decl: AlgebraicGeometry.AffAdaptation.thetaPieceVanishing_iff_gluedTwist_cokernel_eq_zero
docstring: "The same producer in the form consumed by the global cokernel projection.\
  \ -/\ntheorem IsCertified.exists_chartAdaptation_thetaIdealCokernel_app_top_surjective\n\
  \    {D : AffCoverData C R} {d : (relCurve C R).LocalEquations}\n    {A : AffAdaptation\
  \ D d} {g : ℕ} (hc : A.IsCertified g)\n    (hπ : π ≫ P1.structureMap k = C.hom)\n\
  \    (hO : Sheaf.h0 (C.left.moduleKSheaf k) = 1)\n    (hχ : Sheaf.chi (C.left.moduleKSheaf\
  \ k) = 1 - (g : ℤ))\n    {a : ℕ} (ha1 : Subsingleton (relTwistPair C k π (relThetaCocycle\
  \ C k π a)).H1)\n    (hMa : windowM_choice π hπ g ≤ a) :\n    ∃ B : DivisorAdaptation\
  \ C R π d,\n      Function.Surjective\n        ((cokernel.π (DivisorAdaptation.thetaIdealIncl\
  \ (A := B) (a := a))).hom.app\n          (op (⊤ : (relCurve C R).Opens))).hom :=\
  \ by\n  obtain ⟨B, hB⟩ := hc.exists_chartAdaptation_subsingleton_thetaIdealH1\n\
  \    C R π hπ hO hχ ha1 hMa\n  letI : Subsingleton (Sheaf.HModule (B.thetaIdealDatum\
  \ a).sheaf 1) := hB\n  exact ⟨B, B.thetaIdealCokernel_app_top_surjective⟩\n\nend\
  \ AffAdaptation\n\nnamespace AffAdaptation\n\nattribute [local instance] thetaPieceSectionsModule\
  \ thetaOverlapSectionsModule\n  thetaPieceQuotientModule thetaOverlapQuotientModule\n\
  \n/-! ## Overlap vanishing in the theta cokernel\n\nThe intrinsic overlap ideal\
  \ is detected germwise by the widened kernel theorem.  After\nthe glued--twist conversion,\
  \ its two pinned components therefore lie in the kernel of\nthe auxiliary theta-ideal\
  \ cokernel on the overlap.\n-/\n\ntheorem thetaOverlapVanishing_gluedTwist_cokernel_eq_zero\n\
  \    {D : AffCoverData C R} {d : (relCurve C R).LocalEquations}\n    {A : AffAdaptation\
  \ D d} (B : DivisorAdaptation C R π d) (a : ℕ)\n    (i j : D.index)\n    (v : A.ThetaOverlapSections\
  \ (π := π) a i j)\n    (hv : v ∈ A.thetaOverlapVanishing (π := π) a i j) :\n   \
  \ ((cokernel.π (B.thetaIdealIncl (a := a))).hom.app\n      (op (D.pieces i ⊓ D.pieces\
  \ j))).hom\n      (gluedTwistEquiv C R π a (D.pieces i ⊓ D.pieces j) v) = 0 := by\n\
  \  let W := D.pieces i ⊓ D.pieces j\n  have h := (A.mem_thetaOverlapVanishing_iff_forall_germ\
  \ (π := π) a i j v).mp hv\n  have hx :\n      (∀ (z : relCurve C R) (hz : z ∈ W\
  \ ⊓\n        (relCover C R (fiberTwoCover π)).V₀),\n        ((relCurve C R).presheaf.germ\
  \ (W ⊓\n          (relCover C R (fiberTwoCover π)).V₀) z hz).hom\n            (gluedTwistEquiv\
  \ C R π a W v).val.1 ∈ d.stalkIdeal z) ∧\n      (∀ (z : relCurve C R) (hz : z ∈\
  \ W ⊓\n        (relCover C R (fiberTwoCover π)).V₁),\n        ((relCurve C R).presheaf.germ\
  \ (W ⊓\n          (relCover C R (fiberTwoCover π)).V₁) z hz).hom\n            (gluedTwistEquiv\
  \ C R π a W v).val.2 ∈ d.stalkIdeal z) := by\n    constructor\n    · intro z hz\n\
  \      have hswap :\n          ((relCurve C R).presheaf.germ\n            (W ⊓ (relCover\
  \ C R (fiberTwoCover π)).V₀) z hz).hom\n              ((relCurve C R).resHom\n \
  \               (inf_le_inf_left W\n                  (thetaChartCover_pieces_inl\
  \ C R π PUnit.unit).ge)\n                (v.val (Sum.inl PUnit.unit))) =\n     \
  \       ((relCurve C R).presheaf.germ\n              (W ⊓ (thetaChartDatum C R π\
  \ a).pieces (Sum.inl PUnit.unit)) z\n              ⟨hz.1, (thetaChartCover_pieces_inl\
  \ C R π PUnit.unit).ge hz.2⟩).hom\n                (v.val (Sum.inl PUnit.unit))\
  \ :=\n        TopCat.Presheaf.germ_res_apply _ _ _ _ _\n      change ((relCurve\
  \ C R).presheaf.germ\n        (W ⊓ (relCover C R (fiberTwoCover π)).V₀) z hz).hom\n\
  \          ((relCurve C R).resHom\n            (inf_le_inf_left W (thetaChartCover_pieces_inl\
  \ C R π PUnit.unit).ge)\n            (v.val (Sum.inl PUnit.unit))) ∈ d.stalkIdeal\
  \ z\n      rw [hswap]\n      exact h (Sum.inl PUnit.unit) z\n        ⟨hz.1, (thetaChartCover_pieces_inl\
  \ C R π PUnit.unit).ge hz.2⟩\n    · intro z hz\n      have hswap :\n          ((relCurve\
  \ C R).presheaf.germ\n            (W ⊓ (relCover C R (fiberTwoCover π)).V₁) z hz).hom\n\
  \              ((relCurve C R).resHom\n                (inf_le_inf_left W\n    \
  \              (thetaChartCover_pieces_inr C R π PUnit.unit).ge)\n             \
  \   (v.val (Sum.inr PUnit.unit))) =\n            ((relCurve C R).presheaf.germ\n\
  \              (W ⊓ (thetaChartDatum C R π a).pieces (Sum.inr PUnit.unit)) z\n \
  \             ⟨hz.1, (thetaChartCover_pieces_inr C R π PUnit.unit).ge hz.2⟩).hom\n\
  \                (v.val (Sum.inr PUnit.unit)) :=\n        TopCat.Presheaf.germ_res_apply\
  \ _ _ _ _ _\n      change ((relCurve C R).presheaf.germ\n        (W ⊓ (relCover\
  \ C R (fiberTwoCover π)).V₁) z hz).hom\n          ((relCurve C R).resHom\n     \
  \       (inf_le_inf_left W (thetaChartCover_pieces_inr C R π PUnit.unit).ge)\n \
  \           (v.val (Sum.inr PUnit.unit))) ∈ d.stalkIdeal z\n      rw [hswap]\n \
  \     exact h (Sum.inr PUnit.unit) z\n        ⟨hz.1, (thetaChartCover_pieces_inr\
  \ C R π PUnit.unit).ge hz.2⟩\n  exact DivisorAdaptation.cokernelπ_app_eq_zero_of_germ_mem\
  \ C R π B\n    (gluedTwistEquiv C R π a W v) hx.1 hx.2\n\n/-! ## Cokernel compatibility\
  \ of intrinsic representatives\n\nThe equalizer relation on two piece representatives\
  \ is a quotient equality on the\noverlap.  The preceding overlap-kernel producer\
  \ turns that quotient equality into\nequality after passage to the auxiliary theta\
  \ cokernel.\n-/\n\ntheorem thetaPieceCokernel_eq_of_overlap_eq\n    {D : AffCoverData\
  \ C R} {d : (relCurve C R).LocalEquations}\n    {A : AffAdaptation D d} (B : DivisorAdaptation\
  \ C R π d) (a : ℕ)\n    (i j : D.index)\n    (si : A.ThetaPieceSections (π := π)\
  \ a i)\n    (sj : A.ThetaPieceSections (π := π) a j)\n    (hij : A.thetaToOverlapLeft\
  \ (π := π) a i j\n        (Submodule.Quotient.mk si : A.ThetaPieceQuotient (π :=\
  \ π) a i) =\n      A.thetaToOverlapRight (π := π) a i j\n        (Submodule.Quotient.mk\
  \ sj : A.ThetaPieceQuotient (π := π) a j)) :\n    ((cokernel.π (B.thetaIdealIncl\
  \ (a := a))).hom.app\n      (op (D.pieces i ⊓ D.pieces j))).hom\n      (gluedTwistEquiv\
  \ C R π a (D.pieces i ⊓ D.pieces j)\n        (secRes (thetaChartDatum C R π a).sheaf\
  \ inf_le_left si)) =\n    ((cokernel.π (B.thetaIdealIncl (a := a))).hom.app\n  \
  \    (op (D.pieces i ⊓ D.pieces j))).hom\n      (gluedTwistEquiv C R π a (D.pieces\
  \ i ⊓ D.pieces j)\n        (secRes (thetaChartDatum C R π a).sheaf inf_le_right\
  \ sj)) := by\n  let sleft := secRes (thetaChartDatum C R π a).sheaf\n    (inf_le_left\
  \ : D.pieces i ⊓ D.pieces j ≤ D.pieces i) si\n  let sright := secRes (thetaChartDatum\
  \ C R π a).sheaf\n    (inf_le_right : D.pieces i ⊓ D.pieces j ≤ D.pieces j) sj\n\
  \  have hq :\n      (Submodule.Quotient.mk sleft : A.ThetaOverlapQuotient (π :=\
  \ π) a i j) =\n        (Submodule.Quotient.mk sright : A.ThetaOverlapQuotient (π\
  \ := π) a i j) := by\n    simpa only [sleft, sright, A.thetaToOverlapLeft_mk, A.thetaToOverlapRight_mk]\
  \ using hij\n  have hv : sleft - sright ∈ A.thetaOverlapVanishing (π := π) a i j\
  \ :=\n    (Submodule.Quotient.eq (A.thetaOverlapVanishing (π := π) a i j)).mp hq\n\
  \  have hz := A.thetaOverlapVanishing_gluedTwist_cokernel_eq_zero C R π B a i j\n\
  \    (sleft - sright) hv\n  have htw :\n      gluedTwistEquiv C R π a (D.pieces\
  \ i ⊓ D.pieces j) (sleft - sright) =\n        gluedTwistEquiv C R π a (D.pieces\
  \ i ⊓ D.pieces j) sleft -\n          gluedTwistEquiv C R π a (D.pieces i ⊓ D.pieces\
  \ j) sright :=\n    (gluedTwistEquiv C R π a (D.pieces i ⊓ D.pieces j)).map_sub\
  \ sleft sright\n  rw [htw] at hz\n  have hmap :\n      ((cokernel.π (B.thetaIdealIncl\
  \ (a := a))).hom.app\n          (op (D.pieces i ⊓ D.pieces j))).hom\n          (gluedTwistEquiv\
  \ C R π a (D.pieces i ⊓ D.pieces j) sleft -\n            gluedTwistEquiv C R π a\
  \ (D.pieces i ⊓ D.pieces j) sright) =\n        ((cokernel.π (B.thetaIdealIncl (a\
  \ := a))).hom.app\n          (op (D.pieces i ⊓ D.pieces j))).hom\n          (gluedTwistEquiv\
  \ C R π a (D.pieces i ⊓ D.pieces j) sleft) -\n          ((cokernel.π (B.thetaIdealIncl\
  \ (a := a))).hom.app\n            (op (D.pieces i ⊓ D.pieces j))).hom\n        \
  \    (gluedTwistEquiv C R π a (D.pieces i ⊓ D.pieces j) sright) := by\n    exact\
  \ map_sub _ _ _\n  have hzero :\n      ((cokernel.π (B.thetaIdealIncl (a := a))).hom.app\n\
  \          (op (D.pieces i ⊓ D.pieces j))).hom\n          (gluedTwistEquiv C R π\
  \ a (D.pieces i ⊓ D.pieces j) sleft) -\n          ((cokernel.π (B.thetaIdealIncl\
  \ (a := a))).hom.app\n            (op (D.pieces i ⊓ D.pieces j))).hom\n        \
  \    (gluedTwistEquiv C R π a (D.pieces i ⊓ D.pieces j) sright) = 0 := by\n    rw\
  \ [← hmap]\n    exact hz\n  exact sub_eq_zero.mp hzero\n\n/-! ## Piecewise exactness\
  \ of the auxiliary cokernel\n\nThe pointwise cokernel kernel is exactly the equation-generated\
  \ theta submodule on each\nwidened piece.  This is the local converse needed when\
  \ a glued cokernel lift is compared\nback with chosen intrinsic representatives."
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaCokernelGlobal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.thetaPieceVanishing_iff_gluedTwist_cokernel_eq_zero
type: lean
updated: '2026-07-31T19:20:46'
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