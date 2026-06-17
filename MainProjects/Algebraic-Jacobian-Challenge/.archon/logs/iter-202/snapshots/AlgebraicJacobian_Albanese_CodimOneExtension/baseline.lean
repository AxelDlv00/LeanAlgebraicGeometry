/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.RiemannRoch.WeilDivisor
import AlgebraicJacobian.Albanese.CoheightBridge

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
* **Weil-divisor obstruction** (`mem_domain_iff_exists_partialMap_through_point`):
  `f` is defined at the generic point of a prime divisor `W` iff some
  `PartialMap` representative of `f` is regular at `W.point`. This is a thin
  re-shuffle of Mathlib's `RationalMap.mem_domain`; the substantive
  Hartshorne-II.6 "regular ⇔ order ≥ 0 at every DVR pullback" reformulation
  (the original Weil-divisor obstruction) is deferred to a future lemma
  that builds genuine pullback machinery (`Scheme.RationalMap.order`-along-`f`),
  outside this iter's scope.

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
6. `Scheme.RationalMap.mem_domain_iff_exists_partialMap_through_point`
   (theorem, ~2 LOC) — definitional re-shuffle of `RationalMap.mem_domain`
   exposing a `PartialMap` representative whose domain contains `W.point`.
   The substantive Weil-divisor `order ≥ 0` reformulation is deferred (see
   header).

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
* `mem_domain_iff_exists_partialMap_through_point` asserts the (truthful)
  iff between definedness at `W.point` and the existence of a `PartialMap`
  representative containing `W.point` in its domain — a definitional unfold
  of `Mathlib.AlgebraicGeometry.Scheme.RationalMap.mem_domain` with the
  conjunction swapped for downstream ergonomics.

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
  ∀ (x : X), Order.coheight x = 1 → x ∈ f.domain

end RationalMap

/-! ## §3. Smoothness yields a DVR at every codim-1 point

On a nonsingular variety `X` over `k̄`, the local ring at the generic point
of a prime divisor is a discrete valuation ring with fraction field equal to
the function field `K(X) = X.functionField`. This is Hartshorne II.6's
"regular in codimension one" property combined with the regular-local-ring-of-dim-1
$\Leftrightarrow$ DVR equivalence (Atiyah–Macdonald 9.2; Stacks `00PD`).

Blueprint pin: `lem:smooth_codim_one_dvr` (Hartshorne II.6 p. 130). -/

/-! ### Stacks 00TT scaffolding (Lane M↓ iter-191 first scaffold)

The Mathlib gap "smooth over `\bar k` ⟹ stalk is a regular local ring"
(Stacks tag `00TT`) is structured here as a four-stage pipeline:

* **Stage 1** — smooth ⟹ flat at every stalk (Mathlib instance
  `AlgebraicGeometry.instFlatOfSmooth` + `Flat.stalkMap`).
* **Stage 2** — smooth at a point ⟹ exists a standard smooth presentation
  on an affine neighbourhood (Stacks tag `00T7`, packaged in Mathlib at
  `AlgebraicGeometry.Smooth.exists_isStandardSmooth`).
* **Stage 3** — the polynomial generators of the standard smooth
  presentation form a regular sequence after localising at any prime
  (Stacks `02JK`/`07BV`; Mathlib gap as of `b80f227`).
* **Stage 4** — a Noetherian local ring whose maximal ideal is generated
  by a regular sequence of length equal to its Krull dimension is a
  regular local ring (`IsRegularLocalRing.of_regularSequence`; Stacks
  `00OE`/Matsumura 19.2; Mathlib gap as of `b80f227`).

Stages 1-2 are landed axiom-clean as named helpers below. Stages 3-4
remain a single scoped `sorry` inside the main theorem
`isRegularLocalRing_stalk_of_smooth` until either the cotangent /
sheaf-of-relative-differentials route (Mathlib upstream) lands or the
project-side `02JK`/`00OE` chain is built (iter-192+). -/

/-- **Stage 1 (Stacks 00TT, smooth ⟹ flat at stalk).** For a smooth
morphism `X.hom : X.left ⟶ Spec (.of k̄)` with `k̄` algebraically closed,
the induced ring map on stalks at every point `z : X.left` is flat. This
is the smooth ⟹ flat instance applied through the stalk-map flatness
characterisation `AlgebraicGeometry.Flat.iff_flat_stalkMap`.

Axiom-clean: composes the smooth ⟹ flat instance with the stalk-map
flatness lemma. No Mathlib gap. -/
private theorem stalkMap_flat_of_smooth
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    (X : Over (Spec (.of kbar)))
    [Smooth X.hom]
    (z : X.left) :
    ((X.hom.stalkMap z).hom).Flat :=
  AlgebraicGeometry.Flat.stalkMap X.hom z

/-- **Stage 2 (Stacks 00T7, smooth ⟹ standard smooth presentation at a
point).** For a smooth morphism `X.hom : X.left ⟶ Spec (.of k̄)`, every
point `z : X.left` admits affine open neighbourhoods `U ⊆ Spec (.of k̄)`,
`V ⊆ X.left` with `z ∈ V` and `V ⊆ X.hom ⁻¹' U` such that the induced
ring map `(X.hom.appLE U V e).hom` is `IsStandardSmooth`.

Axiom-clean: re-exports `AlgebraicGeometry.Smooth.exists_isStandardSmooth`
(the scheme-level packaging of Stacks tag `00T7`) at the project's
`Over (Spec (.of k̄))` calling convention. -/
private theorem exists_isStandardSmooth_at_of_smooth
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    (X : Over (Spec (.of kbar)))
    [Smooth X.hom]
    (z : X.left) :
    ∃ (U : (Spec (.of kbar)).Opens) (_ : IsAffineOpen U)
      (V : X.left.Opens) (_ : IsAffineOpen V)
      (_hzV : z ∈ V) (e : V ≤ X.hom ⁻¹ᵁ U),
      (X.hom.appLE U V e).hom.IsStandardSmooth :=
  AlgebraicGeometry.Smooth.exists_isStandardSmooth X.hom z

/-- **Stage 3 (Stacks 00TT, scheme-to-algebra bridge for the standard smooth
presentation).** Iter-192 axiom-clean intermediate helper: combines Stage 2's
existence-of-standard-smooth-presentation output with the `RingHom`-to-`Algebra`
bridge `RingHom.IsStandardSmooth.toAlgebra`, plus the affine-open stalk
localisation `IsAffineOpen.isLocalization_stalk`. Returns the full algebra-side
package needed by Stages 4-5 of the regularity proof: an affine neighbourhood
`V ∋ z`, an `Algebra Γ(Spec _, U) Γ(X.left, V)` instance under which
`Γ(X.left, V)` is `Algebra.IsStandardSmooth` over `Γ(Spec _, U)`, plus the
`IsLocalization.AtPrime` witness identifying the stalk at `z` with the
localisation of `Γ(X.left, V)` at the prime ideal of `z`.

Axiom-clean: composition of `exists_isStandardSmooth_at_of_smooth` +
`RingHom.IsStandardSmooth.toAlgebra` + `IsAffineOpen.isLocalization_stalk`.

This is the iter-192 Lane M↓ HARD BAR new axiom-clean helper: it packages the
"smooth ⟹ stalk is localisation of a standard-smooth Γ(Spec, U)-algebra"
content as a standalone declaration that downstream Stages 4-5 (the genuine
Stacks 02JK + 00OE Mathlib-gap chain) can consume directly. -/
private theorem exists_algebra_isStandardSmooth_section_stalk_isLocalization_of_smooth
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    (X : Over (Spec (.of kbar)))
    [Smooth X.hom]
    (z : X.left) :
    ∃ (U : (Spec (.of kbar)).Opens) (_hU : IsAffineOpen U)
      (V : X.left.Opens) (hV : IsAffineOpen V)
      (hzV : z ∈ V) (_e : V ≤ X.hom ⁻¹ᵁ U)
      (alg : Algebra Γ(Spec (.of kbar), U) Γ(X.left, V)),
      @Algebra.IsStandardSmooth _ _ _ _ alg ∧
      letI := TopCat.Presheaf.algebra_section_stalk X.left.presheaf ⟨z, hzV⟩
      IsLocalization.AtPrime
        (X.left.presheaf.stalk z) (hV.primeIdealOf ⟨z, hzV⟩).asIdeal := by
  obtain ⟨U, hU, V, hV, hzV, e, hStdSmooth⟩ :=
    exists_isStandardSmooth_at_of_smooth X z
  refine ⟨U, hU, V, hV, hzV, e, (X.hom.appLE U V e).hom.toAlgebra,
    hStdSmooth.toAlgebra, ?_⟩
  -- Localisation witness: the affine-open stalk is `Aₚ` for `p = primeIdealOf z`.
  letI := TopCat.Presheaf.algebra_section_stalk X.left.presheaf ⟨z, hzV⟩
  exact hV.isLocalization_stalk ⟨z, hzV⟩

/-- **Stage 4 (Stacks 00T7(2), Kähler-differentials freeness).** Iter-192
axiom-clean intermediate helper: given an algebra-level
`Algebra.IsStandardSmooth R S` instance (typically arising from
`Stage 3 = exists_algebra_isStandardSmooth_section_stalk_isLocalization_of_smooth`),
the module of Kähler differentials `Ω[S⁄R]` is `Module.Free` over `S`. The
basis is the `{d sᵢ}ᵢ` family witnessed by
`Algebra.IsStandardSmooth.iff_exists_basis_kaehlerDifferential`.

Axiom-clean: re-export of `Algebra.IsStandardSmooth.iff_exists_basis_kaehlerDifferential`
+ `Module.Free.of_basis`. -/
private theorem module_free_kaehlerDifferential_of_isStandardSmooth
    {R S : Type*} [CommRing R] [CommRing S] [Algebra R S]
    [Algebra.IsStandardSmooth R S] :
    Module.Free S (Ω[S⁄R]) := by
  obtain ⟨_, _, b, _⟩ :=
    (Algebra.IsStandardSmooth.iff_exists_basis_kaehlerDifferential
      (R := R) (S := S)).mp ‹_›
  exact Module.Free.of_basis b

/-- **Stage 5a (Stacks 02JK, freeness transports through localisation, algebra-side).**
Iter-193 Lane M↓ axiom-clean substrate helper: for an `R`-algebra `S` whose Kähler
differentials `Ω[S⁄R]` are `S`-free (e.g.\ when `S` is `R`-standard smooth via
`module_free_kaehlerDifferential_of_isStandardSmooth`), the localisation `Sₘ` at any
submonoid `M ⊆ S` has Kähler differentials `Ω[Sₘ⁄R]` which are `Sₘ`-free.

Axiom-clean: composes `KaehlerDifferential.isLocalizedModule_map` (Mathlib re-export)
with `Module.free_of_isLocalizedModule`. This is the substantive localisation-of-freeness
step that Stage 5 of the smooth ⟹ regular pipeline uses; extracted as a named helper
here so the main proof body of `isRegularLocalRing_stalk_of_smooth` reads as a clean
chain of named lemmas rather than an inline `IsLocalizedModule` + `Module.free_of_*`
maneuver. -/
private theorem module_free_kaehlerDifferential_localization
    {R : Type u} [CommRing R]
    {S : Type u} [CommRing S] [Algebra R S]
    [Module.Free S (Ω[S⁄R])]
    (M : Submonoid S)
    (Sₘ : Type u) [CommRing Sₘ] [Algebra R Sₘ] [Algebra S Sₘ]
    [IsScalarTower R S Sₘ] [IsLocalization M Sₘ] :
    Module.Free Sₘ (Ω[Sₘ⁄R]) := by
  haveI : IsLocalizedModule M (KaehlerDifferential.map R R S Sₘ) :=
    KaehlerDifferential.isLocalizedModule_map R S Sₘ M
  exact Module.free_of_isLocalizedModule (R := S) (Rₛ := Sₘ) (S := M)
    (M := Ω[S⁄R]) (Mₛ := Ω[Sₘ⁄R])
    (KaehlerDifferential.map R R S Sₘ)

/-- **Stage 5b (Stacks 02JK + 00T7, rank computation through localisation, algebra-side).**
Iter-193 Lane M↓ axiom-clean substrate helper: for an `R`-algebra `S` that is
`IsStandardSmoothOfRelativeDimension n` over `R` and a localisation `Sₘ` at any
submonoid `M` (with `Sₘ` non-trivial), the `Sₘ`-rank of `Ω[Sₘ⁄R]` equals `n`. This
upgrades Stage 5a's freeness conclusion with a *specific* rank.

Axiom-clean: composes `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`
(Mathlib, gives `rank S Ω[S⁄R] = n`) with `Module.lift_rank_of_isLocalizedModule_of_free`
(Mathlib, transports module rank through `IsLocalizedModule`). The combination
provides the rank of the stalk-side Kähler differentials, which is one of the two
ingredients of the regularity conclusion at the stalk (the other ingredient is the
Stacks 00OE smooth-algebra dimension formula, still a Mathlib gap). -/
private theorem rank_kaehlerDifferential_localization_eq_relativeDimension
    {R : Type u} [CommRing R]
    {S : Type u} [CommRing S] [Nontrivial S] [Algebra R S]
    (n : ℕ) [hS : Algebra.IsStandardSmoothOfRelativeDimension n R S]
    (M : Submonoid S)
    (Sₘ : Type u) [CommRing Sₘ] [Nontrivial Sₘ]
    [Algebra R Sₘ] [Algebra S Sₘ]
    [IsScalarTower R S Sₘ] [IsLocalization M Sₘ] :
    Module.rank Sₘ (Ω[Sₘ⁄R]) = n := by
  haveI : Algebra.IsStandardSmooth R S := hS.isStandardSmooth
  haveI : Module.Free S (Ω[S⁄R]) := Algebra.IsStandardSmooth.free_kaehlerDifferential
  haveI : IsLocalizedModule M (KaehlerDifferential.map R R S Sₘ) :=
    KaehlerDifferential.isLocalizedModule_map R S Sₘ M
  have hrank :
      Cardinal.lift.{u, u} (Module.rank Sₘ (Ω[Sₘ⁄R])) =
      Cardinal.lift.{u, u} (Module.rank S (Ω[S⁄R])) :=
    Module.lift_rank_of_isLocalizedModule_of_free Sₘ M
      (KaehlerDifferential.map R R S Sₘ)
  rw [Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential
        (S := S) n] at hrank
  simpa using hrank

/-- **Stage 6.B substrate (Stacks 02JK, RHS of the conormal iso).** Iter-198
Lane COE axiom-clean substrate helper: under the Stage 5a + 5b hypotheses
(`Ω[Sₘ⁄R]` is `Sₘ`-free with `Sₘ`-rank `n`), the residue-field base-change
`κ(mₘ) ⊗_{Sₘ} Ω[Sₘ⁄R]` has `κ(mₘ)`-dimension `n`. This is the *right-hand
side* of the Stacks-02JK cotangent iso
`κ(mₘ) ⊗_{Sₘ} Ω[Sₘ⁄R] ≃ mₘ/mₘ²` (the iso itself is the missing Mathlib
bridge for sub-lemma 6.B); combined with the bridge it gives
`Module.finrank κ (CotangentSpace Sₘ) = n`, the cotangent input of the
regularity criterion `IsRegularLocalRing.iff_finrank_cotangentSpace`.

Axiom-clean: composes `Module.finrank_baseChange` (Mathlib re-export,
`LinearAlgebra/Dimension/Constructions.lean`) with the cardinal-to-natural
cast `Module.finrank_eq_of_rank_eq`. Consumes no Mathlib gap.

The hypothesis pattern (free + rank = n) is exactly the conclusion of
Stages 5a + 5b applied to the stalk of a smooth scheme; the helper is
phrased independently of `IsStandardSmoothOfRelativeDimension` because the
stalk-side localisation is not preserved by that class (Mathlib commit
`b80f227` only provides `localization_away` which collapses to rel-dim 0).
-/
private theorem finrank_residueField_tensor_kaehlerDifferential_of_free_rank_eq
    {R : Type u} [CommRing R]
    {Sₘ : Type u} [CommRing Sₘ] [IsLocalRing Sₘ] [Nontrivial Sₘ] [Algebra R Sₘ]
    [Module.Free Sₘ (Ω[Sₘ⁄R])] (n : ℕ) (hrank : Module.rank Sₘ (Ω[Sₘ⁄R]) = n) :
    Module.finrank (IsLocalRing.ResidueField Sₘ)
      (TensorProduct Sₘ (IsLocalRing.ResidueField Sₘ) (Ω[Sₘ⁄R])) = n := by
  rw [Module.finrank_baseChange]
  exact Module.finrank_eq_of_rank_eq hrank

/-- **Stage 6.B substrate (Stacks 02JK, RHS of the conormal iso) —
`IsStandardSmoothOfRelativeDimension`-tied form.** Iter-198 Lane COE
axiom-clean substrate helper, parallel to
`finrank_residueField_tensor_kaehlerDifferential_of_free_rank_eq` above but
with the rank hypothesis discharged directly from the
`IsStandardSmoothOfRelativeDimension n R Sₘ` instance via Mathlib's
`Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`.

This packaging is useful in the *closed-point* case where the
standard-smooth presentation of an affine chart `Spec S ⊆ X` is itself a
local ring (e.g. via Mathlib's `IsStandardSmoothOfRelativeDimension`
basechange / composition apparatus). For the general
stalk-as-localisation case, use the hypothesis-form helper above with
Stage 5a (`module_free_kaehlerDifferential_localization`) and Stage 5b
(`rank_kaehlerDifferential_localization_eq_relativeDimension`)
discharging the `Free` + `rank = n` hypotheses respectively.

Axiom-clean: composes `Algebra.IsStandardSmoothOfRelativeDimension.\linebreak
rank_kaehlerDifferential` (Mathlib),
`Algebra.IsStandardSmooth.free_kaehlerDifferential` (Mathlib), and
`Module.finrank_baseChange` (Mathlib). Consumes no Mathlib gap. -/
private theorem
    finrank_residueField_tensor_kaehlerDifferential_of_isStandardSmoothOfRelativeDimension
    {R : Type u} [CommRing R]
    {Sₘ : Type u} [CommRing Sₘ] [IsLocalRing Sₘ] [Nontrivial Sₘ] [Algebra R Sₘ]
    (n : ℕ) [Algebra.IsStandardSmoothOfRelativeDimension n R Sₘ] :
    Module.finrank (IsLocalRing.ResidueField Sₘ)
      (TensorProduct Sₘ (IsLocalRing.ResidueField Sₘ) (Ω[Sₘ⁄R])) = n := by
  haveI : Algebra.IsStandardSmooth R Sₘ :=
    Algebra.IsStandardSmoothOfRelativeDimension.isStandardSmooth n
  haveI : Module.Free Sₘ (Ω[Sₘ⁄R]) := Algebra.IsStandardSmooth.free_kaehlerDifferential
  exact finrank_residueField_tensor_kaehlerDifferential_of_free_rank_eq n
    (Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential
      (R := R) (S := Sₘ) n)

/-- **Stage 6.B substrate (Stacks 02JK, LHS-RHS bridge): formally-smooth residue
gives the cotangent iso.** Iter-199 Lane COE axiom-clean closed-point-style
helper: assuming the source ring `Sₘ` is formally smooth over `R`, its residue
field `κ = ResidueField Sₘ` is formally smooth over `R`, and `Ω[κ⁄R]` is
subsingleton (the three hypotheses combine to model the closed-point case of
Stacks 02JK over an algebraically closed base, where `κ = R` makes both FS
and `Ω[κ⁄R] = 0` automatic), the canonical Mathlib map
`KaehlerDifferential.kerCotangentToTensor R Sₘ κ`
is an `Sₘ`-linear equivalence between
`(maximalIdeal Sₘ).Cotangent` (the `Sₘ`-side packaging of `m/m²`)
and `κ ⊗_Sₘ Ω[Sₘ⁄R]` (the residue-field base-change of the Kähler
differentials).

This is the closed-point case of the Stacks-02JK cotangent ↔ Kähler iso
(sub-gap (ii.A) of the Stage 6 chain in `isRegularLocalRing_stalk_of_smooth`).
The proof is the 3-step recipe from `analogies/coe-stacks02jk.md`:

* **Step 1** — retraction → injection via
  `Algebra.FormallySmooth.iff_split_injection`: under
  `FormallySmooth R κ` and surjectivity of `Sₘ → κ`, the conormal map
  `kerCotangentToTensor R Sₘ κ` admits a left-inverse `l`, hence is injective.
* **Step 2** — `Ω[κ⁄R] = 0` + exactness → surjection: combining
  `KaehlerDifferential.exact_kerCotangentToTensor_mapBaseChange` with
  `Subsingleton (Ω[κ⁄R])` gives that every element of the tensor space lies
  in the kernel of `mapBaseChange`, hence in the range of `kerCotangentToTensor`.
* **Step 3** — bijective → iso: package as `LinearEquiv.ofBijective`.

The `kerCotangentToTensor` map's domain is
`(RingHom.ker (algebraMap Sₘ κ)).Cotangent`, which equals
`(IsLocalRing.maximalIdeal Sₘ).Cotangent = IsLocalRing.CotangentSpace Sₘ` since
`κ = Sₘ / maximalIdeal Sₘ`; the equivalence is therefore the
Stacks 02JK closed-point cotangent iso
`m/m² ≃ₗ[Sₘ] κ ⊗_Sₘ Ω[Sₘ⁄R]`.

Axiom-clean: composes
`Algebra.FormallySmooth.iff_split_injection` (Mathlib;
`Mathlib/RingTheory/Smooth/Basic.lean`),
`KaehlerDifferential.exact_kerCotangentToTensor_mapBaseChange` (Mathlib;
`Mathlib/RingTheory/Kaehler/Basic.lean`), and `LinearEquiv.ofBijective`. -/
private noncomputable def
    cotangent_iso_residue_tensor_kaehler_of_formallySmooth_residue
    {R Sₘ : Type*} [CommRing R] [CommRing Sₘ] [IsLocalRing Sₘ] [Algebra R Sₘ]
    [Algebra.FormallySmooth R Sₘ]
    [Algebra.FormallySmooth R (IsLocalRing.ResidueField Sₘ)]
    [Subsingleton (Ω[IsLocalRing.ResidueField Sₘ⁄R])] :
    (RingHom.ker (algebraMap Sₘ (IsLocalRing.ResidueField Sₘ))).Cotangent ≃ₗ[Sₘ]
      TensorProduct Sₘ (IsLocalRing.ResidueField Sₘ) Ω[Sₘ⁄R] := by
  -- Surjectivity of `algebraMap Sₘ κ` is the residue surjection.
  have hSurj : Function.Surjective
      (algebraMap Sₘ (IsLocalRing.ResidueField Sₘ)) := by
    rw [IsLocalRing.ResidueField.algebraMap_eq]
    exact IsLocalRing.residue_surjective
  -- Step 1: retraction → injection via `iff_split_injection`.
  have hInj : Function.Injective
      (KaehlerDifferential.kerCotangentToTensor R Sₘ (IsLocalRing.ResidueField Sₘ)) := by
    obtain ⟨l, hl⟩ :=
      (Algebra.FormallySmooth.iff_split_injection
        (R := R) (P := Sₘ) (A := IsLocalRing.ResidueField Sₘ) hSurj).mp ‹_›
    refine Function.LeftInverse.injective (g := l) (fun x => ?_)
    have := LinearMap.congr_fun hl x
    simpa using this
  -- Step 2: `Ω[κ⁄R] = 0` + exactness → surjection.
  have hExact :=
    KaehlerDifferential.exact_kerCotangentToTensor_mapBaseChange R Sₘ
      (IsLocalRing.ResidueField Sₘ) hSurj
  have hSurjMap :
      Function.Surjective
        (KaehlerDifferential.kerCotangentToTensor R Sₘ
          (IsLocalRing.ResidueField Sₘ)) := by
    intro x
    have h0 :
        KaehlerDifferential.mapBaseChange R Sₘ
          (IsLocalRing.ResidueField Sₘ) x = 0 :=
      Subsingleton.elim _ _
    exact (hExact x).mp h0
  -- Step 3: bijective → linear equivalence.
  exact LinearEquiv.ofBijective _ ⟨hInj, hSurjMap⟩

/-- **Stage 6.B substrate (iter-199), maximal-ideal-domain repackaging.** The
same Stacks-02JK closed-point cotangent iso as
`cotangent_iso_residue_tensor_kaehler_of_formallySmooth_residue` above, but
restated with `(IsLocalRing.maximalIdeal Sₘ).Cotangent` (the canonical
`Sₘ/m = κ`-module side of `IsLocalRing.CotangentSpace Sₘ`) as the domain
rather than `(RingHom.ker (algebraMap Sₘ κ)).Cotangent`. The two coincide
through `IsLocalRing.ResidueField.algebraMap_eq + IsLocalRing.ker_residue`,
but the maximal-ideal form is the one Mathlib pre-equips with the κ-module
instance via `IsLocalRing.instModuleResidueFieldCotangentSpace`, so this
repackaging is what downstream κ-finrank computations want to consume.

Axiom-clean: `rw`-transports the iso above along the ideal equality. -/
private noncomputable def
    cotangent_iso_maximalIdeal_residue_tensor_kaehler_of_formallySmooth_residue
    {R Sₘ : Type*} [CommRing R] [CommRing Sₘ] [IsLocalRing Sₘ] [Algebra R Sₘ]
    [Algebra.FormallySmooth R Sₘ]
    [Algebra.FormallySmooth R (IsLocalRing.ResidueField Sₘ)]
    [Subsingleton (Ω[IsLocalRing.ResidueField Sₘ⁄R])] :
    (IsLocalRing.maximalIdeal Sₘ).Cotangent ≃ₗ[Sₘ]
      TensorProduct Sₘ (IsLocalRing.ResidueField Sₘ) Ω[Sₘ⁄R] := by
  have hker : RingHom.ker (algebraMap Sₘ (IsLocalRing.ResidueField Sₘ)) =
      IsLocalRing.maximalIdeal Sₘ := by
    rw [IsLocalRing.ResidueField.algebraMap_eq, IsLocalRing.ker_residue]
  rw [← hker]
  exact cotangent_iso_residue_tensor_kaehler_of_formallySmooth_residue

/-- **Stage 6.B substrate (iter-199), κ-finrank conclusion.** Assemble the
maximal-ideal-side cotangent iso of
`cotangent_iso_maximalIdeal_residue_tensor_kaehler_of_formallySmooth_residue`
with the 6.B-RHS substrate
`finrank_residueField_tensor_kaehlerDifferential_of_free_rank_eq` to compute
the κ-finrank of `IsLocalRing.CotangentSpace Sₘ` (= `m/m²`) explicitly.

Under the closed-point-style hypothesis pattern (`Sₘ` formally smooth over
`R`, residue field `κ` formally smooth over `R`, `Ω[κ⁄R]` subsingleton),
combined with `Module.Free Sₘ Ω[Sₘ⁄R]` of `Sₘ`-rank `n` (the conclusion of
Stages 5a + 5b applied to a standard-smooth localisation), the cotangent
space `m/m²` has `κ`-finrank equal to `n`.

This is the precise conclusion the consumer
`isRegularLocalRing_stalk_of_smooth` needs: combined with the still-open
Stacks-00OE Krull-dim formula (sub-gap (ii.B)) it discharges the regularity
criterion `IsRegularLocalRing.iff_finrank_cotangentSpace`. Sub-gap (ii.A)
(this lemma) is now axiom-clean; sub-gap (ii.B) remains the residual gap.

Axiom-clean: composes the Sₘ-linear iso with `LinearEquiv.extendScalarsOfSurjective`
(promotion to κ-linear via the residue surjection), `LinearEquiv.finrank_eq`,
and the 6.B-RHS substrate `finrank_baseChange + finrank_eq_of_rank_eq`. -/
private theorem finrank_cotangentSpace_of_formallySmooth_residue
    {R Sₘ : Type u} [CommRing R] [CommRing Sₘ] [IsLocalRing Sₘ] [Nontrivial Sₘ]
    [Algebra R Sₘ]
    [Algebra.FormallySmooth R Sₘ]
    [Algebra.FormallySmooth R (IsLocalRing.ResidueField Sₘ)]
    [Subsingleton (Ω[IsLocalRing.ResidueField Sₘ⁄R])]
    [Module.Free Sₘ (Ω[Sₘ⁄R])]
    (n : ℕ) (hrank : Module.rank Sₘ (Ω[Sₘ⁄R]) = n) :
    Module.finrank (IsLocalRing.ResidueField Sₘ)
      (IsLocalRing.CotangentSpace Sₘ) = n := by
  -- 6.B-RHS substrate: finrank κ (κ ⊗_Sₘ Ω[Sₘ⁄R]) = n.
  have hRHS :
      Module.finrank (IsLocalRing.ResidueField Sₘ)
        (TensorProduct Sₘ (IsLocalRing.ResidueField Sₘ) (Ω[Sₘ⁄R])) = n :=
    finrank_residueField_tensor_kaehlerDifferential_of_free_rank_eq n hrank
  -- Sₘ-linear iso (maximalIdeal form).
  have hiso :
      (IsLocalRing.maximalIdeal Sₘ).Cotangent ≃ₗ[Sₘ]
        TensorProduct Sₘ (IsLocalRing.ResidueField Sₘ) (Ω[Sₘ⁄R]) :=
    cotangent_iso_maximalIdeal_residue_tensor_kaehler_of_formallySmooth_residue
  -- Promote to κ-linear via the residue surjection.
  have hSurj : Function.Surjective
      (algebraMap Sₘ (IsLocalRing.ResidueField Sₘ)) := by
    rw [IsLocalRing.ResidueField.algebraMap_eq]
    exact IsLocalRing.residue_surjective
  have hisoκ :
      (IsLocalRing.maximalIdeal Sₘ).Cotangent ≃ₗ[IsLocalRing.ResidueField Sₘ]
        TensorProduct Sₘ (IsLocalRing.ResidueField Sₘ) (Ω[Sₘ⁄R]) :=
    LinearEquiv.extendScalarsOfSurjective hSurj hiso
  rw [hisoκ.finrank_eq, hRHS]

/-- **Stage 6.B substrate (iter-199), bundled bijective-residue-map form.**
Closed-point-friendly bundled variant of
`finrank_cotangentSpace_of_formallySmooth_residue` that replaces the three
typeclass hypotheses `Algebra.FormallySmooth R (ResidueField Sₘ)` and
`Subsingleton (Ω[ResidueField Sₘ⁄R])` with the single hypothesis that
`algebraMap R (ResidueField Sₘ)` is bijective. This is the precise hypothesis
the closed-point case of Stacks 02JK consumes: at a `k̄`-rational closed
point of a smooth `k̄`-algebra, the residue map `k̄ → κ` is the identity
(Nullstellensatz), hence bijective.

The proof:

* `RingHom.FormallySmooth.of_bijective` + `RingHom.formallySmooth_algebraMap`
  upgrade `Bijective` to `Algebra.FormallySmooth R (ResidueField Sₘ)`.
* `KaehlerDifferential.subsingleton_of_surjective` deduces
  `Subsingleton (Ω[ResidueField Sₘ⁄R])` from the surjectivity half of
  bijectivity.
* Then apply the typeclass-hypothesis form
  `finrank_cotangentSpace_of_formallySmooth_residue`.

Axiom-clean: composes Mathlib bridges with the iter-199 helper above. -/
private theorem finrank_cotangentSpace_of_bijective_algebraMap_residue
    {R Sₘ : Type u} [CommRing R] [CommRing Sₘ] [IsLocalRing Sₘ] [Nontrivial Sₘ]
    [Algebra R Sₘ]
    [Algebra.FormallySmooth R Sₘ]
    [Module.Free Sₘ (Ω[Sₘ⁄R])]
    (hbij : Function.Bijective (algebraMap R (IsLocalRing.ResidueField Sₘ)))
    (n : ℕ) (hrank : Module.rank Sₘ (Ω[Sₘ⁄R]) = n) :
    Module.finrank (IsLocalRing.ResidueField Sₘ)
      (IsLocalRing.CotangentSpace Sₘ) = n := by
  haveI : Algebra.FormallySmooth R (IsLocalRing.ResidueField Sₘ) :=
    RingHom.formallySmooth_algebraMap.mp
      (RingHom.FormallySmooth.of_bijective hbij)
  haveI : Subsingleton (Ω[IsLocalRing.ResidueField Sₘ⁄R]) :=
    KaehlerDifferential.subsingleton_of_surjective R _ hbij.surjective
  exact finrank_cotangentSpace_of_formallySmooth_residue n hrank

/-! ### Stage 6 sub-gap (ii.B) Stacks-00OE substrate (iter-200)

The residual Mathlib gap for Stage 6 is the smooth-algebra Krull-dim formula:
for a standard-smooth `k`-algebra `S` of relative dim `n` and a maximal ideal
`m ⊂ S` corresponding to a closed point over an algebraically closed base,
`ringKrullDim (Localization.AtPrime S m) = n`.

The iter-200 `mathlib-analogist coe-stacks00oe` recipe ranks this as a 3-step
chain composing existing Mathlib pieces:

* **Step 1** (`IsLocalization.AtPrime.ringKrullDim_eq_height`, trivial):
  rewrite `ringKrullDim (Localization.AtPrime S m) = m.height`.
* **Step 2** (polynomial-ring height): for the standard-smooth presentation
  `MvPolynomial ι k ↠ S` with kernel a regular sequence, the contracted
  maximal ideal `m' ⊂ MvPolynomial ι k` has height `#ι`. This is built
  axiom-clean below via induction on `Fin n` along Mathlib's
  `Polynomial.height_eq_height_add_one` + `MvPolynomial.finSuccEquiv`
  + `Polynomial.isMaximal_comap_C_of_isJacobsonRing`.
* **Step 3** (regular-sequence drop, Stacks 00SW / 00OW): the relations of the
  standard-smooth presentation form a regular sequence in the localization,
  consumed via `ringKrullDim_add_length_eq_ringKrullDim_of_isRegular`. The
  Jacobian-criterion regular-sequence witness is the substantive residual
  obligation; landing it requires `Algebra.SubmersivePresentation.jacobian_isUnit`
  + `IsLocalRing.isRegular_iff_isWeaklyRegular_of_subset_maximalIdeal`
  scaffolding which is iter-201+ Lane COE substrate.

Iter-200 lands Step 2 fully axiom-clean (`MvPolynomial.maximalIdeal_height_eq_card`
+ general-finite-ι transport `MvPolynomial.maximalIdeal_height_eq_natCard`),
the Step 1 named bridge (`ringKrullDim_localization_eq_height_atPrime`), and
the Step 3 quotient-form re-export
(`ringKrullDim_quotient_isRegular_eq_sub_length`) so the iter-201+ closure
collapses to building the Jacobian-regular-sequence witness alone. -/

/-- **Step 1 bridge (Stacks 00OE chain, iter-200).** Ergonomic re-export of
`IsLocalization.AtPrime.ringKrullDim_eq_height`: for a prime ideal `m ⊂ R` and
a localization `A = R_m`, `ringKrullDim A = m.height`. This is the boundary
translator inside `isRegularLocalRing_stalk_of_smooth` between
`Scheme.ringKrullDim_stalk_eq_coheight` (the iter-183 CoheightBridge bridge,
phrased in `ringKrullDim`) and the Mathlib polynomial-ring height arithmetic
(phrased in `Ideal.height`).

Axiom-clean: 1-line re-export. -/
private theorem ringKrullDim_localization_eq_height_atPrime
    {R : Type*} [CommRing R] (m : Ideal R) [m.IsPrime]
    (A : Type*) [CommRing A] [Algebra R A] [IsLocalization.AtPrime A m] :
    ringKrullDim A = m.height :=
  IsLocalization.AtPrime.ringKrullDim_eq_height m A

/-- **Step 2 substrate (Stacks 00OE chain, iter-200), `Fin n` form.** For a
field `k` and a maximal ideal `m ⊂ MvPolynomial (Fin n) k`, the height of
`m` equals `n`.

This is the substantive Step 2 ingredient: combined with the standard-smooth
presentation surjection `MvPolynomial (Fin (#ι)) k ↠ S`, it computes the
height of any contracted maximal ideal `m' = preimage(m) ⊂ MvPolynomial (Fin (#ι)) k`
explicitly. The closed-point case is the substantive one — every maximal ideal
of `MvPolynomial (Fin n) k` has height exactly `n` (independent of whether `k`
is algebraically closed; the Jacobson property suffices).

Axiom-clean proof: induction on `n`. The base case `n = 0` is trivial (no
maximal-ideal content beyond `bot_le`). The inductive step transports `m` along
`MvPolynomial.finSuccEquiv` to a maximal ideal `m'` of
`Polynomial (MvPolynomial (Fin n) k)`, contracts to `p = m' ∩ MvPolynomial (Fin n) k`
(maximal by `Polynomial.isMaximal_comap_C_of_isJacobsonRing` since
`MvPolynomial (Fin n) k` is Jacobson), and applies `Polynomial.height_eq_height_add_one`
followed by the inductive hypothesis on `p`. The upper bound follows from
`Ideal.height_le_ringKrullDim_of_ne_top` + `MvPolynomial.ringKrullDim_of_isNoetherianRing`. -/
private theorem MvPolynomial.maximalIdeal_height_ge_card_of_field
    (k : Type u) [Field k] (n : ℕ) :
    ∀ (m : Ideal (MvPolynomial (Fin n) k)) [m.IsMaximal], (n : ℕ∞) ≤ m.height := by
  induction n with
  | zero => intro m _; exact_mod_cast bot_le
  | succ n ih =>
    intro m _
    let e := MvPolynomial.finSuccEquiv k n
    let m' : Ideal (Polynomial (MvPolynomial (Fin n) k)) := Ideal.map e.toRingEquiv m
    haveI : m'.IsMaximal := Ideal.map_isMaximal_of_equiv (e := e.toRingEquiv)
    let p : Ideal (MvPolynomial (Fin n) k) := Ideal.comap Polynomial.C m'
    haveI : p.IsMaximal := Polynomial.isMaximal_comap_C_of_isJacobsonRing m'
    haveI : m'.LiesOver p := ⟨rfl⟩
    have ih' := ih p
    have hh : m'.height = p.height + 1 := Polynomial.height_eq_height_add_one p m'
    have hm_eq : m.height = m'.height := (RingEquiv.height_map e.toRingEquiv m).symm
    rw [hm_eq, hh, show ((n + 1 : ℕ) : ℕ∞) = (n : ℕ∞) + 1 from by push_cast; ring]
    gcongr

private theorem MvPolynomial.maximalIdeal_height_le_natCard_of_field.{v}
    (k : Type u) [Field k] {ιx : Type v} [Finite ιx]
    (m : Ideal (MvPolynomial ιx k)) (hm : m ≠ ⊤) :
    m.height ≤ Nat.card ιx := by
  have h1 : (m.height : WithBot ℕ∞) ≤ ringKrullDim (MvPolynomial ιx k) :=
    Ideal.height_le_ringKrullDim_of_ne_top hm
  rw [MvPolynomial.ringKrullDim_of_isNoetherianRing, ringKrullDim_eq_zero_of_field,
    zero_add] at h1
  exact_mod_cast h1

private theorem MvPolynomial.maximalIdeal_height_eq_card
    (k : Type u) [Field k] (n : ℕ)
    (m : Ideal (MvPolynomial (Fin n) k)) [hmax : m.IsMaximal] :
    m.height = n := by
  apply le_antisymm
  · have := MvPolynomial.maximalIdeal_height_le_natCard_of_field k (ιx := Fin n) m hmax.ne_top
    simpa using this
  · exact MvPolynomial.maximalIdeal_height_ge_card_of_field k n m

/-- **Step 2 substrate (Stacks 00OE chain, iter-200), general `[Finite ι]` form.**
For a field `k`, a finite index type `ι`, and a maximal ideal
`m ⊂ MvPolynomial ι k`, the height of `m` equals `Nat.card ι`.

Axiom-clean: transports the `Fin n` form
`MvPolynomial.maximalIdeal_height_eq_card` along the canonical
`MvPolynomial.renameEquiv` induced by `(Finite.equivFin ι)`. -/
private theorem MvPolynomial.maximalIdeal_height_eq_natCard.{v}
    (k : Type u) [Field k] (ιx : Type v) [Finite ιx]
    (m : Ideal (MvPolynomial ιx k)) [m.IsMaximal] :
    m.height = Nat.card ιx := by
  classical
  haveI : Fintype ιx := Fintype.ofFinite ιx
  let σ : ιx ≃ Fin (Fintype.card ιx) := Fintype.equivFin ιx
  let e : MvPolynomial ιx k ≃+* MvPolynomial (Fin (Fintype.card ιx)) k :=
    (MvPolynomial.renameEquiv k σ).toRingEquiv
  let m' : Ideal (MvPolynomial (Fin (Fintype.card ιx)) k) := Ideal.map e m
  haveI : m'.IsMaximal := Ideal.map_isMaximal_of_equiv (e := e)
  have hm_eq : m.height = m'.height := (RingEquiv.height_map e m).symm
  have hcard : Nat.card ιx = Fintype.card ιx := by simp [Nat.card_eq_fintype_card]
  rw [hm_eq, hcard]
  exact MvPolynomial.maximalIdeal_height_eq_card k (Fintype.card ιx) m'

/-- **Step 1 + Step 2 capstone (Stacks 00OE chain, iter-200).** For any
localisation `A` of `MvPolynomial ιx k` at a maximal ideal `m`, the Krull
dimension of `A` equals `Nat.card ιx`.

This is the most direct project-side consumer route for Step 1 + Step 2: it
takes the polynomial-ring height equality (`m.height = Nat.card ιx` via
`MvPolynomial.maximalIdeal_height_eq_natCard`) and pre-composes with the
Step 1 bridge (`ringKrullDim A = m.height` via
`ringKrullDim_localization_eq_height_atPrime`) to expose the closed form
`ringKrullDim A = Nat.card ιx` without going through `Ideal.height`.

Combined with Step 3 (`ringKrullDim_quotient_add_eq_of_regular_sequence`)
plus the Jacobian-regular-sequence witness (iter-201+ Lane COE), this yields
`ringKrullDim Sₘ = Nat.card ιx − rs.length` for the standard-smooth quotient
`Sₘ = A ⧸ Ideal.ofList rs`. -/
private theorem ringKrullDim_localization_atMaximal_MvPolynomial.{v}
    {k : Type u} [Field k] {ιx : Type v} [Finite ιx]
    (m : Ideal (MvPolynomial ιx k)) [m.IsMaximal]
    (A : Type*) [CommRing A] [Algebra (MvPolynomial ιx k) A]
    [IsLocalization.AtPrime A m] :
    ringKrullDim A = (Nat.card ιx : WithBot ℕ∞) := by
  rw [IsLocalization.AtPrime.ringKrullDim_eq_height m A,
    MvPolynomial.maximalIdeal_height_eq_natCard k ιx m]
  rfl

/-- **Step 3 substrate (Stacks 00OE chain, iter-200), parameterised additive form.**
For a Noetherian local ring `R'` with `ringKrullDim R' = a` (a natural number) and
a regular sequence `rs : List R'` of length `b`, the Krull dimension of the
quotient `R' ⧸ Ideal.ofList rs` plus `b` equals `a`.

This is the parameterised version of Mathlib's
`ringKrullDim_add_length_eq_ringKrullDim_of_isRegular` packaged in `WithBot ℕ∞`
arithmetic, with the natural-number values of dimension and length explicit. It is
the additive form preferred over a subtraction form because `WithBot ℕ∞` does not
carry a subtraction structure.

The consumer of `isRegularLocalRing_stalk_of_smooth` chains:

* `R'` = the polynomial-ring localisation `R'_{m'} = (MvPolynomial ι k)_{m'}`,
* `hDim` (a = #ι) = `MvPolynomial.maximalIdeal_height_eq_natCard` composed with
  the Step 1 bridge `ringKrullDim_localization_eq_height_atPrime`,
* `hReg` = the Jacobian-criterion regular-sequence witness (residual Mathlib gap;
  iter-201+ Lane COE),
* `hLen` (b = #σ) = the cardinality of the regular sequence.

Then `ringKrullDim Sₘ = a − b = n` follows by cancellation from this lemma.

Axiom-clean: 3-line re-export. -/
private theorem ringKrullDim_quotient_add_eq_of_regular_sequence
    {R' : Type*} [CommRing R'] [IsNoetherianRing R'] [IsLocalRing R']
    (rs : List R') (hReg : RingTheory.Sequence.IsRegular R' rs)
    {a b : ℕ} (hDim : ringKrullDim R' = (a : WithBot ℕ∞))
    (hLen : rs.length = b) :
    ringKrullDim (R' ⧸ Ideal.ofList rs) + (b : WithBot ℕ∞) = (a : WithBot ℕ∞) := by
  have h := ringKrullDim_add_length_eq_ringKrullDim_of_isRegular rs hReg
  rw [hDim, hLen] at h
  exact h

/-! ### Iter-201 Step A2 substrate (cotangent linear-independence transport)

Two axiom-clean substrate helpers needed by the iter-201+ A2 step of the
Stacks-00SW Jacobian-regular-sequence witness construction
(per `analogies/coe-stacks00sw.md`). They package the
`Algebra.SubmersivePresentation.basisCotangent` linear-independence statement
in two forward-friendly forms:

* `submersivePresentation_relation_cotangent_mk_linearIndependent` — the
  `S`-lin-indep version of the family `i ↦ Cotangent.mk ⟨P.relation i, _⟩`,
  obtained directly from `P.basisCotangent.linearIndependent` via
  `basisCotangent_apply`.
* `submersivePresentation_relation_cotangent_mk_linearIndependent_localized`
  — the same family transported through the canonical localisation map
  `Cot →ₗ[S] LocalizedModule p.primeCompl Cot` at any prime ideal `p` of `S`,
  yielding `Localization.AtPrime p`-lin-indep. This composes the previous
  helper with Mathlib's `LinearIndependent.of_isLocalizedModule`.

Together these realise Analogue D of the analogist recipe (lin-indep
preservation under localisation). The remaining substantive step in the A2
chain — identifying `LocalizedModule p.primeCompl P.toExtension.Cotangent`
with `(I·A) / (I·A)²` over the localisation `A = S_p`, i.e.\ the
conormal-localisation iso (Stacks 02JK, `Algebra.Generators.Cotangent.tensor`
variant for `AtPrime` rather than `Localization.Away`) — is a separate
Mathlib gap not landed here. -/

/-- **Iter-201 Step A2 substrate, Mathlib gap-free part 1.** For a submersive
presentation `P : R → S` of an `R`-algebra, the family
`i ↦ Cotangent.mk ⟨P.relation i, P.relation_mem_ker i⟩`
in `P.toExtension.Cotangent` is `S`-linearly independent.

This is a forward-ergonomics re-package of `P.basisCotangent.linearIndependent`
+ `P.basisCotangent_apply`: the basis-form lin-indep statement is restated
with the explicit `Cotangent.mk`-of-relation form on the consumer side, so
downstream callers do not need to manually unfold the basis abstraction.

Axiom-clean: 1 `Basis.linearIndependent` + 1 funext rewrite. -/
private theorem submersivePresentation_relation_cotangent_mk_linearIndependent
    {R S : Type*} [CommRing R] [CommRing S] [Algebra R S]
    {ix sx : Type*} [Finite sx]
    (P : Algebra.SubmersivePresentation R S ix sx) :
    LinearIndependent S
      (fun i : sx => Algebra.Extension.Cotangent.mk
        (⟨P.relation i, P.relation_mem_ker i⟩ : P.toExtension.ker)) := by
  have h := P.basisCotangent.linearIndependent
  have heq : (fun i : sx => Algebra.Extension.Cotangent.mk
        (⟨P.relation i, P.relation_mem_ker i⟩ : P.toExtension.ker)) = P.basisCotangent := by
    funext i
    exact (P.basisCotangent_apply i).symm
  rw [heq]
  exact h

/-- **Iter-201 Step A2 substrate, Mathlib gap-free part 2.** Transport of
`submersivePresentation_relation_cotangent_mk_linearIndependent` through the
canonical localisation map of `P.toExtension.Cotangent` at any prime `p` of
`S`. The resulting family in `LocalizedModule p.primeCompl P.toExtension.Cotangent`
is `Localization.AtPrime p`-linearly independent.

Composes the previous helper with Mathlib's
`LinearIndependent.of_isLocalizedModule` (in
`Mathlib.RingTheory.Localization.Module`) and the canonical
`LocalizedModule.mkLinearMap` + `LocalizedModule.isModule`-driven
`IsLocalizedModule` instance on the generic `LocalizedModule` construction.

This is Analogue D of the `coe-stacks00sw` mathlib-analogist recipe at the
level of the un-quotiented cotangent module; the residual A2 work
(identifying the localised cotangent with `(I·A)/(I·A)²` over `A = S_p`,
i.e.\ Stacks 02JK's conormal-localisation iso) remains a Mathlib gap and is
not landed here.

Axiom-clean: 1 invocation of `LinearIndependent.of_isLocalizedModule` on top
of `submersivePresentation_relation_cotangent_mk_linearIndependent`. -/
private theorem submersivePresentation_relation_cotangent_mk_linearIndependent_localized
    {R S : Type*} [CommRing R] [CommRing S] [Algebra R S]
    {ix sx : Type*} [Finite sx]
    (P : Algebra.SubmersivePresentation R S ix sx)
    (p : Ideal S) [p.IsPrime] :
    LinearIndependent (Localization.AtPrime p)
      (fun i : sx =>
        (LocalizedModule.mkLinearMap p.primeCompl P.toExtension.Cotangent)
          (Algebra.Extension.Cotangent.mk
            (⟨P.relation i, P.relation_mem_ker i⟩ : P.toExtension.ker))) :=
  LinearIndependent.of_isLocalizedModule (Localization.AtPrime p) p.primeCompl
    (LocalizedModule.mkLinearMap p.primeCompl P.toExtension.Cotangent)
    (submersivePresentation_relation_cotangent_mk_linearIndependent P)

/-- **Iter-201 Steps 1+2+3 composite (Mathlib-gap-conditional).** Given a
regular-sequence witness for a list `rs : List A` on a localisation `A` of
`MvPolynomial ix k` at a maximal ideal `m` (the substantive iter-201+ Step A
obligation, currently a Mathlib gap), the Krull dimension of the
quotient `A ⧸ Ideal.ofList rs` plus the length of `rs` equals
`Nat.card ix`.

This is the direct composition of the iter-200 capstone
`ringKrullDim_localization_atMaximal_MvPolynomial` (polynomial-ring side
Krull dimension) with the iter-200 additive form
`ringKrullDim_quotient_add_eq_of_regular_sequence` (regular-sequence
dimension drop), specialised to the polynomial-ring setting at a maximal
ideal. It gives the cleanest forward-compatible Step 3 "endpoint":
once the Step A `IsRegular` witness lands axiom-clean upstream (per the
`coe-stacks00sw` analogist recipe), this lemma reduces the
`ringKrullDim Sₘ = n` conclusion of Stacks 00OE to a one-line invocation.

Axiom-clean: composes Steps 1+2 (iter-200) and Step 3 (iter-200) with the
trivial `IsLocalization.AtPrime.isLocalRing` instance. -/
private theorem ringKrullDim_quotient_localization_MvPolynomial_of_regular.{v}
    {k : Type u} [Field k] {ix : Type v} [Finite ix]
    (m : Ideal (MvPolynomial ix k)) [m.IsMaximal]
    (A : Type*) [CommRing A] [Algebra (MvPolynomial ix k) A]
    [IsLocalization.AtPrime A m] [IsNoetherianRing A]
    (rs : List A) (hReg : RingTheory.Sequence.IsRegular A rs)
    {b : ℕ} (hLen : rs.length = b) :
    ringKrullDim (A ⧸ Ideal.ofList rs) + (b : WithBot ℕ∞) =
      (Nat.card ix : WithBot ℕ∞) := by
  haveI : IsLocalRing A := IsLocalization.AtPrime.isLocalRing A m
  exact ringKrullDim_quotient_add_eq_of_regular_sequence rs hReg
    (ringKrullDim_localization_atMaximal_MvPolynomial m A) hLen

/-- **Stage 6 sub-gap (i) resolution (iter-198).** Axiom-clean substrate helper:
every `Algebra.IsStandardSmooth R S` instance can be promoted to
`Algebra.IsStandardSmoothOfRelativeDimension n R S` for some specific `n : ℕ`
(extracted from the underlying submersive presentation via
`Algebra.SubmersivePresentation.isStandardSmoothOfRelativeDimension`).

This closes the iter-193 "sub-gap (i): relative-dimension determination"
identified in the docstring of `isRegularLocalRing_stalk_of_smooth` below.
The remaining Stage 6 gap is solely (ii) the Stacks-00OE smooth-algebra
Krull-dimension formula plus the Stacks-02JK cotangent-Kähler bridge over a
field.

Axiom-clean: a 4-line unpacking of `Algebra.IsStandardSmooth.out` via
`Algebra.SubmersivePresentation.isStandardSmoothOfRelativeDimension`. No
Mathlib gap; the only reason this was a sub-gap iter-191--194 was an
overconservative read of `IsStandardSmooth.relativeDimension`'s
`Classical.choice` apparatus. -/
private theorem exists_isStandardSmoothOfRelativeDimension_of_isStandardSmooth
    {R S : Type*} [CommRing R] [CommRing S] [Algebra R S]
    [hS : Algebra.IsStandardSmooth R S] :
    ∃ n : ℕ, Algebra.IsStandardSmoothOfRelativeDimension n R S := by
  obtain ⟨iota, sigma, hσ, hι, ⟨P⟩⟩ := hS.out
  exact ⟨P.dimension, P.isStandardSmoothOfRelativeDimension rfl⟩

/-- **Stacks `00TT`, Jacobian-criterion direction (regularity conclusion).**
For a smooth integral variety `X` over an algebraically closed field `k̄`, the
stalk of `X` at every point is a regular local ring.

This is the scheme-level packaging of Stacks tag `00TT` (Lemma 10.140.3
"Smooth algebras over fields"): given an affine chart `Spec A ⊆ X`, the
\(\bar k\)-algebra `A` is smooth at every prime `𝔮`, and the localisation
`A_𝔮 = X.presheaf.stalk z` (for `z ∈ X` lying over `𝔮`) is regular by the
"in this case the local ring `A_𝔮` is regular" clause of the cited lemma.

**Mathlib status at commit `b80f227` (iter-193 Lane M↓ Stage 5a/5b expansion).**
The 6-stage proof chain is now scaffolded as follows.

* Stage 1 (`stalkMap_flat_of_smooth`): smooth ⟹ flat at every stalk.
  Axiom-clean (iter-191).
* Stage 2 (`exists_isStandardSmooth_at_of_smooth`): smooth ⟹ standard
  smooth ring-hom presentation locally. Axiom-clean (iter-191).
* Stage 3 (`exists_algebra_isStandardSmooth_section_stalk_isLocalization_of_smooth`):
  scheme-to-algebra bridge: composes Stage 2 with the
  `RingHom.IsStandardSmooth.toAlgebra` bridge and the affine-open stalk
  localisation, producing an algebra-side `Algebra.IsStandardSmooth Γ(Spec, U)
  Γ(X.left, V)` + `IsLocalization.AtPrime` on the stalk. Axiom-clean
  (iter-192).
* Stage 4 (`module_free_kaehlerDifferential_of_isStandardSmooth`):
  standard-smooth algebra ⟹ Kähler differentials `Ω[Γ(X.left, V)⁄Γ(Spec, U)]`
  are `Module.Free` over the section algebra. Axiom-clean (iter-192).
* Stage 5a (`module_free_kaehlerDifferential_localization`): localisation
  transports Kähler-differentials freeness. Axiom-clean (iter-193). The
  Stage 5 chain in the body now contracts to a one-liner application of
  this helper. Was previously inline; extraction makes the proof body read
  as a clean sequence of named substrate lemmas.
* Stage 5b (`rank_kaehlerDifferential_localization_eq_relativeDimension`):
  the `Sₘ`-rank of `Ω[Sₘ⁄R]` equals the relative dimension `n` of the
  standard-smooth algebra `R → S`. Axiom-clean (iter-193). Composes
  `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`
  (Mathlib re-export) with `Module.lift_rank_of_isLocalizedModule_of_free`.
  This supplies the *specific rank* that downstream Stage 6 needs as the
  dimension witness for the regularity conclusion.
* **Stage 6 sub-gap (i) RESOLVED**
  (`exists_isStandardSmoothOfRelativeDimension_of_isStandardSmooth`): the
  relative-dimension `n` is now extractable axiom-clean directly from
  the `IsStandardSmooth` instance via the underlying submersive
  presentation. Iter-194 had flagged this as a sub-gap requiring further
  Mathlib work, but in fact it is a 4-line unpacking of `IsStandardSmooth.out`
  + `SubmersivePresentation.isStandardSmoothOfRelativeDimension`. Iter-198.
* **Stage 6.B RHS substrate**
  (`finrank_residueField_tensor_kaehlerDifferential_of_free_rank_eq` and
  `…of_isStandardSmoothOfRelativeDimension`): the residue-field base-change
  `κ(mₘ) ⊗_{Sₘ} Ω[Sₘ⁄R]` has `finrank κ(mₘ) = n` axiom-clean. This is the
  RHS of the Stacks-02JK cotangent iso (sub-lemma 6.B); combined with the
  iso it gives `finrank κ (CotangentSpace Sₘ) = n` (the cotangent input of
  the regularity criterion). Iter-198.
* **Stage 6 sub-gap (ii.A) RESOLVED (iter-199)**
  (`cotangent_iso_residue_tensor_kaehler_of_formallySmooth_residue`,
  `cotangent_iso_maximalIdeal_residue_tensor_kaehler_of_formallySmooth_residue`,
  `finrank_cotangentSpace_of_formallySmooth_residue`,
  `finrank_cotangentSpace_of_bijective_algebraMap_residue`): the
  Stacks-02JK closed-point cotangent ↔ Kähler iso is now axiom-clean as
  an `Sₘ`-linear (and via `extendScalarsOfSurjective` also
  `κ`-linear) equivalence
  `(maximalIdeal Sₘ).Cotangent ≃ κ ⊗_{Sₘ} Ω[Sₘ⁄R]`,
  under the three-typeclass closed-point pattern
  `[FormallySmooth R Sₘ] [FormallySmooth R κ] [Subsingleton (Ω[κ⁄R])]`,
  or equivalently the single-hypothesis bundled form
  `Bijective (algebraMap R κ)`. The proof uses the iter-199 analogist
  recipe: retraction → injection via
  `Algebra.FormallySmooth.iff_split_injection` + surjection via
  `KaehlerDifferential.exact_kerCotangentToTensor_mapBaseChange` and
  `Subsingleton Ω[κ⁄R]`. Composed with the iter-198 6.B-RHS substrate
  it gives `finrank κ (CotangentSpace Sₘ) = n` axiom-clean — the
  cotangent input of the regularity criterion. Iter-199.
* Stage 6 (Stacks `00OE`, the *residual* Mathlib gap iter-199):
  one specific bridge remains unbuilt at commit `b80f227`:
    (ii.B) **Smooth-algebra Krull-dimension formula (Stacks 00OE)**:
        `ringKrullDim Sₘ = n` for a standard-smooth `R`-algebra of
        relative dim `n`. Mathlib has
        `IsLocalization.AtPrime.ringKrullDim_eq_height` but no bridge
        from `IsStandardSmoothOfRelativeDimension` / the algebra-side
        relative dim to either side of the formula. Project-side build:
        ~200--300 LOC on `transcendenceDegree` + Noether normalisation.

Once Stage 6 sub-gap (ii.B) closes upstream, the body of this helper closes
axiom-clean via the closure pattern (sub-gap (ii.A) is already landed
iter-199 via `finrank_cotangentSpace_of_formallySmooth_residue` /
`…_of_bijective_algebraMap_residue`):
   `have hcotN : finrank κ (CotangentSpace Sₘ) = n :=`
     `finrank_cotangentSpace_of_bijective_algebraMap_residue _ n hRank`
   `have hdimN : ringKrullDim Sₘ = n := (ii.B applied)`
   `exact (IsRegularLocalRing.iff_finrank_cotangentSpace _).mpr (...)`
Every downstream consumer
(`smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot`,
`localRing_dvr_of_codim_one`) inherits the closure automatically.

Blueprint reference: `\cref{lem:smooth_to_regular_local_ring}` in
`blueprint/src/chapters/Albanese_CodimOneExtension.tex` (also Stacks
\href{https://stacks.math.columbia.edu/tag/00TT}{tag 00TT}). -/
private theorem isRegularLocalRing_stalk_of_smooth
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    (X : Over (Spec (.of kbar)))
    [Smooth X.hom] [GeometricallyIrreducible X.hom]
    [IsSeparated X.hom] [LocallyOfFiniteType X.hom]
    [IsIntegral X.left] [IsReduced X.left]
    (z : X.left) :
    IsRegularLocalRing (X.left.presheaf.stalk z) := by
  -- Stage 1 (axiom-clean): smooth ⟹ flat at the stalk z.
  have _hflat : ((X.hom.stalkMap z).hom).Flat :=
    stalkMap_flat_of_smooth X z
  -- Stage 3 (axiom-clean): smooth ⟹ algebra-side standard-smooth presentation
  -- on an affine neighbourhood V ∋ z, with the stalk identified as the
  -- localisation of `Γ(X.left, V)` at the prime ideal of `z`. This composes
  -- Stage 1 + Stage 2 + the `RingHom.IsStandardSmooth.toAlgebra` bridge + the
  -- affine-open `IsLocalization.AtPrime` stalk witness.
  obtain ⟨U, hU, V, hV, hzV, e, alg, hSSalg, hLoc⟩ :=
    exists_algebra_isStandardSmooth_section_stalk_isLocalization_of_smooth X z
  -- Activate the algebra structure (= `(X.hom.appLE U V e).hom.toAlgebra`)
  -- and the stalk-section algebra structure so downstream typeclass search
  -- sees both bridges.
  letI : Algebra Γ(Spec (.of kbar), U) Γ(X.left, V) := alg
  haveI hSS : Algebra.IsStandardSmooth Γ(Spec (.of kbar), U) Γ(X.left, V) := hSSalg
  letI : Algebra Γ(X.left, V) (X.left.presheaf.stalk z) :=
    TopCat.Presheaf.algebra_section_stalk X.left.presheaf ⟨z, hzV⟩
  haveI hLoc' : IsLocalization.AtPrime
      (X.left.presheaf.stalk z) (hV.primeIdealOf ⟨z, hzV⟩).asIdeal := hLoc
  -- Stage 4 (axiom-clean, named helper): the Kähler-differentials module
  -- `Ω[Γ(X.left, V)⁄Γ(Spec _, U)]` is a free `Γ(X.left, V)`-module.
  haveI _hFree : Module.Free Γ(X.left, V) (Ω[Γ(X.left, V)⁄Γ(Spec (.of kbar), U)]) :=
    module_free_kaehlerDifferential_of_isStandardSmooth
  -- Stage 5a (axiom-clean, iter-193 named helper):
  -- `module_free_kaehlerDifferential_localization` transports the freeness of
  -- `Ω[Γ(X.left, V)⁄Γ(Spec, U)]` along the localisation `Γ(X.left, V) → stalk z`
  -- to obtain `Module.Free (stalk z) Ω[stalk z⁄Γ(Spec, U)]`.
  letI : Algebra Γ(Spec (.of kbar), U) (X.left.presheaf.stalk z) :=
    ((algebraMap Γ(X.left, V) (X.left.presheaf.stalk z)).comp
      (algebraMap Γ(Spec (.of kbar), U) Γ(X.left, V))).toAlgebra
  haveI : IsScalarTower Γ(Spec (.of kbar), U) Γ(X.left, V)
      (X.left.presheaf.stalk z) := by
    apply IsScalarTower.of_algebraMap_eq
    intro _; rfl
  haveI _hFreeStalk : Module.Free (X.left.presheaf.stalk z)
      (Ω[(X.left.presheaf.stalk z)⁄Γ(Spec (.of kbar), U)]) :=
    module_free_kaehlerDifferential_localization
      (hV.primeIdealOf ⟨z, hzV⟩).asIdeal.primeCompl (X.left.presheaf.stalk z)
  -- Stage 6 sub-gap (i) RESOLVED (iter-198): extract a specific relative
  -- dimension `n` from the `IsStandardSmooth` instance on Γ(X.left, V) via
  -- `exists_isStandardSmoothOfRelativeDimension_of_isStandardSmooth`. The
  -- underlying submersive presentation supplies a concrete `P.dimension`.
  obtain ⟨n, hRelDim⟩ :=
    exists_isStandardSmoothOfRelativeDimension_of_isStandardSmooth
      (R := Γ(Spec (.of kbar), U)) (S := Γ(X.left, V))
  -- With sub-gap (i) discharged, instantiate Stage 5b at the stalk to obtain
  -- the *specific* `Module.rank` of the stalk-side Kähler differentials.
  -- Nontriviality: the stalk at any point of a scheme is a local ring (hence
  -- nontrivial); `Γ(X.left, V)` is nontrivial because `z ∈ V` makes `V`
  -- nonempty (Mathlib `Scheme.component_nontrivial`).
  haveI : Nontrivial (X.left.presheaf.stalk z) := by infer_instance
  haveI hNeV : Nonempty V := ⟨⟨z, hzV⟩⟩
  haveI : Nontrivial Γ(X.left, V) :=
    AlgebraicGeometry.Scheme.component_nontrivial X.left V
  have hRank :
      Module.rank (X.left.presheaf.stalk z)
        (Ω[(X.left.presheaf.stalk z)⁄Γ(Spec (.of kbar), U)]) = n :=
    rank_kaehlerDifferential_localization_eq_relativeDimension n
      (hV.primeIdealOf ⟨z, hzV⟩).asIdeal.primeCompl
      (X.left.presheaf.stalk z)
  -- Now apply the Stage 6.B substrate: the residue-field base-change of the
  -- stalk-side Kähler module has `finrank n`. This is the RHS of the
  -- Stacks-02JK conormal iso `κ ⊗_Sₘ Ω ≃ mₘ/mₘ²`; once the bridge lands the
  -- LHS picks up the same `finrank n` automatically.
  have _hFinrankResidueTensor :
      Module.finrank (IsLocalRing.ResidueField (X.left.presheaf.stalk z))
        (TensorProduct (X.left.presheaf.stalk z)
          (IsLocalRing.ResidueField (X.left.presheaf.stalk z))
          (Ω[(X.left.presheaf.stalk z)⁄Γ(Spec (.of kbar), U)])) = n :=
    finrank_residueField_tensor_kaehlerDifferential_of_free_rank_eq n hRank
  -- **Residual Stage 6 gap (iter-199 surface).** Sub-gaps (i) and (ii.A) are
  -- now DISCHARGED axiom-clean above
  -- (`exists_isStandardSmoothOfRelativeDimension_of_isStandardSmooth` and
  -- `finrank_cotangentSpace_of_formallySmooth_residue` /
  -- `…_of_bijective_algebraMap_residue` respectively). One genuine Mathlib
  -- gap remains:
  --
  -- **Sub-gap (ii.B) — smooth-algebra Krull-dimension formula (Stacks 00OE).**
  -- For a standard-smooth `R`-algebra of relative dim `n`, the localisation
  -- `Sₘ` at any prime has Krull dimension equal to the *geometric* dimension
  -- at the corresponding point, which for a closed point over alg-closed `R`
  -- is `n`. Mathlib has `IsLocalization.AtPrime.ringKrullDim_eq_height`
  -- (`ringKrullDim Sₘ = m.height`) but no bridge from `IsStandardSmooth` /
  -- the algebra-side `relativeDimension` to either side of this equation.
  -- Project-side build: ~200--300 LOC on top of Mathlib's
  -- `transcendenceDegree` API + Noether normalisation chain
  -- `(exists_finite_inj_algHom_of_fg`).
  --
  -- **Note (iter-199).** Promoting the (ii.A) helper to a usable in-body
  -- `finrank κ (CotangentSpace Sₘ) = n` further requires either
  --   (a) the closed-point-style typeclasses
  --       `[Algebra.FormallySmooth (Γ U) (stalk z)]`,
  --       `[Algebra.FormallySmooth (Γ U) (ResidueField (stalk z))]`,
  --       `[Subsingleton Ω[ResidueField (stalk z)⁄(Γ U)]]`
  --   (b) or the bundled-bijective hypothesis
  --       `Bijective (algebraMap (Γ U) (ResidueField (stalk z)))`
  -- which on a kbar-rational closed point reduces to the Nullstellensatz
  -- identification `ResidueField (stalk z) = kbar`. For codim-1 points
  -- (the actual consumer of `localRing_dvr_of_codim_one`) the residue
  -- field is a transcendence-degree-1 extension of kbar and the
  -- closed-point form is not directly applicable; the consumer route
  -- instead localises a closed-point regularity witness via Stacks 00OF
  -- (`IsRegularLocalRing.localization`). Closing the consumer therefore
  -- still requires either the closed-point + 00OF chain or sub-gap (ii.B).
  --
  -- **Closure pattern (post-(ii.B)).**
  --   `have hcotN : finrank κ (CotangentSpace Sₘ) = n :=`
  --     `finrank_cotangentSpace_of_bijective_algebraMap_residue hBij n hRank`
  --   `have hdimN : ringKrullDim Sₘ = n := (ii.B applied)`
  --   `exact (IsRegularLocalRing.iff_finrank_cotangentSpace _).mpr (by`
  --     `rw [hcotN, hdimN]; rfl)`
  --
  -- Iter-200+ tracked: `mathlib-analogist` sweep on (ii.B) smooth-algebra
  -- Krull-dim formula. The Stage 1-5a-5b-6.B-RHS-iiA chain already in place
  -- handles freeness, rank, residue-tensor-finrank, and cotangent
  -- finrank-bridge substrate.
  sorry

/-- **Helper for `localRing_dvr_of_codim_one`.** On a smooth integral variety
over an algebraically closed field, the stalk at a codimension-`1` point has a
*principal nonzero* maximal ideal. Encodes the substantive geometric content
of "regular in codimension one": smoothness ⟹ `IsRegularLocalRing` at the
stalk (Stacks `00PD`/`00TT`), and a Noetherian regular local ring with
`ringKrullDim = 1` has principal nonzero maximal ideal (Stacks `02IZ`),
via the cotangent-space `finrank = 1` characterisation.

**Iter-187 Lane M↓ refactor.** The previous body bundled both Mathlib gaps —
smooth ⟹ regular (Stacks 00TT) and codim-1 ⟹ Krull-dim-1 — into an inline
`hreg_dim` conjunction whose first conjunct was a bare `sorry`. The Krull-dim
half has been closed axiom-clean since iter-184 via
`Scheme.ringKrullDim_stalk_eq_coheight` (the iter-183 `CoheightBridge.lean`
bridge); the iter-187 refactor isolates the remaining Stacks-00TT gap as the
named helper `isRegularLocalRing_stalk_of_smooth` above. This helper is now
*axiom-clean modulo the named Stacks-00TT gap*: its body discharges every
conclusion from explicit Mathlib lemmas and the named regularity helper.
Once `isRegularLocalRing_stalk_of_smooth` closes upstream the whole chain
becomes axiom-clean automatically. -/
private theorem smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    (X : Over (Spec (.of kbar)))
    [Smooth X.hom] [GeometricallyIrreducible X.hom]
    [IsSeparated X.hom] [LocallyOfFiniteType X.hom]
    [IsIntegral X.left] [IsReduced X.left]
    (z : X.left) (_hz : Order.coheight z = 1) :
    Submodule.IsPrincipal (IsLocalRing.maximalIdeal (X.left.presheaf.stalk z)) ∧
      IsLocalRing.maximalIdeal (X.left.presheaf.stalk z) ≠ ⊥ := by
  -- Set up Noetherian structure on the stalk (needed for the cotangent-space API):
  -- `LocallyOfFiniteType X.hom` lifts the automatic `IsLocallyNoetherian (Spec k̄)`
  -- through to `IsLocallyNoetherian X.left`, from which the stalk picks up
  -- `IsNoetherianRing` (Mathlib instance).
  haveI : IsLocallyNoetherian X.left :=
    LocallyOfFiniteType.isLocallyNoetherian X.hom
  -- Regularity half: extracted to the named helper above
  -- (`isRegularLocalRing_stalk_of_smooth`), which captures the Stacks-00TT
  -- Jacobian-criterion gap as a narrow named typed sorry. No further
  -- inline `sorry` is required at this step.
  have hreg : IsRegularLocalRing (X.left.presheaf.stalk z) :=
    isRegularLocalRing_stalk_of_smooth X z
  -- Krull-dim half: closes via the iter-183 axiom-clean CoheightBridge
  -- equality + the codim-1 witness `_hz`.
  have hdim : ringKrullDim (X.left.presheaf.stalk z) = 1 := by
    rw [Scheme.ringKrullDim_stalk_eq_coheight]
    exact_mod_cast _hz
  -- From regularity + dim = 1, the cotangent space has `finrank = 1`
  -- (Mathlib `IsRegularLocalRing.iff_finrank_cotangentSpace`).
  have hfin :
      Module.finrank
        (IsLocalRing.ResidueField (X.left.presheaf.stalk z))
        (IsLocalRing.CotangentSpace (X.left.presheaf.stalk z)) = 1 := by
    have h := (IsRegularLocalRing.iff_finrank_cotangentSpace _).mp hreg
    rw [hdim] at h
    exact_mod_cast h
  -- Principal maximal ideal: `finrank ≤ 1 ↔ IsPrincipal maximalIdeal`
  -- (Mathlib `IsLocalRing.finrank_cotangentSpace_le_one_iff`).
  have hprin : Submodule.IsPrincipal
      (IsLocalRing.maximalIdeal (X.left.presheaf.stalk z)) :=
    IsLocalRing.finrank_cotangentSpace_le_one_iff.mp hfin.le
  -- `maximalIdeal ≠ ⊥`: equivalent to "not a field" by Mathlib
  -- `IsLocalRing.isField_iff_maximalIdeal_eq`, and a field has Krull dim 0,
  -- contradicting `hdim : ringKrullDim = 1` via `ringKrullDim_eq_zero_of_isField`.
  have hne : IsLocalRing.maximalIdeal (X.left.presheaf.stalk z) ≠ ⊥ := by
    intro hbot
    have hF : IsField (X.left.presheaf.stalk z) :=
      IsLocalRing.isField_iff_maximalIdeal_eq.mpr hbot
    have h0 : ringKrullDim (X.left.presheaf.stalk z) = 0 :=
      ringKrullDim_eq_zero_of_isField hF
    -- Contradiction: `1 = 0` in `WithBot ℕ∞`.
    rw [hdim] at h0
    exact_mod_cast h0
  exact ⟨hprin, hne⟩

/-- **Smooth + codim-1 ⇒ DVR.** For a nonsingular integral variety `X` over
an algebraically closed field `k̄` and a point `η : X.left` with
`Order.coheight η = 1`, the stalk `X.left.presheaf.stalk η` is a discrete
valuation ring (with fraction field the function field `K(X)`).

The proof reduces to "regular local ring of Krull dimension `1` is a DVR"
(Mathlib `IsDiscreteValuationRing.isDiscreteValuationRing_iff` or analogous)
plus the smooth-variety fact that every local ring at a codim-1 point is
regular of dimension `1`. The geometric step is packaged in the private helper
`smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot`; the rest assembles the
DVR instance via `IsDiscreteValuationRing.TFAE`.

Blueprint reference: `lem:smooth_codim_one_dvr` (Hartshorne II.6 p. 130;
Stacks `00PD` for the regular-of-dim-1 ⇔ DVR equivalence). -/
theorem localRing_dvr_of_codim_one
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    {X : Over (Spec (.of kbar))}
    [Smooth X.hom] [GeometricallyIrreducible X.hom]
    [IsSeparated X.hom] [LocallyOfFiniteType X.hom]
    [IsIntegral X.left] [IsReduced X.left]
    (z : X.left) (_hz : Order.coheight z = 1) :
    IsDiscreteValuationRing (X.left.presheaf.stalk z) := by
  -- Set up Noetherian structure on the stalk:
  -- `LocallyOfFiniteType X.hom` lifts the (automatic) `IsLocallyNoetherian (Spec k̄)`
  -- to `IsLocallyNoetherian X.left`, from which the stalk inherits
  -- `IsNoetherianRing` (Mathlib instance). The stalk of an integral scheme is
  -- a domain (Mathlib instance), and stalks of schemes are always local (Mathlib
  -- instance); these are picked up automatically by typeclass search.
  haveI : IsLocallyNoetherian X.left :=
    LocallyOfFiniteType.isLocallyNoetherian X.hom
  -- Extract the principal+nonzero-maximal-ideal helper (the Mathlib-gap content).
  obtain ⟨hprin, hne⟩ :=
    smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot X z _hz
  -- The stalk is a local Noetherian domain with principal maximal ideal:
  -- promote `IsPrincipal (maximalIdeal)` to a `IsPrincipalIdealRing` instance
  -- and conclude DVR via `IsDiscreteValuationRing.mk`.
  -- The TFAE entry "principal maximal ideal ⇔ DVR" handles the conversion
  -- once we know `¬ IsField` (which follows from `maximalIdeal ≠ ⊥`).
  have hfield : ¬ IsField (X.left.presheaf.stalk z) := by
    intro hF
    exact hne ((IsLocalRing.isField_iff_maximalIdeal_eq).mp hF)
  have tfae := IsDiscreteValuationRing.TFAE (X.left.presheaf.stalk z) hfield
  -- TFAE entry index 4 is `Submodule.IsPrincipal (IsLocalRing.maximalIdeal R)`.
  exact ((tfae.out 0 4).mpr hprin)

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
    ∃! (g : X.left ⟶ Y.left), g.toRationalMap = f := by
  -- Derived structural instance: the target Y.left is a separated scheme
  -- (as `Y.hom : Y.left ⟶ Spec kbar` is separated and `Spec kbar` is affine
  -- hence separated over the terminal).
  haveI : Y.left.IsSeparated := by
    rw [Scheme.isSeparated_iff]
    have heq : terminal.from Y.left = Y.hom ≫ terminal.from _ := Subsingleton.elim _ _
    rw [heq]; infer_instance
  -- The substantive Milne 3.1 proof body reduces to showing Dom(f) = ⊤:
  --
  -- * Step 1 (codim-1 components of Z(f) ruled out) uses the valuative
  --   criterion of properness on the complete target Y plus the DVR-stalk
  --   structure at codim-1 points (`localRing_dvr_of_codim_one` above, gated
  --   on `isRegularLocalRing_stalk_of_smooth`'s Stage 6 Mathlib gap).
  -- * Step 2 (codim-≥2 extension) uses the depth-≥2 local-cohomology
  --   vanishing `H¹_{x}(V, O_X) = 0` at a depth-≥2 point (Stacks 0AVF), a
  --   genuine Mathlib gap at commit `b80f227`. The codim-1-free hypothesis
  --   `_hf` alone suffices for Step 1's conclusion but Step 2 requires the
  --   local-cohomology / `Module.depth` bridge from
  --   `Albanese/AuslanderBuchsbaum.lean` (`cor:regular_cohen_macaulay`).
  --
  -- Once `Dom(f) = ⊤` is established, the unique morphism extension is the
  -- composition `X.left.topIso.inv ≫ (X.left.isoOfEq h).inv ≫ f.toPartialMap.hom`;
  -- uniqueness follows from the reduced-and-separated agreement principle
  -- (`AlgebraicGeometry.ext_of_isDominant` / `PartialMap.equiv_iff_of_isSeparated`).
  --
  -- Iter-200+ tracked: this lane is gated on Stacks 0AVF
  -- (depth-≥2 H¹ vanishing) + `isRegularLocalRing_stalk_of_smooth`'s Stage 6.
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
        ∃ (z : X.left), Order.coheight z = 1 ∧ x ∈ closure ({z} : Set X.left) := by
  -- Milne's 4-substep proof body — see informal/milne-lemma-3.3.md for the
  -- detailed chain (TBD). Each substep is project-side buildable on top of
  -- Mathlib's Weil-divisor apparatus and the group-object API; substep 4
  -- (pole-divisor intersection with the diagonal is pure codim-1) is the
  -- substantive Mathlib gap.
  --
  -- * Substep 1: construct the difference rational map
  --   `Φ := (id × inv) ∘ (f × f) ∘ m : X × X ⇢ G`, dense on `U × U` for
  --   any representative `(U, φ_U) ∈ f`. Needs the binary product on
  --   `GrpObj`-objects and the right-monoidal-cat structure used in this
  --   project (`MonoidalCategory.tensorObj`, `MonObj.mul`).
  -- * Substep 2: `(x, x) ∈ Dom(Φ) ↔ x ∈ Dom(f)` via the formula
  --   `f(x) = Φ(x, u) · f(u)` for any `u ∈ Dom(f)` in a chosen open
  --   neighbourhood — direct from the group-law continuity + openness of
  --   the domain of definition.
  -- * Substep 3: pullback of the local ring at the identity `e ∈ G`:
  --   `Φ` defined at `(x, x)` ⟺ `Φ^* (𝒪_{G,e}) ⊆ 𝒪_{X×X, (x,x)}`. Uses the
  --   `Scheme.RationalMap`-to-function-field machinery (the same gap that
  --   blocks `thm:weil_divisor_obstruction` at L744 below).
  -- * Substep 4: on the nonsingular variety `X × X`, the pole divisor
  --   `div(g)_∞` of any non-zero rational function `g ∈ Φ^*(𝒪_{G,e})` is
  --   pure codim-1; its intersection with the diagonal is pure codim-1 in
  --   the diagonal (Hartshorne AG 9.2, Krull's principal-ideal theorem).
  --   This is the substantive Mathlib gap: Mathlib's
  --   `RamificationTheory.PrincipalIdeal` provides Krull's HPP for ideals
  --   but the scheme-level codim-1 intersection-with-diagonal lemma is
  --   not packaged.
  --
  -- Iter-200+ tracked: gated on (a) the function-field-pullback bridge for
  -- `Scheme.RationalMap` (also blocks `thm:weil_divisor_obstruction`),
  -- (b) the codim-1 pole-divisor / diagonal intersection lemma (Hartshorne
  -- AG 9.2 scheme-level form).
  sorry

/-! ## §6. Definedness at a prime-divisor generic point

A truthful, lightweight reformulation of definedness at a prime-divisor
generic point: `f` is defined at `W.point` iff `f` admits a `PartialMap`
representative whose domain contains `W.point`. This is a definitional
re-shuffle of `Mathlib.AlgebraicGeometry.Scheme.RationalMap.mem_domain`
swapping the order of the two conjuncts under the existential for downstream
ergonomics (so the `toRationalMap = f` conjunct lands first, the way later
witnesses are constructed in this project).

### Status note (iter-179 Lane D, Path D2)

The blueprint pin `thm:weil_divisor_obstruction` (Hartshorne II.6
pp. 130–131) calls for the genuinely substantive statement

> `f` is defined at `W.point` iff every regular function on every affine
> open `V ⊆ Y` around `f(W.point)` pulls back to an element of
> `O_{X,W.point}` ⊂ `K(X)` of `ord_W`-value `≥ 0`,

which requires the pullback machinery
`Scheme.RationalMap → K(Y) → K(X)` and the project's existing
`Scheme.RationalMap.order : X.functionField → ℤ` valuation from
`RiemannRoch/WeilDivisor.lean`. The Lean-level construction of the
`RationalMap`-to-function-field ring map is **not** shipped by Mathlib
at commit `b80f227`, and building it inside this file would constitute
a substantive new sub-build (cf. `analogies/relative-spec-encoding.md`
on the pullback of a sheaf-of-algebras along a morphism).

iter-178's `extend_iff_order_nonneg` claimed the substantive statement
in its docstring but only proved this reshuffle; the lemma's name and
documentation are corrected here (auditor 178B's Path D2 honest fallback)
to match the proven content. The `[Ring.KrullDimLE 1]` and
`[IsLocallyNoetherian X.left]` typeclass binders that the substantive
statement would have required are dropped along with the renaming, since
the reshuffle does not use them. The substantive statement is deferred to
a future lemma (working title: `extend_iff_pullback_order_nonneg`) once
the pullback machinery lands.

Blueprint reference (in its current weakened form): a definitional unfold
of `Mathlib.AlgebraicGeometry.Scheme.RationalMap.mem_domain`. -/

/-- **Definedness at the generic point of a prime divisor, repackaged.**

For `X` a nonsingular variety over `k̄`, `Y` a variety over `k̄`,
`f : X ⇢ Y` a rational map, and `W : X.left.PrimeDivisor`, the following
are equivalent:

1. `W.point ∈ f.domain` (i.e.\ `f` is defined at the generic point of `W`).
2. There exists a `PartialMap` representative `g` of `f` (a regular morphism
   `g.hom : g.domain ⟶ Y.left` from a dense open `g.domain ⊆ X.left` with
   `g.toRationalMap = f`) whose domain contains `W.point`.

This is the canonical existential characterisation of `f.domain` membership
via `Mathlib.AlgebraicGeometry.Scheme.RationalMap.mem_domain`, with the two
conjuncts under the existential reordered so the `toRationalMap = f`
component lands first (matching the way later witnesses in this project
construct partial-map representatives).

**Iter-179 Lane D scope.** This statement is the auditor-178B Path D2 honest
fallback: the substantive Hartshorne-II.6 "regular = no pole" Weil-divisor
reformulation (Stacks `02ME`), which would tighten the right-hand side to
an `ord_W ≥ 0` condition on every pulled-back regular function, is deferred
to a future lemma that builds the missing `RationalMap → function-field`
pullback machinery. See the section-level docstring above. -/
theorem mem_domain_iff_exists_partialMap_through_point
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    {X : Over (Spec (.of kbar))}
    [Smooth X.hom] [GeometricallyIrreducible X.hom]
    [IsSeparated X.hom] [LocallyOfFiniteType X.hom]
    [IsIntegral X.left] [IsReduced X.left]
    {Y : Over (Spec (.of kbar))}
    [IsSeparated Y.hom] [LocallyOfFiniteType Y.hom]
    [IsIntegral Y.left] [IsReduced Y.left]
    (f : X.left.RationalMap Y.left) (W : X.left.PrimeDivisor) :
    W.point ∈ f.domain ↔
      ∃ (g : X.left.PartialMap Y.left),
        g.toRationalMap = f ∧ W.point ∈ (g.domain : Set X.left) := by
  rw [Scheme.RationalMap.mem_domain]
  exact ⟨fun ⟨g, hxg, hg⟩ => ⟨g, hg, hxg⟩, fun ⟨g, hg, hxg⟩ => ⟨g, hxg, hg⟩⟩

end RationalMap

end Scheme

end AlgebraicGeometry
