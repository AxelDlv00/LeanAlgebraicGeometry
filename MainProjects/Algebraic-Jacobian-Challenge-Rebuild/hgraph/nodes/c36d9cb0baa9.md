---
author: sync
content_type: theorem
created: '2026-07-30T12:49:25'
decl: AlgebraicGeometry.AffAdaptation.IsCertified.exists_fibre_witness_probe
file: ScratchP1/probe_affine_fibre.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.IsCertified.exists_fibre_witness_probe
type: lean
updated: '2026-07-30T15:46:08'
---
theorem AffAdaptation.IsCertified.exists_fibre_witness_probe
    (hπ : π ≫ P1.structureMap k = C.hom)
    {D : AffCoverData C R} {d : (relCurve C R).LocalEquations}
    {A : AffAdaptation D d} {g : ℕ} (hc : A.IsCertified g)
    (hO : Sheaf.h0 (C.left.moduleKSheaf k) = 1)
    (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ))
    {a : ℕ} (ha1 : Subsingleton (relTwistPair C k π (relThetaCocycle C k π a)).H1)
    (hMa : windowM_choice π hπ g ≤ a) (p : PrimeSpectrum R) :
    ∃ W : (relCurve C p.asIdeal.ResidueField).CurveDivisor,
      Scheme.CurveDivisor.picClass p.asIdeal.ResidueField W =
          Scheme.CechPic.map (relCurveMap C R p.asIdeal.ResidueField)
            ((thetaChartDatum C R π a).cechPicClass * d.picClass⁻¹) ∧
        Subsingleton (Sheaf.HModule
          ((relCurve C p.asIdeal.ResidueField).divisorSheaf
            p.asIdeal.ResidueField W) 1) := by
  let W := windowTransportDivisor C p.asIdeal.ResidueField π a
    - Scheme.presentationDivisor p.asIdeal.ResidueField
        ((A.pulledEquations p.asIdeal.ResidueField
          hc.projective_colength).presentation)
  refine ⟨W, ?_, ?_⟩
  · have e1 : Scheme.CurveDivisor.picClass p.asIdeal.ResidueField
          (Scheme.presentationDivisor p.asIdeal.ResidueField
            ((A.pulledEquations p.asIdeal.ResidueField
              hc.projective_colength).presentation))
        = Scheme.CechPic.map (relCurveMap C R p.asIdeal.ResidueField) d.picClass := by
      rw [Scheme.CurveDivisor.picClass_presentationDivisor,
        Scheme.LocalEquations.presentation_picClass]
      exact A.picClass_pulledEquations p.asIdeal.ResidueField hc.projective_colength
    have e2 : Scheme.CurveDivisor.picClass p.asIdeal.ResidueField
          (windowTransportDivisor C p.asIdeal.ResidueField π a)
        = Scheme.CechPic.map (relCurveMap C R p.asIdeal.ResidueField)
            ((thetaChartDatum C R π a).cechPicClass) :=
      (picClass_windowTransportDivisor C p.asIdeal.ResidueField π a).trans
        (cechPicClass_map_thetaChartDatum C R π a p.asIdeal.ResidueField).symm
    change Scheme.CurveDivisor.picClass p.asIdeal.ResidueField
      (windowTransportDivisor C p.asIdeal.ResidueField π a
        - Scheme.presentationDivisor p.asIdeal.ResidueField
            ((A.pulledEquations p.asIdeal.ResidueField
              hc.projective_colength).presentation)) = _
    calc
      _ = Scheme.CurveDivisor.picClass p.asIdeal.ResidueField
              (windowTransportDivisor C p.asIdeal.ResidueField π a)
            * (Scheme.CurveDivisor.picClass p.asIdeal.ResidueField
                (Scheme.presentationDivisor p.asIdeal.ResidueField
                  ((A.pulledEquations p.asIdeal.ResidueField
                    hc.projective_colength).presentation)))⁻¹ := by
          rw [sub_eq_add_neg, Scheme.CurveDivisor.picClass_add, picClass_neg_probe]
      _ = Scheme.CechPic.map (relCurveMap C R p.asIdeal.ResidueField)
            ((thetaChartDatum C R π a).cechPicClass * d.picClass⁻¹) := by
          rw [e1, e2, map_mul, map_inv]
  · change Subsingleton (Sheaf.HModule
      ((relCurve C p.asIdeal.ResidueField).divisorSheaf p.asIdeal.ResidueField
        (windowTransportDivisor C p.asIdeal.ResidueField π a
          - Scheme.presentationDivisor p.asIdeal.ResidueField
              ((A.pulledEquations p.asIdeal.ResidueField
                hc.projective_colength).presentation))) 1)
    refine subsingleton_h1_windowTransportDivisor_sub C π hπ
      p.asIdeal.ResidueField g a ha1 hMa hO hχ
      (chi_relCurve_of_chi_probe C g hχ p.asIdeal.ResidueField) _ ?_
    rw [hc.deg_presentationDivisor_pulledEquations_probe]
    have := Int.natCast_nonneg g
    linarith