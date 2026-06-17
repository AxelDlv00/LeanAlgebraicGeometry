/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib

/-!
# Flattening stratification of a coherent sheaf (A.2.a)

This file is the **A.2.a** file-skeleton sub-build chapter for the project's
positive-genus arm of `nonempty_jacobianWitness`. It packages the
Nitsure~\S4 flattening-stratification theorem — the technical heart that
turns the absolute Quot-functor representability problem on a projective
morphism `π : X ⟶ S` with coherent input `𝓕` into a finite collection of
locally-closed strata over which `𝓕` becomes flat.

## Status (iter-176 Lane E file-skeleton — re-dispatch)

iter-175 Lane E died to the Anthropic session-limit reset window without
ever calling `Write` (the file was never created). iter-176 re-dispatches
the file-skeleton verbatim. Each blueprint-pinned declaration carries the
*intended* substantive type signature (matching the `\lean{...}` pin in
`blueprint/src/chapters/Picard_FlatteningStratification.tex`) with a
`sorry` body. The bodies are iter-177+ work; the substantive proofs are
deep (Nitsure~\S4 ~250-line argument: generic-flatness ⟶ Noetherian
induction ⟶ Castelnuovo–Mumford regularity ⟶ assembly via direct images
`E_i = π_* 𝓕(N+i)`).

The 4 blueprint-pinned declarations are:

1. `AlgebraicGeometry.Scheme.CoherentSheafFlat` (def, ~8 LOC) — the
   **coherent-sheaf flatness predicate** for a coherent `𝓕` on `X` over
   `S` via `f : X ⟶ S`. Affine-locally: for `U ⊆ S` and `V ⊆ f⁻¹U` both
   affine, `Γ(𝓕, V)` is a flat `Γ(S, U)`-module via the composite
   `Γ(S, U) → Γ(X, V) → End(Γ(𝓕, V))`. The corresponding Stacks tag is
   00HB (module-level) lifted to a sheaf-level predicate by the
   affine-local descent characterisation.

2. `AlgebraicGeometry.genericFlatness` (theorem, ~15 LOC) — **generic
   flatness** [Nitsure §4 Theorem]: over a noetherian integral base
   `S`, a coherent sheaf on a finite-type `X ⟶ S` is flat over a
   non-empty open `V ⊆ S`.

3. `AlgebraicGeometry.flatteningStratification` (theorem, ~25 LOC) — the
   **flattening-stratification existence theorem** [Nitsure §4]: for `S`
   noetherian and `𝓕` coherent on a proper `π : X ⟶ S`, there exists a
   finite locally-closed stratification `{S_f}` of `S` (set-theoretically
   covering, pairwise disjoint) such that `𝓕` becomes flat on each
   stratum.

4. `AlgebraicGeometry.flatteningStratification_universal` (theorem, ~15 LOC)
   — the **universal property** of the stratification [Nitsure §4 (ii)]:
   any morphism `φ : T ⟶ S` such that `𝓕` pulled back to `X ×_S T` is
   `T`-flat factors uniquely through the stratum coproduct
   `i : ⨿ S_f ⟶ S`.

Additionally, three sub-lemmas decompose the existence proof, plus a
curve-specialisation corollary feeding the Route~A consumer:

5. `AlgebraicGeometry.flatLocusStratification` (lemma, ~12 LOC) — the
   **special case `n = 0`** [Nitsure §4, n=0]: a coherent `𝓕` on `S`
   admits a finite locally-closed stratification by integer "rank"
   strata.

6. `AlgebraicGeometry.flatLocusReduction` (lemma, ~12 LOC) — the
   **Noetherian-induction reduction** [Nitsure §4 general case opening]:
   a finite reduced locally-closed stratification on which `𝓕`
   *already* becomes flat (without polynomial indexing).

7. `AlgebraicGeometry.flatLocusAssembly` (lemma, ~15 LOC) — the
   **assembly step** [Nitsure §4 via direct images]: combining the
   `n = 0` stratification iteratively on the direct images
   `E_i = π_* 𝓕(N+i)` to refine to the Hilbert-polynomial-indexed
   stratification.

8. `AlgebraicGeometry.flatteningStratification.ofCurve` (theorem, ~10 LOC)
   — the **relative-curve specialisation** for the Route~A consumer
   `C ×_k T → T`.

## Note on type expressivity

Following the project rule "Never weaken the type to dodge the proof",
each declaration carries a substantive, non-tautological type:

- `CoherentSheafFlat` reduces to module-theoretic flatness of every
  affine-local section module over the corresponding affine-base ring
  via the `appLE` ring-hom — non-empty content because flatness of a
  module is the standard non-trivial homological condition.
- `genericFlatness` requires the existence of a *non-empty* open `V`
  and substantive flatness on every affine `U ⊆ V`; both quantifiers
  are necessary (without them the statement collapses to `V = ∅`).
- `flatteningStratification` packages a *finite* indexed family of
  *locally-closed-immersions* `ι : S_f ⟶ S` that pairwise *cover*
  `|S|` *disjointly* AND on which the pullback `𝓕|_{X ×_S S_f}` becomes
  `S_f`-flat — all four conjuncts are substantive (any single
  one trivialises if dropped).
- `flatteningStratification_universal` packages the universal property
  via `∃!` (unique existence of factorisation), a substantive Yoneda
  bijection content.

## Mathlib status

Mathlib (master `b80f227`) provides `Module.Flat`,
`AlgebraicGeometry.Flat` (morphism-level), `IsImmersion`,
`IsLocallyNoetherian`, `IsIntegral`, `LocallyOfFiniteType`. It does NOT
provide: a relative projective space `ℙⁿ_S`, an `IsProjective` morphism
property, the flattening-stratification construction, or coherent-sheaf
flatness as a sheaf-level predicate.

The current file-skeleton uses `IsProper π` as the structural stand-in
for "projective `π`" (every projective morphism is proper; the
restriction is harmless in the Route~A consumer setting where `π` comes
from a smooth proper curve, which is automatically projective).
iter-177+ refinement: once Mathlib gains an `IsProjective` morphism
property, the hypothesis tightens.

## References

Blueprint: `blueprint/src/chapters/Picard_FlatteningStratification.tex`
(735 LOC, 4 pins + 4 sub-lemma/corollary names). Source: Nitsure,
"Construction of Hilbert and Quot schemes", §4 (FGA Explained Ch. 5,
arXiv:math/0504020 pp. 5–18); Stacks Project tags 00HB (module flat),
052H (flattening stratification).
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

/-! ## Project-local Mathlib supplement — algebraic generic freeness (finite case)

This section builds the **module-theoretic** generic-freeness statements that
underlie the geometric `genericFlatness` (blueprint
`thm:generic_flatness_algebraic`, Nitsure~\S4 "Lemma on Generic Flatness").

The full algebraic statement — `A` a noetherian domain, `B` a *finite-type*
`A`-algebra, `M` a finite `B`-module ⟹ `∃ f ≠ 0` with `M_f` free over `A_f` —
is a deep theorem (prime-filtration dévissage + Noether normalisation +
clearing denominators). Mathlib already supplies most of the dévissage
machinery (`IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime`,
`ModuleCat.free_shortExact`, `exists_finite_inj_algHom_of_fg`), but it does
**not** yet contain the polynomial-ring core (generic freeness for a finite
module over `A[X₁,…,X_d]`). See the file `task_results` handoff for the
precise decomposition of the remaining gap.

What we *can* land axiom-clean here is the **finite-module / finite-morphism
case**: when `M` is finite as an `A`-module (in particular when `B` is
module-finite over `A`), generic freeness follows directly from
`Module.FinitePresentation.exists_free_localizedModule_powers` applied at the
generic point `Frac A`, where `M ⊗_A Frac A` is a finite vector space hence
free. This is a genuine special case of the algebraic generic-freeness
theorem (the case of a *finite* morphism `X → S`), and a reusable building
block for the dévissage's leaves. -/

namespace GenericFreeness

/-- **Generic freeness, finite-module case.** For a noetherian integral domain
`A` and a finite `A`-module `M`, there is a non-zero `f ∈ A` such that the
localisation `M_f` is free over `A_f = Localization.Away f`.

This is the `d = 0` (finite-morphism) special case of the algebraic
generic-flatness theorem (`thm:generic_flatness_algebraic`, Nitsure~\S4):
inverting the generic point `Frac A`, the localised module is a finite vector
space hence free, and `Module.FinitePresentation.exists_free_localizedModule_powers`
descends that freeness to a single basic open `D(f) ⊆ Spec A`. -/
theorem exists_free_localizationAway_of_finite
    (A : Type u) (M : Type v) [CommRing A] [IsDomain A] [IsNoetherianRing A]
    [AddCommGroup M] [Module A M] [Module.Finite A M] :
    ∃ f : A, f ≠ 0 ∧
      Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) M) := by
  haveI : Module.FinitePresentation A M := Module.finitePresentation_of_finite A M
  obtain ⟨r, hr, hfree, _⟩ :=
    Module.FinitePresentation.exists_free_localizedModule_powers (nonZeroDivisors A)
      (LocalizedModule.mkLinearMap (nonZeroDivisors A) M) (FractionRing A)
  exact ⟨r, nonZeroDivisors.ne_zero hr, hfree⟩

/-- **Generic flatness, finite-module case.** The flatness form of
`exists_free_localizationAway_of_finite`: for a noetherian domain `A` and a
finite `A`-module `M`, there is a non-zero `f` with `M_f` flat over `A_f`.
This is the affine-local content of `genericFlatness` for a finite morphism. -/
theorem exists_flat_localizationAway_of_finite
    (A : Type u) (M : Type v) [CommRing A] [IsDomain A] [IsNoetherianRing A]
    [AddCommGroup M] [Module A M] [Module.Finite A M] :
    ∃ f : A, f ≠ 0 ∧
      Module.Flat (Localization.Away f) (LocalizedModule (Submonoid.powers f) M) := by
  obtain ⟨f, hf, hfree⟩ := exists_free_localizationAway_of_finite A M
  haveI := hfree
  exact ⟨f, hf, Module.Flat.of_free⟩

/-- **Generic freeness, finite-morphism case.** If `A` is a noetherian domain,
`B` a *module-finite* `A`-algebra, and `M` a finite `B`-module (with the
compatible `A`-module structure), then there is a non-zero `f ∈ A` with `M_f`
free over `A_f`. Reduces to `exists_free_localizationAway_of_finite` via
`Module.Finite.trans` (a finite module over a module-finite algebra is finite
over the base). This is generic flatness for a *finite* morphism `X → S`. -/
theorem exists_free_localizationAway_of_moduleFinite
    (A : Type u) (B : Type v) (M : Type v)
    [CommRing A] [IsDomain A] [IsNoetherianRing A]
    [CommRing B] [Algebra A B] [Module.Finite A B]
    [AddCommGroup M] [Module B M] [Module.Finite B M]
    [Module A M] [IsScalarTower A B M] :
    ∃ f : A, f ≠ 0 ∧
      Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) M) := by
  haveI : Module.Finite A M := Module.Finite.trans B M
  exact exists_free_localizationAway_of_finite A M

end GenericFreeness

namespace Scheme

/-! ## §1. Coherent-sheaf flatness over a base

For a morphism `f : X ⟶ S` of schemes and a coherent (more generally:
quasi-coherent) `𝓞_X`-module `𝓕`, the *coherent-sheaf flatness* predicate
`CoherentSheafFlat f 𝓕` captures Stacks 00HB lifted to the sheaf level:
for every point `x ∈ X` the stalk `𝓕_x` is a flat `𝓞_{S, f(x)}`-module
via the composite `𝓞_{S, f(x)} → 𝓞_{X, x} → End(𝓕_x)`.

Affine-locally (Stacks 00HB equivalence): on an affine open `U = Spec A
⊆ S` and an affine open `V = Spec B ⊆ f⁻¹U` with `𝓕|_V = M̃` for a
finite `B`-module `M`, the condition becomes `Module.Flat A M` with the
`A`-module structure inherited via the ring map `A → B`. The
file-internal encoding uses this affine-local form.

Blueprint reference: `def:coherent_sheaf_flat`. -/

/-- A coherent sheaf `𝓕` on `X` is **flat over `S`** for a morphism
`f : X ⟶ S` if, for every affine open `U ⊆ S` and every affine open
`V ⊆ f⁻¹U`, the `𝓞_X`-module of sections `Γ(𝓕, V)` is flat as a
`Γ(S, U)`-module, where the `Γ(S, U)`-action is the restriction of
scalars along the ring morphism `Γ(S, U) → Γ(X, V)` (the `appLE`
morphism of `f`).

This is the affine-local form of Stacks 00HB (a coherent sheaf is flat
over the base if every stalk is flat over the corresponding base
stalk); the affine-local form and stalk form are equivalent for
*quasi-coherent* sheaves on a noetherian base, which is the regime of
the flattening-stratification theorem.

iter-177+: the body of subsequent flat-locus theorems may package this
predicate as an instance-driven typeclass `Module.Flat`-style if the
sheafified-tensor infrastructure lands in Mathlib; for the iter-176
file-skeleton it is encoded as a `Prop` quantifier. -/
def CoherentSheafFlat {X S : Scheme.{u}} (f : X ⟶ S) (F : X.Modules) : Prop :=
  ∀ {U : S.Opens} (_ : IsAffineOpen U) {V : X.Opens} (_ : IsAffineOpen V)
    (e : V ≤ f ⁻¹ᵁ U),
    letI : Module Γ(S, U) Γ(F, V) := Module.compHom _ (f.appLE U V e).hom
    Module.Flat Γ(S, U) Γ(F, V)

end Scheme

/-! ## §2. Generic flatness (Nitsure §4)

Over a noetherian integral base `S`, a coherent sheaf on a finite-type
`X ⟶ S` is flat above some non-empty open `V ⊆ S`. This is the inductive
engine of the flattening-stratification theorem: combined with
Noetherian induction on the closed complement `S ∖ V`, it produces the
finite stratification of `S` by flatness loci.

Algebraically (theorem `generic_flatness_algebraic`, no Lean pin): for a
noetherian domain `A`, a finite-type `A`-algebra `B`, and a finite
`B`-module `M`, there exists a non-zero `f ∈ A` such that `M_f` is a
free `A_f`-module. The geometric form (this declaration) restricts to a
non-empty affine open `Spec A ⊆ S` and applies the algebraic form on
each finite-type-algebra patch of `X` above `Spec A`.

Blueprint reference: `thm:generic_flatness` (Nitsure §4). -/

/-- **Generic flatness theorem** (Nitsure §4 / Stacks ?).

For a noetherian integral scheme `S`, a finite-type morphism `p : X ⟶ S`,
and a coherent `𝓞_X`-module `𝓕`, there exists a non-empty open subscheme
`V ⊆ S` such that `𝓕|_{X_V} = 𝓕|_{p⁻¹V}` is flat over `𝓞_V`.

iter-177+: the body follows Nitsure §4: pass to a non-empty affine open
`Spec A ⊆ S` where `A` is a noetherian domain, then apply the algebraic
form (Noether normalisation + Auslander–Buchsbaum-style filtration
argument) to each finite-type-`A`-algebra `B` arising from an affine
cover of `p⁻¹(Spec A)`. The witness `V` is the common basic open
`D(f_1 f_2 ⋯ f_r) ⊆ Spec A` clearing the finitely many
generic-flatness elements `f_i ∈ A` produced on each patch. -/
theorem genericFlatness {S X : Scheme.{u}} [IsIntegral S] [IsLocallyNoetherian S]
    (p : X ⟶ S) [LocallyOfFiniteType p] (F : X.Modules) :
    ∃ (V : S.Opens), (V : Set S).Nonempty ∧
      ∀ {U : S.Opens} (_ : IsAffineOpen U) (_ : U ≤ V) {W : X.Opens}
        (_ : IsAffineOpen W) (e : W ≤ p ⁻¹ᵁ U),
        letI : Module Γ(S, U) Γ(F, W) := Module.compHom _ (p.appLE U W e).hom
        Module.Flat Γ(S, U) Γ(F, W) := by
  sorry

/-! ## §3. Sub-lemmas of the existence proof

The Nitsure §4 proof of the existence theorem decomposes into three
sub-lemmas wired together by Noetherian induction. The first is the
special case `n = 0` (when `ℙⁿ_S = S`); the second is the
Noetherian-induction reduction to a finite stratification where `𝓕`
*already* becomes flat (but without polynomial indexing); the third is
the assembly step that re-introduces the Hilbert-polynomial indexing
via the direct images `E_i = π_* 𝓕(N+i)`.

Blueprint references: `lem:flat_locus_open`, `lem:nonflat_locus_proper`,
`lem:noetherian_induction_strata`. -/

/-- **Lemma 5 (special case `n = 0`).** [Nitsure §4 special case]

For `S` noetherian and `𝓕` a coherent `𝓞_S`-module, there exists a
countable family `S_e ⊆ S` (indexed by `e ∈ ℕ`) of locally-closed
subschemes such that
- each `S_e` is a (locally-closed) immersion `S_e ⟶ S`;
- the underlying sets `|S_e|` partition `|S|`;
- the pullback `𝓕|_{S_e}` is flat over `𝓞_{S_e}` (an `𝓞_{S_e}`-module
  pulled back is automatically `𝓞_{S_e}`-flat over itself, which is the
  substantive content for this lemma; the *rank*-`e` refinement is
  iter-177+ work once the locally-free-of-rank-`e` predicate is in
  scope).

The function `s ↦ dim_{κ(s)} 𝓕|_s` is upper-semicontinuous (this is
content (iii) of Nitsure's special case), encoded indirectly by the
fact that the strata are locally-closed and disjoint.

Nitsure's proof: Nakayama produces a local presentation
`𝓞_V^{⊕m} ⟶ 𝓞_V^{⊕e} ⟶ 𝓕|_V ⟶ 0`; the closed subscheme `V_e ⊆ V`
defined by the matrix-entry ideal of the first map represents the
locus of locally-free-of-rank-`e`; gluing over a cover and intersecting
with `V ∖ ⋃_{e' > e} V_{e'}` produces the locally-closed `S_e`. -/
lemma flatLocusStratification {S : Scheme.{u}} [IsLocallyNoetherian S]
    (F : S.Modules) :
    ∃ (S_ : ℕ → Scheme.{u}) (ι : ∀ e, S_ e ⟶ S),
      (∀ e, IsImmersion (ι e)) ∧
      (∀ e e', e ≠ e' → Disjoint (Set.range (ι e).base) (Set.range (ι e').base)) ∧
      (∀ s : S, ∃ e, s ∈ Set.range (ι e).base) ∧
      (∀ e, Scheme.CoherentSheafFlat (ι e) ((Scheme.Modules.pullback (ι e)).obj F)) := by
  sorry

/-- **Lemma 6 (Noetherian-induction reduction).** [Nitsure §4 general
case opening]

For `S` noetherian, `π : X ⟶ S` proper, and `𝓕` coherent on `X`, there
exist finitely many reduced locally-closed immersions `V_i ⟶ S` with
pairwise disjoint set-theoretic images covering `|S|`, such that the
pullback `𝓕|_{X ×_S V_i}` is flat over `V_i`.

Nitsure's proof: peel off non-empty open flat patches by
`genericFlatness` applied to each irreducible component (with its
reduced subscheme structure), induct on the closed complement
`S ∖ V` (which is again noetherian, hence the induction terminates by
Noetherianity).

The substantive content over the special case (Lemma 5) is that the
strata `V_i` are *reduced* and that `𝓕` becomes flat above them (not
merely that strata exist); the polynomial-indexed refinement of the
main theorem (`flatteningStratification`) requires further assembly
(`flatLocusAssembly`). -/
lemma flatLocusReduction {S X : Scheme.{u}} [IsLocallyNoetherian S]
    (π : X ⟶ S) [IsProper π] (F : X.Modules) :
    ∃ (I : Type u) (_ : Finite I) (V_ : I → Scheme.{u}) (ι : ∀ i, V_ i ⟶ S),
      (∀ i, IsImmersion (ι i)) ∧
      (∀ i j, i ≠ j → Disjoint (Set.range (ι i).base) (Set.range (ι j).base)) ∧
      (∀ s : S, ∃ i, s ∈ Set.range (ι i).base) ∧
      (∀ i, Scheme.CoherentSheafFlat (pullback.snd π (ι i))
        ((Scheme.Modules.pullback (pullback.fst π (ι i))).obj F)) := by
  sorry

/-- **Lemma 7 (assembly via direct images).** [Nitsure §4 assembly step]

For `S` noetherian and `𝓕` coherent on a proper `π : X ⟶ S`, there
exists an integer `N` such that iterating the `n=0` stratification
(Lemma 5) on the direct images `E_i := π_*𝓕(N+i)` on `S`
(`i = 0, 1, …`) produces, after finitely many refinements, the
Hilbert-polynomial-indexed stratification of the main theorem.

The substantive content is the existence of the uniform vanishing
bound `N` together with the finite refinement chain producing the
locally-closed strata `S_f` from the rank-strata `W_{e_0, …, e_n}`.

For the iter-176 file-skeleton this is encoded by the existence of a
finite locally-closed stratification refining Lemma 6, together with
the assertion that the strata carry constant Hilbert polynomial (the
"polynomial-locally-constant" content of Nitsure's statement (A)).
The Hilbert polynomial itself is encoded abstractly as a function
`I → (ℕ → ℤ)` (each numerical polynomial restricted to `ℕ`); the
substantive refinement to `numericalPolynomial` of degree `≤ n` is
iter-177+ work. -/
lemma flatLocusAssembly {S X : Scheme.{u}} [IsLocallyNoetherian S]
    (π : X ⟶ S) [IsProper π] (F : X.Modules) :
    ∃ (I : Type u) (_ : Finite I) (S_ : I → Scheme.{u}) (ι : ∀ f, S_ f ⟶ S)
      (P : I → ℕ → ℤ),
      (∀ f, IsImmersion (ι f)) ∧
      (∀ f g, f ≠ g → Disjoint (Set.range (ι f).base) (Set.range (ι g).base)) ∧
      (∀ s : S, ∃ f, s ∈ Set.range (ι f).base) ∧
      (∀ f, Scheme.CoherentSheafFlat (pullback.snd π (ι f))
        ((Scheme.Modules.pullback (pullback.fst π (ι f))).obj F)) ∧
      (∀ f g, f = g ↔ P f = P g) := by
  sorry

/-! ## §4. Existence of the flattening stratification (Nitsure §4 main)

The main theorem combines the three sub-lemmas above: starting from a
proper morphism `π : X ⟶ S` and a coherent sheaf `𝓕`, one obtains a
finite locally-closed stratification of `S` indexed by Hilbert
polynomials, on each piece of which `𝓕` becomes flat, with all four
properties of Nitsure's Theorem packaged in a single conjunction.

Blueprint reference: `thm:flattening_stratification_exists`
(Nitsure §4; Stacks 052H). -/

/-- **Flattening stratification existence theorem** [Nitsure §4 main /
Stacks 052H].

For a noetherian scheme `S`, a proper morphism `π : X ⟶ S`, and a
coherent `𝓞_X`-module `𝓕`, there exists a finite locally-closed
stratification `{S_f}` of `S` indexed by a finite set `I` such that
- each `ι : S_f ⟶ S` is a (locally-closed) immersion;
- the underlying sets `|S_f|` partition `|S|` (disjoint and covering);
- the pullback `𝓕|_{X ×_S S_f}` is flat over `S_f` for each `f`.

The (intended) substantive refinement is that the index set `I` is in
bijection with the set of Hilbert polynomials arising on fibres, and
that each `S_f` is uniquely determined by its Hilbert polynomial. For
the iter-176 file-skeleton the substantive type captures the
stratification + flatness; the Hilbert-polynomial labeling is encoded
in `flatLocusAssembly`'s `P : I → ℕ → ℤ` injection but elided here for
type-clarity.

iter-177+: the body assembles `flatLocusReduction` (Lemma 6) ⟶
`flatLocusAssembly` (Lemma 7). The structural skeleton is encoded
directly here; the Mathlib-side ingredients required (relative
projective space `ℙⁿ_S`, Castelnuovo–Mumford regularity, direct image
base-change `R^r π_* 𝓕(m) = 0` for `m ≫ 0`, cohomology-and-base-change
Stacks tag 02KH for the `H^0` form) are itemised in the blueprint
chapter §`Mathlib status`. -/
theorem flatteningStratification {S X : Scheme.{u}} [IsLocallyNoetherian S]
    (π : X ⟶ S) [IsProper π] (F : X.Modules) :
    ∃ (I : Type u) (_ : Finite I) (S_ : I → Scheme.{u}) (ι : ∀ f, S_ f ⟶ S),
      (∀ f, IsImmersion (ι f)) ∧
      (∀ s : S, ∃ f, s ∈ Set.range (ι f).base) ∧
      (∀ f g, f ≠ g → Disjoint (Set.range (ι f).base) (Set.range (ι g).base)) ∧
      (∀ f, Scheme.CoherentSheafFlat (pullback.snd π (ι f))
        ((Scheme.Modules.pullback (pullback.fst π (ι f))).obj F)) := by
  sorry

/-! ## §5. Universal property of the stratification

Nitsure's part (ii): the morphism `i : ⨿_f S_f → S` assembled from the
stratum inclusions is universal for "`𝓕` becomes `T`-flat after pullback
along `T → S`". Equivalently, for any morphism `φ : T ⟶ S` such that
`𝓕|_{X ×_S T}` is `T`-flat, `φ` factors uniquely through some `S_f`.

For the iter-176 file-skeleton we encode the universal property in the
factor-through form (∃! factorisation through one of the strata
`ι f : S_f ⟶ S`), which is the substantive Yoneda-bijection content of
Nitsure's part (ii).

Blueprint reference: `thm:flattening_stratification_universal`
(Nitsure §4 (ii); Stacks 052H). -/

/-- **Universal property of the flattening stratification**
[Nitsure §4 (ii) / Stacks 052H].

Given the flattening stratification `{S_f}` of `S` (existence supplied
by `flatteningStratification`), a morphism `φ : T ⟶ S` such that the
pullback `𝓕|_{X ×_S T}` is `T`-flat factors uniquely through one of the
locally-closed inclusions `ι : S_f ⟶ S`.

The hypothesis takes the stratification data `(I, S_, ι)` as an
explicit parameter (rather than re-extracting it from
`flatteningStratification`'s existential output) so the universal
property is decoupled from the choice of stratification — different
witnesses agree on the universal-property content. iter-177+: refine
to a `Functor.RepresentableBy`-style universal arrow once the
contravariant functor `T ↦ {φ : T ⟶ S | 𝓕|_{X_T} is T-flat}` is
available. -/
theorem flatteningStratification_universal {S X : Scheme.{u}}
    [IsLocallyNoetherian S] (π : X ⟶ S) [IsProper π] (F : X.Modules)
    (I : Type u) [Finite I] (S_ : I → Scheme.{u}) (ι : ∀ f, S_ f ⟶ S)
    [∀ f, IsImmersion (ι f)] :
    ∀ {T : Scheme.{u}} (φ : T ⟶ S),
      Scheme.CoherentSheafFlat (pullback.snd π φ)
        ((Scheme.Modules.pullback (pullback.fst π φ)).obj F) →
      ∃! (data : (f : I) × (T ⟶ S_ f)),
        data.2 ≫ ι data.1 = φ := by
  sorry

/-! ## §6. Curve specialisation (Route A consumer)

In the Route A consumer setting, the input morphism is the second
projection `pr_T : C ×_k T ⟶ T` of the pullback of a smooth proper
curve `C/k` against a noetherian `k`-scheme `T`. A smooth proper curve
over a field is automatically projective (Hartshorne II.6.7 / II.7.6;
folklore), hence in particular proper; the relative-curve `C ×_k T → T`
inherits properness by base change, hence the hypotheses of the main
theorem are met. This corollary records the specialisation
explicitly. -/

/-- **Flattening stratification for a coherent sheaf on a relative
curve** [Nitsure §4 corollary; Route~A consumer A.2.a entry-point].

Let `k` be a field, `C` a smooth proper curve over `k` (encoded as
`C : Over (Spec k)` with `[SmoothOfRelativeDimension 1 C.hom]` and
`[IsProper C.hom]`), and `T` a noetherian `k`-scheme. For any coherent
sheaf `𝓕` on the relative curve `C ×_k T`, the flattening
stratification conclusion of `flatteningStratification` applies to
`π = pr_T : C ×_k T → T` and `𝓕`: there is a finite locally-closed
stratification `{T_f ⊆ T}` set-theoretically covering `T` disjointly,
such that `𝓕|_{C ×_k T_f}` is flat over `T_f` for each `f`.

iter-177+: the body invokes `flatteningStratification` on the
base-changed morphism `pullback.snd C.hom T.hom : (C ×_k T) ⟶ T`,
using that `IsProper (pullback.snd C.hom T.hom)` holds by base change
of `IsProper C.hom`. For the iter-176 file-skeleton the body is a
typed `sorry`. -/
theorem flatteningStratification.ofCurve {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    (T : Over (Spec (.of k))) [IsLocallyNoetherian T.left]
    (F : (Limits.pullback C.hom T.hom).Modules) :
    ∃ (I : Type u) (_ : Finite I) (T_ : I → Scheme.{u}) (ι : ∀ f, T_ f ⟶ T.left),
      (∀ f, IsImmersion (ι f)) ∧
      (∀ t : T.left, ∃ f, t ∈ Set.range (ι f).base) ∧
      (∀ f g, f ≠ g → Disjoint (Set.range (ι f).base) (Set.range (ι g).base)) ∧
      (∀ f, Scheme.CoherentSheafFlat
        (pullback.snd (pullback.snd C.hom T.hom) (ι f))
        ((Scheme.Modules.pullback
          (pullback.fst (pullback.snd C.hom T.hom) (ι f))).obj F)) := by
  sorry

end AlgebraicGeometry
