---
author: sync
content_type: lemma
created: '2026-07-18T20:01:11'
decl: AlgebraicGeometry.thetaFieldRead_apply
docstring: The reading is the glued value against the trivialization.
file: AlgebraicJacobian/Picard/DivisorFamilyFieldDictionaryCore.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.thetaFieldRead_apply
type: lean
updated: '2026-07-30T15:28:01'
---
lemma thetaFieldRead_apply (s : relThetaSections C K π a) :
    thetaFieldRead C K π a s
      = Scheme.MeromorphicPresentation.gluedVal K (thetaFieldPresentation C K π a)
          (W := ⊤) trivial (thetaFieldGluedEquiv C K π a s) :=
  rfl