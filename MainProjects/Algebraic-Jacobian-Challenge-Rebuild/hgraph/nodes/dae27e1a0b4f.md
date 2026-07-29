---
author: sync
content_type: theorem
created: '2026-07-24T17:32:26'
decl: AlgebraicGeometry.ThetaGeneratorSeed.pullbackEqn_res_self_eq_relPinnedPieceSectionsMap
docstring: 'Restricting the pulled seed equation to the base-changed seed piece is
  exactly the

  side-uniform base change of the original seed equation.  This is the section-level
  bridge

  from the pulled presentation divisor to the residue-fibre reading of the pointwise
  seed.'
file: AlgebraicJacobian/Picard/DivSchemeAdaptationFibreRegular.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ThetaGeneratorSeed.pullbackEqn_res_self_eq_relPinnedPieceSectionsMap
type: lean
updated: '2026-07-29T15:31:39'
---
theorem pullbackEqn_res_self_eq_relPinnedPieceSectionsMap (hD : D.IsGenerator)
    (p : PrimeSpectrum R) (z : relCurve C p.asIdeal.ResidueField) :
    (relCurve C p.asIdeal.ResidueField).resHom
        (relPinnedSectionsMap_basicOpen (C := C) (R := R) (pi := pi)
          p.asIdeal.ResidueField
          (D.side ((relCurveMap C R p.asIdeal.ResidueField).base z))
          (D.h ((relCurveMap C R p.asIdeal.ResidueField).base z))).le
        (Scheme.LocalEquations.pullbackEqn
          (relCurveMap C R p.asIdeal.ResidueField) (D.localEquations hD) z) =
      relPinnedPieceSectionsMap (C := C) (R := R) (pi := pi)
        p.asIdeal.ResidueField
        (D.side ((relCurveMap C R p.asIdeal.ResidueField).base z))
        (D.h ((relCurveMap C R p.asIdeal.ResidueField).base z))
        (D.eqn ((relCurveMap C R p.asIdeal.ResidueField).base z)) := by
  let y : relCurve C R := (relCurveMap C R p.asIdeal.ResidueField).base z
  let hopen := relPinnedSectionsMap_basicOpen (C := C) (R := R) (pi := pi)
    p.asIdeal.ResidueField (D.side y) (D.h y)
  calc
    _ = ((relCurveMap C R p.asIdeal.ResidueField).appLE
          ((relCurve C R).basicOpen (D.h y))
          ((relCurve C p.asIdeal.ResidueField).basicOpen
            (relPinnedSectionsMap C R p.asIdeal.ResidueField pi (D.side y) (D.h y)))
          hopen.le).hom (D.eqn y) :=
      Scheme.LocalEquations.pullbackEqn_res
        (relCurveMap C R p.asIdeal.ResidueField) (D.localEquations hD) z hopen.le
    _ = _ := (relPinnedPieceSectionsMap_eq_appLE
      (C := C) (R := R) (pi := pi) p.asIdeal.ResidueField
      (D.side y) (D.h y) (D.eqn y)).symm