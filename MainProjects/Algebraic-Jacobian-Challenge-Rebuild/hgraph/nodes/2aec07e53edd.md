---
author: sync
content_type: theorem
created: '2026-08-01T13:31:19'
decl: AlgebraicGeometry.AffAdaptation.thetaToTriple_from_first_reversed
docstring: 'A section of the first piece has the same triple restriction through `(i,j)`
  and

  the reversed adjacent pair `(l,i)`.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaCoassoc.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.thetaToTriple_from_first_reversed
type: lean
updated: '2026-08-07T05:01:52'
---
theorem thetaToTriple_from_first_reversed (i j l : D.index)
    (x : A.ThetaPieceQuotient (π := π) a i) :
    A.thetaOverlapToTriple (π := π) a i j i j l
        (A.thetaTripleOpen_le_pair12 i j l)
        (A.thetaToOverlapLeft (π := π) a i j x) =
      A.thetaOverlapToTriple (π := π) a l i i j l
        (A.thetaTripleOpen_le_pair31 i j l)
        (A.thetaToOverlapRight (π := π) a l i x) := by
  induction x using Submodule.Quotient.induction_on with
  | _ s =>
      rw [A.thetaToOverlapLeft_mk, A.thetaToOverlapRight_mk,
        A.thetaOverlapToTriple_mk, A.thetaOverlapToTriple_mk,
        secRes_secRes, secRes_secRes]