/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageOrbitAffine
import AlgebraicJacobian.Picard.Pic0FiniteGaloisRepresentable

/-!
# Stable affine covers from the finite-stage Picard glue

This module immediately consumes finite-stage orbit affineness in the stable-cover engine and
in the finite-Galois Picard representability theorem.  The only additional geometric input is
the projectivity certificate exposed by `pic0FiniteStageOrbitsInAffineOpen_of_isProjective`.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite
open AlgebraicJacobian.GaloisDescent

namespace AlgebraicGeometry

noncomputable section

variable {K k F : Type u} [Field K] [Field k] [Field F]
variable [Algebra F k] [Algebra.IsAlgebraic F k]
variable (C : Over (Spec (.of K)))
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]
variable (Ck : Over (Spec (.of k)))
variable [SmoothOfRelativeDimension 1 Ck.hom] [IsProper Ck.hom]
  [GeometricallyIrreducible Ck.hom] [IsSepClosed k]
variable (P : Pic0FiniteStageGluePackage Ck F)
variable [Algebra K P.N.1] [FiniteDimensional K P.N.1] [IsGalois K P.N.1]

/-- The finite-stage projectivity certificate produces the stable affine cover used by the
finite-Galois quotient construction. -/
@[implicit_reducible]
noncomputable def pic0FiniteStageHasStableAffineCover_of_isProjective
    (rep : (pic0TypeFunctor ((baseChange K P.N.1).obj C)).RepresentableBy P.gluedOver)
    (hproj : P.gluedMap.IsProjective) :
    HasStableAffineCover K P.N.1
      (pic0SemilinearGalActionOfRepresentableBy C rep) := by
  letI : (pic0SemilinearGalActionOfRepresentableBy C rep).OrbitsInAffineOpen :=
    pic0FiniteStageOrbitsInAffineOpen_of_isProjective C Ck P rep hproj
  infer_instance

/-- Consume the finite-stage orbit-affineness producer in the finite-Galois Picard descent
theorem.  The resulting quotient represents Picard zero over the original field. -/
noncomputable def pic0RepresentableBy_finiteStageGaloisDescent_of_isProjective
    (rep : (pic0TypeFunctor ((baseChange K P.N.1).obj C)).RepresentableBy P.gluedOver)
    (hproj : P.gluedMap.IsProjective) :
    (pic0TypeFunctor C).RepresentableBy
      (StableAffineOpen.gluedQuotientOver
        (pic0SemilinearGalActionOfRepresentableBy C rep)) := by
  letI : (pic0SemilinearGalActionOfRepresentableBy C rep).OrbitsInAffineOpen :=
    pic0FiniteStageOrbitsInAffineOpen_of_isProjective C Ck P rep hproj
  exact pic0RepresentableBy_finiteGaloisDescent C rep

end

end AlgebraicGeometry
