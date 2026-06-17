/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib

/-!
# Generic flatness of a coherent sheaf (A.2.a)

This file packages the classical Grothendieck/Nitsure~\S4 **generic flatness**
theorem: over a noetherian integral base `S`, a coherent `𝓞_X`-module on a
finite-type morphism `X ⟶ S` becomes flat after restricting to a non-empty open
subscheme of `S`. This is the inductive engine underlying the
flattening-stratification construction of Grothendieck's existence theorem for
the Quot scheme.

Each blueprint-pinned declaration carries the *intended* substantive type
signature (matching the `\lean{...}` pin in
`blueprint/src/chapters/Picard_FlatteningStratification.tex`) with a `sorry`
body where the proof is not yet supplied. The substantive generic-flatness
proof is deep (Nitsure~\S4: prime-filtration dévissage + Noether normalisation +
clearing denominators).

The blueprint-pinned declaration is:

- `AlgebraicGeometry.genericFlatness` (theorem) — **generic flatness**
  [Nitsure §4 Theorem]: over a noetherian integral base `S`, a coherent sheaf
  on a finite-type `X ⟶ S` is flat over a non-empty open `V ⊆ S`. Its
  algebraic form (`thm:generic_flatness_algebraic`, no Lean pin) is the
  statement that a finite module over a finite-type algebra over a noetherian
  domain becomes free after inverting one non-zero element of the base.

The file-internal `GenericFreeness` namespace lands the **finite-module /
finite-morphism special case** of the algebraic form axiom-clean, as a reusable
building block for the dévissage's leaves.

## Note on type expressivity

Following the project rule "Never weaken the type to dodge the proof",
`genericFlatness` requires the existence of a *non-empty* open `V` and
substantive flatness on every affine `U ⊆ V`; both quantifiers are necessary
(without them the statement collapses to `V = ∅`).

## Mathlib status

Mathlib (master `b80f227`) provides `Module.Flat`, `AlgebraicGeometry.Flat`
(morphism-level), `IsImmersion`, `IsLocallyNoetherian`, `IsIntegral`,
`LocallyOfFiniteType`, and the dévissage / Noether-normalisation infrastructure
the algebraic generic-flatness argument consumes. It does NOT yet provide the
polynomial-ring core of generic freeness, nor the geometric `genericFlatness`
statement packaging it over a noetherian integral base.

## References

Blueprint: `blueprint/src/chapters/Picard_FlatteningStratification.tex`.
Source: Nitsure, "Construction of Hilbert and Quot schemes", §4 (FGA Explained
Ch. 5, arXiv:math/0504020 pp. 5–18); Stacks Project tag 00HB (module flat).
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
    (A : Type*) (M : Type*) [CommRing A] [IsDomain A] [IsNoetherianRing A]
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
    (A : Type*) (M : Type*) [CommRing A] [IsDomain A] [IsNoetherianRing A]
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
    (A : Type*) (B : Type*) (M : Type*)
    [CommRing A] [IsDomain A] [IsNoetherianRing A]
    [CommRing B] [Algebra A B] [Module.Finite A B]
    [AddCommGroup M] [Module B M] [Module.Finite B M]
    [Module A M] [IsScalarTower A B M] :
    ∃ f : A, f ≠ 0 ∧
      Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) M) := by
  haveI : Module.Finite A M := Module.Finite.trans B M
  exact exists_free_localizationAway_of_finite A M

/-! ### Dévissage chain for the finite-type residue (Nitsure §4)

The following sub-lemmas decompose the surviving residue of
`genericFlatnessAlgebraic` — the case where `M` is finite over the finite-type
`A`-algebra `B` but not module-finite over `A` — into the classical Nitsure §4
induction. They are ordered so each step uses only earlier blocks (or Mathlib
anchors). Throughout, `A` is a noetherian domain with fraction field
`K = Frac A`, `B` a finite-type `A`-algebra, and `M` a finite `B`-module with
the compatible `A`-module structure via the scalar tower `A → B → M`. -/

/-- **L1 — torsion base case `M_K = 0`** (`lem:gf_torsion_base`, Nitsure §4 base
case of the induction). If the generic localisation `M_K = K ⊗_A M` (encoded as
`LocalizedModule (nonZeroDivisors A) M`) is trivial and `M` is a finite
`B`-module, then there is a non-zero `f ∈ A` with `f • M = 0`; consequently
`M_f = 0` is free over `A_f`.

The hypothesis `Subsingleton (LocalizedModule (nonZeroDivisors A) M)` is the
formal encoding of `M_K = 0`: localising `M` at the non-zero divisors of the
domain `A` inverts exactly the non-zero elements, so `M_K = S^{-1}M` with
`S = A \ {0}`. Each generator of the finite `B`-module `M` is then killed by a
non-zero element of `A`; the product `f` of those annihilators (non-zero since
`A` is a domain) annihilates all of `M`, whence `M_f` is subsingleton and free. -/
theorem exists_free_localizationAway_of_torsion
    (A B M : Type*) [CommRing A] [IsDomain A]
    [CommRing B] [Algebra A B]
    [AddCommGroup M] [Module B M] [Module.Finite B M]
    [Module A M] [IsScalarTower A B M]
    (htors : Subsingleton (LocalizedModule (nonZeroDivisors A) M)) :
    ∃ f : A, f ≠ 0 ∧
      Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) M) := by
  -- The `A`/`B` scalar actions commute (A acts through `algebraMap A B`).
  have hcomm : ∀ (a : A) (b : B) (x : M), a • b • x = b • a • x := fun a b x => by
    rw [← IsScalarTower.algebraMap_smul B a (b • x), ← IsScalarTower.algebraMap_smul B a x,
      smul_smul, smul_smul, mul_comm]
  -- Torsion: every element of `M` is killed by a non-zero divisor of `A`.
  rw [LocalizedModule.subsingleton_iff] at htors
  choose r hr using htors
  -- `r m ∈ A⁰` and `(r m) • m = 0`.
  -- A finite `B`-generating set of `M`.
  obtain ⟨S, hS⟩ := (Module.Finite.fg_top : (⊤ : Submodule B M).FG)
  -- The product of the chosen annihilators of the generators.
  set f : A := ∏ x ∈ S, r x with hf_def
  have hfmem : f ∈ nonZeroDivisors A := prod_mem fun x _ => (hr x).1
  have hf0 : f ≠ 0 := nonZeroDivisors.ne_zero hfmem
  -- `f` annihilates every generator, hence all of `span B S = ⊤ = M`.
  have hgen : ∀ x ∈ S, f • x = (0 : M) := by
    intro x hx
    classical
    rw [hf_def, ← Finset.prod_erase_mul S r hx, mul_smul, (hr x).2, smul_zero]
  have hfM : ∀ m : M, f • m = (0 : M) := by
    intro m
    have hmem : m ∈ Submodule.span B (↑S : Set M) := by rw [hS]; exact Submodule.mem_top
    induction hmem using Submodule.span_induction with
    | mem x hx => exact hgen x hx
    | zero => exact smul_zero f
    | add x y _ _ ihx ihy => rw [smul_add, ihx, ihy, add_zero]
    | smul b x _ ih => rw [hcomm, ih, smul_zero]
  -- `f • M = 0` ⟹ `M_f` subsingleton ⟹ free over `A_f`.
  refine ⟨f, hf0, ?_⟩
  haveI : Subsingleton (LocalizedModule (Submonoid.powers f) M) :=
    LocalizedModule.subsingleton_iff.mpr fun m => ⟨f, Submonoid.mem_powers f, hfM m⟩
  exact Module.Free.of_subsingleton _ _

/-- **L3 — splicing fact for a short exact sequence** (`lem:gf_splice_shortExact`,
Nitsure §4). Given a short exact sequence `0 → M' → M → M'' → 0` of `B`-modules
and non-zero `f', f'' ∈ A` such that `M'_{f'}` is free over `A_{f'}` and
`M''_{f''}` is free over `A_{f''}`, then for `f := f' f''` the localisation
`M_f` is free over `A_f`.

Proof: localisation at the powers of `f` is exact, so it carries the SES to a
SES `0 → M'_f → M_f → M''_f → 0` of `A_f`-modules. Both ends become free over
`A_f` (a free module over `A_{f'}` stays free under the further localisation
`A_{f'} → A_f`, via `Module.free_of_isLocalizedModule`), and a SES with free
(hence projective) quotient `M''_f` splits, so `M_f ≅ M'_f ⊕ M''_f` is free. -/
theorem exists_free_localizationAway_of_shortExact
    (A B M' M M'' : Type*) [CommRing A] [IsDomain A]
    [CommRing B] [Algebra A B]
    [AddCommGroup M'] [Module B M'] [Module A M'] [IsScalarTower A B M']
    [AddCommGroup M] [Module B M] [Module A M] [IsScalarTower A B M]
    [AddCommGroup M''] [Module B M''] [Module A M''] [IsScalarTower A B M'']
    (i : M' →ₗ[B] M) (q : M →ₗ[B] M'')
    (hi : Function.Injective i) (hq : Function.Surjective q)
    (hexact : Function.Exact i q)
    {f' f'' : A} (hf' : f' ≠ 0) (hf'' : f'' ≠ 0)
    (hM' : Module.Free (Localization.Away f') (LocalizedModule (Submonoid.powers f') M'))
    (hM'' : Module.Free (Localization.Away f'') (LocalizedModule (Submonoid.powers f'') M'')) :
    ∃ f : A, f ≠ 0 ∧
      Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) M) := by
  -- Take `f := f' * f''`, non-zero in the domain `A`.
  refine ⟨f' * f'', mul_ne_zero hf' hf'', ?_⟩
  -- REMAINING (the genuine content of L3, partial — three sub-steps):
  --  (1) `LocalizedModule.map_exact (Submonoid.powers (f'*f''))` on the
  --      `A`-linear restrictions of `i`, `q` gives the localised SES of
  --      `A_f`-modules; injectivity/surjectivity of the localised legs follow
  --      from `IsLocalizedModule.map_injective` / right-exactness.
  --  (2) `Module.free_of_isLocalizedModule` transports `M'_{f'}` free / `A_{f'}`
  --      to `M'_f` free / `A_f` (with `R := A_{f'}`, `S := powers (algebraMap A
  --      A_{f'} f'')`, using `IsLocalization.Away.mul` for `A_f` as a localisation
  --      of `A_{f'}`); symmetrically for `M''`.
  --  (3) a SES of `A_f`-modules with free (projective) quotient `M''_f` splits,
  --      so `M_f ≅ M'_f ⊕ M''_f` is free (`Module.Free.of_equiv` on the split).
  sorry

/-- **L4 — Noether normalisation with clearing of denominators**
(`lem:gf_noether_clear_denominators`, Nitsure §4). For `A` a noetherian domain
with fraction field `K`, and `B` a finite-type `A`-algebra that is a domain with
`B_K = K ⊗_A B ≠ 0`, there exist `g ∈ A`, `g ≠ 0`, a number `n`, and an
injective `A_g`-algebra map `φ : A_g[X_1,…,X_n] → B_g` (the `b_j := φ(X_j)`
algebraically independent over `K`) such that `B_g` is module-finite over
`A_g[X_1,…,X_n]` through `φ`.

Here `A_g := Localization.Away g`, `B_g := Localization.Away (algebraMap A B g)`,
and module-finiteness is taken with respect to the `A_g[X]`-module structure on
`B_g` induced by `φ`.

Proof (Nitsure §4): apply Noether normalisation `exists_finite_inj_algHom_of_fg`
over the field `K` to the finite-type `K`-algebra `B_K`, obtaining algebraically
independent `b̄_j ∈ B_K` with `B_K` module-finite over `K[b̄_1,…,b̄_n]`. Each
`b̄_j` is `1 ⊗ b_j` for some `b_j ∈ B`; choosing a finite generating set and
finitely many integral-dependence equations and letting `g` be a common
denominator of their coefficients makes `B_g` module-finite over
`A_g[b_1,…,b_n]`. -/
theorem exists_localizationAway_finite_mvPolynomial
    (A B : Type*) [CommRing A] [IsDomain A] [IsNoetherianRing A]
    [CommRing B] [IsDomain B] [Algebra A B] [Algebra.FiniteType A B]
    (hBK : Nontrivial (TensorProduct A (FractionRing A) B)) :
    ∃ (n : ℕ) (g : A), g ≠ 0 ∧
      ∃ (_ : Algebra (Localization.Away g) (Localization.Away (algebraMap A B g)))
          (_ : Algebra (MvPolynomial (Fin n) (Localization.Away g))
                (Localization.Away (algebraMap A B g)))
          (_ : IsScalarTower (Localization.Away g)
                (MvPolynomial (Fin n) (Localization.Away g))
                (Localization.Away (algebraMap A B g))),
        -- `B_g` is module-finite over the polynomial subalgebra `A_g[X_1,…,X_n]`,
        -- whose structure map is injective (the `b_j` algebraically independent).
        Function.Injective
            (algebraMap (MvPolynomial (Fin n) (Localization.Away g))
              (Localization.Away (algebraMap A B g))) ∧
          Module.Finite (MvPolynomial (Fin n) (Localization.Away g))
            (Localization.Away (algebraMap A B g)) := by
  -- REMAINING (the genuine content of L4): Noether normalisation over `K`
  -- (`exists_finite_inj_algHom_of_fg` applied to `B_K`) followed by clearing
  -- denominators of the finitely many integral-dependence equations to descend
  -- the module-finiteness from `K[b̄]` to `A_g[b]`. The `Module.Finite` instance
  -- in the existential is taken over the `A_g[X]`-algebra structure on `B_g`
  -- transported along `φ` (`φ.toAlgebra` / `Module.Finite.of_surjective`-free).
  sorry

/-- **L5 — polynomial-ring core of generic freeness** (`lem:gf_polynomial_core`,
Nitsure §4, the genuine Mathlib-absent residue). For `A` a noetherian domain and
`d ≥ 0`, a finite module `N` over the polynomial ring `A[X_1,…,X_d]`, regarded as
an `A`-module via the scalar tower `A → A[X] → N`, becomes free after inverting a
single non-zero `f ∈ A`.

This is the bottom of the Nitsure §4 induction. The base case `d = 0` is the
finite-`A`-module leaf `exists_free_localizationAway_of_finite`
(`MvPolynomial (Fin 0) A ≅ A`). The inductive step builds the generic-rank short
exact sequence `0 → A_g[X]^{⊕m} → N_g → T → 0` with `T` torsion of support
dimension `< d`, applies the inductive hypothesis to `T` and the torsion base
case `exists_free_localizationAway_of_torsion`, and splices via
`exists_free_localizationAway_of_shortExact`. -/
theorem exists_free_localizationAway_polynomial
    (A : Type*) [CommRing A] [IsDomain A] [IsNoetherianRing A]
    (d : ℕ) (N : Type*) [AddCommGroup N]
    [Module (MvPolynomial (Fin d) A) N] [Module.Finite (MvPolynomial (Fin d) A) N]
    [Module A N] [IsScalarTower A (MvPolynomial (Fin d) A) N] :
    ∃ f : A, f ≠ 0 ∧
      Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) N) := by
  induction d with
  | zero =>
    -- Base case `d = 0`: `MvPolynomial (Fin 0) A ≅ A`, so `N` is module-finite
    -- over `A` itself (via `Module.Finite.trans` through the iso), and the claim
    -- is the finite-module leaf.
    haveI : Module.Finite A (MvPolynomial (Fin 0) A) :=
      Module.Finite.equiv (MvPolynomial.isEmptyAlgEquiv A (Fin 0)).symm.toLinearEquiv
    haveI : Module.Finite A N := Module.Finite.trans (MvPolynomial (Fin 0) A) N
    exact exists_free_localizationAway_of_finite A N
  | succ d ih =>
    -- Inductive step (the genuine generic-rank dévissage): pass to `K = Frac A`,
    -- the torsion case via `exists_free_localizationAway_of_torsion`, else build
    -- `0 → A_g[X]^{⊕m} → N_g → T → 0`, apply `ih` to `T` and splice with
    -- `exists_free_localizationAway_of_shortExact`.
    sorry

end GenericFreeness

/-! ## Generic flatness, algebraic form (Nitsure §4 "Lemma on Generic Flatness")

For a noetherian domain `A`, a finite-type `A`-algebra `B`, and a finite
`B`-module `M` (viewed as an `A`-module through the scalar tower `A → B → M`),
there is a non-zero `f ∈ A` such that `M_f` is free over `A_f`.

The proof splits along the blueprint's decomposition:

* **Primary route** (provided here, axiom-clean): when `M` is already
  *module-finite over `A`*, this is the finite-module helper
  `GenericFreeness.exists_free_localizationAway_of_finite` — over `Frac A` the
  localised module is a finite vector space hence free, and
  `Module.FinitePresentation.exists_free_localizedModule_powers` descends that
  freeness to a single basic open `D(f)`.

* **Surviving residue** (`sorry` this iter): when `M` is finite over the
  *finite-type* algebra `B` but not module-finite over `A`, the genuine §4
  dévissage is required — a prime filtration of `M` as a finite `B`-module
  reduces to `M = B/𝔭`, Noether normalisation makes `B_g` finite over the
  polynomial ring `A_g[b₁,…,b_n]`, and induction on the support dimension
  bottoms out at the polynomial-ring core of generic freeness. That core
  (a finite module over `A[X₁,…,X_d]` is generically free) is the precise
  piece Mathlib does not yet supply. -/

/-- **Generic flatness, algebraic form** (Nitsure §4 "Lemma on Generic
Flatness"). Let `A` be a noetherian domain, `B` a finite-type `A`-algebra, and
`M` a finite `B`-module regarded as an `A`-module via the scalar tower
`A → B → M`. Then there exists `f ∈ A`, `f ≠ 0`, such that
`LocalizedModule (Submonoid.powers f) M` is free over `Localization.Away f`.

Blueprint: `thm:generic_flatness_algebraic`. The finite-`A`-module case is the
thin Mathlib wrapper `GenericFreeness.exists_free_localizationAway_of_finite`;
the finite-type residue is the classical §4 dévissage (still `sorry`). -/
theorem genericFlatnessAlgebraic
    (A B M : Type*) [CommRing A] [IsDomain A] [IsNoetherianRing A]
    [CommRing B] [Algebra A B] [Algebra.FiniteType A B]
    [AddCommGroup M] [Module B M] [Module.Finite B M]
    [Module A M] [IsScalarTower A B M] :
    ∃ f : A, f ≠ 0 ∧
      Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) M) := by
  by_cases hAM : Module.Finite A M
  · -- Primary route: `M` module-finite over `A` ⟹ the finite-module helper.
    haveI := hAM
    exact GenericFreeness.exists_free_localizationAway_of_finite A M
  · -- Surviving residue: `M` finite over the finite-type algebra `B` but not
    -- module-finite over `A`. The Nitsure §4 dévissage (prime filtration +
    -- Noether normalisation + induction on support dimension) reduces this to
    -- the polynomial-ring core of generic freeness, which Mathlib does not yet
    -- provide. See `task_results` for the precise remaining gap.
    sorry

/-! ## Generic flatness (Nitsure §4)

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
    (p : X ⟶ S) [LocallyOfFiniteType p] (F : X.Modules)
    [F.IsQuasicoherent] [F.IsFiniteType] :
    ∃ (V : S.Opens), (V : Set S).Nonempty ∧
      ∀ {U : S.Opens} (_ : IsAffineOpen U) (_ : U ≤ V) {W : X.Opens}
        (_ : IsAffineOpen W) (e : W ≤ p ⁻¹ᵁ U),
        letI : Module Γ(S, U) Γ(F, W) := Module.compHom _ (p.appLE U W e).hom
        Module.Flat Γ(S, U) Γ(F, W) := by
  -- Geometric assembly of `genericFlatnessAlgebraic` (Nitsure §4, geometric form).
  --
  -- Genuine starting point: `S` is integral, hence non-empty, so it has a
  -- non-empty affine open `Spec A ⊆ S` with `A := Γ(S, U₀)` a noetherian
  -- domain (integrality gives `IsDomain A`; local-noetherianity gives
  -- `IsNoetherianRing A`).
  obtain ⟨x₀⟩ := (IsIntegral.nonempty : Nonempty ↥S)
  obtain ⟨U₀, hU₀aff, hx₀, -⟩ :=
    exists_isAffineOpen_mem_and_subset (x := x₀) (U := ⊤) (by trivial)
  -- `U₀` is a non-empty affine open of `S`; its sections `A := Γ(S, U₀)` are a
  -- noetherian domain (the base of the algebraic generic-flatness input).
  --
  -- Remaining assembly (the genuine geometric content, still `sorry`):
  --   * `p` is locally of finite type and `F` is coherent
  --     (`[F.IsQuasicoherent] [F.IsFiniteType]`), so over each affine open
  --     `W ⊆ p⁻¹(U₀)` the sections `M := Γ(F, W)` form a finite module over the
  --     finite-type `A`-algebra `B := Γ(X, W)`;
  --   * `p⁻¹(U₀)` is quasi-compact (X locally noetherian above the affine), so it
  --     is covered by finitely many such affine `W_j`;
  --   * `genericFlatnessAlgebraic A B_j M_j` yields `f_j ∈ A`, `f_j ≠ 0`, with
  --     `(M_j)_{f_j}` free over `A_{f_j}`;
  --   * set `V := D(∏ⱼ f_j) ⊆ U₀` (non-empty, as `A` is a domain and each
  --     `f_j ≠ 0`); flatness on every affine `U ≤ V`, `W ≤ p⁻¹U` then follows
  --     from freeness over the localisation by flat-locality
  --     (`Module.flat_of_isLocalized_maximal` / `Module.Flat.of_free`).
  -- The witness `V` must come out of this construction: an arbitrary non-empty
  -- open makes the flatness obligation false, so we do not commit to one here.
  sorry

end AlgebraicGeometry
