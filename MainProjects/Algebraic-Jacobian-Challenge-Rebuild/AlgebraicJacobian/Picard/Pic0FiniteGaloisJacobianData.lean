/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Descent.FiniteGaloisQuotientGeometry
import AlgebraicJacobian.Picard.Pic0FiniteGaloisRepresentable
import AlgebraicJacobian.Picard.Pic0FiniteStageOrbitAffine
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

/-! ## Finite-stage projective specialization -/

variable {k F : Type u} [Field k] [Field F]
variable [Algebra F k] [Algebra.IsAlgebraic F k]

/-- Finite-stage projectivity packages the conditional finite Galois descent as a
`PicRepDatum` over the original field.

This is still a conditional producer: the projectivity of the finite-stage glued carrier is
the visible geometric input which supplies orbit-affineness for the canonical semilinear
action. -/
noncomputable def picRepDatum_finiteStageGaloisDescent_of_isProjective
    (C : Over (Spec (CommRingCat.of K)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIrreducible C.hom]
    (Ck : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 Ck.hom] [IsProper Ck.hom]
    [GeometricallyIrreducible Ck.hom] [IsSepClosed k]
    (P : Pic0FiniteStageGluePackage Ck F)
    [Algebra K P.N.1] [FiniteDimensional K P.N.1] [IsGalois K P.N.1]
    (rep : (pic0TypeFunctor ((baseChange K P.N.1).obj C)).RepresentableBy P.gluedOver)
    (hproj : P.gluedMap.IsProjective) :
    PicRepDatum K K C := by
  letI : (pic0SemilinearGalActionOfRepresentableBy C rep).OrbitsInAffineOpen :=
    pic0FiniteStageOrbitsInAffineOpen_of_isProjective C Ck P rep hproj
  exact
    { J := StableAffineOpen.gluedQuotientOver
        (pic0SemilinearGalActionOfRepresentableBy C rep)
      rep := pic0RepresentableBy_finiteStageGaloisDescent_of_isProjective C Ck P rep hproj
      lft :=
        locallyOfFiniteType_pic0FiniteGaloisDescent C rep
          (by
            change LocallyOfFiniteType P.gluedMap
            infer_instance) }

/-- Finite-stage projectivity packages the conditional finite Galois descent directly as
`JacobianData`.  The finite-stage glued carrier is already locally of finite type and
quasi-compact; projectivity is only used to discharge the orbit-affineness input to the
Galois quotient. -/
noncomputable def jacobianData_finiteStageGaloisDescent_of_isProjective
    (C : Over (Spec (CommRingCat.of K)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIrreducible C.hom]
    (Ck : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 Ck.hom] [IsProper Ck.hom]
    [GeometricallyIrreducible Ck.hom] [IsSepClosed k]
    (P : Pic0FiniteStageGluePackage Ck F)
    [Algebra K P.N.1] [FiniteDimensional K P.N.1] [IsGalois K P.N.1]
    (rep : (pic0TypeFunctor ((baseChange K P.N.1).obj C)).RepresentableBy P.gluedOver)
    (hproj : P.gluedMap.IsProjective) :
    JacobianData C :=
  (picRepDatum_finiteStageGaloisDescent_of_isProjective C Ck P rep hproj).toJacobianData
    (by
      letI : (pic0SemilinearGalActionOfRepresentableBy C rep).OrbitsInAffineOpen :=
        pic0FiniteStageOrbitsInAffineOpen_of_isProjective C Ck P rep hproj
      exact quasiCompact_pic0FiniteGaloisDescent C rep
        (by
          change QuasiCompact P.gluedMap
          infer_instance))

end

end AlgebraicGeometry
