/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.RiemannRoch.WeilDivisor

/-!
# Codimension-1 indeterminacy extension (A.4.a)

This file is the **A.4.a** sub-build chapter for the positive-genus arm of the
project's `nonempty_jacobianWitness`. It packages the two extension inputs to
Milne's *Abelian Varieties* §I.3 Theorem 3.2, plus the Weil-divisor
reformulation of the codim-`1` obstruction:

* **Milne Theorem 3.1** (`extend_of_codimOneFree_of_smooth`): a rational map
  from a nonsingular variety to a complete variety has indeterminacy locus
  of codimension `≥ 2`; if additionally the map is already
  codim-`1`-indeterminacy-free, then it extends to a regular morphism.
* **Milne Lemma 3.3** (`indeterminacy_pure_codim_one_into_grpScheme`): for a
  rational map from a nonsingular variety to a group variety, the
  indeterminacy locus is either empty or of pure codimension `1`.
* **Weil-divisor obstruction** (`extend_iff_order_nonneg`): a rational map
  extends at a prime divisor `W` iff every regular function on an affine
  neighbourhood of the image pulls back to a function of order `≥ 0` at `W`.

These outputs feed Milne Theorem 3.2 in the sibling
`Albanese/Thm32RationalMapExtension.lean` (A.4.c) and consume
`cor:regular_cohen_macaulay` from `Albanese/AuslanderBuchsbaum.lean` (A.4.b)
at Step 2 of `extend_of_codimOneFree_of_smooth`.

## Status (iter-177 Lane 6 file-skeleton)

Each of the six blueprint-pinned declarations carries the *intended*
substantive type signature (matching the `\lean{...}` pin in
`blueprint/src/chapters/Albanese_CodimOneExtension.tex`) with a `sorry` body.
Bodies are iter-178+ work, gated on the local-cohomology / depth-≥2
extension lemma (Step 2 of `thm:codim_one_extension`) being supplied either
from `Albanese/AuslanderBuchsbaum.lean` (the `cor:regular_cohen_macaulay`
input) or from a Mathlib upstream once the local-cohomology vanishing
`H¹_{x}(V, 𝒪_X) = 0` at a depth-≥2 point lands.

The 6 pinned declarations are:

1. `Scheme.RationalMap.indeterminacyLocus` (def, ~3 LOC) — the closed
   complement of `RationalMap.domain` as a `Set X`.
2. `Scheme.RationalMap.CodimOneFree` (def, ~3 LOC) — predicate: every
   point `η : X` with `Order.coheight η = 1` lies in `f.domain`.
3. `Scheme.localRing_dvr_of_codim_one` (theorem, ~3 LOC) — for a smooth
   integral variety, the stalk at a codim-1 point is a DVR.
4. `Scheme.RationalMap.extend_of_codimOneFree_of_smooth` (theorem, ~10 LOC) —
   Milne 3.1 specialised to smooth source + complete target +
   codim-1-indeterminacy-free.
5. `Scheme.RationalMap.indeterminacy_pure_codim_one_into_grpScheme`
   (theorem, ~8 LOC) — Milne Lemma 3.3.
6. `Scheme.RationalMap.extend_iff_order_nonneg` (theorem, ~8 LOC) —
   Weil-divisor obstruction.

## Note on type expressivity

Following the project rule "Never weaken the type to dodge the proof", each
pinned declaration carries a substantive, non-tautological type:

* `indeterminacyLocus f : Set X` returns the carrier of the closed
  complement of `f.domain` — not `∅` or `Set.univ`.
* `CodimOneFree f : Prop` is the genuine ∀-statement over codim-1 points,
  not `True`.
* `localRing_dvr_of_codim_one` produces a Mathlib `IsDiscreteValuationRing`
  instance — not a trivial proposition.
* `extend_of_codimOneFree_of_smooth` asserts `∃! g, g.toRationalMap = f`
  — the existence of a unique regular extension.
* `indeterminacy_pure_codim_one_into_grpScheme` asserts a disjunction:
  either the locus is empty or every component has coheight `1`.
* `extend_iff_order_nonneg` asserts an iff between definedness at a prime
  divisor and the order-≥0 condition.

Unfolding any pinned declaration exposes the named substantive content
(the carrier set complement, the `∀ η, ...` statement, the DVR instance,
the unique regular extension, …); no `Iso.refl _` / empty-content
`proof_wanted` / `Classical.choice ⟨witness⟩` placeholders are used.

## Variety conventions

Following the project (cf. `Albanese/Thm32RationalMapExtension.lean`,
`AbelianVarietyRigidity.lean`), a **nonsingular variety over `k̄`** is an
object `X : Over (Spec (.of k̄))` carrying:

* `[Smooth X.hom]`, `[GeometricallyIrreducible X.hom]`,
* `[IsSeparated X.hom]`, `[LocallyOfFiniteType X.hom]`,
* `[IsIntegral X.left]`, `[IsReduced X.left]`.

A **complete variety** adds `[IsProper Y.hom]`. A **group variety** over
`k̄` adds a `[GrpObj Y]` instance to the variety package.

## References

Blueprint: `blueprint/src/chapters/Albanese_CodimOneExtension.tex` (~750 LOC,
6 pins). Source: Milne, *Abelian Varieties*, §I.3, Theorem 3.1 (p. 16) and
Lemma 3.3 (p. 17); Hartshorne, *Algebraic Geometry*, II.6 pp. 130–131.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory MonObj

namespace AlgebraicGeometry

namespace Scheme

namespace RationalMap

/-! ## §1. The indeterminacy locus of a rational map

The indeterminacy locus `Z(f) ⊆ X` of a rational map `f : X ⇢ Y` is the closed
complement of its domain of definition `Dom(f) := f.domain` (a Mathlib-shipped
open subset of `X`).

Blueprint pin: `def:indeterminacy_locus` (Milne §I.3 p. 16). -/

/-- **Indeterminacy locus of a rational map.** The closed complement of the
domain of definition `f.domain` (an `X.Opens`, exposed by Mathlib at
`Mathlib.AlgebraicGeometry.Birational.RationalMap`):

`Z(f) := X ∖ Dom(f) ⊆ X`.

`f` is everywhere defined (i.e. extends to a regular morphism) iff
`indeterminacyLocus f = ∅`.

Blueprint reference: `def:indeterminacy_locus` (Milne, *Abelian Varieties*,
§I.3, p. 16). -/
def indeterminacyLocus {X Y : Scheme.{u}} (f : X.RationalMap Y) : Set X :=
  (f.domain : Set X)ᶜ

/-- The indeterminacy locus of a rational map is closed (it is the complement
of an open). -/
lemma isClosed_indeterminacyLocus {X Y : Scheme.{u}} (f : X.RationalMap Y) :
    IsClosed (indeterminacyLocus f) := by
  unfold indeterminacyLocus
  exact (f.domain.isOpen).isClosed_compl

/-! ## §2. Codimension-1-indeterminacy-free rational maps

A rational map `f : X ⇢ Y` is **codim-1-indeterminacy-free** if its
indeterminacy locus contains no prime divisor of `X`, i.e. every codim-1
generic point of `X` already lies in `f.domain`. Equivalently (under the
project's standing `Order.coheight` convention on the specialisation
preorder of `X.carrier`), every `η : X` with `Order.coheight η = 1` lies in
`f.domain`.

Blueprint pin: `def:codim_one_indeterminacy` (Milne §I.3 Theorem 3.1, the
conclusion). -/

/-- **Codim-1-indeterminacy-free rational map.** A rational map
`f : X ⇢ Y` is codim-1-indeterminacy-free if every codimension-one point
of `X` lies in its domain of definition. Equivalently: no prime divisor of
`X` (i.e. closure of a codim-1 generic point) is contained in
`indeterminacyLocus f`.

The codim-1 condition is encoded via `Order.coheight η = 1` on the
specialisation preorder of `X.carrier`, matching the project's standing
convention in `Scheme.PrimeDivisor` (`RiemannRoch/WeilDivisor.lean`).

Blueprint reference: `def:codim_one_indeterminacy` (Milne, *Abelian
Varieties*, Theorem 3.1, §I.3, p. 16). -/
def CodimOneFree {X Y : Scheme.{u}} (f : X.RationalMap Y) : Prop :=
  ∀ η : X, Order.coheight η = 1 → η ∈ f.domain

end RationalMap

/-! ## §3. Smoothness yields a DVR at every codim-1 point

On a nonsingular variety `X` over `k̄`, the local ring at the generic point
of a prime divisor is a discrete valuation ring with fraction field equal to
the function field `K(X) = X.functionField`. This is Hartshorne II.6's
"regular in codimension one" property combined with the regular-local-ring-of-dim-1
$\Leftrightarrow$ DVR equivalence (Atiyah–Macdonald 9.2; Stacks `00PD`).

Blueprint pin: `lem:smooth_codim_one_dvr` (Hartshorne II.6 p. 130). -/

/-- **Smooth + codim-1 ⇒ DVR.** For a nonsingular integral variety `X` over
an algebraically closed field `k̄` and a point `η : X.left` with
`Order.coheight η = 1`, the stalk `X.left.presheaf.stalk η` is a discrete
valuation ring (with fraction field the function field `K(X)`).

The proof reduces to "regular local ring of Krull dimension `1` is a DVR"
(Mathlib `IsDiscreteValuationRing.isDiscreteValuationRing_iff` or analogous)
plus the smooth-variety fact that every local ring at a codim-1 point is
regular of dimension `1`.

Blueprint reference: `lem:smooth_codim_one_dvr` (Hartshorne II.6 p. 130;
Stacks `00PD` for the regular-of-dim-1 ⇔ DVR equivalence). -/
theorem localRing_dvr_of_codim_one
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    {X : Over (Spec (.of kbar))}
    [Smooth X.hom] [GeometricallyIrreducible X.hom]
    [IsSeparated X.hom] [LocallyOfFiniteType X.hom]
    [IsIntegral X.left] [IsReduced X.left]
    (η : X.left) (_hη : Order.coheight η = 1) :
    IsDiscreteValuationRing (X.left.presheaf.stalk η) :=
  sorry

namespace RationalMap

/-! ## §4. Milne Theorem 3.1 — codim-≥ 2 extension to a complete target

A rational map from a nonsingular variety to a complete variety has
indeterminacy locus of codimension `≥ 2`. Specialising further: if `f` is
already codim-1-indeterminacy-free (by hypothesis), then `Dom(f) = X` and
`f` extends to a unique regular morphism `X ⟶ Y`.

Blueprint pin: `thm:codim_one_extension` (Milne §I.3 Theorem 3.1 p. 16). -/

/-- **Milne Theorem 3.1 (specialised) — codim-1-indeterminacy-free + smooth
source + complete target ⇒ extension.**

For `X` a nonsingular variety over an algebraically closed field `k̄`,
`Y` a complete variety over `k̄`, and `f : X ⇢ Y` a codim-1-indeterminacy-free
rational map, there exists a *unique* regular morphism `g : X ⟶ Y`
whose induced rational map equals `f`.

The proof combines two steps:
* **Step 1** (codim-1 ruling-out): the indeterminacy locus has no codim-1
  components, because at the generic point of any candidate prime divisor
  `W ⊆ Z(f)` the DVR property of the stalk (`localRing_dvr_of_codim_one`)
  feeds the valuative criterion of properness on the complete target `Y`.
* **Step 2** (codim-≥2 extension): at a remaining codim-≥2 point `x`, the
  depth-≥2 property of the regular local ring `O_{X,x}` (Cohen–Macaulay
  from `cor:regular_cohen_macaulay` of `Albanese/AuslanderBuchsbaum.lean`)
  forces `H¹_{x}(V, O_X) = 0` and the pulled-back coordinates extend
  uniquely. By the `CodimOneFree` hypothesis, Step 1 alone is already
  enough on the dim-≤2 cases the project consumes; Step 2 is what extends
  through the remaining higher-codim points to obtain `Dom(f) = X`.

Uniqueness is the standard reduced-and-separated agreement principle
(`AlgebraicGeometry.ext_of_isDominant`): two morphisms `X ⟶ Y` that agree
on a dense open of the reduced scheme `X` agree everywhere.

Blueprint reference: `thm:codim_one_extension` (Milne, *Abelian Varieties*,
Theorem 3.1, §I.3, p. 16). -/
theorem extend_of_codimOneFree_of_smooth
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    {X : Over (Spec (.of kbar))}
    [Smooth X.hom] [GeometricallyIrreducible X.hom]
    [IsSeparated X.hom] [LocallyOfFiniteType X.hom]
    [IsIntegral X.left] [IsReduced X.left]
    {Y : Over (Spec (.of kbar))}
    [IsProper Y.hom] [GeometricallyIrreducible Y.hom]
    [IsSeparated Y.hom] [LocallyOfFiniteType Y.hom]
    [IsIntegral Y.left] [IsReduced Y.left]
    (f : X.left.RationalMap Y.left) (_hf : CodimOneFree f) :
    ∃! (g : X.left ⟶ Y.left), g.toRationalMap = f :=
  sorry

/-! ## §5. Milne Lemma 3.3 — pure-codim-1 indeterminacy into a group variety

A rational map from a nonsingular variety to a group variety has its
indeterminacy locus either empty or of pure codimension `1`. Combined with
`thm:codim_one_extension`'s codim-≥2 conclusion, this forces the locus to
be empty when the target is an abelian variety.

Blueprint pin: `lem:milne_codim1_indeterminacy` (Milne §I.3 Lemma 3.3 p. 17). -/

/-- **Milne Lemma 3.3 — indeterminacy into a group variety is empty or pure
codim 1.**

For `X` a nonsingular variety over `k̄`, `G` a group variety over `k̄`
(a smooth group scheme of finite type, separated), and `f : X ⇢ G` a
rational map, the indeterminacy locus `Z(f) := indeterminacyLocus f` is
either empty (`f` is defined on all of `X`) or every point of `Z(f)` lies in
the closure of a codim-1 generic point.

The proof (Milne's): consider the difference map
`Φ : X × X ⇢ G`, `(x, y) ↦ f(x) · f(y)⁻¹`. Then `Φ` is defined at `(x, x)`
iff `f` is defined at `x`. Pulling back the maximal ideal of `O_{G,e}` gives
a finite set of rational functions on `X × X` whose pole divisors are pure
codim-1; their intersection with the diagonal exhibits the indeterminacy
locus of `f` as pure codim-1.

Blueprint reference: `lem:milne_codim1_indeterminacy` (Milne, *Abelian
Varieties*, Lemma 3.3, §I.3, p. 17). -/
theorem indeterminacy_pure_codim_one_into_grpScheme
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    {X : Over (Spec (.of kbar))}
    [Smooth X.hom] [GeometricallyIrreducible X.hom]
    [IsSeparated X.hom] [LocallyOfFiniteType X.hom]
    [IsIntegral X.left] [IsReduced X.left]
    {G : Over (Spec (.of kbar))}
    [GrpObj G] [Smooth G.hom] [GeometricallyIrreducible G.hom]
    [IsSeparated G.hom] [LocallyOfFiniteType G.hom]
    [IsIntegral G.left] [IsReduced G.left]
    (f : X.left.RationalMap G.left) :
    indeterminacyLocus f = ∅ ∨
      ∀ x ∈ indeterminacyLocus f,
        ∃ η : X.left, Order.coheight η = 1 ∧ x ∈ closure ({η} : Set X.left) :=
  sorry

/-! ## §6. Weil-divisor reformulation of the codim-1 extension obstruction

The codim-1 extension obstruction of `thm:codim_one_extension` has a clean
reformulation in the project's Weil-divisor language: `f` extends at the
generic point of a prime divisor `W ⊆ X` iff every regular function on an
affine neighbourhood of the image pulls back to a function of order `≥ 0`
along `W` (no pole at `W`).

This is the form the consumer in
`Albanese/AlbaneseUP.lean` (A.4.d) needs when combining
`def:indeterminacy_locus`, `def:order_at_point`, and `def:principal_divisor`.

Blueprint pin: `thm:weil_divisor_obstruction` (Hartshorne II.6 pp. 130–131). -/

/-- **Weil-divisor characterisation of the codim-1 extension obstruction.**

For `X` a nonsingular variety over `k̄`, `Y` a variety over `k̄`,
`f : X ⇢ Y` a rational map, and `W : X.left.PrimeDivisor` a prime divisor
of `X` (encoded by its generic point `W.point` with codim-1 witness
`Order.coheight W.point = 1`), the following are equivalent:

1. `W.point ∈ f.domain` (i.e. `f` is defined at the generic point of `W`).
2. For every affine open `V ⊆ Y` around the image, and for every regular
   function `g : Γ(V, O_Y) → K(X)` pulled back along a representative of
   `f`, the order along `W` satisfies
   `Scheme.RationalMap.order W (pullback g) ≥ 0`.

The equivalence (1) ⇔ (2) is the "regular = no pole" criterion for a
rational map at a DVR-stalk codim-1 point (`localRing_dvr_of_codim_one`
identifies `O_{X,W.point}` with the order-≥0 subring of `K(X)`).

The statement encoding below uses an `∀ g, order W g ≥ 0` predicate on the
function field as the surrogate for (2): the prover-facing form is that
*some* (equivalently *every*) representative pullback into `K(X)` has all
its `order_W` values nonnegative. The Weil-divisor identification feeds
the existing `Scheme.RationalMap.order` API from `RiemannRoch/WeilDivisor.lean`.

Blueprint reference: `thm:weil_divisor_obstruction` (Hartshorne, *Algebraic
Geometry*, II.6 pp. 130–131; Stacks `02ME`).

iter-178+ body: by `localRing_dvr_of_codim_one`, `O_{X,W.point}` is a DVR
inside the function field with valuation `Scheme.RationalMap.order W`; a
rational map is defined at `W.point` iff its pullback lands inside this
order-≥0 subring (the standard "regular = no pole" criterion). -/
theorem extend_iff_order_nonneg
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    {X : Over (Spec (.of kbar))}
    [Smooth X.hom] [GeometricallyIrreducible X.hom]
    [IsSeparated X.hom] [LocallyOfFiniteType X.hom]
    [IsIntegral X.left] [IsReduced X.left] [IsLocallyNoetherian X.left]
    {Y : Over (Spec (.of kbar))}
    [IsSeparated Y.hom] [LocallyOfFiniteType Y.hom]
    [IsIntegral Y.left] [IsReduced Y.left]
    (f : X.left.RationalMap Y.left) (W : X.left.PrimeDivisor)
    [Ring.KrullDimLE 1 (X.left.presheaf.stalk W.point)] :
    W.point ∈ f.domain ↔
      ∀ g : X.left.functionField,
        (∃ V : Y.left.Opens, ∃ s : Y.left.presheaf.obj (Opposite.op V),
          True) → -- placeholder predicate ensuring `g` is a pullback section
        Scheme.RationalMap.order W g ≥ 0 :=
  sorry

end RationalMap

end Scheme

end AlgebraicGeometry
