/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0Functor
import AlgebraicJacobian.Picard.Pic0FiniteStageGluedOver

/-!
# Exact-carrier finite-stage representability handoff

The finite-stage glue package fixes a literal carrier `P.gluedOver` over the
finite field `P.N.1`.  This module records the remaining binder-free handoff
at that carrier.  The all-test equivalences and their pullback naturality are
explicit inputs: this declaration does not replace the finite-Galois descent
producer that must construct them.
-/

set_option autoImplicit false

universe u

open CategoryTheory

namespace AlgebraicGeometry

noncomputable section

private noncomputable def pic0RepresentableBy_of_testEquiv
    {k : Type u} [Field k] (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIrreducible C.hom]
    {J : Over (Spec (.of k))}
    (testEquiv : ∀ T : Over (Spec (.of k)),
      (T ⟶ J) ≃ pic0Subgroup C T)
    (testEquiv_comp : ∀ {T T' : Over (Spec (.of k))}
      (f : T' ⟶ T) (g : T ⟶ J),
      testEquiv T' (f ≫ g) = pic0Map C f (testEquiv T g)) :
    (pic0TypeFunctor C).RepresentableBy J where
  homEquiv := fun {T} => testEquiv T
  homEquiv_comp := by
    intro T T' f g
    exact testEquiv_comp f g

variable {K k F : Type u} [Field K] [Field k] [Field F]
  [Algebra F k] [Algebra.IsAlgebraic F k]

variable (C : Over (Spec (.of K)))
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]

variable (Ck : Over (Spec (.of k)))
variable [SmoothOfRelativeDimension 1 Ck.hom] [IsProper Ck.hom]
  [GeometricallyIrreducible Ck.hom] [IsSepClosed k]

variable (P : Pic0FiniteStageGluePackage Ck F)
variable [Algebra K P.N.1]

/-- The binder-free data needed to represent the base-changed Picard-zero
functor on the exact finite-stage carrier `P.gluedOver`.

The naturality field is stated for arbitrary tests in the over-category, so no
affineness or hidden chart binder is introduced at this boundary.
-/
structure Pic0FiniteStageTestEquiv where
  homEquiv : ∀ T : Over (Spec (.of P.N.1)),
    (T ⟶ P.gluedOver) ≃
      pic0Subgroup ((baseChange K P.N.1).obj C) T
  homEquiv_comp : ∀ {T T' : Over (Spec (.of P.N.1))}
    (f : T' ⟶ T) (g : T ⟶ P.gluedOver),
    homEquiv T' (f ≫ g) =
      pic0Map ((baseChange K P.N.1).obj C) f (homEquiv T g)

/-- The exact finite-stage carrier is a `RepresentableBy` object once the
all-test pullback equivalences have been constructed. -/
noncomputable def pic0RepresentableBy_finiteStage_of_testEquiv
    (data : Pic0FiniteStageTestEquiv C Ck P) :
    (pic0TypeFunctor ((baseChange K P.N.1).obj C)).RepresentableBy P.gluedOver :=
  pic0RepresentableBy_of_testEquiv
    ((baseChange K P.N.1).obj C)
    data.homEquiv data.homEquiv_comp

end

end AlgebraicGeometry
