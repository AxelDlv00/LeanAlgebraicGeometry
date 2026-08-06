---
author: sync
content_type: theorem
created: '2026-08-07T02:08:03'
decl: AlgebraicGeometry.PicRankOneLocalPresentation.baseOpenDatumSectionLocalEquations_divEq_of_unit
docstring: 'A localized unit relating two tied datum sections transports the resulting
  local equations by

  pointwise unit rescaling on the canonical pointed cover.'
file: AlgebraicJacobian/Picard/Pic0RankOneLocalDivisor.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PicRankOneLocalPresentation.baseOpenDatumSectionLocalEquations_divEq_of_unit
type: lean
updated: '2026-08-07T05:01:57'
---
theorem baseOpenDatumSectionLocalEquations_divEq_of_unit
    (P : PicRankOneLocalPresentation pi lam)
    [IsNoetherianRing P.cover.Carrier]
    (f : P.cover.Carrier)
    (y y' : Sheaf.HModule P.datum.sheaf 0)
    (hy : ∀ p : PrimeSpectrum P.cover.Carrier, f ∉ p.asIdeal →
      (y ⊗ₜ (1 : p.asIdeal.ResidueField) :
        Sheaf.HModule P.datum.sheaf 0 ⊗[P.cover.Carrier]
          p.asIdeal.ResidueField) ≠ 0)
    (hy' : ∀ p : PrimeSpectrum P.cover.Carrier, f ∉ p.asIdeal →
      (y' ⊗ₜ (1 : p.asIdeal.ResidueField) :
        Sheaf.HModule P.datum.sheaf 0 ⊗[P.cover.Carrier]
          p.asIdeal.ResidueField) ≠ 0)
    (v : (Localization.Away f)ˣ)
    (hsec : P.datumSectionBaseChange (Localization.Away f) y' =
      (v : Localization.Away f) • P.datumSectionBaseChange (Localization.Away f) y) :
    Scheme.LocalEquations.DivEq
      (P.baseOpenDatumSectionLocalEquations f y hy)
      (P.baseOpenDatumSectionLocalEquations f y' hy') := by
  let B := Localization.Away f
  let D := P.datum.baseChange B
  let s : ↥(gluedSubmodule B D.pieces D.unit ⊤) := P.datumSectionBaseChange B y
  let s' : ↥(gluedSubmodule B D.pieces D.unit ⊤) := P.datumSectionBaseChange B y'
  have hs : s' = (v : B) • s := hsec
  have hcomp : ∀ j : D.index, D.component s' j = (v : B) • D.component s j := by
    intro j
    calc
      D.component s' j = D.component ((v : B) • s) j := by
        exact congrArg (fun t => D.component t j) hs
      _ = (v : B) • D.component s j :=
        baseChange_component_smul (C := C) (pi := pi) D (v : B) s j
  simp only [baseOpenDatumSectionLocalEquations,
    sectionLocalEquationsOfDatumSectionBaseChange]
  apply Scheme.LocalEquations.DivEq.symm
  dsimp [BasicOpenCocycleDatum.sectionLocalEquationsOfFibrewiseRegular,
    BasicOpenCocycleDatum.sectionLocalEquations]
  refine ⟨D.pointedCover, le_rfl, le_rfl, ?_⟩
  intro x
  let a : B →+* Γ(relCurve C B, D.pointedCover.opens x) :=
    (relCurve C B).overAlgebraMap B (D.pointedCover.opens x)
  refine ⟨Units.map a.toMonoidHom v, ?_⟩
  simp only [hs]
  rw [hcomp]
  simp only [Scheme.overModule_smul_def]
  change (relCurve C B).resHom _ ((relCurve C B).resHom _ _) =
    (Units.map a.toMonoidHom v : Γ(relCurve C B, D.pointedCover.opens x)) *
      (relCurve C B).resHom _ ((relCurve C B).resHom _ _)
  simp only [map_mul, Scheme.resHom_resHom]
  congr 1
  change (relCurve C B).resHom _ ((relCurve C B).overAlgebraMap B _ (v : B)) =
    a (v : B)
  exact (relCurve C B).overAlgebraMap_apply_res B
    (homOfLE (le_of_eq (D.pointedCover_opens x))).op (v : B)

set_option maxHeartbeats 800000 in
-- The unique-unit wrapper reuses the preceding non-vacuous generator and section bridges.