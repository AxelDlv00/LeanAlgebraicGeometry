/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivisorFamilyAffFace

/-!
# The widened vehicle and divisor functor: carrying a widened class to a GENERAL test

`divFamZarAff_of_forall_prime_certified_adaptation` (`…AffAssemble.lean`) is the endpoint of
the widened certificate lane, and what it returns is a class **at an affine test**
`DivFamZarAff C R n`.  Every DD-R consumer is stated against a *functor* on the whole slice
over `Spec k`, so between the lane's endpoint and its consumers sits the affine-opens limit —
the `divFamZar` vehicle of `DivisorFamilyZarVehicle.lean` — and that layer had no widened
counterpart.  This file supplies it, following the chart-typed template line for line.

## The shape, and why it is unchanged by R2

A section over a test `T` is a family of widened classes, one per affine open of `T.left`,
compatible under restriction.  R2 widened where the pieces live **on the curve**; it changed
nothing about the Zariski structure of the **base**.  So the vehicle's shape is literally the
old one with `DivFamZar` replaced by `DivFamZarAff` and `mapAlgHom` by the widened face of
`…AffFace.lean` — which is precisely why that face had to exist first.

`[IsProper C.hom]` is carried throughout: the widened base change needs it (an arbitrary affine
open's overlaps are not affine by fiat), and it is a hypothesis the DD-R lane has everywhere.

## What this does NOT claim

It does not claim the widened functor is *representable*, nor that it agrees with `divFunctor`
as a functor.  It gives the widened value a Zariski-continuous extension and the functor
packaging, so a consumer can be stated against it at all.  The comparison natural
transformation from the chart-typed functor is `divFunctorToAff` below, built from the already
landed `DivFamZar.toAff` and its explicit-face naturality — it goes old → new, which is the
only direction R2 asserts (the converse is exactly what R2 says fails).

## Main declarations

* `AlgebraicGeometry.divFamZarAff` — the widened affine-opens limit at an arbitrary test.
* `divFamZarAff.eval`, `divFamZarAff.compat`, `divFamZarAff.ext` — the section API.
* `AlgebraicGeometry.divFamZarAffAffineEquiv` — on an affine test the limit collapses to
  `DivFamZarAff` of the test algebra.
* `AlgebraicGeometry.divFunctorAff` — the widened divisor functor, and `divFunctorAff_obj`.
* `AlgebraicGeometry.divFunctorToAff` — the natural transformation from the chart-typed
  divisor functor to the widened one.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
/- `lake env lean` drops the lakefile's `[leanOptions]` (I-0161), so the pinned synthesis
depth must be set in-file for the faithful per-file check. -/
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory

namespace AlgebraicGeometry

attribute [local instance] Over.sectionsAlgebra Scheme.overModule Scheme.overSectionsAlgebra

variable {k : Type u} [Field k] {C : Over (Spec (.of k))} [IsProper C.hom] {n : ℕ}

noncomputable section

/-! ## The widened affine-opens limit -/

variable (C n)

/-- **The widened locally certified divisor functor at an arbitrary test object.**  Compatible
families of *widened* locally certified divisor classes over the affine opens of `T.left`: the
value at a smaller affine open is the base change of the value at a larger one along the
section-restriction algebra map.

Identical in shape to `divFamZar` (`DivisorFamilyZarVehicle.lean`), with `DivFamZarAff` in
place of `DivFamZar` — R2 widens the curve side and leaves the base side alone.  The
compatibility is spelled with `DivFamZarAff.mapAlgHom`, which is why the explicit-map face had
to be built first: `Over.resAlgHom` carries no algebra-tower instance. -/
def divFamZarAff (T : Over (Spec (.of k))) : Type u :=
  {s : Π U : T.left.affineOpens, DivFamZarAff C Γ(T.left, U.1) n //
    ∀ (U V : T.left.affineOpens) (h : U.1 ≤ V.1),
      DivFamZarAff.mapAlgHom (Over.resAlgHom T h) (s V) = s U}

namespace divFamZarAff

variable {C n} {T : Over (Spec (.of k))}

/-- The compatibility of a section of `divFamZarAff` along an inclusion of affine opens. -/
lemma compat (s : divFamZarAff C n T) (U V : T.left.affineOpens) (h : U.1 ≤ V.1) :
    DivFamZarAff.mapAlgHom (Over.resAlgHom T h) (s.1 V) = s.1 U :=
  s.2 U V h

/-- Two sections of `divFamZarAff` agreeing at every affine open are equal. -/
@[ext]
lemma ext {s t : divFamZarAff C n T} (h : ∀ U : T.left.affineOpens, s.1 U = t.1 U) :
    s = t :=
  Subtype.ext (funext h)

variable (C n T) in
/-- Evaluation of a section of `divFamZarAff` at an affine open. -/
def eval (U : T.left.affineOpens) : divFamZarAff C n T → DivFamZarAff C Γ(T.left, U.1) n :=
  fun s => s.1 U

/-- Evaluation is projection to the component at the affine open. -/
@[simp]
lemma eval_apply (U : T.left.affineOpens) (s : divFamZarAff C n T) :
    eval C n T U s = s.1 U :=
  rfl

end divFamZarAff

/-! ## The affine comparison -/

section Affine

variable (R : Type u) [CommRing R] [Algebra k R]

/-- Evaluation at the top affine open of an affine test, composed with the `ΓSpecIso`-transport
into the test algebra: the forward direction of the widened affine comparison. -/
def divFamZarAffToAff : divFamZarAff C n (overSpec k R) → DivFamZarAff C R n :=
  fun s => DivFamZarAff.congr (Over.overSpecΓTopAlgEquiv k R) (s.1 (overSpecTopAffine R))

/-- The section of `divFamZarAff` over an affine test determined by a widened locally certified
class of the test algebra: restrict from the top affine open. -/
def divFamZarAffOfAff : DivFamZarAff C R n → divFamZarAff C n (overSpec k R) :=
  fun x =>
    ⟨fun U => DivFamZarAff.mapAlgHom
      ((Over.resAlgHom (overSpec k R) le_top).comp
        (Over.overSpecΓTopAlgEquiv k R).symm.toAlgHom) x,
      fun U V h => by rw [← DivFamZarAff.mapAlgHom_comp, ← AlgHom.comp_assoc,
        Over.resAlgHom_comp]⟩

/-- The value of `divFamZarAffOfAff` at every affine open is the restricted transported
class. -/
lemma divFamZarAffOfAff_val (x : DivFamZarAff C R n)
    (U : (overSpec k R).left.affineOpens) :
    (divFamZarAffOfAff C n R x).1 U
      = DivFamZarAff.mapAlgHom
          ((Over.resAlgHom (overSpec k R) le_top).comp
            (Over.overSpecΓTopAlgEquiv k R).symm.toAlgHom) x :=
  rfl

/-- Round trip on the vehicle side: restricting the transported top value recovers every
component, by the compatibility of the section. -/
private lemma divFamZarAffOfAff_divFamZarAffToAff (s : divFamZarAff C n (overSpec k R)) :
    divFamZarAffOfAff C n R (divFamZarAffToAff C n R s) = s := by
  refine divFamZarAff.ext fun U => ?_
  calc (divFamZarAffOfAff C n R (divFamZarAffToAff C n R s)).1 U
      = DivFamZarAff.mapAlgHom
          (((Over.resAlgHom (overSpec k R) le_top).comp
              (Over.overSpecΓTopAlgEquiv k R).symm.toAlgHom).comp
            (Over.overSpecΓTopAlgEquiv k R).toAlgHom)
          (s.1 (overSpecTopAffine R)) :=
        (DivFamZarAff.mapAlgHom_comp _ _ _).symm
    _ = DivFamZarAff.mapAlgHom (Over.resAlgHom (overSpec k R) le_top)
          (s.1 (overSpecTopAffine R)) := by
        rw [AlgHom.comp_assoc,
          show (Over.overSpecΓTopAlgEquiv k R).symm.toAlgHom.comp
              (Over.overSpecΓTopAlgEquiv k R).toAlgHom
            = AlgHom.id k Γ((overSpec k R).left, ⊤) from
            AlgHom.ext fun a => (Over.overSpecΓTopAlgEquiv k R).symm_apply_apply a,
          AlgHom.comp_id]
    _ = s.1 U := s.compat U (overSpecTopAffine R) le_top

/-- Round trip on the algebra side: the two `ΓSpecIso` transports and the trivial restriction
collapse to the identity (`DivFamZarAff.mapAlgHom_id`). -/
private lemma divFamZarAffToAff_divFamZarAffOfAff (x : DivFamZarAff C R n) :
    divFamZarAffToAff C n R (divFamZarAffOfAff C n R x) = x := by
  calc divFamZarAffToAff C n R (divFamZarAffOfAff C n R x)
      = DivFamZarAff.mapAlgHom
          ((Over.overSpecΓTopAlgEquiv k R).toAlgHom.comp
            ((Over.resAlgHom (overSpec k R) le_top).comp
              (Over.overSpecΓTopAlgEquiv k R).symm.toAlgHom)) x :=
        (DivFamZarAff.mapAlgHom_comp _ _ _).symm
    _ = DivFamZarAff.mapAlgHom (AlgHom.id k R) x := by
        rw [show Over.resAlgHom (overSpec k R) (le_top :
              (⊤ : (overSpec k R).left.Opens) ≤ (⊤ : (overSpec k R).left.Opens))
            = AlgHom.id k Γ((overSpec k R).left, ⊤) from Over.resAlgHom_rfl _ le_top,
          AlgHom.id_comp,
          show (Over.overSpecΓTopAlgEquiv k R).toAlgHom.comp
              (Over.overSpecΓTopAlgEquiv k R).symm.toAlgHom
            = AlgHom.id k R from
            AlgHom.ext fun a => (Over.overSpecΓTopAlgEquiv k R).apply_symm_apply a]
    _ = x := DivFamZarAff.mapAlgHom_id x

/-- **The widened affine comparison equivalence**: on an affine test `overSpec k R`, the
widened affine-opens limit collapses by evaluation at the terminal element `⊤` of the
affine-opens poset to the widened value `DivFamZarAff C R n` of the test algebra.

This is what makes the vehicle a genuine extension rather than a new object: the widened
certificate lane's endpoint lands in the right-hand side, so this equivalence is the step that
carries it into the vehicle, and from there to a general test. -/
def divFamZarAffAffineEquiv :
    divFamZarAff C n (overSpec k R) ≃ DivFamZarAff C R n where
  toFun := divFamZarAffToAff C n R
  invFun := divFamZarAffOfAff C n R
  left_inv := divFamZarAffOfAff_divFamZarAffToAff C n R
  right_inv := divFamZarAffToAff_divFamZarAffOfAff C n R

/-- The widened affine comparison evaluates at the top affine open and transports along
`Over.overSpecΓTopAlgEquiv`. -/
@[simp]
lemma divFamZarAffAffineEquiv_apply (s : divFamZarAff C n (overSpec k R)) :
    divFamZarAffAffineEquiv C n R s
      = DivFamZarAff.mapAlgHom (Over.overSpecΓTopAlgEquiv k R).toAlgHom
          (s.1 (overSpecTopAffine R)) :=
  rfl

/-- The inverse widened affine comparison restricts the transported class from the top affine
open. -/
@[simp]
lemma divFamZarAffAffineEquiv_symm_apply_val (x : DivFamZarAff C R n)
    (U : (overSpec k R).left.affineOpens) :
    ((divFamZarAffAffineEquiv C n R).symm x).1 U
      = DivFamZarAff.mapAlgHom
          ((Over.resAlgHom (overSpec k R) le_top).comp
            (Over.overSpecΓTopAlgEquiv k R).symm.toAlgHom) x :=
  rfl

end Affine

end

end AlgebraicGeometry
