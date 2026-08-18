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

An immersion of the finite-stage glued representative into finite relative projective space
gives the finite-in-affine property, so every orbit of its canonical finite-Galois action lies
in an affine open.  This file records both producers at the exact carrier `P.gluedOver` used by
finite-stage descent.  The projectivity entry point remains as a compatibility wrapper.
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

/-- A finite-dimensional projective-space immersion makes the finite-stage glue
`FiniteInAffine`. -/
theorem pic0FiniteStageFiniteInAffine_of_isImmersion
    (P : Pic0FiniteStageGluePackage Ck F)
    {n : Type u} [Finite n]
    (i : P.glueData.glued ⟶ ℙ(n; Spec (.of P.N.1)))
    (hi : IsImmersion i) :
    Scheme.FiniteInAffine P.glueData.glued := by
  letI : IsImmersion i := hi
  exact Scheme.finiteInAffine_of_isImmersion i
    (Scheme.finiteInAffine_projectiveSpace n (Spec (.of P.N.1)))

/-- A finite-dimensional projective-space immersion supplies orbit affineness for the
canonical action attached to a representation of Picard zero by the finite-stage glue. -/
@[implicit_reducible]
noncomputable def pic0FiniteStageOrbitsInAffineOpen_of_isImmersion
    (P : Pic0FiniteStageGluePackage Ck F)
    [Algebra K P.N.1] [FiniteDimensional K P.N.1] [IsGalois K P.N.1]
    (rep : (pic0TypeFunctor ((baseChange K P.N.1).obj C)).RepresentableBy P.gluedOver)
    {n : Type u} [Finite n]
    (i : P.glueData.glued ⟶ ℙ(n; Spec (.of P.N.1)))
    (hi : IsImmersion i) :
    (pic0SemilinearGalActionOfRepresentableBy C rep).OrbitsInAffineOpen :=
  Scheme.orbitsInAffineOpen_of_finiteInAffine _
    (pic0FiniteStageFiniteInAffine_of_isImmersion Ck P i hi)

/-- Compatibility wrapper deriving the immersion input from projectivity of the finite-stage
glued morphism. -/
@[implicit_reducible]
noncomputable def pic0FiniteStageOrbitsInAffineOpen_of_isProjective
    (P : Pic0FiniteStageGluePackage Ck F)
    [Algebra K P.N.1] [FiniteDimensional K P.N.1] [IsGalois K P.N.1]
    (rep : (pic0TypeFunctor ((baseChange K P.N.1).obj C)).RepresentableBy P.gluedOver)
    (hproj : P.gluedMap.IsProjective) :
    (pic0SemilinearGalActionOfRepresentableBy C rep).OrbitsInAffineOpen := by
  obtain ⟨n, hn, i, hi, -⟩ := hproj
  letI : Finite n := hn
  letI : IsClosedImmersion i := hi
  exact pic0FiniteStageOrbitsInAffineOpen_of_isImmersion C Ck P rep i
    (inferInstance : IsImmersion i)

end

end AlgebraicGeometry
