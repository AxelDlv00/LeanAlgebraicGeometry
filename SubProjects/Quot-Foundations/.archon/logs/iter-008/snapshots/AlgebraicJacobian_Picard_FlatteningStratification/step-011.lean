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

/-- **L3a — localisation of a short exact sequence is exact**
(`lem:gf_splice_shortExact_localized_exact`, Nitsure §4). Given a short exact
sequence `0 → M' → M → M'' → 0` of `B`-modules and `f ∈ A`, restricting scalars
along `A → B` and localising every term at the powers of `f` yields a short
exact sequence `0 → M'_f → M_f → M''_f → 0` of `A_f`-modules; the localised
`i_f` is injective and the localised `q_f` is surjective.

Localisation of modules at a multiplicative set is exact, so it preserves the
injection `i`, the surjection `q`, and exactness at the middle term
(`LocalizedModule.map_injective` / `…map_surjective` / `…map_exact` applied to
the scalar-restricted maps). -/
theorem exact_localizedModule_powers_of_shortExact
    (A B M' M M'' : Type*) [CommRing A]
    [CommRing B] [Algebra A B]
    [AddCommGroup M'] [Module B M'] [Module A M'] [IsScalarTower A B M']
    [AddCommGroup M] [Module B M] [Module A M] [IsScalarTower A B M]
    [AddCommGroup M''] [Module B M''] [Module A M''] [IsScalarTower A B M'']
    (i : M' →ₗ[B] M) (q : M →ₗ[B] M'')
    (hi : Function.Injective i) (hq : Function.Surjective q)
    (hexact : Function.Exact i q)
    (f : A) :
    Function.Injective (LocalizedModule.map (Submonoid.powers f) (i.restrictScalars A)) ∧
    Function.Surjective (LocalizedModule.map (Submonoid.powers f) (q.restrictScalars A)) ∧
    Function.Exact (LocalizedModule.map (Submonoid.powers f) (i.restrictScalars A))
      (LocalizedModule.map (Submonoid.powers f) (q.restrictScalars A)) := by
  refine ⟨LocalizedModule.map_injective _ (i.restrictScalars A) hi,
    LocalizedModule.map_surjective _ (q.restrictScalars A) hq, ?_⟩
  exact LocalizedModule.map_exact (Submonoid.powers f) (i.restrictScalars A)
    (q.restrictScalars A) hexact

/-- **L3b — free transport across a finer localisation**
(`lem:gf_splice_shortExact_free_transport`, Nitsure §4). Let `N` be an
`A`-module and `f', f'' ∈ A` with `f = f' f''`. If `N_{f'}` is free over
`A_{f'}`, then `N_f` is free over `A_f`.

Because `f = f' f''`, the localisation `A_f` is a localisation of `A_{f'}` at the
image of `f''` (`IsLocalization.Away.awayToAwayLeft` / `IsLocalization.Away.mul'`),
and `N_f` is the corresponding localisation of `N_{f'}`; a localisation of a free
module is free over the localised base ring (`Module.free_of_isLocalizedModule`). -/
theorem free_localizationAway_of_free_of_eq_mul
    (A N : Type*) [CommRing A] [AddCommGroup N] [Module A N]
    {f f' f'' : A} (hf : f = f' * f'')
    (hN' : Module.Free (Localization.Away f')
      (LocalizedModule (Submonoid.powers f') N)) :
    Module.Free (Localization.Away f)
      (LocalizedModule (Submonoid.powers f) N) := by
  subst hf
  haveI : Module.Free (Localization.Away f')
    (LocalizedModule (Submonoid.powers f') N) := hN'
  -- `A_f` also localises `f'' * f'` (= `f' * f''`).
  haveI hloc : IsLocalization.Away (f'' * f') (Localization.Away (f' * f'')) := by
    rw [mul_comm]; infer_instance
  -- The ring map `A_{f'} → A_{f'f''}` and the `A`-scalar-tower it sits in.
  letI algA' : Algebra (Localization.Away f') (Localization.Away (f' * f'')) :=
    (IsLocalization.Away.awayToAwayLeft (R := A) (S := Localization.Away f')
      (P := Localization.Away (f' * f'')) f' f'').toAlgebra
  haveI htower : IsScalarTower A (Localization.Away f') (Localization.Away (f' * f'')) :=
    IsScalarTower.of_algebraMap_eq fun a =>
      (IsLocalization.Away.awayToAwayLeft_eq (S := Localization.Away f') f' f'' a).symm
  -- Restrict scalars along `A_{f'} → A_{f'f''}` to make `N_f` an `A_{f'}`-module.
  letI modA' : Module (Localization.Away f') (LocalizedModule (Submonoid.powers (f' * f'')) N) :=
    Module.compHom _ (algebraMap (Localization.Away f') (Localization.Away (f' * f'')))
  haveI towerA'Af : IsScalarTower (Localization.Away f') (Localization.Away (f' * f''))
      (LocalizedModule (Submonoid.powers (f' * f'')) N) :=
    IsScalarTower.of_algebraMap_smul fun _ _ => rfl
  haveI towerAA' : IsScalarTower A (Localization.Away f')
      (LocalizedModule (Submonoid.powers (f' * f'')) N) := by
    refine ⟨fun a a' x => ?_⟩
    have hcompA' : ∀ (b : Localization.Away f')
        (y : LocalizedModule (Submonoid.powers (f' * f'')) N),
        b • y = algebraMap (Localization.Away f') (Localization.Away (f' * f'')) b • y :=
      fun _ _ => rfl
    rw [hcompA' (a • a') x, hcompA' a' x, Algebra.smul_def, map_mul,
      ← IsScalarTower.algebraMap_apply A (Localization.Away f') (Localization.Away (f' * f'')) a,
      mul_smul, IsScalarTower.algebraMap_smul]
  -- `f'` acts invertibly on `N_f`: `f' * f''` does, and the commuting factor `f'` inherits it.
  have hunit : ∀ x : Submonoid.powers f',
      IsUnit (algebraMap A (Module.End A (LocalizedModule (Submonoid.powers (f' * f'')) N))
        (x : A)) := by
    have hprod : IsUnit (algebraMap A
        (Module.End A (LocalizedModule (Submonoid.powers (f' * f'')) N)) (f' * f'')) :=
      IsLocalizedModule.map_units
        (LocalizedModule.mkLinearMap (Submonoid.powers (f' * f'')) N)
        ⟨f' * f'', Submonoid.mem_powers _⟩
    rw [map_mul] at hprod
    have hcomm : Commute
        (algebraMap A (Module.End A (LocalizedModule (Submonoid.powers (f' * f'')) N)) f')
        (algebraMap A (Module.End A (LocalizedModule (Submonoid.powers (f' * f'')) N)) f'') :=
      (Commute.all _ _).map _
    have hf'unit := (hcomm.isUnit_mul_iff.mp hprod).1
    rintro ⟨x, n, rfl⟩
    simpa [map_pow] using hf'unit.pow n
  -- The `A`-linear localisation map `N_{f'} → N_f`, upgraded to `A_{f'}`-linear.
  let φ : LocalizedModule (Submonoid.powers f') N →ₗ[A]
      LocalizedModule (Submonoid.powers (f' * f'')) N :=
    IsLocalizedModule.lift (Submonoid.powers f') (LocalizedModule.mkLinearMap _ N)
      (LocalizedModule.mkLinearMap _ N) hunit
  let h : LocalizedModule (Submonoid.powers f') N →ₗ[Localization.Away f']
      LocalizedModule (Submonoid.powers (f' * f'')) N :=
    LinearMap.extendScalarsOfIsLocalization (Submonoid.powers f') (Localization.Away f') φ
  -- `N_{f'}` is the base change of `N` to `A_{f'}`; the composite to `N_f` is the
  -- base change of `N` to `A_f`, so by cancellation `h` is the base change to `A_f`.
  have hbcA' : IsBaseChange (Localization.Away f')
      (LocalizedModule.mkLinearMap (Submonoid.powers f') N) :=
    IsLocalizedModule.isBaseChange (Submonoid.powers f') (Localization.Away f') _
  have hcomp : (LinearMap.restrictScalars A h) ∘ₗ
      (LocalizedModule.mkLinearMap (Submonoid.powers f') N)
      = LocalizedModule.mkLinearMap (Submonoid.powers (f' * f'')) N := by
    rw [LinearMap.restrictScalars_extendScalarsOfIsLocalization]
    exact IsLocalizedModule.lift_comp _ _ _ hunit
  have hbcAf : IsBaseChange (Localization.Away (f' * f''))
      ((LinearMap.restrictScalars A h) ∘ₗ
        (LocalizedModule.mkLinearMap (Submonoid.powers f') N)) := by
    rw [hcomp]
    exact IsLocalizedModule.isBaseChange (Submonoid.powers (f' * f''))
      (Localization.Away (f' * f'')) _
  exact (hbcA'.of_comp hbcAf).free

/-- **L3c — a short exact sequence with free ends has a free middle**
(`lem:gf_splice_shortExact_split`, Nitsure §4). Let
`0 → P → Q → T → 0` be a short exact sequence of `R`-modules with both ends `P`
and `T` free over `R`. Then `Q` is free over `R`.

The free quotient `T` is projective, so the surjection `Q → T` admits a section
(`Module.projective_lifting_property`); the splitting
(`Function.Exact.splitSurjectiveEquiv`) gives `Q ≃ₗ[R] P × T`, and `P × T` is
free, hence so is `Q` (`Module.Free.of_equiv`). -/
theorem free_of_shortExact_of_free_free
    (R P Q T : Type*) [CommRing R]
    [AddCommGroup P] [Module R P] [Module.Free R P]
    [AddCommGroup Q] [Module R Q]
    [AddCommGroup T] [Module R T] [Module.Free R T]
    (iota : P →ₗ[R] Q) (pi : Q →ₗ[R] T)
    (hiota : Function.Injective iota) (hpi : Function.Surjective pi)
    (hexact : Function.Exact iota pi) :
    Module.Free R Q := by
  obtain ⟨l, hl⟩ := Module.projective_lifting_property pi LinearMap.id hpi
  obtain ⟨e, -⟩ := hexact.splitSurjectiveEquiv hiota ⟨l, hl⟩
  exact Module.Free.of_equiv e.symm

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
  -- (L3b) Both ends become free over `A_{f'f''}`.
  haveI hM'f : Module.Free (Localization.Away (f' * f''))
      (LocalizedModule (Submonoid.powers (f' * f'')) M') :=
    free_localizationAway_of_free_of_eq_mul A M' (f := f' * f'') (f' := f') (f'' := f'') rfl hM'
  haveI hM''f : Module.Free (Localization.Away (f' * f''))
      (LocalizedModule (Submonoid.powers (f' * f'')) M'') :=
    free_localizationAway_of_free_of_eq_mul A M'' (f := f' * f'') (f' := f'') (f'' := f')
      (mul_comm f' f'') hM''
  -- (L3a) The scalar-restricted SES stays exact after localising at the powers of `f'f''`.
  obtain ⟨hinj, hsurj, hex⟩ :=
    exact_localizedModule_powers_of_shortExact A B M' M M'' i q hi hq hexact (f' * f'')
  -- (L3c) A short exact sequence of `A_{f'f''}`-modules with free ends has a free middle.
  exact free_of_shortExact_of_free_free (Localization.Away (f' * f''))
    (LocalizedModule (Submonoid.powers (f' * f'')) M')
    (LocalizedModule (Submonoid.powers (f' * f'')) M)
    (LocalizedModule (Submonoid.powers (f' * f'')) M'')
    (LocalizedModule.map (Submonoid.powers (f' * f'')) (i.restrictScalars A))
    (LocalizedModule.map (Submonoid.powers (f' * f'')) (q.restrictScalars A))
    hinj hsurj hex

/-- **L4a — clearing one polynomial's denominators** (`lem:gf_clear_one_denominator`,
Nitsure §4 common-denominator step). For `A` a noetherian domain with fraction
field `K = Frac A` and a polynomial `p ∈ K[X_1,…,X_n]`, there is a non-zero
`g ∈ A` such that `p` lies in the image of the coefficient-extension map
`A_g[X_1,…,X_n] → K[X_1,…,X_n]`, where `A_g = Localization.Away g`; equivalently
every coefficient of `p` already lies in the subring `A_g ⊆ K`.

The denominator-clearing engine: take `g` to be a common denominator of the
finitely many coefficients of `p` (Mathlib's
`IsLocalization.exist_integer_multiples` over the support), so each coefficient
`c = a / g ∈ A_g`. The witness polynomial is the numerator polynomial scaled by
the unit `g⁻¹ ∈ A_g`. This is the shared primitive the Noether-normalisation L4
denominator-clear and the torsion-reindex (L5b) both consume. -/
theorem gf_clear_one_denominator
    (A : Type*) [CommRing A] [IsDomain A] (n : ℕ)
    (p : MvPolynomial (Fin n) (FractionRing A)) :
    ∃ (g : A) (hg : g ≠ 0),
      p ∈ Set.range (MvPolynomial.map
        (IsLocalization.map (FractionRing A) (RingHom.id A)
          (show Submonoid.powers g ≤ Submonoid.comap (RingHom.id A) (nonZeroDivisors A) by
            rw [Submonoid.powers_le]
            simpa using mem_nonZeroDivisors_of_ne_zero hg)
          : Localization.Away g →+* FractionRing A)) := by
  classical
  obtain ⟨s, hs⟩ := IsLocalization.exist_integer_multiples (nonZeroDivisors A)
    p.support (fun i => MvPolynomial.coeff i p)
  refine ⟨s, nonZeroDivisors.ne_zero s.2, ?_⟩
  have hle : Submonoid.powers (↑s : A) ≤ Submonoid.comap (RingHom.id A) (nonZeroDivisors A) := by
    rw [Submonoid.powers_le]; simpa using s.2
  set φ : Localization.Away (↑s : A) →+* FractionRing A :=
    IsLocalization.map (FractionRing A) (RingHom.id A) hle with hφ
  have hunit : IsUnit (algebraMap A (Localization.Away (↑s : A)) ↑s) :=
    IsLocalization.map_units (Localization.Away (↑s : A))
      (⟨↑s, Submonoid.mem_powers _⟩ : Submonoid.powers (↑s : A))
  have hnum : ∀ i, ∃ a : A, (algebraMap A (FractionRing A)) a =
      (algebraMap A (FractionRing A) ↑s) * MvPolynomial.coeff i p := by
    intro i
    by_cases hi : i ∈ p.support
    · obtain ⟨a, ha⟩ := hs i hi
      exact ⟨a, by rw [ha, Algebra.smul_def]⟩
    · exact ⟨0, by rw [MvPolynomial.notMem_support_iff.mp hi]; simp⟩
  choose a ha using hnum
  have hφs : φ (algebraMap A (Localization.Away (↑s:A)) ↑s)
      = algebraMap A (FractionRing A) ↑s := by rw [hφ, IsLocalization.map_eq]; rfl
  have hee : (↑(hunit.unit⁻¹) : Localization.Away (↑s:A))
      * algebraMap A (Localization.Away (↑s:A)) ↑s = 1 := by
    have h := Units.inv_mul hunit.unit
    rwa [hunit.unit_spec] at h
  have hφinv : φ (↑(hunit.unit⁻¹) : Localization.Away (↑s:A))
      * algebraMap A (FractionRing A) ↑s = 1 := by
    rw [← hφs, ← map_mul, hee, map_one]
  -- The preimage polynomial: the numerator polynomial scaled by the unit `g⁻¹`.
  refine ⟨MvPolynomial.C (↑(hunit.unit⁻¹) : Localization.Away (↑s:A))
        * (MvPolynomial.map (algebraMap A (Localization.Away (↑s:A)))
            (∑ i ∈ p.support, MvPolynomial.monomial i (a i))), ?_⟩
  apply MvPolynomial.ext
  intro i
  rw [MvPolynomial.coeff_map, MvPolynomial.coeff_C_mul, map_mul, MvPolynomial.coeff_map,
    IsLocalization.map_eq]
  have hcoeff : MvPolynomial.coeff i (∑ j ∈ p.support, MvPolynomial.monomial j (a j)) = a i := by
    rw [MvPolynomial.coeff_sum]
    simp only [MvPolynomial.coeff_monomial, Finset.sum_ite_eq']
    by_cases hi : i ∈ p.support
    · rw [if_pos hi]
    · rw [if_neg hi]
      have hz : MvPolynomial.coeff i p = 0 := MvPolynomial.notMem_support_iff.mp hi
      have h2 := ha i
      rw [hz, mul_zero] at h2
      exact (IsFractionRing.injective A (FractionRing A) (by rw [h2, map_zero])).symm
  rw [hcoeff, RingHom.id_apply, ha i, ← mul_assoc, hφinv, one_mul]

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
    ∃ (n : ℕ) (g : A) (_ : g ≠ 0)
      (_ : Algebra (Localization.Away g) (Localization.Away (algebraMap A B g)))
      (φ : MvPolynomial (Fin n) (Localization.Away g)
            →ₐ[Localization.Away g] Localization.Away (algebraMap A B g)),
      Function.Injective φ ∧
      (letI := φ.toAlgebra;
        Module.Finite (MvPolynomial (Fin n) (Localization.Away g))
          (Localization.Away (algebraMap A B g))) := by
  classical
  -- Step 1 (Nitsure §4): Noether normalisation over the fraction field
  -- `K = Frac A`, applied to the finite-type `K`-algebra `B_K = K ⊗_A B`. This
  -- yields algebraically independent generators (encoded by the injective AlgHom
  -- `gK`) over which `B_K` is module-finite.
  haveI : Nontrivial (TensorProduct A (FractionRing A) B) := hBK
  haveI : Algebra.FiniteType (FractionRing A) (TensorProduct A (FractionRing A) B) :=
    inferInstance
  obtain ⟨s, gK, hgK_inj, hgK_fin⟩ :=
    exists_finite_inj_algHom_of_fg (FractionRing A) (TensorProduct A (FractionRing A) B)
  -- `gK : MvPolynomial (Fin s) K →ₐ[K] B_K`, injective and module-finite.
  -- Step 2 (the surviving Mathlib-absent residue): each generator `b̄_j = 1 ⊗ b_j`
  -- with `b_j ∈ B`; choosing finitely many integral-dependence equations and a
  -- common denominator `g ∈ A` of their coefficients descends the
  -- module-finiteness from `K[b̄_1,…,b̄_s]` to `A_g[b_1,…,b_s]`, giving the
  -- `A_g`-algebra map `φ : A_g[X_1,…,X_s] → B_g` of the conclusion (with
  -- `n := s`). The denominator-clearing construction is not yet available from
  -- Mathlib and is the genuine remaining content of L4.
  sorry

/-- **L5a — the generic-rank short exact sequence** (`lem:gf_generic_rank_ses`,
Nitsure §4 inductive step). For `A` a noetherian domain and `d ≥ 0`, a finite
module `N` over the polynomial ring `P_d := A[X_1,…,X_d]`, there exist `m ∈ ℕ`
and an injective `P_d`-linear map `φ : P_d^{⊕m} → N` whose cokernel
`T := N ⧸ range φ` is a torsion `P_d`-module. Equivalently, a short exact
sequence `0 → P_d^{⊕m} → N → T → 0` with `T` torsion.

`m` is the generic rank: `dim_{Frac P_d} (Frac P_d ⊗_{P_d} N)`. The map `φ`
is the `P_d`-linear combination of `m` lifts `v : Fin m → N` whose images form a
`Frac P_d`-basis of the localisation `N_Q := LocalizedModule (P_d)⁰ N`. This step
is built over `P_d` directly — no inversion of any `g ∈ A` is required. -/
theorem gf_generic_rank_ses
    (A : Type*) [CommRing A] [IsDomain A] [IsNoetherianRing A]
    (d : ℕ) (N : Type*) [AddCommGroup N]
    [Module (MvPolynomial (Fin d) A) N] [Module.Finite (MvPolynomial (Fin d) A) N]
    [Module A N] [IsScalarTower A (MvPolynomial (Fin d) A) N] :
    ∃ (m : ℕ) (φ : (Fin m → MvPolynomial (Fin d) A)
        →ₗ[MvPolynomial (Fin d) A] N),
      Function.Injective φ ∧
      Module.IsTorsion (MvPolynomial (Fin d) A) (N ⧸ LinearMap.range φ) := by
  classical
  -- Notation: `P = A[X_1,…,X_d]`, its non-zero divisors `S`, fraction field `K`,
  -- localisation `NK = N_Q`, and the localisation map `ℓ : N → NK`.
  let P := MvPolynomial (Fin d) A
  let S := nonZeroDivisors P
  let K := Localization S
  let NK := LocalizedModule S N
  let ℓ : N →ₗ[P] NK := LocalizedModule.mkLinearMap S N
  -- `NK` is a finite-dimensional `K`-vector space; take a basis indexed by `Fin m`.
  let m := Module.finrank K NK
  let b : Module.Basis (Fin m) K NK := Module.finBasis K NK
  -- Lift each basis vector along `ℓ`, clearing its denominator.
  obtain ⟨lift, hlift⟩ :
      ∃ lift : Fin m → N × S, ∀ i, ((lift i).2 : P) • b i = ℓ (lift i).1 := by
    refine ⟨fun i => (IsLocalizedModule.surj S ℓ (b i)).choose, fun i => ?_⟩
    exact (IsLocalizedModule.surj S ℓ (b i)).choose_spec
  let v : Fin m → N := fun i => (lift i).1
  -- The denominators map to units of `K`.
  let u : Fin m → Kˣ := fun i => (IsLocalization.map_units K (lift i).2).unit
  have hlv : ∀ i, ℓ (v i) = (↑(u i) : K) • b i := by
    intro i
    have hu : (↑(u i) : K) = algebraMap P K ((lift i).2 : P) :=
      (IsLocalization.map_units K (lift i).2).unit_spec
    rw [hu, algebraMap_smul]
    exact (hlift i).symm
  -- The images `ℓ (v i)` are linearly independent over `K` (unit multiples of a basis).
  have hLIK : LinearIndependent K (fun i => ℓ (v i)) := by
    have h := b.linearIndependent.units_smul u
    have heq : (fun i => ℓ (v i)) = (u • (⇑b)) := by
      funext i; rw [hlv i]; rfl
    rw [heq]; exact h
  -- Restrict scalars to `P` (the inclusion `P → K` is injective), then descend to `v`.
  have hLIP : LinearIndependent P (fun i => ℓ (v i)) := by
    refine hLIK.restrict_scalars ?_
    intro x y hxy
    simp only [Algebra.smul_def, mul_one] at hxy
    exact IsFractionRing.injective P K hxy
  have hLIv : LinearIndependent P v := LinearIndependent.of_comp ℓ hLIP
  -- The map `φ : P^{⊕m} → N`, `e_i ↦ v i`.
  refine ⟨m, Fintype.linearCombination P v, ?_, ?_⟩
  · -- Injectivity of `φ` is exactly linear independence of `v`.
    rw [← LinearMap.ker_eq_bot, LinearMap.ker_eq_bot']
    intro g hg
    rw [Fintype.linearCombination_apply] at hg
    funext i
    exact Fintype.linearIndependent_iff.mp hLIv g hg i
  · -- The cokernel `T = N ⧸ range φ` is torsion: every element is killed by a
    -- non-zero divisor of `P`.
    intro x
    obtain ⟨n, rfl⟩ := Submodule.Quotient.mk_surjective _ x
    -- The images `ℓ (v i)` span `NK` over `K` (they are unit multiples of a basis).
    have hspan : Submodule.span K (Set.range (fun i => ℓ (v i))) = ⊤ := by
      refine top_unique ?_
      rw [← b.span_eq, Submodule.span_le]
      rintro _ ⟨i, rfl⟩
      have hbi : b i = (↑(u i) : K)⁻¹ • ℓ (v i) := by
        rw [hlv i, smul_smul, inv_mul_cancel₀ (u i).ne_zero, one_smul]
      rw [hbi]
      exact Submodule.smul_mem _ _ (Submodule.subset_span ⟨i, rfl⟩)
    -- Hence `ℓ n` is a `K`-linear combination of the `ℓ (v i)`.
    obtain ⟨c, hc⟩ := (Submodule.mem_span_range_iff_exists_fun K).mp
      (show ℓ n ∈ Submodule.span K (Set.range fun i => ℓ (v i)) by
        rw [hspan]; exact Submodule.mem_top)
    -- Clear the denominators of the finitely many coefficients `c i`.
    obtain ⟨s, hs⟩ := IsLocalization.exist_integer_multiples S Finset.univ c
    have ha : ∀ i, ∃ y : P, algebraMap P K y = (s : P) • c i := fun i =>
      hs i (Finset.mem_univ i)
    choose a hae using ha
    -- After multiplying by `s`, `ℓ (s • n)` becomes `ℓ (φ a)`.
    have key : ℓ ((s : P) • n) = ℓ (Fintype.linearCombination P v a) := by
      rw [map_smul, ← hc, Fintype.linearCombination_apply, map_sum, Finset.smul_sum]
      refine Finset.sum_congr rfl (fun i _ => ?_)
      rw [map_smul]
      -- `(s:P) • (c i • ℓ v_i) = a i • ℓ v_i`
      rw [← algebraMap_smul K ((s : P)) (c i • ℓ (v i)), smul_smul, ← Algebra.smul_def,
        ← hae i, algebraMap_smul]
    -- So `s • n - φ a` lies in the kernel of `ℓ`, hence is killed by some `t ∈ S`.
    have hker : ℓ ((s : P) • n - Fintype.linearCombination P v a) = 0 := by
      rw [map_sub, key, sub_self]
    obtain ⟨t, ht⟩ := (IsLocalizedModule.eq_zero_iff S ℓ).mp hker
    -- The non-zero divisor `t * s` annihilates the class of `n` in `T`.
    refine ⟨t * s, ?_⟩
    rw [smul_sub, sub_eq_zero] at ht
    have ht2 : (↑t : P) • ((↑s : P) • n) = (↑t : P) • Fintype.linearCombination P v a := ht
    have hmem : (↑(t * s) : P) • n ∈ LinearMap.range (Fintype.linearCombination P v) := by
      rw [Submonoid.coe_mul, mul_smul, ht2, ← map_smul]
      exact LinearMap.mem_range_self _ _
    -- Conclude `(t * s) • ⟦n⟧ = 0`.
    rw [← Submodule.Quotient.mk_smul, Submodule.Quotient.mk_eq_zero]
    exact hmem

/-- **L5b — torsion reindex onto fewer variables** (`lem:gf_torsion_reindex`,
Nitsure §4 support-dimension drop). For `A` a noetherian domain, `d ≥ 1`, and `T`
a finite torsion module over `P_d := A[X_1,…,X_d]`, there exist `g ≠ 0` in `A` and
`m' < d` such that, after inverting `g`, the localisation `T_g` is module-finite
over `A_g[X_1,…,X_{m'}]` (one may take `m' = d - 1`). -/
theorem gf_torsion_reindex
    (A : Type*) [CommRing A] [IsDomain A] [IsNoetherianRing A]
    (d : ℕ) (hd : 0 < d) (T : Type*) [AddCommGroup T]
    [Module (MvPolynomial (Fin d) A) T] [Module.Finite (MvPolynomial (Fin d) A) T]
    [Module A T] [IsScalarTower A (MvPolynomial (Fin d) A) T]
    (htors : Module.IsTorsion (MvPolynomial (Fin d) A) T) :
    ∃ (g : A) (_ : g ≠ 0) (m' : ℕ) (_ : m' < d)
      (_ : Module (MvPolynomial (Fin m') (Localization.Away g))
              (LocalizedModule (Submonoid.powers g) T))
      (_ : Module (Localization.Away g) (LocalizedModule (Submonoid.powers g) T))
      (_ : IsScalarTower (Localization.Away g)
              (MvPolynomial (Fin m') (Localization.Away g))
              (LocalizedModule (Submonoid.powers g) T)),
      Module.Finite (MvPolynomial (Fin m') (Localization.Away g))
        (LocalizedModule (Submonoid.powers g) T) := by
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
    (A : Type u) [CommRing A] [IsDomain A] [IsNoetherianRing A]
    (d : ℕ) (N : Type u) [AddCommGroup N]
    [Module (MvPolynomial (Fin d) A) N] [Module.Finite (MvPolynomial (Fin d) A) N]
    [Module A N] [IsScalarTower A (MvPolynomial (Fin d) A) N] :
    ∃ f : A, f ≠ 0 ∧
      Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) N) := by
  -- The genuine proof is a *strong* induction on `d`, with the module `N` and its
  -- instances universally quantified in the motive: the inductive hypothesis must
  -- apply to the lower-support-dimension torsion quotient `T` (a module over a
  -- polynomial ring in fewer variables `m < d`), and the module instances depend
  -- on `d`, so a faithful induction must re-quantify `N` over each `d`. The
  -- `generalizing N` reverts `N` together with all five of its `d`-dependent
  -- instances, so the IH has the shape
  --   IH : ∀ m < d, ∀ (N : Type _) [AddCommGroup N] [Module (MvPolynomial (Fin m) A) N]
  --          [Module.Finite (MvPolynomial (Fin m) A) N] [Module A N]
  --          [IsScalarTower A (MvPolynomial (Fin m) A) N],
  --          ∃ f ≠ 0, Module.Free (A_f) (N_f).
  induction d using Nat.strong_induction_on generalizing A N with
  | _ d IH =>
    rcases Nat.eq_zero_or_pos d with hd | hd
    · -- Base case `d = 0`: `MvPolynomial (Fin 0) A ≅ A`, so `N` is module-finite
      -- over `A` itself (via `Module.Finite.trans` through the iso), and the claim
      -- is the finite-module leaf `exists_free_localizationAway_of_finite`.
      subst hd
      haveI : Module.Finite A (MvPolynomial (Fin 0) A) :=
        Module.Finite.equiv (MvPolynomial.isEmptyAlgEquiv A (Fin 0)).symm.toLinearEquiv
      haveI : Module.Finite A N := Module.Finite.trans (MvPolynomial (Fin 0) A) N
      exact exists_free_localizationAway_of_finite A N
    · -- Inductive step. Pass to `K = Frac A` and split on whether `N_K = 0`.
      by_cases htors : Subsingleton (LocalizedModule (nonZeroDivisors A) N)
      · -- Torsion sub-case `N_K = 0`: closed by the L1 torsion base case applied
        -- with the finite-type polynomial ring `B := A[X_1,…,X_d]` as the module's
        -- ring of definition.
        exact exists_free_localizationAway_of_torsion A (MvPolynomial (Fin d) A) N htors
      · -- Generic-rank dévissage (the genuine generic-rank residue): with `N_K ≠ 0`,
        -- let `m` be the generic rank of `N` over the domain `A[X_1,…,X_d]`; choosing
        -- `m` elements whose images form a `K(X)`-basis and clearing denominators
        -- gives, after inverting some `g ≠ 0`, a short exact sequence
        --   `0 → A_g[X]^{⊕m} → N_g → T → 0`
        -- with `T` torsion of support dimension `< d`. After a Noether-normalisation
        -- reindex `T` is finite over a polynomial ring in `m' < d` variables, so the
        -- IH applies:  `IH m' (by …) T` yields `h ≠ 0` with `T_h` free over `A_h`.
        -- The free middle term `A_g[X]^{⊕m}` localises to a free `A_{gh}`-module by
        -- the `d = 0` leaf (`exists_free_localizationAway_of_finite`) applied
        -- coordinatewise, and `exists_free_localizationAway_of_shortExact` (L3)
        -- splices the localised SES to give `N_f` free over `A_f` with `f := g·h`.
        --
        -- The IH is now genuinely in scope and quantifies over the base domain `A`
        -- (the structural fix of this iter): `IH m' (hm' : m' < d) A_g T_g` typechecks
        -- at the reindexed base `A_g = Localization.Away g`.
        --
        -- The generic-rank SES is now concretely available from `gf_generic_rank_ses`:
        obtain ⟨_mrank, _φ, _hφinj, _hTtors⟩ := gf_generic_rank_ses A d N
        -- `φ : (Fin mrank → P_d) →ₗ[P_d] N` is injective with torsion cokernel
        -- `T := N ⧸ range φ` (`hTtors`). The remaining residue, to be assembled once
        -- `gf_torsion_reindex` (L5b, still `sorry`) lands, is:
        --   1. equip `T` with its restricted `A`-module structure + scalar tower
        --      (the restriction-of-scalars motive plumbing) and `Module.Finite P_d T`;
        --   2. `gf_torsion_reindex A d hd T hTtors` ⟹ `g ≠ 0`, `m' < d`, and `T_g`
        --      module-finite over `A_g[X_1,…,X_{m'}]`;
        --   3. `IH m' hm' (Localization.Away g) T_g` ⟹ `h ≠ 0` in `A_g` with `(T_g)_h`
        --      free over `(A_g)_h` (the IH is now available AT BASE `A_g`);
        --   4. descend the witness `h = a/g^k` to `f := g·a ∈ A` via
        --      `free_localizationAway_of_free_of_eq_mul` (L3b);
        --   5. the free left end `P_d^{⊕mrank}` localises to a free `A_f`-module, and
        --      `exists_free_localizationAway_of_shortExact` (L3) splices the localised
        --      SES `0 → (P_d^{⊕mrank})_f → N_f → T_f → 0` to give `N_f` free over `A_f`.
        -- Steps 1–5 are blocked only on `gf_torsion_reindex`; the SES (step 0) and the
        -- base-domain-generalised IH are both in hand.
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
    -- module-finite over `A`. ASSEMBLY ROUTE (the dévissage chain is now
    -- scaffolded in the `GenericFreeness` namespace above):
    --   * Run the prime-filtration induction principle
    --     `IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime` over the
    --     noetherian ring `B` with motive
    --     `P N := ∃ f ≠ 0, Free A_f (N_f)` (each B-module `N` given its
    --     restricted A-structure via `algebraMap A B`); its three obligations
    --     are: subsingleton `N` ⟹ `exists_free_localizationAway_of_torsion`;
    --     SES closure ⟹ `exists_free_localizationAway_of_shortExact` (L3);
    --     `N ≅ B/𝔭` ⟹ the `B/𝔭` (domain, finite-type/A) case.
    --   * The `B/𝔭` case: `exists_localizationAway_finite_mvPolynomial` (L4) makes
    --     `(B/𝔭)_g` module-finite over `A_g[X_1,…,X_n]`, then
    --     `exists_free_localizationAway_polynomial` (L5) over `A_g` gives `h ≠ 0`
    --     with `((B/𝔭)_g)_h` free over `A_{gh}`; descend with `f := g·h`.
    -- Wiring this assembly requires the restriction-of-scalars motive plumbing
    -- (a `Module A N` on each `B`-module `N` of the induction, defeq-compatible
    -- with the given `Module A M`); deferred until L3/L4/L5 are closed. The chain
    -- decls and their `sorry`s are the genuine remaining gap (see `task_results`).
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
