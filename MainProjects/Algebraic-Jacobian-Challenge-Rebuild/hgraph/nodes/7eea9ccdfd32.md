---
author: sync
content_type: theorem
created: '2026-08-01T13:31:19'
decl: AlgebraicGeometry.AffAdaptation.thetaOverlapToTriple_smulColength
docstring: 'Pair-to-triple theta restriction is semilinear for the induced map on
  intrinsic

  divisor quotient rings.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaCoassoc.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.thetaOverlapToTriple_smulColength
type: lean
updated: '2026-08-02T07:12:51'
---
theorem thetaOverlapToTriple_smulColength
    (p q i j l : D.index)
    (h : A.thetaTripleOpen i j l ≤ D.pieces p ⊓ D.pieces q)
    (c : A.ovlColength p q)
    (x : A.ThetaOverlapQuotient (π := π) a p q) :
    A.thetaOverlapToTriple (π := π) a p q i j l h (c • x) =
      A.ovlToTriple p q i j l h c •
        A.thetaOverlapToTriple (π := π) a p q i j l h x := by
  obtain ⟨r, rfl⟩ := Ideal.Quotient.mk_surjective c
  change A.thetaOverlapToTriple (π := π) a p q i j l h (r • x) =
    relResAlgHom C R h r •
      A.thetaOverlapToTriple (π := π) a p q i j l h x
  exact (A.thetaOverlapToTriple (π := π) a p q i j l h).map_smulₛₗ r x