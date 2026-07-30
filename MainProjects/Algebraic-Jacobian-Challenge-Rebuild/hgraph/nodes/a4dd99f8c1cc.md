---
author: sync
content_type: theorem
created: '2026-07-19T14:31:14'
decl: AlgebraicGeometry.h0_relCurve_baseField
docstring: '**`hOK` at every field extension**: `h⁰(𝒪) = 1` on the fibre curve —

  `h0_moduleKSheaf` at the base-changed bundle (the `GluedSheafDatumFibre` firing

  pattern, public form of the `DivSchemeMonoBridgeRel` private lemma).'
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivAssembleKappa.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.h0_relCurve_baseField
type: lean
updated: '2026-07-30T15:46:03'
---
theorem h0_relCurve_baseField : Sheaf.h0 ((relCurve C K).moduleKSheaf K) = 1 := by
  haveI : IsProper (baseChangeBundle C K).hom := instIsProperSndLeft C K
  haveI : SmoothOfRelativeDimension 1 (baseChangeBundle C K).hom :=
    instSmoothOfRelativeDimensionSndLeft C K
  haveI : GeometricallyIrreducible (baseChangeBundle C K).hom :=
    instGeometricallyIrreducibleSndLeft C K
  exact h0_moduleKSheaf (baseChangeBundle C K)