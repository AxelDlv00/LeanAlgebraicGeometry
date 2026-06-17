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

/-- **Stacks `00TT`, Jacobian-criterion direction (regularity conclusion).**
For a smooth integral variety `X` over an algebraically closed field `k̄`, the
stalk of `X` at every point is a regular local ring.

This is the scheme-level packaging of Stacks tag `00TT` (Lemma 10.140.3
"Smooth algebras over fields"): given an affine chart `Spec A ⊆ X`, the
\(\bar k\)-algebra `A` is smooth at every prime `𝔮`, and the localisation
`A_𝔮 = X.presheaf.stalk z` (for `z ∈ X` lying over `𝔮`) is regular by the
"in this case the local ring `A_𝔮` is regular" clause of the cited lemma.

**Mathlib status at commit `b80f227` (iter-191 Lane M↓ first scaffold).**
The 4-stage proof chain is now scaffolded as follows.

* Stage 1 (`stalkMap_flat_of_smooth`): smooth ⟹ flat at every stalk.
  Axiom-clean.
* Stage 2 (`exists_isStandardSmooth_at_of_smooth`): smooth ⟹ standard
  smooth presentation locally. Axiom-clean.
* Stage 3-4 (Stacks `02JK`/`00OE`): polynomial generators ⟹ regular
  sequence ⟹ regular local ring. The Jacobian-criterion content
  ("standard smooth presentation ⟹ the maximal ideal of every stalk is
  generated by a regular sequence of length = Krull dim") is the
  Mathlib gap, captured here as a *single named scoped* `sorry` consuming
  the Stage 1-2 axiom-clean outputs.

Once Stages 3-4 close upstream, this helper closes axiom-clean and every
downstream consumer (`smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot`,
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
  -- Stage 2 (axiom-clean): smooth ⟹ standard smooth presentation on
  -- some affine neighbourhood of z.
  obtain ⟨U, hU, V, hV, hzV, e, hStdSmooth⟩ :=
    exists_isStandardSmooth_at_of_smooth X z
  -- Stages 3-4 (Mathlib gap, Stacks 02JK + 00OE):
  --   from the standard smooth presentation `hStdSmooth` (with polynomial
  --   generators), the maximal ideal of every localisation of the affine
  --   chart `V = Spec A` at a prime `𝔭` is generated by a regular sequence
  --   of length equal to the Krull dimension of `A_𝔭`; hence the local
  --   ring is regular. The stalk `X.left.presheaf.stalk z` is identified
  --   with `A_𝔭` via the affine-open-stalk Mathlib bridge, transporting
  --   regularity. This chain remains to be assembled (iter-192+ work,
  --   either via the cotangent / sheaf-of-relative-differentials route
  --   upstream or via a project-side `02JK`/`00OE` build).
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
        ∃ (z : X.left), Order.coheight z = 1 ∧ x ∈ closure ({z} : Set X.left) :=
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
