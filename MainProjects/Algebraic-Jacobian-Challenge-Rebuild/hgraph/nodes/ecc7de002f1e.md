---
author: sync
content_type: theorem
created: '2026-07-31T07:19:40'
decl: AlgebraicGeometry.AffAdaptation.mem_thetaOverlapVanishing_iff_forall_germ
docstring: 'A theta section on a widened piece overlap lies in the symmetric equation-generated

  submodule if and only if every cocycle component has germ in the divisor''s stalk
  ideal.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaKernel.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.AffAdaptation.mem_thetaOverlapVanishing_iff_forall_germ
type: lean
updated: '2026-07-31T20:14:52'
---
theorem mem_thetaOverlapVanishing_iff_forall_germ [IsProper C.hom]
    (A : AffAdaptation D d) (a : ℕ)
    (i j : D.index) (s : A.ThetaOverlapSections (π := π) a i j) :
    s ∈ A.thetaOverlapVanishing (π := π) a i j ↔
      ∀ (q : (thetaChartDatum C R π a).index) (z : relCurve C R)
        (hz : z ∈ (D.pieces i ⊓ D.pieces j) ⊓
          (thetaChartDatum C R π a).pieces q),
        ((relCurve C R).presheaf.germ
          ((D.pieces i ⊓ D.pieces j) ⊓ (thetaChartDatum C R π a).pieces q)
          z hz).hom (s.val q) ∈ d.stalkIdeal z := by
  let Mij := A.thetaOverlapSectionsModel (π := π) a i j
  letI : Scheme.QcohOn (thetaChartDatum C R π a).sheaf
      (D.pieces i ⊓ D.pieces j) := Mij.qcoh
  letI : Module Γ(relCurve C R, D.pieces i ⊓ D.pieces j)
      (A.ThetaOverlapSections (π := π) a i j) :=
    A.thetaOverlapSectionsModule (π := π) a i j
  constructor
  · intro hs q z hz
    rw [thetaOverlapVanishing, A.ovlIdeal_eq_span_left i j,
      Submodule.ideal_span_singleton_smul] at hs
    obtain ⟨t, -, ht⟩ :=
      (Submodule.mem_smul_pointwise_iff_exists s
        (relResAlgHom C R
          (inf_le_left : D.pieces i ⊓ D.pieces j ≤ D.pieces i) (A.eqn i)) ⊤).mp hs
    have hq := congrArg
      (fun y : A.ThetaOverlapSections (π := π) a i j => y.val q) ht
    change (Scheme.QcohOn.qsmul (F := (thetaChartDatum C R π a).sheaf)
      (le_refl (D.pieces i ⊓ D.pieces j))
      (relResAlgHom C R inf_le_left (A.eqn i)) t).val q = s.val q at hq
    rw [Mij.qsmul_eq, gluedQsmul_coe] at hq
    have hgerm := congrArg ((relCurve C R).presheaf.germ
      ((D.pieces i ⊓ D.pieces j) ⊓ (thetaChartDatum C R π a).pieces q)
      z hz).hom hq
    rw [map_mul] at hgerm
    have hswapOverlap :
        ((relCurve C R).presheaf.germ
          ((D.pieces i ⊓ D.pieces j) ⊓ (thetaChartDatum C R π a).pieces q)
          z hz).hom
            ((relCurve C R).resHom inf_le_left
              (relResAlgHom C R inf_le_left (A.eqn i))) =
          ((relCurve C R).presheaf.germ (D.pieces i ⊓ D.pieces j) z hz.1).hom
            (relResAlgHom C R inf_le_left (A.eqn i)) :=
      TopCat.Presheaf.germ_res_apply _ _ _ _ _
    have hswapPiece :
        ((relCurve C R).presheaf.germ (D.pieces i ⊓ D.pieces j) z hz.1).hom
            (relResAlgHom C R inf_le_left (A.eqn i)) =
          ((relCurve C R).presheaf.germ (D.pieces i) z hz.1.1).hom (A.eqn i) :=
      TopCat.Presheaf.germ_res_apply _ _ _ _ _
    rw [hswapOverlap, hswapPiece] at hgerm
    rw [← A.germ_eqn_span_eq_stalkIdeal i hz.1.1, ← hgerm]
    exact Ideal.mul_mem_right _ _ (Ideal.subset_span rfl)
  · intro hs
    let c : ∀ q : (thetaChartDatum C R π a).index,
        Γ(relCurve C R, (D.pieces i ⊓ D.pieces j) ⊓
          (thetaChartDatum C R π a).pieces q) :=
      fun q => A.eqnDiv i (inf_le_left.trans inf_le_left) (s.val q) (hs q)
    have hc (q : (thetaChartDatum C R π a).index) :
        (relCurve C R).resHom
            (inf_le_left.trans inf_le_left :
              (D.pieces i ⊓ D.pieces j) ⊓
                (thetaChartDatum C R π a).pieces q ≤ D.pieces i)
            (A.eqn i) * c q = s.val q := by
      simpa only [c] using
        A.eqn_mul_eqnDiv i (inf_le_left.trans inf_le_left) (s.val q) (hs q)
    have hc_mem : c ∈ AlgebraicGeometry.gluedSubmodule R
        (thetaChartDatum C R π a).pieces
        (thetaChartDatum C R π a).unit (D.pieces i ⊓ D.pieces j) := by
      intro q r
      refine A.eqn_res_cancel i ((inf_le_left.trans inf_le_left).trans inf_le_left) ?_
      have hL := congrArg ((relCurve C R).resHom
        (inf_le_left : (D.pieces i ⊓ D.pieces j) ⊓
          (thetaChartDatum C R π a).pieces q ⊓
          (thetaChartDatum C R π a).pieces r ≤
            (D.pieces i ⊓ D.pieces j) ⊓
              (thetaChartDatum C R π a).pieces q)) (hc q)
      have hR := congrArg ((relCurve C R).resHom
        (gluedInclSnd (thetaChartDatum C R π a).pieces
          (D.pieces i ⊓ D.pieces j) q r)) (hc r)
      rw [map_mul] at hL hR
      simp only [Scheme.resHom_resHom] at hL hR
      calc
        _ = (relCurve C R).resHom inf_le_left (s.val q) := hL
        _ = (relCurve C R).resHom
              (gluedInclCoc (thetaChartDatum C R π a).pieces
                (D.pieces i ⊓ D.pieces j) q r)
              ((thetaChartDatum C R π a).unit q r :
                Γ(relCurve C R, (thetaChartDatum C R π a).pieces q ⊓
                  (thetaChartDatum C R π a).pieces r)) *
              (relCurve C R).resHom
                (gluedInclSnd (thetaChartDatum C R π a).pieces
                  (D.pieces i ⊓ D.pieces j) q r)
                (s.val r) := s.property q r
        _ = (relCurve C R).resHom
              (gluedInclCoc (thetaChartDatum C R π a).pieces
                (D.pieces i ⊓ D.pieces j) q r)
              ((thetaChartDatum C R π a).unit q r :
                Γ(relCurve C R, (thetaChartDatum C R π a).pieces q ⊓
                  (thetaChartDatum C R π a).pieces r)) *
              ((relCurve C R).resHom
                  ((inf_le_left.trans inf_le_left).trans inf_le_left) (A.eqn i) *
                (relCurve C R).resHom
                  (gluedInclSnd (thetaChartDatum C R π a).pieces
                    (D.pieces i ⊓ D.pieces j) q r)
                  (c r)) := by rw [hR]
        _ = (relCurve C R).resHom
              ((inf_le_left.trans inf_le_left).trans inf_le_left) (A.eqn i) *
              ((relCurve C R).resHom
                (gluedInclCoc (thetaChartDatum C R π a).pieces
                  (D.pieces i ⊓ D.pieces j) q r)
                ((thetaChartDatum C R π a).unit q r :
                  Γ(relCurve C R, (thetaChartDatum C R π a).pieces q ⊓
                    (thetaChartDatum C R π a).pieces r)) *
                (relCurve C R).resHom
                  (gluedInclSnd (thetaChartDatum C R π a).pieces
                    (D.pieces i ⊓ D.pieces j) q r)
                  (c r)) := by ring
    let t : A.ThetaOverlapSections (π := π) a i j := ⟨c, hc_mem⟩
    rw [thetaOverlapVanishing, A.ovlIdeal_eq_span_left i j,
      Submodule.ideal_span_singleton_smul]
    apply (Submodule.mem_smul_pointwise_iff_exists s
      (relResAlgHom C R
        (inf_le_left : D.pieces i ⊓ D.pieces j ≤ D.pieces i) (A.eqn i)) ⊤).mpr
    refine ⟨t, Submodule.mem_top, ?_⟩
    apply Subtype.ext
    funext q
    change (Scheme.QcohOn.qsmul (F := (thetaChartDatum C R π a).sheaf)
      (le_refl (D.pieces i ⊓ D.pieces j))
      (relResAlgHom C R inf_le_left (A.eqn i)) t).val q = s.val q
    rw [Mij.qsmul_eq, gluedQsmul_coe]
    have hrel :
        relResAlgHom C R
            (inf_le_left : D.pieces i ⊓ D.pieces j ≤ D.pieces i) (A.eqn i) =
          (relCurve C R).resHom inf_le_left (A.eqn i) := rfl
    rw [hrel, Scheme.resHom_resHom]
    exact hc q