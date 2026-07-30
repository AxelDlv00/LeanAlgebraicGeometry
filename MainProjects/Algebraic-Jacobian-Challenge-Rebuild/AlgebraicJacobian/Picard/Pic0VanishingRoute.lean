/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.JacobianDataCharts

/-!
# A SECOND ROUTE TO `JacobianData`, WITH NONE OF THE THREE ATLAS ANTECEDENTS

Every producer of `JacobianData C` in this tree — `JacobianData.ofCharts`,
`ofChartsOfCompactSpace`, `ofAbelImage`, `ofChartsOfAbelImage`,
`jacobianDataOfMixedParamCharts`, `jacobianDataOfCompactFromClass`,
`jacobianDataOfFiniteMixedParamCharts` — consumes the same chart family.  So the three
antecedents the board tracks (`rep`, `IsChartUniv`, coverage) are antecedents of **one
route**, not of the goal, and every result about them is conditional on that route being
the one that closes.

This file builds a different route.  It is not a better route in general; it is a route
whose inputs are *disjoint* from the atlas's, and writing it down turns "the goal needs
`rep`" into "the *atlas* needs `rep`", which is a different and true statement.

## The mechanism

`JacobianData` has four fields: a representing object `J`, the universal property `rep`,
`LocallyOfFiniteType J.hom`, and `QuasiCompact J.hom`.  Take
`J := Over.mk (𝟙 (Spec k))`.  Then `J.hom` is the identity, so the two certificate fields
are `inferInstance` — *both* of the finiteness obligations the atlas route spends whole
rows on (`dat-j`, `dat-glue.atlas-hcpt`, the `hD`/`hcpt` pair) are free here, for the
reason that the object is the base.

That leaves `rep`, and at the terminal object it is cheap in the other direction:
`Hom(T, Over.mk (𝟙 (Spec k)))` is a *singleton* for every `T`, so a natural bijection with
`pic⁰(T)` exists exactly when `pic⁰(T)` is a singleton too.  Hence:

**`Subsingleton (pic0Subgroup C T)` at every test `T` ⟹ `JacobianData C`.**

No atlas, no divisor representability, no chart certificate, no coverage, no Abel map, no
index finiteness.

## What this is honestly worth

The hypothesis is **strong** — it says the Jacobian is a point — and it is *false* for
every curve of positive genus.  That is not a defect of the route; it is the route's
content.  Three things follow that are not available without it:

1. **The three antecedents are route-specific, provably.**  `jacobianData_of_subsingleton`
   produces the goal object with none of them in scope.  A reader can no longer conclude
   from "`rep` has no producer" that `JacobianData` has no producer.
2. **`Genus0Terminal` gains its missing direction.**  `Albanese/Genus0Terminal.lean` proves
   a datum *plus* vanishing gives a terminal `d.J`, and its header records the vanishing
   implication as "the single mathematical debt of S11".  Nobody wrote the direction that
   *produces* the datum from the vanishing, which is the direction with no antecedents.  It
   is landed downstream, in `Albanese/Genus0VanishingDatum.lean` — not here, because
   `Genus0Terminal` imports the Abel material and this file sits below it.  Its consequence
   is that the whole S11 leaf, uniqueness clause included, no longer waits on DAT-D at all.
3. **The debt becomes a statement about RINGS.**  `picEt C T` is by construction a subgroup
   of a *product* over `T.left.affineOpens` valued in `PicEtAff C Γ(T.left, U)`, so a
   subsingleton at every test *algebra* gives one at every test *object* componentwise —
   no cover, no gluing, no naturality (`subsingleton_picEt_of_affine`).  And the converse
   holds by the affine comparison (`subsingleton_picEtAff_of_forall`), so the reduction is
   an equivalence rather than a weakening.

## What this does NOT do

It does not represent `pic0Functor` for a curve of positive genus, and it does not weaken
the genus-0 debt: deriving the vanishing hypothesis from `genus C = 0` is the curve theory
`Genus0Terminal`'s header isolates, and nothing here supplies it.  In particular
`jacobianData_of_subsingleton` is **not** a witness that `JacobianData C` is inhabited for
the challenge curve — it is a witness that the three atlas antecedents are not the goal's.

## Main declarations

* `AlgebraicGeometry.pic0RepresentableBy_terminal_of_subsingleton` — the `rep` field at the
  terminal object, from vanishing `pic⁰`.
* `AlgebraicGeometry.jacobianData_of_subsingleton` — **the atlas-free producer.**
* `AlgebraicGeometry.subsingleton_picEt_of_affine` / `subsingleton_pic0_of_affine` — the
  reduction to test rings, componentwise.
* `AlgebraicGeometry.subsingleton_picEtAff_of_forall` — its converse.
* `AlgebraicGeometry.jacobianData_of_affine_subsingleton` — the producer with the
  ring-level hypothesis.
* `AlgebraicGeometry.pic0Subgroup_eq_bot_of_subsingleton` /
  `subsingleton_of_pic0Subgroup_eq_bot` — the two spellings of the hypothesis are
  interderivable, so `Genus0Terminal`'s `= ⊥` form and this file's `Subsingleton` form are
  not a fork.
-/

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits Opposite

namespace AlgebraicGeometry

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom]

attribute [local instance] Over.sectionsAlgebra

noncomputable section

/-! ## The two certificate fields at the terminal object

Both are `inferInstance`, and they are recorded as named lemmas because the atlas route
spends two board rows on exactly these obligations (`dat-j` for `quasiCompact`,
`dat-glue.atlas-hcpt` for its `CompactSpace` spelling).  At this carrier they cost
nothing, and the reason is structural rather than lucky: the structure morphism *is* an
identity, so any morphism property containing identities holds. -/

/-- `LocallyOfFiniteType` at the terminal object: the structure morphism is `𝟙`. -/
theorem locallyOfFiniteType_terminal :
    LocallyOfFiniteType (Over.mk (𝟙 (Spec (CommRingCat.of k)))).hom := by
  change LocallyOfFiniteType (𝟙 (Spec (CommRingCat.of k)))
  infer_instance

/-- `QuasiCompact` at the terminal object: the structure morphism is `𝟙`. -/
theorem quasiCompact_terminal :
    QuasiCompact (Over.mk (𝟙 (Spec (CommRingCat.of k)))).hom := by
  change QuasiCompact (𝟙 (Spec (CommRingCat.of k)))
  infer_instance

/-! ## The `rep` field at the terminal object -/

variable (C) in
/-- **The degree-zero Picard functor is represented by the terminal object as soon as it
vanishes.**

The `Hom`-set `T ⟶ Over.mk (𝟙 (Spec k))` is a singleton (`Over.mkIdTerminal`), so the
bijection with `pic⁰(T)` is the unique map in each direction, and both round trips are
`Subsingleton.elim`.  Naturality is likewise a `Subsingleton.elim`, at the *source* test:
this is the one place the hypothesis is needed at `T` rather than at `T'`.

Note what is NOT assumed: no atlas, no chart, no divisor functor, no representation of
anything else.  The only input is that the functor's values are singletons. -/
def pic0RepresentableBy_terminal_of_subsingleton
    (h : ∀ T : Over (Spec (.of k)), Subsingleton (pic0Subgroup C T)) :
    (pic0TypeFunctor C).RepresentableBy (Over.mk (𝟙 (Spec (CommRingCat.of k)))) where
  homEquiv {T} :=
    { toFun := fun _ => 1
      invFun := fun _ => Over.mkIdTerminal.from T
      left_inv := fun _ => Over.mkIdTerminal.hom_ext _ _
      right_inv := fun x => @Subsingleton.elim (pic0Subgroup C T) (h T) 1 x }
  homEquiv_comp {T _T'} _g _x := by
    haveI : Subsingleton ((pic0TypeFunctor C).obj (op T)) := h T
    apply Subsingleton.elim

variable (C) in
/-- **THE ATLAS-FREE PRODUCER OF THE NORTH STAR'S DATUM.**

`JacobianData C` from vanishing `pic⁰` alone.  Read the input list against
`jacobianDataOfMixedParamCharts`, whose docstring enumerates `rep`, `hf`, the
`IsLocallySurjective` instance, `hD` and `hcpt`: **none of the five appears here.**

That is the point of the declaration.  Those five are the antecedents of the *chart* route,
and until this file existed the tree had no second route to compare them against — so a
reader auditing "what does `JacobianData` cost" would read the atlas's price as the goal's.
It is not: the goal costs whichever route one takes, and this route costs one hypothesis
about the functor's values.

**The hypothesis is strong and this is not hidden.**  `Subsingleton (pic0Subgroup C T)` at
every `T` says the Jacobian is a point, which for a curve of positive genus is false.  So
this produces a datum for *degenerate* curves only.  What it establishes unconditionally is
the structure of the problem, plus the genus-0 leaf below. -/
def jacobianData_of_subsingleton
    (h : ∀ T : Over (Spec (.of k)), Subsingleton (pic0Subgroup C T)) :
    JacobianData C :=
  JacobianData.ofRepresentableBy C _
    (pic0RepresentableBy_terminal_of_subsingleton C h)
    locallyOfFiniteType_terminal quasiCompact_terminal

@[simp]
lemma jacobianData_of_subsingleton_J
    (h : ∀ T : Over (Spec (.of k)), Subsingleton (pic0Subgroup C T)) :
    (jacobianData_of_subsingleton C h).J = Over.mk (𝟙 (Spec (CommRingCat.of k))) :=
  rfl

/-! ## The hypothesis, reduced to test RINGS

The producer above needs a statement at every test *object* of `Over (Spec k)` — a
scheme-level quantifier.  This section removes it: the same hypothesis at every test
*algebra* suffices, and the reduction is componentwise rather than by descent.

The reason is the vehicle chosen for `picEt` (inbox `I-0140`): `picEt C T` is *defined*
as a subgroup of `Π U : T.left.affineOpens, PicEtAff C Γ(T.left, U)`.  A product of
subsingletons is a subsingleton, and a subgroup of one is one.  So there is no cover to
choose, no compatibility to check, and no naturality to transport — `picEt.ext` is the
whole proof.

This is worth isolating because it is the step a lane would expect to be expensive.  The
Zariski-sheaf machinery for `pic⁰` exists (`Pic0ZariskiSheaf.lean`,
`PicEtCoverBridge.lean`) and a reduction to affines through *it* would need a cover, the
S-lemma and the gluing seam.  None of that is needed for a *subsingleton* hypothesis,
because subsingleton-ness is inherited by subobjects rather than glued.

The two `picEt`-level statements carry an `omit`, and it is a measurement rather than
tidying: they use **none** of the curve's geometry — not smoothness, not properness, not
geometric irreducibility.  A reduction that needed the curve would be a statement about
this particular Picard functor; these are statements about the vehicle. -/

omit [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] in
variable (C) in
/-- **The scheme-level quantifier reduces to test algebras, componentwise.**

If `PicEtAff C A` is a subsingleton for every test algebra `A`, then `picEt C T` is a
subsingleton for every test object `T`.

One line, because `picEt C T` is a subgroup of the product of the `PicEtAff C Γ(T.left, U)`
and `picEt.ext` says two sections agree as soon as they agree at each affine open. -/
theorem subsingleton_picEt_of_affine
    (h : ∀ (A : Type u) [CommRing A] [Algebra k A], Subsingleton (PicEtAff C A))
    (T : Over (Spec (.of k))) : Subsingleton (picEt C T) :=
  ⟨fun _ _ => picEt.ext fun U => @Subsingleton.elim _ (h Γ(T.left, U.1)) _ _⟩

omit [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] in
variable (C) in
/-- **THE CONVERSE**, so the previous lemma is an equivalence and not a weakening.

If `picEt C T` is a subsingleton at every test object then in particular at the affine test
`overSpec k A`, and the affine comparison `picEtAffineEquiv` is a bijection onto
`PicEtAff C A`.

Recorded because a reduction whose hypothesis is strictly stronger than its conclusion
hides the gap instead of naming it.  Here the two are interderivable, so "vanishing at
every test ring" and "vanishing at every test object" are the *same* hypothesis, and a lane
may attack whichever is convenient. -/
theorem subsingleton_picEtAff_of_forall
    (h : ∀ T : Over (Spec (.of k)), Subsingleton (picEt C T))
    (A : Type u) [CommRing A] [Algebra k A] : Subsingleton (PicEtAff C A) :=
  haveI := h (overSpec k A)
  (picEtAffineEquiv C A).toEquiv.symm.subsingleton

variable (C) in
/-- **The degree-zero form**: `pic0Subgroup C T` is a subgroup of `picEt C T`, so it
inherits the subsingleton.

Note the direction of the inheritance, since it is what makes the ring-level hypothesis
*sufficient but not necessary*: vanishing of the whole `picEt` gives vanishing of `pic⁰`,
never the reverse.  `picEt` does not vanish for a curve with a degree-one class even when
`pic⁰` does, so a lane attacking the genus-0 debt should attack `pic0Subgroup` directly and
use this lemma only as the cheap sufficient condition it is. -/
theorem subsingleton_pic0_of_affine
    (h : ∀ (A : Type u) [CommRing A] [Algebra k A], Subsingleton (PicEtAff C A))
    (T : Over (Spec (.of k))) : Subsingleton (pic0Subgroup C T) :=
  haveI := subsingleton_picEt_of_affine C h T
  ⟨fun _ _ => Subtype.ext (Subsingleton.elim _ _)⟩

variable (C) in
/-- **The producer with the ring-level hypothesis**: `JacobianData C` from vanishing at
every test *algebra*.

Composite of `subsingleton_pic0_of_affine` with `jacobianData_of_subsingleton`.  This is
the form to quote when pricing the route, because its hypothesis mentions no scheme, no
open, and no test object — only the plus construction at a commutative `k`-algebra. -/
def jacobianData_of_affine_subsingleton
    (h : ∀ (A : Type u) [CommRing A] [Algebra k A], Subsingleton (PicEtAff C A)) :
    JacobianData C :=
  jacobianData_of_subsingleton C (subsingleton_pic0_of_affine C h)

/-! ## `Subsingleton` and `= ⊥` are the same hypothesis

`Genus0Terminal.lean` states its input as `pic0Subgroup C T = ⊥`; this file states it as
`Subsingleton (pic0Subgroup C T)`.  Both directions are two lines, and having them means
neither spelling is a fork. -/

/-- A subsingleton subgroup is trivial. -/
theorem pic0Subgroup_eq_bot_of_subsingleton {T : Over (Spec (.of k))}
    (h : Subsingleton (pic0Subgroup C T)) : pic0Subgroup C T = ⊥ :=
  haveI := h
  (Subgroup.eq_bot_iff_forall _).mpr fun x hx =>
    congrArg Subtype.val (Subsingleton.elim (⟨x, hx⟩ : pic0Subgroup C T) 1)

/-- A trivial subgroup is a subsingleton. -/
theorem subsingleton_of_pic0Subgroup_eq_bot {T : Over (Spec (.of k))}
    (h : pic0Subgroup C T = ⊥) : Subsingleton (pic0Subgroup C T) := by
  rw [h]; infer_instance

end

end AlgebraicGeometry
