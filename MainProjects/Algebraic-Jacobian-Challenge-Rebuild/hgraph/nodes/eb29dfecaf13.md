---
author: sync
content_type: lemma
created: '2026-07-18T20:01:11'
decl: AlgebraicGeometry.DivisorAdaptation.stalkColEval_mk
file: AlgebraicJacobian/Picard/DivisorFamilyStalkEval.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivisorAdaptation.stalkColEval_mk
type: lean
updated: '2026-07-29T15:31:45'
---
lemma stalkColEval_mk (j : A.index) {z : relCurve C K} (hz : z ∈ A.pieces j)
    (t : Γ(relCurve C K, A.pieces j)) :
    A.stalkColEval j hz (Ideal.Quotient.mk (Ideal.span {A.eqn j}) t)
      = Ideal.Quotient.mk (d.stalkIdeal z)
          (((relCurve C K).presheaf.germ (A.pieces j) z hz).hom t) :=
  rfl