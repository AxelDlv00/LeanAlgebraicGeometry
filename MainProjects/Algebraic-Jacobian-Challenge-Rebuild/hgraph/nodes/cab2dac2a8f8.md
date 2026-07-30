---
author: sync
content_type: theorem
created: '2026-07-24T09:32:17'
decl: AlgebraicGeometry.DivisorAdaptation.exists_germ_pulledEqn_eq_unit_mul_pullbackEqn
docstring: 'At a point of a pulled adaptation piece, the pulled piece equation is
  a unit

  multiple of the pulled local equation indexed by that point.  This is the reverse

  orientation of the comparison used by

  `DivisorAdaptation.germ_pullbackEqn_mem_nonZeroDivisors`.'
file: AlgebraicJacobian/Picard/DivSchemeAdaptationFibreRegular.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.DivisorAdaptation.exists_germ_pulledEqn_eq_unit_mul_pullbackEqn
type: lean
updated: '2026-07-30T15:28:04'
---
theorem exists_germ_pulledEqn_eq_unit_mul_pullbackEqn
    (j : A.index) (z : relCurve C R')
    (hzj : z ∈ (A.toFinCoverData.baseChange R').pieces j) :
    ∃ v : ((relCurve C R').presheaf.stalk z)ˣ,
      ((relCurve C R').presheaf.germ
          ((A.toFinCoverData.baseChange R').pieces j) z hzj).hom
          (A.pulledEqn R' j) =
        (v : (relCurve C R').presheaf.stalk z) *
          ((relCurve C R').presheaf.germ
            ((d.cover.pullback (relCurveMap C R R')).opens z) z
            ((d.cover.pullback (relCurveMap C R R')).mem_opens z)).hom
            (Scheme.LocalEquations.pullbackEqn (relCurveMap C R R') d z) := by
  have hzj' : z ∈ relCurveMap C R R' ⁻¹ᵁ A.pieces j := by
    rw [← A.toFinCoverData.pieces_baseChange R' j]
    exact hzj
  have hfzj : (relCurveMap C R R').base z ∈ A.pieces j := hzj'
  have hfzz : (relCurveMap C R R').base z ∈
      d.cover.opens ((relCurveMap C R R').base z) :=
    d.cover.mem_opens _
  have hfzW : (relCurveMap C R R').base z ∈
      A.pieces j ⊓ d.cover.opens ((relCurveMap C R R').base z) :=
    ⟨hfzj, hfzz⟩
  have hgermF : ((relCurve C R').presheaf.germ
      ((A.toFinCoverData.baseChange R').pieces j) z hzj).hom (A.pulledEqn R' j) =
      ((relCurveMap C R R').stalkMap z).hom
        (((relCurve C R).presheaf.germ (A.pieces j)
          ((relCurveMap C R R').base z) hfzj).hom (A.eqn j)) := by
    have happ := (relCurveMap C R R').germ_stalkMap_apply
      (A.pieces j) z hfzj (A.eqn j)
    have hres : ((relCurve C R').presheaf.germ
        ((A.toFinCoverData.baseChange R').pieces j) z hzj).hom (A.pulledEqn R' j) =
        ((relCurve C R').presheaf.germ
          (relCurveMap C R R' ⁻¹ᵁ A.pieces j) z hzj').hom
          (((relCurveMap C R R').app (A.pieces j)).hom (A.eqn j)) := by
      have hle : (A.toFinCoverData.baseChange R').pieces j ≤
          relCurveMap C R R' ⁻¹ᵁ A.pieces j :=
        A.toFinCoverData.baseChange_pieces_le_preimage R' j
      have h := TopCat.Presheaf.germ_res_apply (relCurve C R').presheaf
        (homOfLE hle) z hzj (((relCurveMap C R R').app (A.pieces j)).hom (A.eqn j))
      rw [← h]
      rfl
    rw [hres, happ]
  obtain ⟨u, hu⟩ := A.eqn_rel j ((relCurveMap C R R').base z)
  have hdecomp : ((relCurve C R).presheaf.germ (A.pieces j)
      ((relCurveMap C R R').base z) hfzj).hom (A.eqn j) =
      ((relCurve C R).presheaf.germ
          (A.pieces j ⊓ d.cover.opens ((relCurveMap C R R').base z))
          ((relCurveMap C R R').base z) hfzW).hom
        (u : Γ(relCurve C R,
          A.pieces j ⊓ d.cover.opens ((relCurveMap C R R').base z))) *
        ((relCurve C R).presheaf.germ
          (d.cover.opens ((relCurveMap C R R').base z))
          ((relCurveMap C R R').base z) hfzz).hom
          (d.eqn ((relCurveMap C R R').base z)) := by
    have hkey := congrArg ((relCurve C R).presheaf.germ
        (A.pieces j ⊓ d.cover.opens ((relCurveMap C R R').base z))
        ((relCurveMap C R R').base z) hfzW).hom hu
    rw [map_mul, TopCat.Presheaf.germ_res_apply,
      TopCat.Presheaf.germ_res_apply] at hkey
    exact hkey
  have hgermG : ((relCurve C R').presheaf.germ
      ((d.cover.pullback (relCurveMap C R R')).opens z) z
      ((d.cover.pullback (relCurveMap C R R')).mem_opens z)).hom
      (Scheme.LocalEquations.pullbackEqn (relCurveMap C R R') d z) =
      ((relCurveMap C R R').stalkMap z).hom
        (((relCurve C R).presheaf.germ
          (d.cover.opens ((relCurveMap C R R').base z))
          ((relCurveMap C R R').base z) hfzz).hom
          (d.eqn ((relCurveMap C R R').base z))) := by
    rw [Scheme.LocalEquations.pullbackEqn]
    have happLE : ((relCurveMap C R R').appLE
        (d.cover.opens ((relCurveMap C R R').base z))
        ((d.cover.pullback (relCurveMap C R R')).opens z) le_rfl).hom
        (d.eqn ((relCurveMap C R R').base z)) =
        ((relCurve C R').presheaf.map (homOfLE (le_refl
          ((d.cover.pullback (relCurveMap C R R')).opens z))).op).hom
          (((relCurveMap C R R').app
            (d.cover.opens ((relCurveMap C R R').base z))).hom
            (d.eqn ((relCurveMap C R R').base z))) := rfl
    rw [happLE, TopCat.Presheaf.germ_res_apply]
    exact ((relCurveMap C R R').germ_stalkMap_apply
      (d.cover.opens ((relCurveMap C R R').base z)) z hfzz
      (d.eqn ((relCurveMap C R R').base z))).symm
  have hunit : IsUnit (((relCurveMap C R R').stalkMap z).hom
      (((relCurve C R).presheaf.germ
        (A.pieces j ⊓ d.cover.opens ((relCurveMap C R R').base z))
        ((relCurveMap C R R').base z) hfzW).hom
        (u : Γ(relCurve C R,
          A.pieces j ⊓ d.cover.opens ((relCurveMap C R R').base z))))) :=
    (u.isUnit.map ((relCurve C R).presheaf.germ
      (A.pieces j ⊓ d.cover.opens ((relCurveMap C R R').base z))
      ((relCurveMap C R R').base z) hfzW).hom).map
      ((relCurveMap C R R').stalkMap z).hom
  refine ⟨hunit.unit, ?_⟩
  rw [hgermF, hdecomp, map_mul, IsUnit.unit_spec, hgermG]