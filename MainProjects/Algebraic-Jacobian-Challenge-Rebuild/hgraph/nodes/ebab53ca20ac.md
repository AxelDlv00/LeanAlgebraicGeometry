---
author: sync
content_type: theorem
created: '2026-08-02T04:08:38'
decl: AlgebraicGeometry.Scheme.LocalEquations.range_relCurveMap_residueField_aff
docstring: 'The residue-field base change maps onto the corresponding topological
  fibre of the

  relative curve.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffFibreSupport.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.Scheme.LocalEquations.range_relCurveMap_residueField_aff
type: lean
updated: '2026-08-02T07:12:50'
---
private theorem range_relCurveMap_residueField_aff (p : PrimeSpectrum R) :
    Set.range (relCurveMap C R p.asIdeal.ResidueField).base =
      {z : relCurve C R | relCurveBasePoint C R z = p} := by
  ext z
  constructor
  · rintro ⟨x, rfl⟩
    exact relCurveBasePoint_relCurveMap_residueField C R p x
  · intro hz
    let z' : relCurve C p.asIdeal.ResidueField :=
      Eq.ndrec
        (motive := fun q : PrimeSpectrum R => relCurve C q.asIdeal.ResidueField)
        (relCurveResiduePoint C R z) hz
    refine ⟨z', ?_⟩
    exact (relCurveMap_residueField_cast C R hz
      (relCurveResiduePoint C R z)).trans
      (relCurveMap_relCurveResiduePoint C R z)

variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]