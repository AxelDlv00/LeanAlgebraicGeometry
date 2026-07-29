---
author: sync
content_type: lemma
created: '2026-07-18T20:01:11'
decl: AlgebraicGeometry.thetaFieldRead_apply
docstring: The reading is the glued value against the trivialization.
file: AlgebraicJacobian/Picard/DivisorFamilyFieldDictionaryCore.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.thetaFieldRead_apply
type: lean
updated: '2026-07-29T15:31:45'
---
lemma thetaFieldRead_apply (s : relThetaSections C K π a) :
    thetaFieldRead C K π a s
      = Scheme.MeromorphicPresentation.gluedVal K (thetaFieldPresentation C K π a)
          (W := ⊤) trivial (thetaFieldGluedEquiv C K π a s) :=
  rfl