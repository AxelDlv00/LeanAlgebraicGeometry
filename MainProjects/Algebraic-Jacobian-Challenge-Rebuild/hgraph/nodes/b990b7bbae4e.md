---
author: sync
content_type: theorem
created: '2026-07-28T19:44:56'
decl: AlgebraicGeometry.AffAdaptation.exists_germ_pulledEqn_eq_unit_mul_pullbackEqn
docstring: '**The comparison, in the orientation that needs no projectivity.**  At
  a point `z` of a

  base-changed piece, the pulled piece equation is a UNIT multiple of the pulled system
  equation

  indexed by `z` itself.


  `germ_pullbackEqn_mem_nonZeroDivisors` (`DivisorFamilyAffBaseChange.lean`) runs
  the same

  decomposition in the other direction and therefore needs the pulled piece equation
  to be

  regular, which costs `Module.Projective R (A.colength j)`.  Here the piece equation
  is the

  CONCLUSION''s subject rather than its input, so nothing about the colength is assumed
  — which is

  what makes this usable to *produce* the fibrewise datum instead of consuming it.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffFibre.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.AffAdaptation.exists_germ_pulledEqn_eq_unit_mul_pullbackEqn
type: lean
updated: '2026-07-30T15:28:03'
---
theorem exists_germ_pulledEqn_eq_unit_mul_pullbackEqn (j : D.index) (z : relCurve C R')
    (hzj : z ∈ (D.baseChange R').pieces j) :
    ∃ v : ((relCurve C R').presheaf.stalk z)ˣ,
      ((relCurve C R').presheaf.germ ((D.baseChange R').pieces j) z hzj).hom
          (A.pulledEqn R' j) =
        (v : (relCurve C R').presheaf.stalk z) *
          ((relCurve C R').presheaf.germ
            ((d.cover.pullback (relCurveMap C R R')).opens z) z
            ((d.cover.pullback (relCurveMap C R R')).mem_opens z)).hom
            (Scheme.LocalEquations.pullbackEqn (relCurveMap C R R') d z) := by
  have hzj' : z ∈ relCurveMap C R R' ⁻¹ᵁ D.pieces j := hzj
  have hfzj : (relCurveMap C R R').base z ∈ D.pieces j := hzj'
  have hfzz : (relCurveMap C R R').base z ∈
      d.cover.opens ((relCurveMap C R R').base z) :=
    d.cover.mem_opens _
  have hfzW : (relCurveMap C R R').base z ∈
      D.pieces j ⊓ d.cover.opens ((relCurveMap C R R').base z) :=
    ⟨hfzj, hfzz⟩
  -- the pulled piece equation's germ is the stalk image of the piece equation's germ
  have hgermF : ((relCurve C R').presheaf.germ ((D.baseChange R').pieces j) z hzj).hom
      (A.pulledEqn R' j) =
      ((relCurveMap C R R').stalkMap z).hom
        (((relCurve C R).presheaf.germ (D.pieces j)
          ((relCurveMap C R R').base z) hfzj).hom (A.eqn j)) := by
    have happ := (relCurveMap C R R').germ_stalkMap_apply (D.pieces j) z hfzj (A.eqn j)
    have hres : ((relCurve C R').presheaf.germ ((D.baseChange R').pieces j) z hzj).hom
        (A.pulledEqn R' j) =
        ((relCurve C R').presheaf.germ (relCurveMap C R R' ⁻¹ᵁ D.pieces j) z hzj').hom
          (((relCurveMap C R R').app (D.pieces j)).hom (A.eqn j)) := by
      have hstep := TopCat.Presheaf.germ_res_apply (relCurve C R').presheaf
        (homOfLE (le_refl (relCurveMap C R R' ⁻¹ᵁ D.pieces j))) z hzj
        (((relCurveMap C R R').app (D.pieces j)).hom (A.eqn j))
      rw [← hstep]
      rfl
    rw [hres, happ]
  -- decompose the piece equation at the point itself through `eqn_rel`
  obtain ⟨u, hu⟩ := A.eqn_rel j ((relCurveMap C R R').base z)
  have hdecomp : ((relCurve C R).presheaf.germ (D.pieces j)
      ((relCurveMap C R R').base z) hfzj).hom (A.eqn j) =
      ((relCurve C R).presheaf.germ
          (D.pieces j ⊓ d.cover.opens ((relCurveMap C R R').base z))
          ((relCurveMap C R R').base z) hfzW).hom
        (u : Γ(relCurve C R,
          D.pieces j ⊓ d.cover.opens ((relCurveMap C R R').base z))) *
        ((relCurve C R).presheaf.germ
          (d.cover.opens ((relCurveMap C R R').base z))
          ((relCurveMap C R R').base z) hfzz).hom
          (d.eqn ((relCurveMap C R R').base z)) := by
    have hkey := congrArg ((relCurve C R).presheaf.germ
        (D.pieces j ⊓ d.cover.opens ((relCurveMap C R R').base z))
        ((relCurveMap C R R').base z) hfzW).hom hu
    rw [map_mul, TopCat.Presheaf.germ_res_apply,
      TopCat.Presheaf.germ_res_apply] at hkey
    exact hkey
  -- the pulled system equation's germ is the stalk image of the system equation's germ
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
        (D.pieces j ⊓ d.cover.opens ((relCurveMap C R R').base z))
        ((relCurveMap C R R').base z) hfzW).hom
        (u : Γ(relCurve C R,
          D.pieces j ⊓ d.cover.opens ((relCurveMap C R R').base z))))) :=
    (u.isUnit.map ((relCurve C R).presheaf.germ
      (D.pieces j ⊓ d.cover.opens ((relCurveMap C R R').base z))
      ((relCurveMap C R R').base z) hfzW).hom).map
      ((relCurveMap C R R').stalkMap z).hom
  refine ⟨hunit.unit, ?_⟩
  rw [hgermF, hdecomp, map_mul, IsUnit.unit_spec, hgermG]