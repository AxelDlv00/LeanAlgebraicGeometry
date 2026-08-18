/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Descent.QuasiProjectiveFiniteInAffine
import AlgebraicJacobian.Picard.Pic0FiniteStageGluedOver
import AlgebraicJacobian.Picard.Pic0GaloisAction

/-!
# Orbit affineness for the finite-stage Picard glue

A projective finite-stage glued representative has the finite-in-affine property, so every
orbit of its canonical finite-Galois action lies in an affine open.  This file records that
producer at the exact carrier `P.gluedOver` used by finite-stage descent.

The projectivity argument is deliberately explicit.  The affine-chart glue package does not
yet construct `P.gluedMap.IsProjective`; that geometric certificate remains the sole input of
this bridge rather than being hidden in an auxiliary class.
-/

set_option autoImplicit false

universe u

open CategoryTheory
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

/-- Projectivity of the finite-stage glued morphism supplies orbit affineness for the
canonical action attached to a representation of Picard zero by that exact glue. -/
@[implicit_reducible]
noncomputable def pic0FiniteStageOrbitsInAffineOpen_of_isProjective
    (P : Pic0FiniteStageGluePackage Ck F)
    [Algebra K P.N.1] [FiniteDimensional K P.N.1] [IsGalois K P.N.1]
    (rep : (pic0TypeFunctor ((baseChange K P.N.1).obj C)).RepresentableBy P.gluedOver)
    (hproj : P.gluedMap.IsProjective) :
    (pic0SemilinearGalActionOfRepresentableBy C rep).OrbitsInAffineOpen :=
  Scheme.orbitsInAffineOpen_of_finiteInAffine _
    (Scheme.finiteInAffine_of_isProjective hproj)

end

end AlgebraicGeometry
