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
    rw [Submonoid.powers_le]; exact s.2
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

/-- **L4 helper — a localisation lift into another injective localisation is injective.**
If `S` is a localisation of `R` at `M`, `g : R →+* P` sends `M` to units, and both
`algebraMap R S` and `g` are injective, then the induced `IsLocalization.lift hg : S →+* P`
is injective. (Used for the comparison maps `ν : B_g → B_K` and `ψ : A_g → K` in L4, both
localisations of a domain into a larger localisation.) -/
theorem isLocalization_lift_injective {R P : Type*} [CommRing R] [CommRing P]
    {S : Type*} [CommRing S] [Algebra R S] {M : Submonoid R} [IsLocalization M S]
    {g : R →+* P} (hg : ∀ y : M, IsUnit (g (y : R)))
    (hSinj : Function.Injective (algebraMap R S))
    (hginj : Function.Injective g) :
    Function.Injective (IsLocalization.lift hg : S →+* P) := by
  rw [IsLocalization.lift_injective_iff]
  intro x y
  rw [hSinj.eq_iff, hginj.eq_iff]

set_option synthInstance.maxHeartbeats 1000000 in
-- Deep nested localization instance synthesis (cf. `gf_torsion_reindex`) needs raised budgets.
set_option maxHeartbeats 4000000 in
-- The comparison-map (`ν`, `ψ`) + `aeval` assembly over stacked `Away` localizations is heavy.
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
  --
  -- ===================================================================
  -- iter-018 foundation (proved below, `g`-independent and reusable). The
  -- remaining `sorry` is the denominator-clearing assembly; all the API it needs
  -- is verified present and recorded in the roadmap comment that follows.
  -- ===================================================================
  --
  -- (F1) `A ↪ B`. Nontriviality of `B_K = K ⊗_A B` forces `algebraMap A B`
  -- injective: if `0 ≠ a ∈ A` had `algebraMap A B a = 0`, then `a` acts as `0`
  -- on every pure tensor (`a • (k ⊗ b) = k ⊗ (a • b) = k ⊗ 0 = 0`) yet `a` acts
  -- invertibly through the unit `algebraMap A K a`, forcing `B_K` subsingleton.
  have hAB : Function.Injective (algebraMap A B) := by
    rw [injective_iff_map_eq_zero]
    intro a ha
    by_contra h0
    have hunit : IsUnit (algebraMap A (FractionRing A) a) :=
      IsLocalization.map_units (FractionRing A)
        (⟨a, mem_nonZeroDivisors_of_ne_zero h0⟩ : nonZeroDivisors A)
    have hsub : ∀ z : TensorProduct A (FractionRing A) B, z = 0 := by
      intro z
      have haz : a • z = 0 := by
        induction z using TensorProduct.induction_on with
        | zero => simp
        | tmul k b =>
          rw [← TensorProduct.tmul_smul, Algebra.smul_def, ha, zero_mul, TensorProduct.tmul_zero]
        | add x y hx hy => rw [smul_add, hx, hy, add_zero]
      have h2 : (algebraMap A (FractionRing A) a) • z = 0 := by
        rw [IsScalarTower.algebraMap_smul]; exact haz
      exact (hunit.smul_eq_zero).mp h2
    haveI : Subsingleton (TensorProduct A (FractionRing A) B) :=
      ⟨fun x y => by rw [hsub x, hsub y]⟩
    exact (not_subsingleton _) ‹_›
  -- (F2) `B_K = K ⊗_A B` is the localisation of `B` at the image of the non-zero
  -- divisors of `A` (`IsLocalization.tensorRight`). This is the structural fact
  -- that lets us clear denominators of `gK (X j) ∈ B_K` down into `B` (and then
  -- into `B_g`), and that identifies the canonical maps `B → B_g → B_K`.
  letI : Algebra B (TensorProduct A (FractionRing A) B) := Algebra.TensorProduct.rightAlgebra
  haveI hloc : IsLocalization (Algebra.algebraMapSubmonoid B (nonZeroDivisors A))
      (TensorProduct A (FractionRing A) B) :=
    IsLocalization.tensorRight (FractionRing A) (nonZeroDivisors A)
  -- (F3) A single common denominator `g0 ∈ A`, `g0 ≠ 0`, clearing all `s`
  -- generators `gK (X j)` into `B`: for each `j` there is `β_j ∈ B` with
  -- `algebraMap B B_K β_j = (algebraMap A B g0) • gK (X j)`.
  obtain ⟨den, hden⟩ := IsLocalization.exist_integer_multiples
    (Algebra.algebraMapSubmonoid B (nonZeroDivisors A)) (Finset.univ : Finset (Fin s))
    (fun j => gK (MvPolynomial.X j))
  obtain ⟨g0, hg0mem, hg0eq⟩ := den.2
  have hg0ne : g0 ≠ 0 := nonZeroDivisors.ne_zero hg0mem
  -- (F4) `B_K` is integral over the polynomial subring `gK (K[X])` (module-finite
  -- ⟹ integral), so every element — in particular the image of each `A`-algebra
  -- generator of `B` — satisfies a monic equation with coefficients in `K[X]`.
  letI := gK.toAlgebra
  haveI hmf : Module.Finite (MvPolynomial (Fin s) (FractionRing A))
      (TensorProduct A (FractionRing A) B) := hgK_fin
  haveI hint : Algebra.IsIntegral (MvPolynomial (Fin s) (FractionRing A))
      (TensorProduct A (FractionRing A) B) := Algebra.IsIntegral.of_finite _ _
  -- (F5) A finite `A`-algebra generating set `σ` of `B` (hence of `B_g` over
  -- `A_g`, and so of `B_g` over `A_g[X]` once `φ` is in hand).
  obtain ⟨σ, hσ⟩ : ∃ σ : Finset B, Algebra.adjoin A (↑σ : Set B) = ⊤ :=
    (inferInstance : Algebra.FiniteType A B).out
  -- (F6) the generators `gK (X j)` are algebraically independent over `K`
  -- (`hgK_inj`, since `gK = aeval (gK ∘ X)`). Restricting scalars along the
  -- injection `A_g ↪ K` will descend this to independence over `A_g`, which is
  -- exactly injectivity of `φ` (see the INJECTIVITY step of the roadmap).
  have hAI : AlgebraicIndependent (FractionRing A) (fun j => gK (MvPolynomial.X j)) := by
    rw [algebraicIndependent_iff_injective_aeval]
    have hgKaeval : (MvPolynomial.aeval (fun j => gK (MvPolynomial.X j)) :
        MvPolynomial (Fin s) (FractionRing A) →ₐ[FractionRing A] _) = gK := by
      apply MvPolynomial.algHom_ext; intro j; simp
    rw [hgKaeval]; exact hgK_inj
  -- ===================================================================
  -- REMAINING ASSEMBLY (denominator-clearing core of L4). All API verified
  -- present (iter-018); the residue is the bookkeeping of choosing `g` and
  -- discharging the two conjuncts:
  --
  --   • Choose `g1 ≠ 0` clearing the `K[X]`-coefficients of the finitely many
  --     monic integral-dependence equations of the generators `σ` (via (F4) and
  --     `gf_clear_one_denominator` / `IsLocalization.exist_integer_multiples`,
  --     folded over `σ`). Set `g := g0 * g1` (`≠ 0`, a multiple of `g0`).
  --   • `Algebra A_g B_g := (Localization.awayMap (algebraMap A B) g).toAlgebra`
  --     (verified). `ν : B_g →+* B_K := IsLocalization.Away.lift (algebraMap A B g) _`
  --     (verified; the unit hypothesis is `IsUnit (algebraMap B B_K (algebraMap A B g))`,
  --     which holds since `algebraMap A K g` is a unit of `K`).
  --   • `b_j ∈ B_g := (unit (algebraMap A B g0))⁻¹ • algebraMap B B_g β_j`
  --     (well-defined as `g0 ∣ g`); then `ν (b_j) = gK (X j)` by (F3).
  --     `φ := MvPolynomial.aeval b : A_g[X] →ₐ[A_g] B_g`, `n := s`.
  --
  --   INJECTIVITY: `φ` injective ⟺ `AlgebraicIndependent A_g b`
  --     (`algebraicIndependent_iff_injective_aeval`). Via the injective `A_g`-algebra
  --     map `ν` and `ν ∘ b = gK ∘ X`, `AlgHom.algebraicIndependent_iff` reduces this to
  --     `AlgebraicIndependent A_g (gK ∘ X)`, obtained from
  --     `AlgebraicIndependent K (gK ∘ X)` (= `hgK_inj` via
  --     `algebraicIndependent_iff_injective_aeval` + `aeval_unique`) by
  --     `AlgebraicIndependent.restrictScalars` along the injection `A_g ↪ K`.
  --
  --   FINITENESS: each generator `σ_i` is integral over `A_g[X]` via `φ` (push the
  --     (F4) monic relation through `φ`/`ν`, using `ν` injective and that `g1` cleared
  --     its coefficients), so `Algebra.IsIntegral A_g[X] B_g`; with
  --     `Algebra.FiniteType A_g[X] B_g` (from `B_g` finite-type over `A_g`),
  --     `Algebra.IsIntegral.finite` gives `Module.Finite A_g[X] B_g`.
  -- ===================================================================
  -- ASSEMBLY (this iter): with `g := g0`, build the algebra instance, the comparison maps
  -- `ν : B_g → B_K` and `ψ : A_g → K`, the generators `b_j` with `ν (b_j) = gK (X j)`, and
  -- the `A_g`-algebra map `φ := aeval b`.  Injectivity is reduced to
  -- `ν ∘ φ = gK ∘ (map ψ)` (a composite of injectives).  Finiteness over the finer `g` is
  -- the residual.
  letI algAgBg : Algebra (Localization.Away g0) (Localization.Away (algebraMap A B g0)) :=
    (Localization.awayMap (algebraMap A B) g0).toAlgebra
  -- `algebraMap B B_K` is injective (`B_K` is a localisation of the domain `B`).
  have hSle : Algebra.algebraMapSubmonoid B (nonZeroDivisors A) ≤ nonZeroDivisors B := by
    rintro _ ⟨a, ha, rfl⟩
    exact mem_nonZeroDivisors_of_ne_zero ((map_ne_zero_iff _ hAB).2 (nonZeroDivisors.ne_zero ha))
  have hBKinj : Function.Injective (algebraMap B (TensorProduct A (FractionRing A) B)) :=
    IsLocalization.injective _ hSle
  -- ν : B_g → B_K, comparison map, injective.
  have hg_unit_BK : ∀ y : Submonoid.powers (algebraMap A B g0),
      IsUnit (algebraMap B (TensorProduct A (FractionRing A) B) (y : B)) := by
    rintro ⟨_, n, rfl⟩
    rw [map_pow]
    exact (IsLocalization.map_units (TensorProduct A (FractionRing A) B)
      (⟨algebraMap A B g0, ⟨g0, mem_nonZeroDivisors_of_ne_zero hg0ne, rfl⟩⟩ :
        Algebra.algebraMapSubmonoid B (nonZeroDivisors A))).pow n
  set ν : Localization.Away (algebraMap A B g0) →+* TensorProduct A (FractionRing A) B :=
    IsLocalization.lift (M := Submonoid.powers (algebraMap A B g0)) hg_unit_BK with hν_def
  have hν_inj : Function.Injective ν := by
    rw [hν_def]
    refine isLocalization_lift_injective hg_unit_BK ?_ hBKinj
    exact IsLocalization.injective _
      (Submonoid.powers_le.mpr (mem_nonZeroDivisors_of_ne_zero ((map_ne_zero_iff _ hAB).2 hg0ne)))
  -- ψ : A_g → K, injective.
  have hg_unit_K : ∀ y : Submonoid.powers g0, IsUnit (algebraMap A (FractionRing A) (y : A)) := by
    rintro ⟨_, n, rfl⟩
    rw [map_pow]
    exact (IsLocalization.map_units (FractionRing A)
      (⟨g0, mem_nonZeroDivisors_of_ne_zero hg0ne⟩ : nonZeroDivisors A)).pow n
  set ψ : Localization.Away g0 →+* FractionRing A :=
    IsLocalization.lift (M := Submonoid.powers g0) hg_unit_K with hψ_def
  have hψ_inj : Function.Injective ψ := by
    rw [hψ_def]
    refine isLocalization_lift_injective hg_unit_K ?_ (IsFractionRing.injective A (FractionRing A))
    exact IsLocalization.injective _
      (Submonoid.powers_le.mpr (mem_nonZeroDivisors_of_ne_zero hg0ne))
  -- the generators b_j ∈ B_g with ν(b_j) = gK(X j).
  have hgB_unit : IsUnit
      (algebraMap B (Localization.Away (algebraMap A B g0)) (algebraMap A B g0)) :=
    IsLocalization.map_units (Localization.Away (algebraMap A B g0))
      (⟨algebraMap A B g0, Submonoid.mem_powers _⟩ : Submonoid.powers (algebraMap A B g0))
  have hβex : ∀ j : Fin s, ∃ β : B,
      algebraMap B (TensorProduct A (FractionRing A) B) β = (↑den : B) • gK (MvPolynomial.X j) := by
    intro j
    obtain ⟨β, hβ⟩ := hden j (Finset.mem_univ j)
    exact ⟨β, hβ⟩
  choose β hβ using hβex
  let b : Fin s → Localization.Away (algebraMap A B g0) :=
    fun j => ↑(hgB_unit.unit⁻¹) * algebraMap B _ (β j)
  have hνb : ∀ j, ν (b j) = gK (MvPolynomial.X j) := by
    intro j
    change ν (↑(hgB_unit.unit⁻¹) * algebraMap B _ (β j)) = gK (MvPolynomial.X j)
    rw [map_mul]
    have h1 : ν (algebraMap B (Localization.Away (algebraMap A B g0)) (β j))
        = algebraMap B (TensorProduct A (FractionRing A) B) (β j) := by
      rw [hν_def]; exact IsLocalization.lift_eq hg_unit_BK (β j)
    have hden_eq : (↑den : B) = algebraMap A B g0 := hg0eq.symm
    have h3 : ν (↑hgB_unit.unit)
        = algebraMap B (TensorProduct A (FractionRing A) B) (↑den : B) := by
      rw [hgB_unit.unit_spec, hν_def, IsLocalization.lift_eq, hden_eq]
    rw [h1, hβ j, Algebra.smul_def, ← h3, ← mul_assoc, ← map_mul, Units.inv_mul, map_one, one_mul]
  set φ : MvPolynomial (Fin s) (Localization.Away g0) →ₐ[Localization.Away g0]
      Localization.Away (algebraMap A B g0) := MvPolynomial.aeval b with hφ_def
  -- compatibility square: ν ∘ (A_g → B_g) = (K → B_K) ∘ ψ.
  have hsquare : ∀ a : Localization.Away g0,
      ν (algebraMap (Localization.Away g0) (Localization.Away (algebraMap A B g0)) a)
        = algebraMap (FractionRing A) (TensorProduct A (FractionRing A) B) (ψ a) := by
    have key : (ν.comp (algebraMap (Localization.Away g0)
          (Localization.Away (algebraMap A B g0)))).comp (algebraMap A (Localization.Away g0))
        = ((algebraMap (FractionRing A) (TensorProduct A (FractionRing A) B)).comp ψ).comp
            (algebraMap A (Localization.Away g0)) := by
      ext a0
      simp only [RingHom.coe_comp, Function.comp_apply]
      rw [hψ_def, IsLocalization.lift_eq,
        ← IsScalarTower.algebraMap_apply A (FractionRing A) (TensorProduct A (FractionRing A) B)]
      have hstep1 : (algebraMap (Localization.Away g0) (Localization.Away ((algebraMap A B) g0)))
            ((algebraMap A (Localization.Away g0)) a0)
          = (algebraMap B (Localization.Away ((algebraMap A B) g0))) ((algebraMap A B) a0) := by
        change (Localization.awayMap (algebraMap A B) g0)
          ((algebraMap A (Localization.Away g0)) a0) = _
        rw [Localization.awayMap, IsLocalization.Away.map, IsLocalization.map_eq]
      rw [hstep1, hν_def, IsLocalization.lift_eq,
        ← IsScalarTower.algebraMap_apply A B (TensorProduct A (FractionRing A) B)]
    intro a
    exact RingHom.congr_fun (IsLocalization.ringHom_ext (Submonoid.powers g0) key) a
  have hφ_inj : Function.Injective φ := by
    have hcomp : (ν.comp (φ : MvPolynomial (Fin s) (Localization.Away g0) →+*
          Localization.Away (algebraMap A B g0)))
        = (gK.toRingHom).comp (MvPolynomial.map ψ) := by
      apply MvPolynomial.ringHom_ext
      · intro a
        simp only [RingHom.comp_apply, AlgHom.toRingHom_eq_coe, AlgHom.coe_toRingHom,
          MvPolynomial.map_C, hφ_def, MvPolynomial.aeval_C]
        rw [hsquare, ← MvPolynomial.algebraMap_eq, AlgHom.commutes]
      · intro j
        simp only [RingHom.comp_apply, AlgHom.toRingHom_eq_coe, AlgHom.coe_toRingHom,
          MvPolynomial.map_X, hφ_def, MvPolynomial.aeval_X]
        exact hνb j
    have hcompfun : ⇑ν ∘ ⇑φ = ⇑gK ∘ ⇑(MvPolynomial.map ψ) := by
      have := congrArg (DFunLike.coe) hcomp
      simpa [RingHom.coe_comp, AlgHom.coe_toRingHom] using this
    have hinj : Function.Injective (⇑ν ∘ ⇑φ) := by
      rw [hcompfun]
      exact hgK_inj.comp (MvPolynomial.map_injective ψ hψ_inj)
    exact hinj.of_comp
  -- FINITENESS (remaining leaf). The injectivity half above is closed for the witness `g0`.
  -- Module-finiteness of `B_g` over `A_g[X]` (via `φ.toAlgebra`) requires refining the witness
  -- to `g := g0 * g1`, where `g1 ≠ 0` clears the `K[X]`-coefficients of the finitely many monic
  -- integral-dependence equations satisfied by the `A`-algebra generators `σ` of `B` (each
  -- `algebraMap B B_K σᵢ` is integral over `K[X]` by `hint`; clear via `gf_clear_one_denominator`
  -- folded over the coefficients). Over the refined `A_g`, every `σᵢ` becomes integral over the
  -- image polynomial subalgebra (pull the cleared monic relation back through the injective `ν`),
  -- and since `Algebra.adjoin A_g (algebraMap B B_g '' σ) = ⊤`, the finiteness follows from
  -- `Algebra.finite_adjoin_of_finite_of_isIntegral`. The witness `g0` here is provisional: it
  -- must be replaced by `g0 * g1` together with the integral-clearing assembly when this leaf is
  -- discharged. All the structural scaffolding (`ν`, `ψ`, `b`, `φ`, injectivity) above transfers
  -- verbatim to the finer `g` (the unit `hgB_unit` only needs `g0 ∣ g`).
  have hfin : letI := φ.toAlgebra;
      Module.Finite (MvPolynomial (Fin s) (Localization.Away g0))
        (Localization.Away (algebraMap A B g0)) := by
    sorry
  exact ⟨s, g0, hg0ne, algAgBg, φ, hφ_inj, hfin⟩

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
    apply IsFractionRing.injective P K
    rw [Algebra.algebraMap_eq_smul_one, Algebra.algebraMap_eq_smul_one]
    exact hxy
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

/-- **L5b.1 — annihilator extraction for the torsion module**
(`lem:gf_torsion_annihilator`, Nitsure §4). For `A` a noetherian domain, `d ≥ 0`,
and `T` a finite *torsion* module over `P_d := A[X_1,…,X_d]`, there exists a
non-zero `F ∈ Ann_{P_d}(T)`. Since `P_d` is a domain, a non-zero-divisor
annihilator (provided by `Submodule.annihilator_top_inter_nonZeroDivisors`) is the
same thing as a non-zero one. -/
theorem gf_torsion_annihilator
    (A : Type*) [CommRing A] [IsDomain A] [IsNoetherianRing A] (d : ℕ)
    (T : Type*) [AddCommGroup T] [Module (MvPolynomial (Fin d) A) T]
    [Module.Finite (MvPolynomial (Fin d) A) T]
    (htors : Module.IsTorsion (MvPolynomial (Fin d) A) T) :
    ∃ F : MvPolynomial (Fin d) A, F ≠ 0 ∧
      F ∈ Module.annihilator (MvPolynomial (Fin d) A) T := by
  obtain ⟨F, hFann, hFnzd⟩ := Submodule.annihilator_top_inter_nonZeroDivisors htors
  refine ⟨F, nonZeroDivisors.ne_zero hFnzd, ?_⟩
  rw [← Submodule.annihilator_top]
  exact hFann

/-! ### L5b.2 — Nagata change of variables (`lem:gf_nagata_monic_lastVar`)

The single-variable elimination of the support-dimension drop needs a triangular
change of variables `e` making a non-zero `F ∈ A[X_0,…,X_n]` monic in `X_0` up to a
unit after inverting one `g ∈ A`. Mathlib's Noether-normalisation development
(`Mathlib.RingTheory.NoetherNormalization`) constructs exactly this transformation
`T` and proves the leading coefficient is a unit — but only over a *field*, and as
`private` lemmas. The block below replays that construction over a noetherian *domain*
(the field is used in Mathlib only to conclude the top coefficient is a unit; over a
domain it is merely non-zero, and becomes a unit after inverting it). The degree
bookkeeping (`degreeOf_zero_t`, `leadingCoeff_finSuccEquiv_t`, `T_leadingcoeff_eq`) is
a domain-adapted transcription of the Mathlib originals. -/

section NagataNormalization

-- `AlgebraicGeometry.Polynomial` exists and would shadow the root namespace, so the
-- `Polynomial`/`MvPolynomial` lemma APIs are opened with explicit `_root_.` prefixes.
open _root_.Polynomial _root_.MvPolynomial _root_.Ideal Nat _root_.RingHom List

/-- `finSuccEquiv` commutes with coefficient base change `MvPolynomial.map phi`. -/
private theorem finSuccEquiv_map_comm {A B : Type*} [CommRing A] [CommRing B]
    (phi : A →+* B) (m : ℕ) (q : MvPolynomial (Fin (m + 1)) A) :
    finSuccEquiv B m (MvPolynomial.map phi q)
      = Polynomial.map (MvPolynomial.map phi) (finSuccEquiv A m q) := by
  induction q using MvPolynomial.induction_on with
  | C a => simp [finSuccEquiv_apply]
  | add p q hp hq => simp [hp, hq]
  | mul_X p i hp =>
    simp only [map_mul, Polynomial.map_mul, hp]
    congr 1
    cases i using Fin.cases with
    | zero => simp [finSuccEquiv_X_zero]
    | succ j => simp [finSuccEquiv_X_succ]

variable {k : Type*} [CommRing k] [IsDomain k] {n : ℕ} (f : MvPolynomial (Fin (n + 1)) k)
variable (v w : Fin (n + 1) →₀ ℕ)

local notation3 "up" => 2 + f.totalDegree
local notation3 "r" => fun (i : Fin (n + 1)) ↦ up ^ i.1

omit [IsDomain k] in
variable {f v} in
private lemma lt_up (vlt : ∀ i, v i < up) : ∀ l ∈ ofFn v, l < up := by grind

/-- The triangular Nagata substitution `X_i ↦ X_i + c • X_0 ^ (up ^ i)` (`i ≠ 0`),
`X_0 ↦ X_0`. Transcribed from `Mathlib.RingTheory.NoetherNormalization` to a domain. -/
private noncomputable abbrev T1 (c : k) :
    MvPolynomial (Fin (n + 1)) k →ₐ[k] MvPolynomial (Fin (n + 1)) k :=
  aeval fun i ↦ if i = 0 then X 0 else X i + c • X 0 ^ r i

omit [IsDomain k] in
private lemma t1_comp_t1_neg (c : k) : (T1 f c).comp (T1 f (-c)) = AlgHom.id _ _ := by
  rw [comp_aeval, ← MvPolynomial.aeval_X_left]; ext i v; cases i using Fin.cases <;> simp

/-- The Nagata transformation as an `A`-algebra automorphism. -/
private noncomputable abbrev T := AlgEquiv.ofAlgHom (T1 f 1) (T1 f (-1))
  (t1_comp_t1_neg f 1) (by simpa using t1_comp_t1_neg f (-1))

omit [IsDomain k] in
private lemma sum_r_mul_ne (vlt : ∀ i, v i < up) (wlt : ∀ i, w i < up) (ne : v ≠ w) :
    ∑ x : Fin (n + 1), r x * v x ≠ ∑ x : Fin (n + 1), r x * w x := by
  intro h
  refine ne <| Finsupp.ext <| congrFun <| ofFn_inj.mp ?_
  apply ofDigits_inj_of_len_eq (Nat.lt_add_right f.totalDegree one_lt_two)
    (by simp) (lt_up vlt) (lt_up wlt)
  simpa only [ofDigits_eq_sum_mapIdx, mapIdx_eq_ofFn, get_ofFn, length_ofFn,
    Fin.val_cast, mul_comm, sum_ofFn] using h

private lemma degreeOf_zero_t {a : k} (ha : a ≠ 0) : ((T f) (monomial v a)).degreeOf 0 =
    ∑ i : Fin (n + 1), (r i) * v i := by
  rw [← natDegree_finSuccEquiv, monomial_eq, Finsupp.prod_pow v fun a ↦ X a]
  simp only [Fin.prod_univ_succ, Fin.sum_univ_succ, map_mul, map_prod, map_pow,
    AlgEquiv.ofAlgHom_apply, MvPolynomial.aeval_C, MvPolynomial.aeval_X, if_pos, Fin.succ_ne_zero,
    ite_false, one_smul, map_add, finSuccEquiv_X_zero, finSuccEquiv_X_succ, algebraMap_eq]
  have h (i : Fin n) :
      (Polynomial.C (X (R := k) i) + Polynomial.X ^ r i.succ) ^ v i.succ ≠ 0 :=
    pow_ne_zero (v i.succ) (leadingCoeff_ne_zero.mp <| by simp [add_comm, leadingCoeff_X_pow_add_C])
  rw [natDegree_mul (by simp [ha]) (mul_ne_zero (by simp) (Finset.prod_ne_zero_iff.mpr
    (fun i _ ↦ h i))), natDegree_mul (by simp) (Finset.prod_ne_zero_iff.mpr (fun i _ ↦ h i)),
    natDegree_prod _ _ (fun i _ ↦ h i), natDegree_finSuccEquiv, degreeOf_C]
  simpa only [natDegree_pow, zero_add, natDegree_X, mul_one, Fin.val_zero, pow_zero, one_mul,
    add_right_inj] using Finset.sum_congr rfl (fun i _ ↦ by
    rw [add_comm (Polynomial.C _), natDegree_X_pow_add_C, mul_comm])

private lemma degreeOf_t_ne_of_ne (hv : v ∈ f.support) (hw : w ∈ f.support) (ne : v ≠ w) :
    (T f <| monomial v <| coeff v f).degreeOf 0 ≠
    (T f <| monomial w <| coeff w f).degreeOf 0 := by
  rw [degreeOf_zero_t _ _ <| mem_support_iff.mp hv, degreeOf_zero_t _ _ <| mem_support_iff.mp hw]
  refine sum_r_mul_ne f v w (fun i ↦ ?_) (fun i ↦ ?_) ne <;>
  exact lt_of_le_of_lt ((monomial_le_degreeOf i ‹_›).trans (degreeOf_le_totalDegree f i)) (by lia)

private lemma leadingCoeff_finSuccEquiv_t :
    (finSuccEquiv k n ((T f) ((monomial v) (coeff v f)))).leadingCoeff =
    algebraMap k _ (coeff v f) := by
  rw [monomial_eq, Finsupp.prod_fintype]
  · simp only [map_mul, map_prod, leadingCoeff_mul, leadingCoeff_prod]
    rw [AlgEquiv.ofAlgHom_apply, algHom_C, algebraMap_eq, finSuccEquiv_apply, eval₂Hom_C, coe_comp]
    simp only [AlgEquiv.ofAlgHom_apply, Function.comp_apply, leadingCoeff_C, map_pow,
      leadingCoeff_pow, algebraMap_eq]
    have : ∀ j, ((finSuccEquiv k n) ((T1 f) 1 (X j))).leadingCoeff = 1 := fun j ↦ by
      by_cases h : j = 0
      · simp [h, finSuccEquiv_apply]
      · simp only [aeval_eq_bind₁, bind₁_X_right, if_neg h, one_smul, map_add, map_pow]
        obtain ⟨i, rfl⟩ := Fin.exists_succ_eq.mpr h
        simp [finSuccEquiv_X_succ, finSuccEquiv_X_zero, add_comm]
    simp only [this, one_pow, Finset.prod_const_one, mul_one]
  exact fun i ↦ pow_zero _

/-- Over a domain, the `T`-transform of a non-zero `f` has, in `X_0`, a leading
coefficient equal to `C (coeff v f)` for some `v ∈ f.support` (hence non-zero). The
Mathlib original concludes `IsUnit` using the field hypothesis; here we keep the exact
coefficient so the caller can invert it. -/
private lemma T_leadingcoeff_eq (fne : f ≠ 0) :
    ∃ v ∈ f.support,
      (finSuccEquiv k n (T f f)).leadingCoeff = MvPolynomial.C (coeff v f) := by
  obtain ⟨v, vin, vs⟩ := Finset.exists_max_image f.support
    (fun v ↦ (T f ((monomial v) (coeff v f))).degreeOf 0) (support_nonempty.mpr fne)
  set h := fun w ↦ (MvPolynomial.monomial w) (coeff w f)
  simp only [← natDegree_finSuccEquiv] at vs
  replace vs : ∀ x ∈ f.support \ {v}, (finSuccEquiv k n ((T f) (h x))).degree <
      (finSuccEquiv k n ((T f) (h v))).degree := by
    intro x hx
    obtain ⟨h1, h2⟩ := Finset.mem_sdiff.mp hx
    apply degree_lt_degree <| lt_of_le_of_ne (vs x h1) ?_
    simpa only [natDegree_finSuccEquiv]
      using degreeOf_t_ne_of_ne f _ _ h1 vin <| ne_of_not_mem_cons h2
  have coeff : (finSuccEquiv k n ((T f) (h v + ∑ x ∈ f.support \ {v}, h x))).leadingCoeff =
      (finSuccEquiv k n ((T f) (h v))).leadingCoeff := by
    simp only [map_add, map_sum]
    rw [add_comm]
    apply leadingCoeff_add_of_degree_lt <| (lt_of_le_of_lt <| degree_sum_le _ _) ?_
    have h2 : h v ≠ 0 := by simpa [h] using mem_support_iff.mp vin
    replace h2 : (finSuccEquiv k n ((T f) (h v))) ≠ 0 := fun eq ↦ h2 <|
      by simpa only [map_eq_zero_iff _ (AlgEquiv.injective _)] using eq
    exact (Finset.sup_lt_iff <| Ne.bot_lt (fun x ↦ h2 <| degree_eq_bot.mp x)).mpr vs
  refine ⟨v, vin, ?_⟩
  rw [leadingCoeff_finSuccEquiv_t] at coeff
  nth_rw 2 [← f.support_sum_monomial_coeff]
  rw [Finset.sum_eq_add_sum_diff_singleton_of_mem vin h, coeff, algebraMap_eq]

/-- **L5b.2 — Nagata change of variables: monic in the distinguished variable**
(`lem:gf_nagata_monic_lastVar`, Nitsure §4). For `A` a domain and `0 ≠ F ∈
A[X_0,…,X_m]`, there is a triangular `A`-algebra automorphism `e` and a non-zero
`g ∈ A` such that, after inverting `g`, the image of `e F` in `A_g[X_0,…,X_m]` —
viewed via `finSuccEquiv` as a univariate polynomial in `X_0` — has a *unit* leading
coefficient. (Variable convention: `finSuccEquiv` singles out `X_0`, not `X_m`; the
choice is immaterial up to renaming.) -/
theorem gf_nagata_monic_lastVar
    (A : Type*) [CommRing A] [IsDomain A] (m : ℕ)
    (F : MvPolynomial (Fin (m + 1)) A) (hF : F ≠ 0) :
    ∃ (g : A) (_ : g ≠ 0)
      (e : MvPolynomial (Fin (m + 1)) A ≃ₐ[A] MvPolynomial (Fin (m + 1)) A),
      IsUnit
        (MvPolynomial.finSuccEquiv (Localization.Away g) m
          (MvPolynomial.map (algebraMap A (Localization.Away g)) (e F))).leadingCoeff := by
  obtain ⟨v, vin, hlc⟩ := T_leadingcoeff_eq F hF
  have hg0 : coeff v F ≠ 0 := mem_support_iff.mp vin
  refine ⟨coeff v F, hg0, T F, ?_⟩
  set g := coeff v F with hg
  haveI : Nontrivial (Localization.Away g) := by
    have hle : Submonoid.powers g ≤ nonZeroDivisors A := by
      rw [Submonoid.powers_le]; exact mem_nonZeroDivisors_of_ne_zero hg0
    exact (IsLocalization.injective (Localization.Away g) hle).nontrivial
  have hgunit : IsUnit (algebraMap A (Localization.Away g) g) :=
    IsLocalization.Away.algebraMap_isUnit g
  have hCunit : IsUnit (MvPolynomial.C (algebraMap A (Localization.Away g) g)
      : MvPolynomial (Fin m) (Localization.Away g)) := hgunit.map MvPolynomial.C
  have hne : (MvPolynomial.map (algebraMap A (Localization.Away g)))
      (finSuccEquiv A m (T F F)).leadingCoeff ≠ 0 := by
    rw [hlc, MvPolynomial.map_C]; exact hCunit.ne_zero
  rw [finSuccEquiv_map_comm, leadingCoeff_map_of_leadingCoeff_ne_zero _ hne, hlc,
    MvPolynomial.map_C]
  exact hCunit

end NagataNormalization

/-- Compatibility of `finSuccEquiv` with the constant-variable inclusion
`rename Fin.succ`: the composite `S = R[X_1,…,X_n] → R[X_0,…,X_n] → S[X_0]` is the
coefficient inclusion `Polynomial.C`. Project-local because Mathlib only records the
`optionEquivLeft` variant (`finSuccEquiv_rename_finSuccEquiv`). -/
private theorem finSuccEquiv_rename_succ
    (R : Type*) [CommRing R] (n : ℕ) (s : MvPolynomial (Fin n) R) :
    MvPolynomial.finSuccEquiv R n (MvPolynomial.rename Fin.succ s) = Polynomial.C s := by
  induction s using MvPolynomial.induction_on with
  | C r => rw [MvPolynomial.rename_C, MvPolynomial.finSuccEquiv_apply, MvPolynomial.eval₂Hom_C]; rfl
  | add p q hp hq => simp [hp, hq]
  | mul_X p i hp =>
    rw [map_mul, map_mul, hp, MvPolynomial.rename_X, MvPolynomial.finSuccEquiv_X_succ,
      Polynomial.C_mul]

/-- **L5b.3 — single-variable elimination engine** (shared)
(`lem:gf_mvPolynomial_quotient_finite_monic`, Nitsure §4). Let `R` be a commutative
ring and `p ∈ R[X_0,…,X_n]` a polynomial whose image under `finSuccEquiv` (a
univariate polynomial in `X_0` over `S := R[X_1,…,X_n]`) has a *unit* leading
coefficient — i.e. `p` is monic in `X_0` up to a unit. Then `R[X_0,…,X_n]/(p)` is
module-finite over `S = R[X_1,…,X_n]`, the structure being via the constant
inclusion `S ↪ R[X_0,…,X_n]` (`rename Fin.succ`) followed by `Ideal.Quotient.mk`.

Encoded as `RingHom.Finite` of that composite ring map (which unfolds to
`Module.Finite S (R[X_0,…,X_n]/(p))` with the exotic algebra structure) to avoid an
in-statement `letI` whose `Module` synthesis loops. The proof rescales `finSuccEquiv p`
by the inverse of its unit leading coefficient to a monic polynomial generating the
same ideal, invokes `Polynomial.Monic.finite_quotient`, and transports along the
`S`-algebra isomorphism induced by `finSuccEquiv`. -/
theorem mvPolynomial_quotient_finite_of_monic_lastVar
    (R : Type*) [CommRing R] (n : ℕ)
    (p : MvPolynomial (Fin (n + 1)) R)
    (hp : IsUnit (MvPolynomial.finSuccEquiv R n p).leadingCoeff) :
    ((Ideal.Quotient.mk (Ideal.span {p})).comp
        (MvPolynomial.rename Fin.succ).toRingHom :
          MvPolynomial (Fin n) R →+* (MvPolynomial (Fin (n + 1)) R ⧸ Ideal.span {p})).Finite := by
  letI algI : Algebra (MvPolynomial (Fin n) R) (MvPolynomial (Fin (n + 1)) R ⧸ Ideal.span {p}) :=
    ((Ideal.Quotient.mk (Ideal.span {p})).comp
      (MvPolynomial.rename Fin.succ).toRingHom).toAlgebra
  have hc : IsUnit ((hp.unit⁻¹ : (MvPolynomial (Fin n) R)ˣ) : MvPolynomial (Fin n) R) :=
    (hp.unit⁻¹).isUnit
  have hcP :
      IsUnit (Polynomial.C ((hp.unit⁻¹ : (MvPolynomial (Fin n) R)ˣ) : MvPolynomial (Fin n) R)) :=
    hc.map Polynomial.C
  have hmonic : (Polynomial.C ((hp.unit⁻¹ : (MvPolynomial (Fin n) R)ˣ) : MvPolynomial (Fin n) R)
      * MvPolynomial.finSuccEquiv R n p).Monic := by
    rw [Polynomial.Monic, Polynomial.leadingCoeff_C_mul_of_isUnit hc]
    exact Units.inv_mul_of_eq hp.unit_spec
  have hspan : Ideal.span {Polynomial.C ((hp.unit⁻¹ : (MvPolynomial (Fin n) R)ˣ) :
        MvPolynomial (Fin n) R) * MvPolynomial.finSuccEquiv R n p}
      = Ideal.span {MvPolynomial.finSuccEquiv R n p} :=
    Ideal.span_singleton_mul_left_unit hcP (MvPolynomial.finSuccEquiv R n p)
  have hfinstd : Module.Finite (MvPolynomial (Fin n) R)
      (Polynomial (MvPolynomial (Fin n) R) ⧸ Ideal.span {MvPolynomial.finSuccEquiv R n p}) := by
    rw [← hspan]; exact hmonic.finite_quotient
  have hJ : Ideal.span {MvPolynomial.finSuccEquiv R n p}
      = Ideal.map ((MvPolynomial.finSuccEquiv R n).toRingEquiv :
          MvPolynomial (Fin (n + 1)) R →+* Polynomial (MvPolynomial (Fin n) R))
        (Ideal.span {p}) := by
    rw [Ideal.map_span, Set.image_singleton]; rfl
  let ψ : (MvPolynomial (Fin (n + 1)) R ⧸ Ideal.span {p})
      ≃+* (Polynomial (MvPolynomial (Fin n) R) ⧸ Ideal.span {MvPolynomial.finSuccEquiv R n p}) :=
    Ideal.quotientEquiv (Ideal.span {p}) (Ideal.span {MvPolynomial.finSuccEquiv R n p})
      (MvPolynomial.finSuccEquiv R n).toRingEquiv hJ
  have hsmul : ∀ s : MvPolynomial (Fin n) R,
      ψ (algebraMap (MvPolynomial (Fin n) R)
          (MvPolynomial (Fin (n + 1)) R ⧸ Ideal.span {p}) s)
      = algebraMap (MvPolynomial (Fin n) R)
          (Polynomial (MvPolynomial (Fin n) R) ⧸ Ideal.span {MvPolynomial.finSuccEquiv R n p})
          s := by
    intro s
    change ψ (Ideal.Quotient.mk _ (MvPolynomial.rename Fin.succ s))
      = Ideal.Quotient.mk _ (Polynomial.C s)
    rw [Ideal.quotientEquiv_mk]
    exact congrArg _ (finSuccEquiv_rename_succ R n s)
  let Ψ : (MvPolynomial (Fin (n + 1)) R ⧸ Ideal.span {p})
      ≃ₐ[MvPolynomial (Fin n) R]
      (Polynomial (MvPolynomial (Fin n) R) ⧸ Ideal.span {MvPolynomial.finSuccEquiv R n p}) :=
    AlgEquiv.ofRingEquiv hsmul
  exact @Module.Finite.equiv (MvPolynomial (Fin n) R)
    (Polynomial (MvPolynomial (Fin n) R) ⧸ Ideal.span {MvPolynomial.finSuccEquiv R n p})
    (MvPolynomial (Fin (n + 1)) R ⧸ Ideal.span {p})
    _ _ _ _ algI.toModule hfinstd Ψ.symm.toLinearEquiv

/-- Pull back an `R`-module structure along an additive equivalence `e : M ≃+ N`, defining
`r • y := e (r • e.symm y)`. With this structure `e` is `R`-linear; used in the torsion
reindex to transport the reindexed module structure from the `P`-localisation of the torsion
module to the goal's `A`-localisation. -/
@[reducible] def pullbackModuleAddEquiv {R M N : Type*} [Semiring R] [AddCommMonoid M]
    [AddCommMonoid N] [Module R M] (e : M ≃+ N) : Module R N where
  smul r y := e (r • e.symm y)
  one_smul y := by change e (1 • e.symm y) = y; rw [one_smul, AddEquiv.apply_symm_apply]
  mul_smul r s y := by
    change e ((r * s) • e.symm y) = e (r • e.symm (e (s • e.symm y)))
    rw [AddEquiv.symm_apply_apply, mul_smul]
  smul_zero r := by change e (r • e.symm 0) = 0; rw [map_zero, smul_zero, map_zero]
  smul_add r x y := by
    change e (r • e.symm (x + y)) = e (r • e.symm x) + e (r • e.symm y)
    rw [map_add, smul_add, map_add]
  add_smul r s y := by
    change e ((r + s) • e.symm y) = e (r • e.symm y) + e (s • e.symm y)
    rw [add_smul, map_add]
  zero_smul y := by change e (0 • e.symm y) = 0; rw [zero_smul, map_zero]

/-- Module-finiteness transports across the pulled-back structure of `pullbackModuleAddEquiv`:
if `M` is a finite `R`-module then so is `N` under the pulled-back action. -/
theorem finite_of_pullbackModuleAddEquiv {R M N : Type*} [Semiring R] [AddCommMonoid M]
    [AddCommMonoid N] [Module R M] [Module.Finite R M] (e : M ≃+ N) :
    @Module.Finite R N _ _ (pullbackModuleAddEquiv e) := by
  letI : Module R N := pullbackModuleAddEquiv e
  refine Module.Finite.equiv (M := M) (N := N)
    { toFun := e, map_add' := map_add e, invFun := e.symm,
      left_inv := e.left_inv, right_inv := e.right_inv,
      map_smul' := fun r x => ?_ }
  simp only [RingHom.id_apply]
  change e (r • x) = e (r • e.symm (e x))
  rw [AddEquiv.symm_apply_apply]

/-- A scalar tower transports across the pulled-back structures of `pullbackModuleAddEquiv`:
if `e : M ≃+ N` and `M` carries compatible `Ag`- and `R`-actions (`IsScalarTower Ag R M`), then
the pulled-back `Ag`- and `R`-actions on `N` form a scalar tower as well. -/
theorem pullback_isScalarTower {Ag R M N : Type*} [CommSemiring Ag] [Semiring R] [Algebra Ag R]
    [AddCommMonoid M] [AddCommMonoid N] [Module R M] [Module Ag M] [IsScalarTower Ag R M]
    (e : M ≃+ N) :
    letI := pullbackModuleAddEquiv (R := R) e
    letI := pullbackModuleAddEquiv (R := Ag) e
    IsScalarTower Ag R N := by
  letI := pullbackModuleAddEquiv (R := R) e
  letI := pullbackModuleAddEquiv (R := Ag) e
  refine ⟨fun a b x => ?_⟩
  change e ((a • b) • e.symm x) = e (a • e.symm (e (b • e.symm x)))
  rw [AddEquiv.symm_apply_apply, smul_assoc]

/-- Transport module-finiteness across a ring isomorphism of the acting ring that is
compatible with given `R`-algebra structures. If `ψ : B₁ ≃+* B₂` satisfies
`ψ ∘ algebraMap R B₁ = algebraMap R B₂`, `B₂` is module-finite over `R`, and `M` is
module-finite over `B₁` (with the scalar tower `R → B₁ → M`), then `M` is module-finite
over `R`. -/
theorem finite_of_quotientRingEquiv
    {R B₁ B₂ M : Type*} [CommRing R] [CommRing B₁] [CommRing B₂] [AddCommGroup M]
    [Algebra R B₁] [Algebra R B₂] [Module B₁ M] [Module R M] [IsScalarTower R B₁ M]
    (ψ : B₁ ≃+* B₂)
    (hψ : ∀ r : R, ψ (algebraMap R B₁ r) = algebraMap R B₂ r)
    (hB₂ : Module.Finite R B₂) (hM : Module.Finite B₁ M) :
    Module.Finite R M := by
  haveI := hB₂
  haveI := hM
  have hsymm : ∀ r : R, ψ.symm (algebraMap R B₂ r) = algebraMap R B₁ r := by
    intro r; rw [← hψ r, ψ.symm_apply_apply]
  haveI : Module.Finite R B₁ :=
    Module.Finite.equiv (AlgEquiv.ofRingEquiv (f := ψ.symm) hsymm).toLinearEquiv
  exact Module.Finite.trans B₁ M

/-- Descent of a localized-module structure along a scalar tower. If `f : M →ₗ[R] M'`
localises `M` at the image submonoid `S.map (algebraMap R' R)` over `R`, then its
restriction of scalars to `R'` localises `M` at `S` over `R'`. -/
theorem isLocalizedModule_restrictScalars
    {R' R M M' : Type*} [CommRing R'] [CommRing R] [Algebra R' R]
    [AddCommGroup M] [AddCommGroup M'] [Module R' M] [Module R M] [Module R' M'] [Module R M']
    [IsScalarTower R' R M] [IsScalarTower R' R M']
    (S : Submonoid R') (f : M →ₗ[R] M')
    [IsLocalizedModule (S.map (algebraMap R' R)) f] :
    IsLocalizedModule S (f.restrictScalars R') := by
  apply IsLocalizedModule.mk
  · intro s
    rw [Module.End.isUnit_iff]
    have hmem : algebraMap R' R (s : R') ∈ S.map (algebraMap R' R) := ⟨s, s.2, rfl⟩
    have hu := IsLocalizedModule.map_units f ⟨algebraMap R' R (s : R'), hmem⟩
    rw [Module.End.isUnit_iff] at hu
    have hfun : ⇑((algebraMap R' (Module.End R' M')) (s : R'))
        = ⇑((algebraMap R (Module.End R M')) (algebraMap R' R (s : R'))) := by
      funext x
      rw [Module.algebraMap_end_apply, Module.algebraMap_end_apply, IsScalarTower.algebraMap_smul]
    rw [hfun]
    exact hu
  · intro y
    obtain ⟨⟨t, sm⟩, hsm⟩ := IsLocalizedModule.surj (S.map (algebraMap R' R)) f y
    obtain ⟨s, hsS, hs⟩ := sm.2
    refine ⟨⟨t, ⟨s, hsS⟩⟩, ?_⟩
    change (s : R') • y = (f.restrictScalars R') t
    rw [LinearMap.restrictScalars_apply, ← IsScalarTower.algebraMap_smul R (s : R') y, hs]
    exact hsm
  · intro x₁ x₂ h
    rw [LinearMap.restrictScalars_apply, LinearMap.restrictScalars_apply] at h
    obtain ⟨c, hc⟩ := IsLocalizedModule.exists_of_eq (S := S.map (algebraMap R' R)) (f := f) h
    obtain ⟨s, hsS, hs⟩ := c.2
    refine ⟨⟨s, hsS⟩, ?_⟩
    change (s : R') • x₁ = (s : R') • x₂
    rw [← IsScalarTower.algebraMap_smul R (s : R') x₁,
        ← IsScalarTower.algebraMap_smul R (s : R') x₂, hs]
    exact hc

set_option synthInstance.maxHeartbeats 1000000 in
-- Localisation-of-modules instance search over the doubly-indexed polynomial rings
-- `MvPolynomial (Fin (m+1)) (Localization.Away g)` is unusually deep in this assembly.
set_option maxHeartbeats 4000000 in
-- Elaboration of the verified `Module.Finite Qf Tg'` localisation chain plus the `A_g`-linearity
-- transport for the final reindex is heavy.
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
      (_ : IsScalarTower (Localization.Away g)
              (MvPolynomial (Fin m') (Localization.Away g))
              (LocalizedModule (Submonoid.powers g) T)),
      Module.Finite (MvPolynomial (Fin m') (Localization.Away g))
        (LocalizedModule (Submonoid.powers g) T) := by
  -- Reshape `d = m + 1` (uses `hd : 0 < d`); the distinguished eliminated variable is `X₀`.
  obtain ⟨m, rfl⟩ := Nat.exists_eq_succ_of_ne_zero hd.ne'
  -- L5b.1 (`gf_torsion_annihilator`): a non-zero annihilator `F` of the torsion module `T`.
  obtain ⟨F, hF0, hFann⟩ := gf_torsion_annihilator A (m + 1) T htors
  -- L5b.2 (`gf_nagata_monic_lastVar`): a triangular `A`-algebra automorphism `e` and a
  -- non-zero `g ∈ A` making `e F` monic in `X₀` up to a unit after inverting `g`.
  obtain ⟨g, hg0, e, hunit⟩ := gf_nagata_monic_lastVar A m F hF0
  -- L5b.3 (`mvPolynomial_quotient_finite_of_monic_lastVar`): the coefficient subring
  -- `A_g[X₁,…,X_m] = MvPolynomial (Fin m) A_g` has `A_g[X₀,…,X_m]/(map (e F))` module-finite
  -- over it; this is the source of the dimension drop `m' = m < m + 1`.
  have hfin := mvPolynomial_quotient_finite_of_monic_lastVar (Localization.Away g) m
    (MvPolynomial.map (algebraMap A (Localization.Away g)) (e F)) hunit
  classical
  -- ASSEMBLY. Strategy: work with the *`P`-localisation* `Tg' := LocalizedModule (C(powers g)) T`
  -- of `T` (it inherits the full `P_g`-module API, finiteness, and quotient structure for free),
  -- prove `Tg'` module-finite over `R := MvPolynomial (Fin m) A_g`, and finally transport the
  -- module structures + finiteness to the goal's `T_g := LocalizedModule (powers g) T` (the
  -- `A`-localisation) along the canonical `A_g`-linear equivalence `T_g ≃ₗ[A_g] Tg'`.
  -- Notation: `P := MvPolynomial (Fin (m+1)) A`, `P_g := MvPolynomial (Fin (m+1)) A_g`,
  --           `A_g := Localization.Away g`, `MC := Submonoid.map C (powers g) ⊆ P`.
  letI algPPg : Algebra (MvPolynomial (Fin (m + 1)) A)
      (MvPolynomial (Fin (m + 1)) (Localization.Away g)) :=
    (MvPolynomial.algebraMvPolynomial :
      Algebra (MvPolynomial (Fin (m + 1)) A) (MvPolynomial (Fin (m + 1)) (Localization.Away g)))
  set MC : Submonoid (MvPolynomial (Fin (m + 1)) A) :=
    Submonoid.map (MvPolynomial.C) (Submonoid.powers g) with hMC_def
  haveI hPgloc : IsLocalization MC (MvPolynomial (Fin (m + 1)) (Localization.Away g)) :=
    MvPolynomial.isLocalization (Submonoid.powers g) (Localization.Away g)
  -- The `P`-localised torsion module and its canonical `P_g`-module structure.
  letI hmodPg : Module (MvPolynomial (Fin (m + 1)) (Localization.Away g))
      (LocalizedModule MC T) :=
    LocalizedModule.moduleOfIsLocalization
  haveI htowerPg : IsScalarTower (MvPolynomial (Fin (m + 1)) A)
      (MvPolynomial (Fin (m + 1)) (Localization.Away g)) (LocalizedModule MC T) :=
    inferInstance
  -- `Tg'` is module-finite over `P_g` (localisation of the `P`-finite module `T`).
  haveI hfinPg : Module.Finite (MvPolynomial (Fin (m + 1)) (Localization.Away g))
      (LocalizedModule MC T) :=
    Module.Finite.of_isLocalizedModule MC (LocalizedModule.mkLinearMap MC T)
  -- `Fg := algebraMap P Pg F` annihilates `Tg'` (localising `F • T = 0`).
  set Fg : MvPolynomial (Fin (m + 1)) (Localization.Away g) :=
    algebraMap (MvPolynomial (Fin (m + 1)) A) (MvPolynomial (Fin (m + 1)) (Localization.Away g)) F
    with hFg_def
  have hFgann : ∀ y : LocalizedModule MC T, Fg • y = 0 := by
    intro y
    induction y using LocalizedModule.induction_on with
    | _ t s =>
      have hFt : F • t = 0 := Module.mem_annihilator.mp hFann t
      rw [hFg_def, IsScalarTower.algebraMap_smul, LocalizedModule.smul'_mk, hFt,
        LocalizedModule.zero_mk]
  -- `Tg'` is torsion by the ideal `(Fg)`, hence a module over `Qf := Pg ⧸ (Fg)`.
  have htorsion : Module.IsTorsionBySet (MvPolynomial (Fin (m + 1)) (Localization.Away g))
      (LocalizedModule MC T) (↑(Ideal.span {Fg})) := by
    intro x a
    obtain ⟨b, hb⟩ := Ideal.mem_span_singleton.mp a.2
    rw [hb, mul_smul, hFgann]
  letI hmodQf :
      Module ((MvPolynomial (Fin (m + 1)) (Localization.Away g)) ⧸ Ideal.span {Fg})
        (LocalizedModule MC T) :=
    htorsion.module
  -- `Tg'` is module-finite over `Qf` (the `Pg`-action factors through the quotient).
  haveI hfinQf :
      Module.Finite ((MvPolynomial (Fin (m + 1)) (Localization.Away g)) ⧸ Ideal.span {Fg})
        (LocalizedModule MC T) := by
    refine Module.Finite.of_surjective
      (f := { toFun := id, map_add' := fun _ _ => rfl,
              map_smul' := fun r x => (htorsion.mk_smul r x).symm }) Function.surjective_id
  -- Assembly via standalone helpers (avoiding `isDefEq` blow-ups from stacked instances on
  -- `LocalizedModule MC T`).  Notation:  `Pg := MvPolynomial (Fin (m+1)) A_g`,
  -- `R := MvPolynomial (Fin m) A_g`, `G := map (algebraMap A A_g) (e F)`.
  set G : MvPolynomial (Fin (m + 1)) (Localization.Away g) :=
    MvPolynomial.map (algebraMap A (Localization.Away g)) (e F) with hG_def
  -- (a) Base-change `e` to a ring automorphism `ebar : Pg ≃+* Pg` (localising `e` at `MC`,
  -- which `e` preserves since it fixes the constants `C z`), with `ebar Fg = G`.
  have he_C : ∀ z : A, e (MvPolynomial.C z) = MvPolynomial.C z := by
    intro z; rw [← MvPolynomial.algebraMap_eq]; exact e.commutes z
  have hmap : Submonoid.map e.toRingEquiv.toMonoidHom MC = MC := by
    rw [hMC_def]; ext x; simp only [Submonoid.mem_map]
    constructor
    · rintro ⟨y, ⟨z, hz, rfl⟩, rfl⟩
      exact ⟨z, hz, (he_C z).symm⟩
    · rintro ⟨z, hz, rfl⟩
      exact ⟨MvPolynomial.C z, ⟨z, hz, rfl⟩, he_C z⟩
  letI ebar : MvPolynomial (Fin (m + 1)) (Localization.Away g)
      ≃+* MvPolynomial (Fin (m + 1)) (Localization.Away g) :=
    IsLocalization.ringEquivOfRingEquiv
      (MvPolynomial (Fin (m + 1)) (Localization.Away g))
      (MvPolynomial (Fin (m + 1)) (Localization.Away g)) e.toRingEquiv hmap
  have hebarFg : ebar Fg = G := by
    rw [hFg_def, IsLocalization.ringEquivOfRingEquiv_apply, IsLocalization.map_eq, hG_def]
    rfl
  -- (b) The induced quotient ring iso `ψ : Pg/(Fg) ≃+* Pg/(G)`.
  have hspan : Ideal.span {G}
      = Ideal.map (ebar : MvPolynomial (Fin (m + 1)) (Localization.Away g) →+*
          MvPolynomial (Fin (m + 1)) (Localization.Away g)) (Ideal.span {Fg}) := by
    rw [Ideal.map_span, Set.image_singleton]
    simp only [RingEquiv.coe_toRingHom, hebarFg]
  letI ψ : (MvPolynomial (Fin (m + 1)) (Localization.Away g) ⧸ Ideal.span {Fg})
      ≃+* (MvPolynomial (Fin (m + 1)) (Localization.Away g) ⧸ Ideal.span {G}) :=
    Ideal.quotientEquiv (Ideal.span {Fg}) (Ideal.span {G}) ebar hspan
  -- (c)/(d) Reindexed-base structures and finiteness over `R := MvPolynomial (Fin m) A_g`.
  set ρ : MvPolynomial (Fin m) (Localization.Away g) →+*
      (MvPolynomial (Fin (m + 1)) (Localization.Away g) ⧸ Ideal.span {G}) :=
    (Ideal.Quotient.mk (Ideal.span {G})).comp (MvPolynomial.rename Fin.succ).toRingHom with hρ_def
  letI algRB2 : Algebra (MvPolynomial (Fin m) (Localization.Away g))
      (MvPolynomial (Fin (m + 1)) (Localization.Away g) ⧸ Ideal.span {G}) := ρ.toAlgebra
  haveI hfinRB2 : Module.Finite (MvPolynomial (Fin m) (Localization.Away g))
      (MvPolynomial (Fin (m + 1)) (Localization.Away g) ⧸ Ideal.span {G}) := hfin
  letI θ : MvPolynomial (Fin m) (Localization.Away g) →+*
      (MvPolynomial (Fin (m + 1)) (Localization.Away g) ⧸ Ideal.span {Fg}) :=
    ψ.symm.toRingHom.comp ρ
  letI algRB1 : Algebra (MvPolynomial (Fin m) (Localization.Away g))
      (MvPolynomial (Fin (m + 1)) (Localization.Away g) ⧸ Ideal.span {Fg}) := θ.toAlgebra
  letI hmodRM : Module (MvPolynomial (Fin m) (Localization.Away g)) (LocalizedModule MC T) :=
    Module.compHom (LocalizedModule MC T) θ
  haveI towerRB1M : IsScalarTower (MvPolynomial (Fin m) (Localization.Away g))
      (MvPolynomial (Fin (m + 1)) (Localization.Away g) ⧸ Ideal.span {Fg})
      (LocalizedModule MC T) :=
    IsScalarTower.of_algebraMap_smul fun _ _ => rfl
  have hψcompat : ∀ r : MvPolynomial (Fin m) (Localization.Away g),
      ψ (algebraMap (MvPolynomial (Fin m) (Localization.Away g))
          (MvPolynomial (Fin (m + 1)) (Localization.Away g) ⧸ Ideal.span {Fg}) r)
      = algebraMap (MvPolynomial (Fin m) (Localization.Away g))
          (MvPolynomial (Fin (m + 1)) (Localization.Away g) ⧸ Ideal.span {G}) r := by
    intro r
    change ψ (ψ.symm (ρ r)) = ρ r
    rw [ψ.apply_symm_apply]
  haveI hfinRTg' : Module.Finite (MvPolynomial (Fin m) (Localization.Away g))
      (LocalizedModule MC T) :=
    finite_of_quotientRingEquiv ψ hψcompat hfinRB2 hfinQf
  -- (e) Transport `R`-finiteness from the `P`-localisation `LocalizedModule MC T` to the
  -- goal's `A`-localisation `LocalizedModule (powers g) T`, which it agrees with as a
  -- localisation of `T` at `g`; restrict the `R`-action to `A_g` for the remaining witnesses.
  haveI towerAMC : IsScalarTower A (MvPolynomial (Fin (m + 1)) A) (LocalizedModule MC T) :=
    inferInstance
  have hsub : (Submonoid.powers g).map (algebraMap A (MvPolynomial (Fin (m + 1)) A)) = MC := by
    rw [hMC_def, MvPolynomial.algebraMap_eq]
  haveI hMCloc : IsLocalizedModule
      ((Submonoid.powers g).map (algebraMap A (MvPolynomial (Fin (m + 1)) A)))
      (LocalizedModule.mkLinearMap MC T) :=
    hsub ▸ (localizedModuleIsLocalizedModule (M := T) MC)
  haveI hdesc : IsLocalizedModule (Submonoid.powers g)
      ((LocalizedModule.mkLinearMap MC T).restrictScalars A) :=
    isLocalizedModule_restrictScalars (Submonoid.powers g) (LocalizedModule.mkLinearMap MC T)
  -- Equip the source `LocalizedModule MC T` with the `A_g`-action restricting its `R`-action.
  letI hmodAgMC : Module (Localization.Away g) (LocalizedModule MC T) :=
    Module.compHom _
      (algebraMap (Localization.Away g) (MvPolynomial (Fin m) (Localization.Away g)))
  haveI towerAgRMC : IsScalarTower (Localization.Away g)
      (MvPolynomial (Fin m) (Localization.Away g)) (LocalizedModule MC T) :=
    IsScalarTower.of_algebraMap_smul fun _ _ => rfl
  -- `C (algebraMap A A_g a')` is the image of the `P`-constant `C a'` under `algebraMap P Pg`.
  have hCeq : ∀ a' : A,
      (MvPolynomial.C (algebraMap A (Localization.Away g) a') :
        MvPolynomial (Fin (m + 1)) (Localization.Away g))
      = algebraMap (MvPolynomial (Fin (m + 1)) A)
          (MvPolynomial (Fin (m + 1)) (Localization.Away g)) (MvPolynomial.C a') := by
    intro a'
    rw [show (algebraMap (MvPolynomial (Fin (m + 1)) A)
          (MvPolynomial (Fin (m + 1)) (Localization.Away g)) (MvPolynomial.C a'))
        = MvPolynomial.map (algebraMap A (Localization.Away g)) (MvPolynomial.C a') from rfl,
      MvPolynomial.map_C]
  -- `θ` fixes `A`-constants: `θ (C (algebraMap A A_g a')) = mk (C …)`, because that constant comes
  -- from `P` (via `algebraMap P Pg`) and the Nagata equivalence `ebar` fixes constants from `P`.
  have hθCA : ∀ a' : A,
      θ (MvPolynomial.C (algebraMap A (Localization.Away g) a'))
      = Ideal.Quotient.mk (Ideal.span {Fg})
          (MvPolynomial.C (algebraMap A (Localization.Away g) a')) := by
    intro a'
    have hebarfix : ebar (MvPolynomial.C (algebraMap A (Localization.Away g) a'))
        = MvPolynomial.C (algebraMap A (Localization.Away g) a') := by
      rw [hCeq, IsLocalization.ringEquivOfRingEquiv_apply, IsLocalization.map_eq]
      congr 1
      exact he_C a'
    change ψ.symm (ρ (MvPolynomial.C (algebraMap A (Localization.Away g) a'))) = _
    have hρC : ρ (MvPolynomial.C (algebraMap A (Localization.Away g) a'))
        = Ideal.Quotient.mk (Ideal.span {G})
            (MvPolynomial.C (algebraMap A (Localization.Away g) a')) := by
      rw [hρ_def]; simp
    rw [hρC, Ideal.quotientEquiv_symm_mk]
    congr 1
    exact (RingEquiv.symm_apply_eq ebar).mpr hebarfix.symm
  -- Hence the `A`-action through the `A_g`-action factors as the original `A`-action, giving
  -- the scalar tower needed to upgrade the localisation isomorphism to `A_g`-linear.
  haveI towerAAgMC : IsScalarTower A (Localization.Away g) (LocalizedModule MC T) := by
    refine IsScalarTower.of_algebraMap_smul fun a' z => ?_
    change θ (MvPolynomial.C (algebraMap A (Localization.Away g) a')) • z = a' • z
    rw [hθCA a', htorsion.mk_smul, hCeq, IsScalarTower.algebraMap_smul,
      show (MvPolynomial.C a' : MvPolynomial (Fin (m + 1)) A)
        = algebraMap A (MvPolynomial (Fin (m + 1)) A) a' from by rw [MvPolynomial.algebraMap_eq],
      IsScalarTower.algebraMap_smul]
  -- The `A`-linear localisation isomorphism is in fact `A_g`-linear.
  letI eAgL : LocalizedModule (Submonoid.powers g) T
      ≃ₗ[Localization.Away g] LocalizedModule MC T :=
    LinearEquiv.extendScalarsOfIsLocalization (Submonoid.powers g) (Localization.Away g)
      (IsLocalizedModule.linearEquiv (Submonoid.powers g)
        (LocalizedModule.mkLinearMap (Submonoid.powers g) T)
        ((LocalizedModule.mkLinearMap MC T).restrictScalars A))
  letI eAdd : LocalizedModule MC T ≃+ LocalizedModule (Submonoid.powers g) T :=
    eAgL.symm.toAddEquiv
  letI hmodRTg : Module (MvPolynomial (Fin m) (Localization.Away g))
      (LocalizedModule (Submonoid.powers g) T) :=
    pullbackModuleAddEquiv (R := MvPolynomial (Fin m) (Localization.Away g)) eAdd
  -- The pulled-back `R`-action restricted to `A_g` agrees with the canonical `A_g`-action on
  -- `T_g`, because `eAgL` is `A_g`-linear; this gives the required scalar tower.
  haveI htower : IsScalarTower (Localization.Away g)
      (MvPolynomial (Fin m) (Localization.Away g)) (LocalizedModule (Submonoid.powers g) T) := by
    refine IsScalarTower.of_algebraMap_smul fun a x => ?_
    change eAgL.symm (a • eAgL x) = a • x
    rw [eAgL.symm.map_smul, eAgL.symm_apply_apply]
  exact ⟨g, hg0, m, Nat.lt_succ_self m, hmodRTg, htower,
    finite_of_pullbackModuleAddEquiv eAdd⟩

set_option synthInstance.maxHeartbeats 1000000 in
-- The doubly-localised carrier `LocalizedModule (powers h) (LocalizedModule (powers g) T)`
-- makes instance search for the transported `Localization.Away (g*a)`-action explore many
-- `OreLocalization`/`LocalizedModule` paths; raise the synthesis budget accordingly.
/-- **Descent of generic freeness across a tower of `Away` localisations.** If after
inverting `g ∈ A` and then `h ∈ A_g = Localization.Away g` the `A`-module `T` becomes
free, then it becomes free after inverting a single non-zero `f ∈ A`.

This is the "descend the witness from `A_g` to `A`" step (step 4) of the polynomial-ring
core `exists_free_localizationAway_polynomial`: the inductive hypothesis is applied at the
new base `A_g` and produces freeness of the *iterated* localisation
`(T_g)_h := LocalizedModule (powers h) (LocalizedModule (powers g) T)` over `(A_g)_h`. Here
`h = a / gᵏ`, so `(A_g)_h ≅ A_{g·a}` (`IsLocalization.Away.mul_of_associated`) and the
iterated localisation is the single localisation of `T` at `powers (g·a)`; transporting
freeness across the ring iso (`Module.Free.of_ringEquiv`) and the localised-module
identification gives `T_f` free over `A_f` with `f := g·a`. -/
theorem free_localizationAway_of_away_tower
    (A T : Type u) [CommRing A] [IsDomain A] [AddCommGroup T] [Module A T]
    {g : A} (hg : g ≠ 0) {h : Localization.Away g} (hh : h ≠ 0)
    (hfree : Module.Free (Localization.Away h)
      (LocalizedModule (Submonoid.powers h) (LocalizedModule (Submonoid.powers g) T))) :
    ∃ f : A, f ≠ 0 ∧
      Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) T) := by
  classical
  -- Witness `f := g · a`, where `a ∈ A` is a numerator of `h` over `A_g`.
  -- === Ring side: clear the denominator of `h` ===
  obtain ⟨⟨a, s⟩, hs⟩ := IsLocalization.surj (Submonoid.powers g) h
  -- `hs : h * algebraMap A A_g ↑s = algebraMap A A_g a`, with `s ∈ powers g` a unit denominator.
  have hsunit : IsUnit (algebraMap A (Localization.Away g) (s : A)) :=
    IsLocalization.map_units (Localization.Away g) s
  -- `algebraMap ↑s` is the unit `u`; record `algebraMap ↑s * u⁻¹ = 1`.
  have hsu : algebraMap A (Localization.Away g) (s : A) * ↑(hsunit.unit⁻¹) = 1 := by
    have h1 := hsunit.unit.mul_inv
    rwa [hsunit.unit_spec] at h1
  -- `a ≠ 0`: else `h * algebraMap ↑s = 0`, and `algebraMap ↑s` is a unit, forcing `h = 0`.
  have ha : a ≠ 0 := by
    rintro rfl
    rw [map_zero] at hs
    apply hh
    calc h = h * (algebraMap A (Localization.Away g) (s : A) * ↑(hsunit.unit⁻¹)) := by
            rw [hsu, mul_one]
      _ = h * algebraMap A (Localization.Away g) (s : A) * ↑(hsunit.unit⁻¹) := by rw [mul_assoc]
      _ = 0 := by rw [hs, zero_mul]
  have hf0 : g * a ≠ 0 := mul_ne_zero hg ha
  -- `algebraMap a` and `h` are associated (differ by the unit `algebraMap ↑s`).
  have hassoc : Associated (algebraMap A (Localization.Away g) a) h := by
    refine ⟨hsunit.unit⁻¹, ?_⟩
    rw [← hs, mul_assoc, hsu, mul_one]
  -- The canonical tower `A → A_g → A_h` already holds; `A_h` is then the localisation of `A`
  -- away from `g · a` (`mul_of_associated`).
  haveI hlocAh : IsLocalization.Away (g * a) (Localization.Away h) :=
    (IsLocalization.Away.mul_of_associated g a h hassoc :
      IsLocalization.Away (g * a) (Localization.Away h))
  -- === Module side: the composite localisation map and its `IsLocalizedModule` structure ===
  -- `ψ : T →ₗ[A] D` factoring `T → T_g → D` (restrict the second map to `A`).
  let ψ : T →ₗ[A]
      LocalizedModule (Submonoid.powers h) (LocalizedModule (Submonoid.powers g) T) :=
    (LocalizedModule.mkLinearMap (Submonoid.powers h)
        (LocalizedModule (Submonoid.powers g) T)).restrictScalars A ∘ₗ
      LocalizedModule.mkLinearMap (Submonoid.powers g) T
  -- The `A`-action on `D` factors through `A_h`.
  haveI towerAAhD : IsScalarTower A (Localization.Away h)
      (LocalizedModule (Submonoid.powers h) (LocalizedModule (Submonoid.powers g) T)) := by
    refine IsScalarTower.of_algebraMap_smul fun a' x => ?_
    rw [IsScalarTower.algebraMap_apply A (Localization.Away g) (Localization.Away h) a',
      IsScalarTower.algebraMap_smul (Localization.Away h),
      IsScalarTower.algebraMap_smul (Localization.Away g)]
  -- Localisation-of-localisation as a base change: `D` is the base change of `T` to `A_h`.
  have hbcψ : IsBaseChange (Localization.Away h) ψ :=
    (IsLocalizedModule.isBaseChange (Submonoid.powers g) (Localization.Away g)
        (LocalizedModule.mkLinearMap (Submonoid.powers g) T)).comp
      (IsLocalizedModule.isBaseChange (Submonoid.powers h) (Localization.Away h)
        (LocalizedModule.mkLinearMap (Submonoid.powers h)
          (LocalizedModule (Submonoid.powers g) T)))
  haveI hLMψ : IsLocalizedModule (Submonoid.powers (g * a)) ψ :=
    (isLocalizedModule_iff_isBaseChange (Submonoid.powers (g * a)) (Localization.Away h) ψ).mpr hbcψ
  -- === Transport freeness from `A_h` down to `A_{g·a}` ===
  refine ⟨g * a, hf0, ?_⟩
  -- `A_{g·a} ≃ₐ[A] A_h` (two localisations of `A` away from `g · a`).
  let σ : Localization.Away (g * a) ≃ₐ[A] Localization.Away h :=
    IsLocalization.algEquiv (Submonoid.powers (g * a)) (Localization.Away (g * a))
      (Localization.Away h)
  -- The `A`-linear uniqueness iso between the two localisations of `T` at `powers (g·a)`.
  let ε : LocalizedModule (Submonoid.powers (g * a)) T ≃ₗ[A]
      LocalizedModule (Submonoid.powers h) (LocalizedModule (Submonoid.powers g) T) :=
    IsLocalizedModule.linearEquiv (Submonoid.powers (g * a))
      (LocalizedModule.mkLinearMap (Submonoid.powers (g * a)) T) ψ
  -- Equip `D` with the `A_{g·a}`-action transported through `σ` (acting via `σ`).
  letI modLga : Module (Localization.Away (g * a))
      (LocalizedModule (Submonoid.powers h) (LocalizedModule (Submonoid.powers g) T)) :=
    Module.compHom
      (LocalizedModule (Submonoid.powers h) (LocalizedModule (Submonoid.powers g) T))
      (σ.toAlgHom.toRingHom : Localization.Away (g * a) →+* Localization.Away h)
  -- The `A`-action through this new `A_{g·a}`-action is the original one.
  haveI towerLga : IsScalarTower A (Localization.Away (g * a))
      (LocalizedModule (Submonoid.powers h) (LocalizedModule (Submonoid.powers g) T)) := by
    refine IsScalarTower.of_algebraMap_smul fun a' x => ?_
    change σ (algebraMap A (Localization.Away (g * a)) a') • x = a' • x
    rw [AlgEquiv.commutes]
    exact IsScalarTower.algebraMap_smul (Localization.Away h) a' x
  -- `D` is free over `A_{g·a}`: transport a basis of `D` over `A_h` through the ring iso `σ.symm`.
  haveI : Module.Free (Localization.Away h)
      (LocalizedModule (Submonoid.powers h) (LocalizedModule (Submonoid.powers g) T)) := hfree
  have hcompat : ∀ (c : Localization.Away h)
      (x : LocalizedModule (Submonoid.powers h) (LocalizedModule (Submonoid.powers g) T)),
      (σ.symm.toRingEquiv c) • x = c • x := fun c x => by
    change σ (σ.symm c) • x = c • x
    rw [AlgEquiv.apply_symm_apply]
  have hDfree : Module.Free (Localization.Away (g * a))
      (LocalizedModule (Submonoid.powers h) (LocalizedModule (Submonoid.powers g) T)) :=
    Module.Free.of_basis
      ((Module.Free.chooseBasis (Localization.Away h)
        (LocalizedModule (Submonoid.powers h)
          (LocalizedModule (Submonoid.powers g) T))).mapCoeffs σ.symm.toRingEquiv hcompat)
  -- The `A`-linear `ε` upgrades to `A_{g·a}`-linear; conclude freeness of `T_{g·a}`.
  have εL : LocalizedModule (Submonoid.powers (g * a)) T ≃ₗ[Localization.Away (g * a)]
      LocalizedModule (Submonoid.powers h) (LocalizedModule (Submonoid.powers g) T) :=
    LinearEquiv.extendScalarsOfIsLocalization (Submonoid.powers (g * a))
      (Localization.Away (g * a)) ε
  exact Module.Free.of_equiv' hDfree εL.symm

set_option synthInstance.maxHeartbeats 1000000 in
-- The reindexed localised quotient `(N ⧸ range φ)_g` carries stacked
-- `OreLocalization`/`MvPolynomial` module structures whose instance search is expensive;
-- raise the synthesis budget for the inductive-step wiring.
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
        -- The generic-rank SES `0 → (Fin m → P) → N → T → 0` (`gf_generic_rank_ses`),
        -- with `T := N ⧸ range φ` torsion over `P := A[X_1,…,X_d]`.
        obtain ⟨m, φ, hφinj, hTtors⟩ := gf_generic_rank_ses A d N
        -- Step 1: the torsion cokernel `N ⧸ range φ` is a finite `P`-module (its restricted
        -- `A`-module structure + scalar tower `A → P → quotient` are found by instances).
        haveI hTfin : Module.Finite (MvPolynomial (Fin d) A) (N ⧸ LinearMap.range φ) :=
          Module.Finite.of_surjective (LinearMap.range φ).mkQ (LinearMap.range φ).mkQ_surjective
        -- Step 2: reindex the torsion cokernel onto `m' < d` variables over `A_g`.
        -- `gf_torsion_reindex` now emits its `MvPolynomial (Fin m') A_g`-action (`hmod1`) and the
        -- scalar tower (`htower`) over the *canonical* (`inferInstance`) `Module A_g`-action on the
        -- localised module — the redundant `Module A_g T_g` existential was dropped, so the
        -- `A_g`-action the IH and `free_localizationAway_of_away_tower` synthesise is exactly the
        -- one `htower` refers to.  This dissolves the former `OreLocalization`
        -- instance-presentation diamond: there is now a single `Module A_g T_g` instance in play.
        obtain ⟨g, hg0, m', hm'lt, hmod1, htower, hfin⟩ :=
          gf_torsion_reindex A d hd (N ⧸ LinearMap.range φ) hTtors
        -- Step 3: the inductive hypothesis at the new noetherian-domain base `A_g`.
        haveI hdomg : IsDomain (Localization.Away g) :=
          IsLocalization.isDomain_localization
            (Submonoid.powers_le.mpr (mem_nonZeroDivisors_of_ne_zero hg0))
        haveI hnoethg : IsNoetherianRing (Localization.Away g) := inferInstance
        -- Register the reindex's `MvPolynomial (Fin m') A_g`-module structure, its finiteness, and
        -- its scalar tower in the local instance cache so the IH application infers them.
        letI := hmod1
        haveI := hfin
        haveI := htower
        -- Steps 3–4: the IH at base `A_g` produces `hh ≠ 0` in `A_g` with the doubly-localised
        -- `(T_g)_hh` free over `(A_g)_hh`; the tower-descent helper
        -- `free_localizationAway_of_away_tower` descends that witness to a single `f := g·a ∈ A`.
        obtain ⟨f, hf0, hTf_free⟩ :
            ∃ f : A, f ≠ 0 ∧ Module.Free (Localization.Away f)
              (LocalizedModule (Submonoid.powers f) (N ⧸ LinearMap.range φ)) := by
          obtain ⟨hh, hh0, hfree_Tgh⟩ :=
            IH m' hm'lt (Localization.Away g)
              (LocalizedModule (Submonoid.powers g) (N ⧸ LinearMap.range φ))
          exact free_localizationAway_of_away_tower A (N ⧸ LinearMap.range φ) hg0 hh0 hfree_Tgh
        -- Step 5: splice the localised SES.  The free left end `Fin m → P` (a finite power
        -- of the `A`-free polynomial ring `P`) localises to a free `A_f`-module by base
        -- change, and `exists_free_localizationAway_of_shortExact` (L3) splices.
        haveI hM'free_base : Module.Free A (Fin m → MvPolynomial (Fin d) A) := inferInstance
        have hM'_free : Module.Free (Localization.Away f)
            (LocalizedModule (Submonoid.powers f) (Fin m → MvPolynomial (Fin d) A)) :=
          (IsLocalizedModule.isBaseChange (Submonoid.powers f) (Localization.Away f)
            (LocalizedModule.mkLinearMap (Submonoid.powers f)
              (Fin m → MvPolynomial (Fin d) A))).free
        exact exists_free_localizationAway_of_shortExact A (MvPolynomial (Fin d) A)
          (Fin m → MvPolynomial (Fin d) A) N (N ⧸ LinearMap.range φ) φ
          (LinearMap.range φ).mkQ hφinj (LinearMap.range φ).mkQ_surjective
          (by rw [LinearMap.exact_iff, Submodule.ker_mkQ]) hf0 hf0 hM'_free hTf_free

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
    -- module-finite over `A`. Dévissage over the noetherian ring `B`
    -- (`IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime`) with motive
    -- `P N := ∃ f ≠ 0, Free A_f (N_f)`, each `B`-module `N` carrying its restricted
    -- `A`-action through `algebraMap A B`. The subsingleton obligation discharges
    -- from the torsion base case (L1); the short-exact obligation from the L3
    -- splice; the `N ≅ B/𝔭` obligation is the genuine residual (it needs L4
    -- finiteness + L5, the polynomial-ring core still under construction).
    have key : letI : Module A M := Module.compHom M (algebraMap A B)
        ∃ f : A, f ≠ 0 ∧
          Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) M) := by
      refine IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime B
        (inferInstance : Module.Finite B M)
        (motive := fun N _ _ _ => letI : Module A N := Module.compHom N (algebraMap A B)
          ∃ f : A, f ≠ 0 ∧
            Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) N))
        ?_ ?_ ?_
      · -- subsingleton `N` ⟹ torsion base case (L1).
        intro N _ _ _ _
        letI : Module A N := Module.compHom N (algebraMap A B)
        haveI : IsScalarTower A B N := IsScalarTower.of_algebraMap_smul fun _ _ => rfl
        refine GenericFreeness.exists_free_localizationAway_of_torsion A B N ?_
        exact LocalizedModule.subsingleton_iff.mpr fun m =>
          ⟨1, Submonoid.one_mem _, by rw [Subsingleton.elim m 0, smul_zero]⟩
      · -- `N ≅ B/𝔭` (domain quotient, finite-type over `A`): the genuine residual.
        -- Closes via `exists_localizationAway_finite_mvPolynomial` (L4) +
        -- `exists_free_localizationAway_polynomial` (L5); both still under
        -- construction (L4 finiteness leaf open), so this node stays `sorry`.
        intro N _ _ _ p a
        letI : Module A N := Module.compHom N (algebraMap A B)
        haveI : IsScalarTower A B N := IsScalarTower.of_algebraMap_smul fun _ _ => rfl
        sorry
      · -- short-exact closure ⟹ the L3 splice.
        intro N₁ _ _ _ N₂ _ _ _ N₃ _ _ _ i q hi hq hex hN₁ hN₃
        letI : Module A N₁ := Module.compHom N₁ (algebraMap A B)
        letI : Module A N₂ := Module.compHom N₂ (algebraMap A B)
        letI : Module A N₃ := Module.compHom N₃ (algebraMap A B)
        haveI : IsScalarTower A B N₁ := IsScalarTower.of_algebraMap_smul fun _ _ => rfl
        haveI : IsScalarTower A B N₂ := IsScalarTower.of_algebraMap_smul fun _ _ => rfl
        haveI : IsScalarTower A B N₃ := IsScalarTower.of_algebraMap_smul fun _ _ => rfl
        obtain ⟨f', hf', hF'⟩ := hN₁
        obtain ⟨f'', hf'', hF''⟩ := hN₃
        exact GenericFreeness.exists_free_localizationAway_of_shortExact A B N₁ N₂ N₃
          i q hi hq hex hf' hf'' hF' hF''
    -- Transport the dévissage conclusion (restricted `A`-action via `algebraMap A B`)
    -- to the ambient `A`-module structure on `M`; they agree by the scalar tower.
    have hAinst : (Module.compHom M (algebraMap A B) : Module A M) = ‹Module A M› := by
      refine Module.ext_iff.mpr ?_
      funext a m
      show algebraMap A B a • m = a • m
      rw [Algebra.algebraMap_eq_smul_one, smul_assoc, one_smul]
    rw [hAinst] at key
    exact key

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
