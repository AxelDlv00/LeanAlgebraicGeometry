/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0RigidityAffineReduction
import AlgebraicJacobian.Picard.PicEtAffZariskiSep

/-!
# THE RING CASE OF THE `pic⁰` VANISHING IS ZARISKI-LOCAL ON THE TEST RING

The surviving obligation of the whole vanishing route to a `JacobianData` is a statement at
an **arbitrary** `k`-algebra `A`, in either of two interderivable spellings:

* `Subsingleton (pic0Subgroup C (overSpec k A))` — consumed by
  `jacobianData_of_overSpec_subsingleton` (`Pic0VanishingAffineReduction.lean:269`);
* ring-level field-point rigidity `hrigAff` — consumed by `jacobianData_of_rigidityAff`
  (`Pic0RigidityAffineReduction.lean:190`).

This file attacks the **quantifier** rather than the content: both spellings are Zariski-local
on `Spec A`.  The input is the *separation* half of the landed Zariski sheaf property of the
plus construction, `PicEtAff.eq_of_away_eq` (`PicEtAffZariskiSep.lean:137`) — nothing is glued,
so the gluing half (`PicEtAffZariskiGlue.lean`) is not used.

## What this is and is not

It is a reduction of the *test algebra*, not of the geometry.  It does **not** prove the ring
case: it says the ring case at `A` follows from the ring case at the members of any finite
covering family of localizations of `A`.  A lane that computes `Pic` over local rings — where
seminormality, and hence the Traverso–Swan obstruction measured at
`AJCR.w4-rep.datum.p1-witness`, is a far weaker demand than over a general `A` — gets the
general case from these lemmas.

No new hypothesis is added to any existing statement: every theorem below either takes the
covering data as an explicit argument or is an unconditional statement about a degenerate ring.

## The degenerate test ring, and why it is here rather than in a probe

`hrigAff`'s antecedent is **vacuous** at a subsingleton `A` (there is no `k`-algebra map from
the zero ring to a field), so the hypothesis demands `q = 1` for free there.  That made the
subsingleton ring the cheapest potential *refutation* site for the affine spelling, and it was
recorded as genuinely unchecked (inbox `I-1655`, author addendum).  It is now checked, and it
goes the other way: `subsingleton_picEtAff_of_subsingleton` proves the plus construction **is**
trivial there, unconditionally and with no genus or curve input.  So the affine spelling is not
refuted at its cheapest site; it is *satisfied* there.

The chain is four steps, each of which is about the vehicle rather than the curve: `Spec` of a
subsingleton ring has empty carrier (`PrimeSpectrum.isEmpty_iff_subsingleton`), hence so does
the product `C ⊗ overSpec k A` (project along `snd`), hence its Čech Picard group is trivial
(the landed `Scheme.CechPic.subsingleton_of_subsingleton`, `Pic.lean:257`) and so is the
quotient `relPic`; and every étale cover of a subsingleton ring is again subsingleton, because
its spectrum maps *onto* the empty spectrum.

## Main declarations

* `AlgebraicGeometry.PicEtAff.subsingleton_of_away` — **the reduction, `Subsingleton`
  spelling**: triviality of the plus construction at each member of a finite covering family
  of localizations gives it at `A`.
* `AlgebraicGeometry.PicEtAff.rigidity_of_away` — **the reduction, rigidity spelling**: the
  `hrigAff` clause at each member of the family gives it at `A`.  Note the direction the field
  points travel: a field point of a localization `S i` restricts to one of `A` by composing
  with `A → S i`, so the antecedent at `A` supplies the antecedent at `S i` and no lifting of
  field points is needed.
* `AlgebraicGeometry.subsingleton_pic0Subgroup_overSpec_of_away` — the same reduction
  transported to the `pic0Subgroup` carrier the producers consume.
* `AlgebraicGeometry.PicEtAff.subsingleton_of_subsingleton` /
  `subsingleton_relPic_of_subsingleton` / `Algebra.EtaleCover.subsingleton_carrier` — the
  degenerate-test-ring chain, unconditional.
-/

set_option autoImplicit false

universe u

open CategoryTheory MonoidalCategory CartesianMonoidalCategory

namespace AlgebraicGeometry

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))

noncomputable section

/-! ## The degenerate test ring -/

/-- Every étale cover of a subsingleton ring has subsingleton carrier: the carrier's spectrum
maps **onto** `Spec A`, which is empty, so the carrier's spectrum is empty too. -/
theorem Algebra.EtaleCover.subsingleton_carrier {A : Type u} [CommRing A] [Subsingleton A]
    (E : Algebra.EtaleCover A) : Subsingleton E.Carrier := by
  haveI : IsEmpty (PrimeSpectrum A) :=
    PrimeSpectrum.isEmpty_iff_subsingleton.mpr ‹_›
  haveI : IsEmpty (PrimeSpectrum E.Carrier) :=
    ⟨fun p => isEmptyElim (PrimeSpectrum.comap (algebraMap A E.Carrier) p)⟩
  exact PrimeSpectrum.isEmpty_iff_subsingleton.mp ‹_›

/-- **The relative Picard group is trivial over a subsingleton test ring.**

`Spec A` is empty, so the product `C ⊗ overSpec k A` is empty (project along `snd`), so its
Čech Picard group is trivial by the landed `Scheme.CechPic.subsingleton_of_subsingleton`; the
quotient by `picFromBase` inherits it.

Uses none of the curve's geometry — this is a statement about the vehicle. -/
theorem subsingleton_relPic_of_subsingleton (A : Type u) [CommRing A] [Algebra k A]
    [Subsingleton A] : Subsingleton (relPic C (overSpec k A)) := by
  haveI : IsEmpty ↥((overSpec k A).left) := by
    show IsEmpty (PrimeSpectrum A)
    exact PrimeSpectrum.isEmpty_iff_subsingleton.mpr ‹_›
  haveI : Subsingleton ↥((C ⊗ overSpec k A).left) :=
    ⟨fun x _ => isEmptyElim ((snd C (overSpec k A)).left.base x)⟩
  haveI := Scheme.CechPic.subsingleton_of_subsingleton ((C ⊗ overSpec k A).left)
  exact ⟨fun x y => by
    induction x using relPic.ind with | mk L =>
    induction y using relPic.ind with | mk M =>
    exact congrArg (relPicMk C (overSpec k A)) (Subsingleton.elim L M)⟩

/-- The `A`-algebra map into a subsingleton `A`-algebra: everything goes to `0`.  Needed
because two plus-class representatives over a subsingleton base live on *different* covers,
and `mk_eq_mk_iff` wants a common refinement. -/
def toSubsingletonAlgHom (A : Type u) [CommRing A] (R S : Type u)
    [CommRing R] [CommRing S] [Algebra A R] [Algebra A S] [Subsingleton S] :
    R →ₐ[A] S where
  toFun _ := 0
  map_one' := Subsingleton.elim _ _
  map_mul' _ _ := Subsingleton.elim _ _
  map_zero' := Subsingleton.elim _ _
  map_add' _ _ := Subsingleton.elim _ _
  commutes' _ := Subsingleton.elim _ _

/-- **THE PLUS CONSTRUCTION IS TRIVIAL OVER A SUBSINGLETON TEST RING**, unconditionally.

This settles the open question of `I-1655`: the subsingleton ring is the site at which
`hrigAff`'s antecedent is vacuous, and therefore its cheapest potential refutation site.  The
answer is that the conclusion holds there anyway, so the affine spelling is **satisfied**
rather than refuted at that site.

No genus hypothesis, no curve input beyond the standing section variable. -/
theorem PicEtAff.subsingleton_of_subsingleton {A : Type u} [CommRing A] [Algebra k A]
    [Subsingleton A] : Subsingleton (PicEtAff C A) := by
  refine ⟨fun x y => ?_⟩
  induction x using PicEtAff.ind with | _ E ξ =>
  induction y using PicEtAff.ind with | _ F ζ =>
  haveI : Subsingleton E.Carrier := Algebra.EtaleCover.subsingleton_carrier E
  haveI : Subsingleton (relPic C (overSpec k E.Carrier)) :=
    subsingleton_relPic_of_subsingleton C E.Carrier
  refine (PicEtAff.mk_eq_mk_iff C).mpr
    ⟨E, AlgHom.id A _, toSubsingletonAlgHom A F.Carrier E.Carrier, ?_⟩
  exact Subtype.ext (Subsingleton.elim _ _)

/-- The `pic⁰` form at a subsingleton test ring: a subgroup of a subsingleton group. -/
theorem subsingleton_pic0Subgroup_overSpec_of_subsingleton
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]
    (A : Type u) [CommRing A] [Algebra k A] [Subsingleton A] :
    Subsingleton (pic0Subgroup C (overSpec k A)) := by
  haveI hplus : Subsingleton (PicEtAff C A) :=
    PicEtAff.subsingleton_of_subsingleton C (A := A)
  haveI : Subsingleton (picEt C (overSpec k A)) :=
    @Equiv.subsingleton _ _ (picEtAffineEquiv C A).toEquiv hplus
  exact ⟨fun s t => Subtype.ext (Subsingleton.elim _ _)⟩

/-! ## The reduction: both spellings are Zariski-local on the test ring -/

section Local

variable {A : Type u} [CommRing A] [Algebra k A]
variable {ι : Type u} [Finite ι] (g : ι → A)
variable (S : ι → Type u) [∀ i, CommRing (S i)] [∀ i, Algebra k (S i)]
  [∀ i, Algebra A (S i)] [∀ i, IsScalarTower k A (S i)]
  [∀ i, IsLocalization.Away (g i) (S i)]

/-- **THE REDUCTION, `Subsingleton` spelling**: if the plus construction is trivial at every
member of a finite covering family of localizations of `A`, it is trivial at `A`.

One application of the landed separation half `PicEtAff.eq_of_away_eq`: two classes over `A`
have equal restrictions because the target is a subsingleton. -/
theorem PicEtAff.subsingleton_of_away (hg : Ideal.span (Set.range g) = ⊤)
    (hloc : ∀ i, Subsingleton (PicEtAff C (S i))) :
    Subsingleton (PicEtAff C A) :=
  ⟨fun _ _ => PicEtAff.eq_of_away_eq C g S hg fun i => @Subsingleton.elim _ (hloc i) _ _⟩

/-- **THE REDUCTION, rigidity spelling**: the `hrigAff` clause at every member of a finite
covering family of localizations of `A` gives it at `A`.

Note which way the field points travel, because it is what makes this cheap: a field point of a
localization `S i` restricts to a field point of `A` by composing with `A → S i`, so the
antecedent **at `A`** supplies the antecedent at each `S i` — no lifting of field points along
the localization is required, and no compatibility between the members is used.  The classes
then agree with `1` after each localization, and separation finishes. -/
theorem PicEtAff.rigidity_of_away (hg : Ideal.span (Set.range g) = ⊤)
    (hloc : ∀ i, ∀ q : PicEtAff C (S i),
      (∀ (K : Type u) [Field K] [Algebra k K] (φ : S i →ₐ[k] K),
        PicEtAff.mapAlg C φ q = 1) → q = 1)
    (q : PicEtAff C A)
    (hq : ∀ (K : Type u) [Field K] [Algebra k K] (φ : A →ₐ[k] K),
      PicEtAff.mapAlg C φ q = 1) :
    q = 1 := by
  refine PicEtAff.eq_of_away_eq C g S hg (x := q) (y := 1) fun i => ?_
  rw [map_one]
  refine hloc i _ fun K _ _ φ => ?_
  rw [← PicEtAff.mapAlg_comp]
  exact hq K (φ.comp (IsScalarTower.toAlgHom k A (S i)))

/-- **The reduction on the `pic⁰` carrier the producers consume**: `Subsingleton
(pic0Subgroup C (overSpec k A))` from triviality of the plus construction at each member of a
finite covering family.

Transported through the affine comparison `picEtAffineEquiv`, then restricted to the subgroup.
Stated separately because `jacobianData_of_overSpec_subsingleton`
(`Pic0VanishingAffineReduction.lean:269`) takes exactly this carrier. -/
theorem subsingleton_pic0Subgroup_overSpec_of_away
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]
    (hg : Ideal.span (Set.range g) = ⊤)
    (hloc : ∀ i, Subsingleton (PicEtAff C (S i))) :
    Subsingleton (pic0Subgroup C (overSpec k A)) := by
  haveI hplus : Subsingleton (PicEtAff C A) :=
    PicEtAff.subsingleton_of_away C g S hg hloc
  haveI : Subsingleton (picEt C (overSpec k A)) :=
    @Equiv.subsingleton _ _ (picEtAffineEquiv C A).toEquiv hplus
  exact ⟨fun s t => Subtype.ext (Subsingleton.elim _ _)⟩

end Local

end

end AlgebraicGeometry
