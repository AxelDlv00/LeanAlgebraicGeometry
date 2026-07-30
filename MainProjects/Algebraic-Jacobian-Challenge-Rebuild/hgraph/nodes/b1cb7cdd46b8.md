---
author: sync
content_type: lemma
created: '2026-07-29T15:31:44'
decl: AlgebraicGeometry.glueThetaZero_eq_of_forall
docstring: Uniqueness, in the form the linearity proofs consume.
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaTyping.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.glueThetaZero_eq_of_forall
type: lean
updated: '2026-07-30T15:28:02'
---
lemma glueThetaZero_eq_of_forall {x : relThetaSections C R π 0} {s : Γ(relCurve C R, ⊤)}
    (h : ∀ b : Bool, (relCurve C R).resHom
        (inf_le_left : (⊤ : (relCurve C R).Opens) ⊓ relPinnedChart C R π b ≤ ⊤) s
      = relThetaResSide 0 b inf_le_right x) :
    s = glueThetaZero C R π x :=
  (existsUnique_glueThetaZero C R π x).unique h
    ((existsUnique_glueThetaZero C R π x).choose_spec.1)