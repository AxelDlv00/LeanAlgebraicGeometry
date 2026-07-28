---
author: sync
content_type: theorem
created: '2026-07-28T15:48:27'
decl: AlgebraicGeometry.isCommMonObj_of_isProper_smooth_of_package
docstring: '**Milne §I.1 Corollary 1.4 on the standard package — an abelian variety
  is

  commutative.**


  Same statement as `isCommMonObj_of_isProper_smooth`, but with the three self-product

  hypotheses discharged by §1, so it applies to any `A` carrying the project''s

  four-instance abelian-variety package.


  This is what makes `MonObj.powSum` (`Albanese/GrpObjFoldSum.lean`) usable at an

  actual abelian variety, and hence the symmetrisation step of Milne III.6.1

  available.'
file: AlgebraicJacobian/Albanese/AVSelfProduct.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.isCommMonObj_of_isProper_smooth_of_package
type: lean
updated: '2026-07-28T15:48:27'
---
theorem isCommMonObj_of_isProper_smooth_of_package (A : Over (Spec (.of kbar)))
    [GrpObj A] [IsProper A.hom] [Smooth A.hom] [GeometricallyIrreducible A.hom] :
    IsCommMonObj A := by
  haveI := geometricallyIrreducible_tensorObj_self A
  haveI := locallyOfFiniteType_tensorObj_self A
  haveI := isReduced_tensorObj_self_left A
  exact isCommMonObj_of_isProper_smooth