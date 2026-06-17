# Lean ↔ Blueprint Check Report

## Slug
gf

## Iteration
005

## Files audited
- Lean: `AlgebraicJacobian/Picard/FlatteningStratification.lean`
- Blueprint: `blueprint/src/chapters/Picard_FlatteningStratification.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.genericFlatnessAlgebraic}` (thm:generic_flatness_algebraic)
- **Lean target exists**: yes (line 532)
- **Signature matches**: yes — exact match with the `% INTENDED LEAN SIGNATURE` block in the blueprint (types/classes/conclusion identical)
- **Proof follows sketch**: partial (primary finite-A-module route matches; surviving residue is `sorry` at line 562 — known authorized gap)
- **notes**: `\leanok` present in both statement and proof blocks in the blueprint; the sorry is correctly described as the "finite-type B-algebra" residue awaiting L3/L4/L5 assembly.

---

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_finite}` (lem:gf_finite_module)
- **Lean target exists**: yes (line 105)
- **Signature matches**: yes — `(A M : Type*) [CommRing A] [IsDomain A] [IsNoetherianRing A] [AddCommGroup M] [Module A M] [Module.Finite A M] : ∃ f : A, f ≠ 0 ∧ Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) M)` matches the blueprint prose exactly.
- **Proof follows sketch**: yes — uses `Module.FinitePresentation.exists_free_localizedModule_powers` at the generic point, as described.
- **notes**: sorry-free; axiom-clean.

---

### `\lean{Module.FinitePresentation.exists_free_localizedModule_powers}` (lem:fp_free_descent)
- **Lean target exists**: N/A (Mathlib, `\mathlibok`)
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Mathlib lemma, not in this file.

---

### `\lean{AlgebraicGeometry.GenericFreeness.exists_flat_localizationAway_of_finite}` (lem:gf_flat_finite)
- **Lean target exists**: yes (line 120)
- **Signature matches**: yes — conclusion is `Module.Flat` (not `Module.Free`), matching the blueprint prose.
- **Proof follows sketch**: yes — deduces flatness from `exists_free_localizationAway_of_finite` via `Module.Flat.of_free`, as described.
- **notes**: sorry-free; axiom-clean.

---

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_moduleFinite}` (lem:gf_free_moduleFinite)
- **Lean target exists**: yes (line 135)
- **Signature matches**: yes — `[Module.Finite A B]` (not just `[Algebra A B]`) plus `[Module.Finite B M]` with scalar tower, matching the blueprint's description of B as a module-finite A-algebra.
- **Proof follows sketch**: yes — uses `Module.Finite.trans B M` to derive A-finiteness, then calls `exists_free_localizationAway_of_finite`, exactly as described.
- **notes**: sorry-free; axiom-clean.

---

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_torsion}` (lem:gf_torsion_base)
- **Lean target exists**: yes (line 168)
- **Signature matches**: yes — hypothesis `Subsingleton (LocalizedModule (nonZeroDivisors A) M)` encodes `M_K = 0` as described; conclusion is the expected free-localization form.
- **Proof follows sketch**: yes — chooses a finite B-generating set, takes the product of annihilators, shows `f • M = 0`, concludes `M_f` is subsingleton hence free.
- **notes**: sorry-free; axiom-clean. Note `IsNoetherianRing A` is not required for L1 (not listed in the Lean signature), which is correct — torsion argument only needs `IsDomain A`.

---

### `\lean{IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime}` (lem:noeth_prime_filtration)
- **Lean target exists**: N/A (Mathlib, `\mathlibok`)
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Mathlib lemma, not in this file.

---

### `\lean{AlgebraicGeometry.GenericFreeness.exact_localizedModule_powers_of_shortExact}` (lem:gf_splice_shortExact_localized_exact)
- **Lean target exists**: yes (line 220)
- **Signature matches**: yes — takes B-linear maps `i : M' →ₗ[B] M`, `q : M →ₗ[B] M''`, injectivity/surjectivity/exactness hypotheses, an element `f : A`; returns the three localisation exactness facts. Matches the blueprint's description.
- **Proof follows sketch**: yes — uses `LocalizedModule.map_injective`, `map_surjective`, `map_exact` after scalar-restricting to A.
- **notes**: sorry-free; axiom-clean. Closed this iteration.

---

### `\lean{AlgebraicGeometry.GenericFreeness.free_localizationAway_of_free_of_eq_mul}` (lem:gf_splice_shortExact_free_transport)
- **Lean target exists**: yes (line 248)
- **Signature matches**: yes — hypotheses `hf : f = f' * f''` and `hN' : Module.Free (Localization.Away f') (LocalizedModule (Submonoid.powers f') N)`; conclusion `Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) N)`. Matches the blueprint statement.
- **Proof follows sketch**: yes — constructs the ring map `A_{f'} → A_{f'f''}` via `IsLocalization.Away.awayToAwayLeft`, then uses `IsBaseChange.free`.
- **notes**: sorry-free; axiom-clean. Closed this iteration (L3b).

---

### `\lean{AlgebraicGeometry.GenericFreeness.free_of_shortExact_of_free_free}` (lem:gf_splice_shortExact_split)
- **Lean target exists**: yes (line 336)
- **Signature matches**: yes — `(R P Q T : Type*) [CommRing R]` with free ends P and T, injective iota, surjective pi, exact; concludes `Module.Free R Q`. Matches the blueprint description.
- **Proof follows sketch**: yes — uses `Module.projective_lifting_property` to section pi, then `hexact.splitSurjectiveEquiv` to get the splitting iso, then `Module.Free.of_equiv`.
- **notes**: sorry-free; axiom-clean. Closed this iteration (L3c).

---

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_shortExact}` (lem:gf_splice_shortExact)
- **Lean target exists**: yes (line 360)
- **Signature matches**: yes — matches the blueprint's assembly lemma: explicit `{f' f'' : A} (hf' : f' ≠ 0) (hf'' : f'' ≠ 0)` freeness hypotheses for the two ends, concludes existence of `f` with `M_f` free.
- **Proof follows sketch**: yes — applies L3b to both ends, L3a for exactness of the localised sequence, L3c for the splitting. The conclusion witness is `f' * f''`.
- **notes**: sorry-free; axiom-clean. Closed this iteration (L3 assembly).

---

### `\lean{AlgebraicGeometry.GenericFreeness.exists_localizationAway_finite_mvPolynomial}` (lem:gf_noether_clear_denominators) — **KEY FINDING**
- **Lean target exists**: yes (line 415)
- **Signature matches**: **partial** — see detail below
- **Proof follows sketch**: partial (Step 1 Noether normalisation over K is closed; Step 2 denominator clearing is `sorry` at line 445 — known authorized gap)
- **notes**: The mathematical prose statement in the blueprint is correct. The `% LEAN SIGNATURE` specification comment in the blueprint is **stale and wrong** (see "Red flags / Signature comment mismatch" below).

**Signature detail:**

The blueprint's `% LEAN SIGNATURE` block (lines 365–374) specifies the conclusion as:
```
∃ (n : ℕ) (g : A) (_ : g ≠ 0)
  (φ : MvPolynomial (Fin n) (Localization.Away g)
        →ₐ[Localization.Away g] Localization.Away (algebraMap A B g)),
  Function.Injective φ ∧ ...
```
and additionally comments (lines 375–381) that this form **"replaces the earlier anonymous instance existentials `(∃ (_ : Algebra A_g B_g) ...)`"**.

The landed Lean signature (lines 419–426) is:
```lean
∃ (n : ℕ) (g : A) (_ : g ≠ 0)
  (_ : Algebra (Localization.Away g) (Localization.Away (algebraMap A B g)))
  (φ : MvPolynomial (Fin n) (Localization.Away g)
        →ₐ[Localization.Away g] Localization.Away (algebraMap A B g)),
  Function.Injective φ ∧ ...
```

**Direction of mismatch**: The blueprint's `% LEAN SIGNATURE` comment omits `(_ : Algebra (Localization.Away g) (Localization.Away (algebraMap A B g)))` and explicitly claims that binder was removed. The landed Lean code retains it (the AlgHom's target type `Localization.Away (algebraMap A B g)` requires this algebra instance to elaborate as an `A_g`-algebra, since Lean cannot infer the `Localization.Away g`-algebra structure on `Localization.Away (algebraMap A B g)` without it).

**Mathematical content**: The informal prose statement of `lem:gf_noether_clear_denominators` is correct and matches the Lean's mathematical intent. The extra binder `(_ : Algebra A_g B_g)` is a Lean elaboration requirement, not a mathematical change to the statement.

**Impact**: The stale `% LEAN SIGNATURE` comment actively misrepresents what the Lean signature looks like and could mislead the blueprint-writing subagent or the downstream L5 assembly work that must consume L4's existential. The comment should be updated to match the landed signature.

---

### `\lean{exists_finite_inj_algHom_of_fg}` (lem:noether_normalization_fg)
- **Lean target exists**: N/A (Mathlib, `\mathlibok`)
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Mathlib lemma; confirmed used correctly at line 436 of `exists_localizationAway_finite_mvPolynomial`.

---

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_polynomial}` (lem:gf_polynomial_core)
- **Lean target exists**: yes (line 460)
- **Signature matches**: yes — `(d : ℕ) (N : Type*) [AddCommGroup N] [Module (MvPolynomial (Fin d) A) N] [Module.Finite (MvPolynomial (Fin d) A) N] [Module A N] [IsScalarTower A (MvPolynomial (Fin d) A) N] : ∃ f : A, f ≠ 0 ∧ Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) N)` matches the blueprint prose.
- **Proof follows sketch**: partial — base case `d = 0` closed axiom-clean; torsion sub-case `N_K = 0` for `d ≥ 1` closed via `exists_free_localizationAway_of_torsion`; generic-rank dévissage (non-torsion branch, `d ≥ 1`) is `sorry` at line 495 — known authorized gap.
- **notes**: The `d = 0` case uses `Module.Finite.equiv` through the `MvPolynomial (Fin 0) A ≅ A` iso, which correctly demonstrates A-finiteness of N.

---

### `\lean{AlgebraicGeometry.genericFlatness}` (thm:generic_flatness)
- **Lean target exists**: yes (line 594)
- **Signature matches**: yes — header `{S X : Scheme.{u}} [IsIntegral S] [IsLocallyNoetherian S] (p : X ⟶ S) [LocallyOfFiniteType p] (F : X.Modules) [F.IsQuasicoherent] [F.IsFiniteType]` matches the blueprint's note exactly; the flatness conclusion (universal over affine opens U ≤ V and W ≤ p⁻¹U with `Module.Flat Γ(S, U) Γ(F, W)`) matches the blueprint's re-signed description.
- **Proof follows sketch**: partial — `exists_isAffineOpen_mem_and_subset` step is closed; geometric assembly (`sorry` at line 629) is the known authorized gap.
- **notes**: Blueprint re-signing note from iter-002 is accurately reflected in the Lean code. `\leanok` is appropriately absent from the proof block (known sorry).

---

## Red flags

### Signature comment mismatch (blueprint side)

- **`lem:gf_noether_clear_denominators`** (`% LEAN SIGNATURE` block, blueprint lines 365–381): The comment claims the earlier `∃ (_ : Algebra A_g B_g)` existential was **replaced** by the AlgHom encoding, but the landed Lean declaration at line 419 still carries `(_ : Algebra (Localization.Away g) (Localization.Away (algebraMap A B g)))`. This is a stale/wrong `% LEAN SIGNATURE` specification comment. It does not affect mathematical correctness (the prose statement is accurate and the Lean elaborates correctly), but it is actively misleading: anyone reading the blueprint to understand what the L4 existential tuple looks like will receive a wrong description, and downstream assembly proofs that pattern-match on the existential must account for the extra binder.

### Authorized sorry bodies (per directive — not re-flagged)
- `exists_localizationAway_finite_mvPolynomial` line 445: denominator-clearing step (Mathlib-absent).
- `exists_free_localizationAway_polynomial` line 495: generic-rank dévissage (Mathlib-absent).
- `genericFlatnessAlgebraic` line 562: finite-type residue assembly.
- `genericFlatness` line 629: geometric assembly.

No axiom declarations. No Classical.choice on non-trivial claims. No excuse-comments on sorry-free declarations.

---

## Unreferenced declarations (informational)

All 12 project-local declarations in the Lean file have a corresponding `\lean{...}` reference in the blueprint. No unreferenced declarations.

---

## Blueprint adequacy for this file

- **Coverage**: 12/12 project-local Lean declarations have a corresponding `\lean{...}` block. The 3 Mathlib anchors (`lem:fp_free_descent`, `lem:noeth_prime_filtration`, `lem:noether_normalization_fg`) are correctly marked `\mathlibok`. **Full coverage.**
- **Proof-sketch depth**: **adequate** for closed declarations (L1, L3a/b/c, L3 assembly, finite-module leaf, flat variant, module-finite variant). For the sorry-carrying declarations (L4, L5, `genericFlatnessAlgebraic` residue, `genericFlatness`) the blueprint proof sketches are detailed and structurally accurate guides for when Mathlib supplies the missing pieces. The one exception is noted below.
- **Hint precision**: **mostly precise / one stale comment**. The `% LEAN SIGNATURE` block for `lem:gf_noether_clear_denominators` is wrong about the absence of `(_ : Algebra A_g B_g)`. All other `\lean{...}` pins and signature comments are accurate.
- **Generality**: matches need — declarations are at the correct level of generality for the project.

### Recommended chapter-side actions

1. **Update `% LEAN SIGNATURE` for `lem:gf_noether_clear_denominators`** (blueprint lines 366–381): Replace the existing block with the landed Lean conclusion verbatim, i.e. insert `(_ : Algebra (Localization.Away g) (Localization.Away (algebraMap A B g)))` as the third existential binder (after `(_ : g ≠ 0)`, before `(φ : ...)`). Remove or correct the sentence claiming that form was "replaced". This ensures anyone reading the blueprint to guide the L5 assembly work knows the exact shape of the L4 existential.

---

## Severity summary

- **must-fix-this-iter**: none.
- **major** (1):
  - `lem:gf_noether_clear_denominators` `% LEAN SIGNATURE` comment (blueprint lines 365–381): claims the `(_ : Algebra A_g B_g)` binder was removed, but the landed Lean signature at line 419 retains it. Stale specification comment that misrepresents the actual Lean signature and could mislead downstream L5 assembly work.
- **minor**: none.

**Overall verdict**: The Lean file is mathematically faithful to the blueprint on all 12 project-local declarations; the single major finding is a stale `% LEAN SIGNATURE` specification comment in the blueprint that misreports the L4 existential tuple — the blueprint should be updated to match the landed Lean signature for `exists_localizationAway_finite_mvPolynomial`.
