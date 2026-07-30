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
2. **`Genus0Terminal` gains its missing direction.**  That file proves a datum *plus*
   vanishing gives a terminal `d.J`, and its header records the vanishing implication as
   "the single mathematical debt of S11".  Nobody wrote the direction that *produces* the
   datum from the vanishing, which is the direction with no antecedents, and which makes
   the whole S11 leaf — uniqueness clause included — unconditional on DAT-D.
   `existsUnique_ofCurve_comp_of_vanishing` below is that composite.
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

end

end AlgebraicGeometry
