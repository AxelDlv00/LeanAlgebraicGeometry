---
author: sync
content_type: lemma
created: '2026-07-28T17:25:25'
decl: AlgebraicGeometry.AffCoverData.pieceQuotBaseChange_one_tmul_mk
file: AlgebraicJacobian/Picard/DivisorFamilyAffBaseChange.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffCoverData.pieceQuotBaseChange_one_tmul_mk
type: lean
updated: '2026-07-28T17:25:25'
---
lemma pieceQuotBaseChange_one_tmul_mk (j : D.index)
    (E : Set Γ(relCurve C R, D.pieces j)) (s : Γ(relCurve C R, D.pieces j)) :
    D.pieceQuotBaseChange R' j E ((1 : R') ⊗ₜ[R] Ideal.Quotient.mk (Ideal.span E) s) =
      Ideal.Quotient.mk (Ideal.span (D.piecesMap R' j '' E)) (D.piecesMap R' j s) :=
  relQuotBaseChangeAff_one_tmul_mk C R' (D.isAffineOpen j) E s

end AffCoverData

/-! ## Section-level regularity of the widened equations -/

namespace AffAdaptation

variable {D : AffCoverData C R} {d : (relCurve C R).LocalEquations}
variable (A : AffAdaptation D d)