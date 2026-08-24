---
author: sync
content_type: definition
created: '2026-08-14T14:17:16'
decl: AlgebraicGeometry.abelToPic0SepClosedRepresenter
docstring: 'The admissible Abel chart, viewed as a scheme morphism to the exact separably
  closed

  Picard representing scheme.'
file: AlgebraicJacobian/Picard/Pic0SepClosedJacobianData.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.abelToPic0SepClosedRepresenter
type: lean
updated: '2026-08-18T20:51:06'
---
noncomputable def abelToPic0SepClosedRepresenter (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIrreducible C.hom] [IsSepClosed k] :
    (divRepAffAdmissibleScheme C).left ⟶ (pic0_sepClosed_representableBy (C := C)).1.left :=
  yoneda.preimage (abelSigmaChartAffAdmissible C ≫
    (representableBySigmaIso (pic0_sepClosed_representableBy (C := C)).2).inv)