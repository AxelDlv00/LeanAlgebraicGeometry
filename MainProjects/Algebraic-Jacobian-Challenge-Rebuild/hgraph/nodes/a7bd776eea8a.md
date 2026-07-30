---
author: sync
content_type: theorem
created: '2026-07-24T14:52:03'
decl: AlgebraicGeometry.relCurveResiduePoint_map_cast
docstring: 'Every point of a residue fibre is the canonical residue lift of its image
  in the

  total relative curve, in an explicit dependent-cast spelling.'
file: AlgebraicJacobian/Picard/DivSchemeFibrePoint.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.relCurveResiduePoint_map_cast
type: lean
updated: '2026-07-30T15:46:02'
---
theorem relCurveResiduePoint_map_cast (p : PrimeSpectrum R)
    (z : relCurve C p.asIdeal.ResidueField) :
    let zR : relCurve C R := (relCurveMap C R p.asIdeal.ResidueField).base z
    let hp : relCurveBasePoint C R zR = p :=
      relCurveBasePoint_relCurveMap_residueField C R p z
    Eq.ndrec
        (motive := fun q : PrimeSpectrum R => relCurve C q.asIdeal.ResidueField)
        (relCurveResiduePoint C R zR) hp = z := by
  dsimp
  let zR : relCurve C R := (relCurveMap C R p.asIdeal.ResidueField).base z
  have hp : relCurveBasePoint C R zR = p :=
    relCurveBasePoint_relCurveMap_residueField C R p z
  let z' : relCurve C p.asIdeal.ResidueField :=
    Eq.ndrec
      (motive := fun q : PrimeSpectrum R => relCurve C q.asIdeal.ResidueField)
      (relCurveResiduePoint C R zR) hp
  have hz' : (relCurveMap C R p.asIdeal.ResidueField).base z' = zR := by
    rw [show (relCurveMap C R p.asIdeal.ResidueField).base z' =
        (relCurveMap C R (relCurveBasePoint C R zR).asIdeal.ResidueField).base
          (relCurveResiduePoint C R zR) by
      exact relCurveMap_residueField_cast C R hp (relCurveResiduePoint C R zR)]
    exact relCurveMap_relCurveResiduePoint C R zR
  apply relCurveMap_residueField_injective C R p
  calc
    (relCurveMap C R p.asIdeal.ResidueField).base z' = zR := hz'
    _ = (relCurveMap C R p.asIdeal.ResidueField).base z := rfl