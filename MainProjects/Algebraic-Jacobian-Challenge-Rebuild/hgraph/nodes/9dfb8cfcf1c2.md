---
author: sync
content_type: lemma
created: '2026-07-28T17:25:25'
decl: AlgebraicGeometry.AffAdaptation.toOvlRight_mk'
docstring: The right overlap-restriction map on a residue class.
file: AlgebraicJacobian/Picard/DivisorFamilyAffCert.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.AffAdaptation.toOvlRight_mk'
type: lean
updated: '2026-07-30T15:46:03'
---
private lemma toOvlRight_mk' (i j : D.index) (t : Γ(relCurve C R, D.pieces j)) :
    A.toOvlRight i j (Ideal.Quotient.mk (Ideal.span {A.eqn j}) t) =
      Ideal.Quotient.mk (A.ovlIdeal i j) (relResAlgHom C R inf_le_right t) :=
  rfl

variable (hinf : ∀ i j : D.index, IsAffineOpen (D.pieces i ⊓ D.pieces j))