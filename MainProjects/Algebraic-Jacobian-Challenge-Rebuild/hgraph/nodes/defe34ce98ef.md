---
author: sync
content_type: lemma
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.DivisorAdaptation.pulledToOvlRight_mk
file: AlgebraicJacobian/Picard/DivisorFamilyPullbackCert.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.DivisorAdaptation.pulledToOvlRight_mk
type: lean
updated: '2026-07-31T20:14:51'
---
lemma pulledToOvlRight_mk (i j : A.index)
    (x : Γ(relCurve C R', (A.toFinCoverData.baseChange R').pieces j)) :
    A.pulledToOvlRight R' i j (Ideal.Quotient.mk (Ideal.span {A.pulledEqn R' j}) x) =
      Ideal.Quotient.mk (A.pulledOvlIdeal R' i j) (relResAlgHom C R' inf_le_right x) :=
  rfl