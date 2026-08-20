/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Descent.FiniteGaloisQuotientGeometry
import AlgebraicJacobian.Picard.Pic0FiniteGaloisRepresentable
import AlgebraicJacobian.Picard.JacobianDataHandoff

/-!
# Jacobian data from conditional finite Galois descent

The finite Galois quotient representing Picard zero inherits local finite type
and quasi-compactness from the chosen representer after scalar extension.  This
packages the existing conditional representability theorem into the exact
`PicRepDatum` and `JacobianData` interfaces, without hiding either the local
representer or the orbit-in-an-affine-open hypothesis.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite
open AlgebraicJacobian.GaloisDescent

namespace AlgebraicGeometry

noncomputable section

variable {K L : Type u} [Field K] [Field L] [Algebra K L]

/-- Local finite type of a Picard-zero representer descends through the glued
finite Galois quotient. -/
theorem locallyOfFiniteType_pic0FiniteGaloisDescent
    (C : Over (Spec (CommRingCat.of K)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIrreducible C.hom]
    [FiniteDimensional K L] [IsGalois K L]
    {J : Over (Spec (CommRingCat.of L))}
    (rep : (pic0TypeFunctor ((baseChange K L).obj C)).RepresentableBy J)
    (hlft : LocallyOfFiniteType J.hom)
    [((pic0SemilinearGalActionOfRepresentableBy C rep).OrbitsInAffineOpen)] :
    LocallyOfFiniteType
      (StableAffineOpen.gluedQuotientMap
        (pic0SemilinearGalActionOfRepresentableBy C rep)) := by
  letI := hlft
  exact IsGaloisQuotient.locallyOfFiniteType
    (StableAffineOpen.isGaloisQuotient_glued
      (pic0SemilinearGalActionOfRepresentableBy C rep))

/-- Quasi-compactness of a Picard-zero representer descends through the glued
finite Galois quotient. -/
theorem quasiCompact_pic0FiniteGaloisDescent
    (C : Over (Spec (CommRingCat.of K)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIrreducible C.hom]
    [FiniteDimensional K L] [IsGalois K L]
    {J : Over (Spec (CommRingCat.of L))}
    (rep : (pic0TypeFunctor ((baseChange K L).obj C)).RepresentableBy J)
    (hqc : QuasiCompact J.hom)
    [((pic0SemilinearGalActionOfRepresentableBy C rep).OrbitsInAffineOpen)] :
    QuasiCompact
      (StableAffineOpen.gluedQuotientMap
        (pic0SemilinearGalActionOfRepresentableBy C rep)) := by
  letI := hqc
  exact IsGaloisQuotient.quasiCompact
    (StableAffineOpen.isGaloisQuotient_glued
      (pic0SemilinearGalActionOfRepresentableBy C rep))

/-- The conditional finite Galois quotient, packaged as representability data
over the original field. -/
noncomputable def picRepDatum_finiteGaloisDescent
    (C : Over (Spec (CommRingCat.of K)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIrreducible C.hom]
    [FiniteDimensional K L] [IsGalois K L]
    {J : Over (Spec (CommRingCat.of L))}
    (rep : (pic0TypeFunctor ((baseChange K L).obj C)).RepresentableBy J)
    (hlft : LocallyOfFiniteType J.hom)
    [((pic0SemilinearGalActionOfRepresentableBy C rep).OrbitsInAffineOpen)] :
    PicRepDatum K K C where
  J := StableAffineOpen.gluedQuotientOver
    (pic0SemilinearGalActionOfRepresentableBy C rep)
  rep := pic0RepresentableBy_finiteGaloisDescent C rep
  lft := locallyOfFiniteType_pic0FiniteGaloisDescent C rep hlft

/-- The same conditional quotient, packaged in the challenge-facing
`JacobianData` interface without changing its carrier or representation. -/
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

end

end AlgebraicGeometry
