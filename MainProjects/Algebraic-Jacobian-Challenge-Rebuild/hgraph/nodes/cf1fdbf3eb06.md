---
author: sync
content_type: theorem
created: '2026-08-11T11:10:29'
decl: AlgebraicGeometry.BasicOpenCocycleDatum.pullback_sectionLocalEquationsOfFibrewiseRegular_divEq_sectionsMapTop
docstring: 'Pulling back the divisor cut by a fibrewise-regular glued section is `DivEq`
  to the

  divisor cut by the compared section on the canonical cover after an arbitrary affine

  coefficient change.  The first comparison has unit `1` on the pulled cover; the
  second is

  the transition-unit refinement supplied by `sectionLocalEquations_divEq_of_same_section`.'
file: AlgebraicJacobian/Picard/Pic0RankOneFibrePresentedProducerSectionDivEq.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.BasicOpenCocycleDatum.pullback_sectionLocalEquationsOfFibrewiseRegular_divEq_sectionsMapTop
type: lean
updated: '2026-08-18T20:51:05'
---
theorem pullback_sectionLocalEquationsOfFibrewiseRegular_divEq_sectionsMapTop
    [IsFinite pi] [IsNoetherianRing B]
    (D : BasicOpenCocycleDatum C B pi)
    (s : ↑(gluedSubmodule B D.pieces D.unit ⊤))
    (hfib : ∀ (j : D.index) (p : PrimeSpectrum B), Function.Injective
      ((Scheme.mulSectionEnd B (D.component s j)).rTensor p.asIdeal.ResidueField))
    (B' : Type u) [CommRing B'] [Algebra k B'] [Algebra B B']
    [IsScalarTower k B B'] [IsNoetherianRing B']
    (hfib' : ∀ (j : (D.baseChange B').index) (p : PrimeSpectrum B'),
      Function.Injective
        ((Scheme.mulSectionEnd B'
          ((D.baseChange B').component (D.sectionsMapTop B' s) j)).rTensor
            p.asIdeal.ResidueField))
    (hpull : ∀ (y z : relCurve C B')
      (hz : z ∈ ((D.sectionLocalEquationsOfFibrewiseRegular s hfib).cover.pullback
        (relCurveMap C B B')).opens y),
      ((relCurve C B').presheaf.germ
        (((D.sectionLocalEquationsOfFibrewiseRegular s hfib).cover.pullback
          (relCurveMap C B B')).opens y) z hz).hom
          (Scheme.LocalEquations.pullbackEqn (relCurveMap C B B')
            (D.sectionLocalEquationsOfFibrewiseRegular s hfib) y) ∈
        nonZeroDivisors ((relCurve C B').presheaf.stalk z)) :
    Scheme.LocalEquations.DivEq
      ((D.sectionLocalEquationsOfFibrewiseRegular s hfib).pullback
        (relCurveMap C B B') hpull)
      ((D.baseChange B').sectionLocalEquationsOfFibrewiseRegular
        (D.sectionsMapTop B' s) hfib') := by
  let f := relCurveMap C B B'
  let W := D.pointedCover.pullback f
  let sigma : relCurve C B' → D.index := fun z => D.pieceIndex (f.base z)
  let hsigma : ∀ z : relCurve C B', W.opens z ≤ (D.baseChange B').pieces (sigma z) :=
    fun z => D.pullback_pointedCover_le B' z
  let s' := D.sectionsMapTop B' s
  let hreg' : ∀ (j : (D.baseChange B').index) (z : relCurve C B')
      (hz : z ∈ (D.baseChange B').pieces j),
      ((relCurve C B').presheaf.germ ((D.baseChange B').pieces j) z hz).hom
          ((D.baseChange B').component s' j) ∈
        nonZeroDivisors ((relCurve C B').presheaf.stalk z) :=
    fun j z hz =>
      (D.baseChange B').germ_component_mem_nonZeroDivisors s' j (hfib' j) z hz
  refine Scheme.LocalEquations.DivEq.trans (d₂ :=
    (D.baseChange B').sectionLocalEquations s' W sigma hsigma hreg') ?_ ?_
  · refine ⟨W, (fun _ => le_rfl), (fun _ => le_rfl), fun z => ?_⟩
    refine ⟨1, ?_⟩
    rw [Units.val_one, one_mul]
    simp only [Scheme.LocalEquations.pullback_eqn, sectionLocalEquations_eqn]
    rw [D.pullbackEqn_sectionLocalEquations_eq_relAffSectionsMap s hfib B' z]
    rw [D.component_sectionsMapTop B' s (sigma z)]
    apply congrArg ((relCurve C B').resHom _)
    exact (D.resHom_piecesMap_eq_relAffSectionsMap B' (sigma z)
      (D.component s (sigma z))).symm
  · simpa only [BasicOpenCocycleDatum.sectionLocalEquationsOfFibrewiseRegular,
      s', hreg'] using
      (D.baseChange B').sectionLocalEquations_divEq_of_same_section s'
        W (D.baseChange B').pointedCover sigma (D.baseChange B').pieceIndex
        hsigma (fun _ => le_rfl) hreg'