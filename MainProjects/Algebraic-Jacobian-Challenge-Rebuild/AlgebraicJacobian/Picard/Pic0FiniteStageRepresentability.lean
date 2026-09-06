/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0Functor
import AlgebraicJacobian.Picard.Pic0FiniteStageGluedOver
import AlgebraicJacobian.Picard.Pic0RepresentableByTransport

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

/-! ## Extracting the binder-free family from a certificate -/

/-- A finite-stage `RepresentableBy` certificate already contains the required
all-test equivalences.  This adapter exposes them at the exact carrier without
introducing any chart or affine-test binder. -/
noncomputable def Pic0FiniteStageTestEquiv.ofRepresentableBy
    (rep : (pic0TypeFunctor ((baseChange K P.N.1).obj C)).RepresentableBy
      P.gluedOver) :
    Pic0FiniteStageTestEquiv C Ck P where
  homEquiv := fun T => rep.homEquiv
  homEquiv_comp := by
    intro T T' f g
    exact rep.homEquiv_comp f g

/-- An explicit identification of the finite-stage carrier with a scalar extension of
an already represented Picard-zero object supplies the binder-free finite-stage family.

The carrier is retained literally as `P.gluedOver`; all finite-Galois descent and
geometric content is concentrated in the displayed isomorphism. -/
noncomputable def Pic0FiniteStageTestEquiv.ofBaseChangeRepresentableBy
    {J : Over (Spec (.of K))}
    (rep : (pic0TypeFunctor C).RepresentableBy J)
    (carrierIso :
      (Over.pullback
        (Spec.map (CommRingCat.ofHom (algebraMap K P.N.1)))).obj J ≅
        P.gluedOver) :
    Pic0FiniteStageTestEquiv C Ck P :=
  Pic0FiniteStageTestEquiv.ofRepresentableBy C Ck P
    (pic0RepresentableBy_of_baseChangeObjectIso C rep carrierIso)

@[simp]
theorem Pic0FiniteStageTestEquiv.ofRepresentableBy_universalClass
    (rep : (pic0TypeFunctor ((baseChange K P.N.1).obj C)).RepresentableBy
      P.gluedOver) :
    (Pic0FiniteStageTestEquiv.ofRepresentableBy C Ck P rep).universalClass =
      rep.homEquiv (𝟙 P.gluedOver) :=
  rfl

/-! ## The exact-carrier universal class -/

/-- The class represented by the identity of the finite-stage carrier.

This is the finite-stage analogue of the universal class extracted from a
`RepresentableBy` certificate.  Keeping it attached to the test-equivalence
data makes the carrier and its field of definition explicit at the descent
boundary. -/
noncomputable def Pic0FiniteStageTestEquiv.universalClass
    (data : Pic0FiniteStageTestEquiv C Ck P) :
    pic0Subgroup ((baseChange K P.N.1).obj C) P.gluedOver :=
  data.homEquiv P.gluedOver (𝟙 P.gluedOver)

/-- Every value of the test equivalence is pullback of the pinned universal
class on the literal carrier `P.gluedOver`. -/
theorem Pic0FiniteStageTestEquiv.homEquiv_eq_pic0Map_universalClass
    (data : Pic0FiniteStageTestEquiv C Ck P)
    {T : Over (Spec (.of P.N.1))} (f : T ⟶ P.gluedOver) :
    data.homEquiv T f =
      pic0Map ((baseChange K P.N.1).obj C) f data.universalClass := by
  simpa [Pic0FiniteStageTestEquiv.universalClass] using
    (data.homEquiv_comp f (𝟙 P.gluedOver))

/-- Two finite-stage test equivalences with the same universal class agree on every
test object.  Thus the descent producer only has to identify the class represented by
the identity of `P.gluedOver`; naturality then determines the whole Yoneda family. -/
theorem Pic0FiniteStageTestEquiv.homEquiv_eq_of_universalClass_eq
    (data data' : Pic0FiniteStageTestEquiv C Ck P)
    (h : data.universalClass = data'.universalClass)
    {T : Over (Spec (.of P.N.1))} (f : T ⟶ P.gluedOver) :
    data.homEquiv T f = data'.homEquiv T f := by
  rw [data.homEquiv_eq_pic0Map_universalClass,
    data'.homEquiv_eq_pic0Map_universalClass, h]

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
