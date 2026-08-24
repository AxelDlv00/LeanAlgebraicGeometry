---
author: sync
content_type: definition
created: '2026-08-21T08:24:53'
decl: AlgebraicGeometry.jacobianData_finiteGaloisDescent
docstring: 'The same conditional quotient, packaged in the challenge-facing

  `JacobianData` interface without changing its carrier or representation.'
file: AlgebraicJacobian/Picard/Pic0FiniteGaloisJacobianData.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.jacobianData_finiteGaloisDescent
type: lean
updated: '2026-08-21T10:45:40'
---
noncomputable def jacobianData_finiteGaloisDescent
    (C : Over (Spec (CommRingCat.of K)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIrreducible C.hom]
    [FiniteDimensional K L] [IsGalois K L]
    {J : Over (Spec (CommRingCat.of L))}
    (rep : (pic0TypeFunctor ((baseChange K L).obj C)).RepresentableBy J)
    (hlft : LocallyOfFiniteType J.hom) (hqc : QuasiCompact J.hom)
    [((pic0SemilinearGalActionOfRepresentableBy C rep).OrbitsInAffineOpen)] :
    JacobianData C :=
  (picRepDatum_finiteGaloisDescent C rep hlft).toJacobianData
    (quasiCompact_pic0FiniteGaloisDescent C rep hqc)

/-! ## Finite-stage projective specialization -/

variable {k F : Type u} [Field k] [Field F]
variable [Algebra F k] [Algebra.IsAlgebraic F k]