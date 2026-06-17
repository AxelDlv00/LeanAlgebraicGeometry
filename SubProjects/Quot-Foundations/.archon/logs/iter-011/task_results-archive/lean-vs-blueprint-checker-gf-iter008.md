# Lean ↔ Blueprint Check Report

## Slug
gf-iter008

## Iteration
008

## Files audited
- Lean: `AlgebraicJacobian/Picard/FlatteningStratification.lean`
- Blueprint: `blueprint/src/chapters/Picard_FlatteningStratification.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_finite}` (chapter: `lem:gf_finite_module`)
- **Lean target exists**: yes (L105)
- **Signature matches**: yes — exact match with `% INTENDED LEAN SIGNATURE` comment and blueprint prose: `(A : Type*) (M : Type*) [CommRing A] [IsDomain A] [IsNoetherianRing A] [AddCommGroup M] [Module A M] [Module.Finite A M] : ∃ f : A, f ≠ 0 ∧ Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) M)`
- **Proof follows sketch**: yes — uses `Module.finitePresentation_of_finite` + `Module.FinitePresentation.exists_free_localizedModule_powers` at `nonZeroDivisors A` (= `Frac A`), exactly as the blueprint describes
- **notes**: axiom-clean `[propext, Classical.choice, Quot.sound]`

---

### `\lean{Module.FinitePresentation.exists_free_localizedModule_powers}` (chapter: `lem:fp_free_descent`)
- **Lean target exists**: N/A — `\mathlibok`, provided by Mathlib; not in this file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Mathlib-backed; correctly tagged `\mathlibok` in the chapter

---

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_torsion}` (chapter: `lem:gf_torsion_base`)
- **Lean target exists**: yes (L168)
- **Signature matches**: yes — hypothesis `htors : Subsingleton (LocalizedModule (nonZeroDivisors A) M)` faithfully encodes the prose "K ⊗_A M = 0"; conclusion `∃ f : A, f ≠ 0 ∧ Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) M)` matches
- **Proof follows sketch**: yes — finds the product of annihilators of a finite `B`-generating set (via `LocalizedModule.subsingleton_iff` + `Module.Finite.fg_top` + `Finset.prod_erase_mul`), shows `f • M = 0` by `Submodule.span_induction`, then `M_f` is a subsingleton and hence free; this is precisely the Nitsure §4 base-case argument
- **notes**: axiom-clean

---

### `\lean{IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime}` (chapter: `lem:noeth_prime_filtration`)
- **Lean target exists**: N/A — `\mathlibok`
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: correctly tagged `\mathlibok`

---

### `\lean{AlgebraicGeometry.GenericFreeness.exact_localizedModule_powers_of_shortExact}` (chapter: `lem:gf_splice_shortExact_localized_exact`)
- **Lean target exists**: yes (L220)
- **Signature matches**: yes — SES of B-modules `(i : M' →ₗ[B] M) (q : M →ₗ[B] M'')`, non-zero `f : A`, conclusion is injectivity + surjectivity + exactness of the localised maps (scalar-restricted to `A`); exactly as the blueprint states
- **Proof follows sketch**: yes — direct application of `LocalizedModule.map_injective`, `LocalizedModule.map_surjective`, `LocalizedModule.map_exact`
- **notes**: axiom-clean

---

### `\lean{AlgebraicGeometry.GenericFreeness.free_localizationAway_of_free_of_eq_mul}` (chapter: `lem:gf_splice_shortExact_free_transport`)
- **Lean target exists**: yes (L248)
- **Signature matches**: yes — `(A N : Type*) [CommRing A] [AddCommGroup N] [Module A N] {f f' f'' : A} (hf : f = f' * f'') (hN' : free N at f') : free N at f`; matches the blueprint's "N a module, f = f' f'', N_{f'} free ⟹ N_f free"
- **Proof follows sketch**: yes — constructs the ring map `A_{f'} → A_{f'f''}`, builds the tower, uses `IsLocalizedModule.lift` and `IsBaseChange.of_comp` to transport freeness; matches the blueprint's "A_f is a localisation of A_{f'}" argument
- **notes**: axiom-clean

---

### `\lean{AlgebraicGeometry.GenericFreeness.free_of_shortExact_of_free_free}` (chapter: `lem:gf_splice_shortExact_split`)
- **Lean target exists**: yes (L336)
- **Signature matches**: yes — `(R P Q T : Type*) ... [Module.Free R P] ... [Module.Free R T] (iota : P →ₗ[R] Q) (pi : Q →ₗ[R] T)` injective SES with free ends; exactly the blueprint statement
- **Proof follows sketch**: yes — uses `Module.projective_lifting_property` + `Function.Exact.splitSurjectiveEquiv` + `Module.Free.of_equiv`; the blueprint says "free quotient splits the SES giving Q ≅ P ⊕ T"
- **notes**: axiom-clean

---

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_shortExact}` (chapter: `lem:gf_splice_shortExact`)
- **Lean target exists**: yes (L360)
- **Signature matches**: yes — SES of B-modules, `{f' f'' : A} (hf' : f' ≠ 0) (hf'' : f'' ≠ 0)` with `hM' : Module.Free ... M'` and `hM'' : Module.Free ... M''`; conclusion `∃ f : A, f ≠ 0 ∧ Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) M)` matches
- **Proof follows sketch**: yes — takes `f := f' * f''`, applies L3b to both ends, L3a for the localised SES, then L3c for the free middle; exactly as the blueprint describes
- **notes**: axiom-clean

---

### `\lean{exists_finite_inj_algHom_of_fg}` (chapter: `lem:noether_normalization_fg`)
- **Lean target exists**: N/A — `\mathlibok`
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: correctly tagged `\mathlibok`

---

### `\lean{AlgebraicGeometry.GenericFreeness.gf_clear_one_denominator}` (chapter: `lem:gf_clear_one_denominator`)
- **Lean target exists**: yes (L409)
- **Signature matches**: partial — the blueprint's `% LEAN SIGNATURE` comment says:
  ```
  p ∈ Set.range (MvPolynomial.map (algebraMap (Localization.Away g) (FractionRing A)))
  ```
  The actual Lean conclusion uses:
  ```
  p ∈ Set.range (MvPolynomial.map (IsLocalization.map (FractionRing A) (RingHom.id A)
        (show Submonoid.powers g ≤ Submonoid.comap (RingHom.id A) (nonZeroDivisors A) by ...)
        : Localization.Away g →+* FractionRing A))
  ```
  These denote the same ring homomorphism (the canonical `A_g → K`), but the blueprint's spec comment is a simplified form while the Lean uses the explicit `IsLocalization.map` construction (which requires supplying the proof that powers of `g` map into `nonZeroDivisors A` as a visible term). The mathematical content is identical; the blueprint's `% LEAN SIGNATURE` is imprecise about the syntactic encoding.
- **Proof follows sketch**: yes — uses `IsLocalization.exist_integer_multiples` on `p.support` to find a common denominator `s` for the finitely many coefficients of `p`, then constructs the preimage polynomial scaled by `s⁻¹`; this matches the blueprint's "take g to be a common denominator of the finitely many coefficients"
- **notes**: axiom-clean (`[propext, Classical.choice, Quot.sound]`, verified by LSP). The `% LEAN SIGNATURE` comment should be updated to reflect the explicit `IsLocalization.map` form.

---

### `\lean{AlgebraicGeometry.GenericFreeness.exists_localizationAway_finite_mvPolynomial}` (chapter: `lem:gf_noether_clear_denominators`)
- **Lean target exists**: yes (L486)
- **Signature matches**: yes — exact match with the `% LEAN SIGNATURE` block in the chapter: `∃ (n : ℕ) (g : A) (_ : g ≠ 0) (_ : Algebra (Localization.Away g) (Localization.Away (algebraMap A B g))) (φ : MvPolynomial (Fin n) (Localization.Away g) →ₐ[Localization.Away g] Localization.Away (algebraMap A B g)), Function.Injective φ ∧ (letI := φ.toAlgebra; Module.Finite ...)`
- **Proof follows sketch**: partial — Step 1 (Noether normalisation over K via `exists_finite_inj_algHom_of_fg`) is completed in the Lean body; Steps 2–3 (denominator-clearing fold and AlgHom assembly) are `sorry`'d
- **notes**: known issue per directive (scaffold sorry on L4, denominator-clearing assembly blocked)

---

### `\lean{AlgebraicGeometry.GenericFreeness.gf_generic_rank_ses}` (chapter: `lem:gf_generic_rank_ses`)
- **Lean target exists**: yes (L529)
- **Signature matches**: yes — exact match with `% LEAN SIGNATURE` block: `(A : Type*) [CommRing A] [IsDomain A] [IsNoetherianRing A] (d : ℕ) (N : Type*) [AddCommGroup N] [Module (MvPolynomial (Fin d) A) N] [Module.Finite (MvPolynomial (Fin d) A) N] [Module A N] [IsScalarTower A (MvPolynomial (Fin d) A) N] : ∃ (m : ℕ) (φ : (Fin m → MvPolynomial (Fin d) A) →ₗ[MvPolynomial (Fin d) A] N), Function.Injective φ ∧ Module.IsTorsion (MvPolynomial (Fin d) A) (N ⧸ LinearMap.range φ)`
- **Proof follows sketch**: yes — takes `m = Module.finrank K NK` (generic rank), lifts a K-basis via `IsLocalizedModule.surj` (denominator-clearing), proves linear independence over K then over P_d via scalar restriction, defines `φ = Fintype.linearCombination P_d v`, shows injectivity from LI, shows torsion by `hspan : span K (range ℓ∘v) = ⊤` + denominator-clearing for the cokernel element; all steps match the blueprint's proof sketch exactly
- **notes**: axiom-clean (`[propext, Classical.choice, Quot.sound]`, verified by LSP)

---

### `\lean{AlgebraicGeometry.GenericFreeness.gf_torsion_reindex}` (chapter: `lem:gf_torsion_reindex`)
- **Lean target exists**: yes (L634)
- **Signature matches**: yes — exact match with `% LEAN SIGNATURE` block in the chapter, including all five `∃`-bound instance hypotheses
- **Proof follows sketch**: N/A (body is `sorry`)
- **notes**: known issue per directive; scaffold sorry, blocked on Nagata change-of-variables (Mathlib-absent)

---

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_polynomial}` (chapter: `lem:gf_polynomial_core`)
- **Lean target exists**: yes (L664)
- **Signature matches**: partial — **the chapter has no `% LEAN SIGNATURE` annotation for this lemma** recording the shared-universe form. The Lean declaration uses `(A : Type u) ... (N : Type u)` (shared universe `u`), changed this iteration from `(A : Type*) ... (N : Type*)`. The chapter's `% LEAN PROOF STRUCTURE` comment (added iter-007) uses `(A)` and `(N)` in informal notation without universe annotation; no `% LEAN SIGNATURE` block and no `% NOTE` recording the `Type*` → shared `Type u` change exists. See severity below.
- **Proof follows sketch**: partial — the strong induction structure `Nat.strong_induction_on generalizing A N` (with `generalizing N` reverting all five d-dependent instances) is in place and matches the blueprint's structure note precisely; base case `d = 0` is axiom-clean; inductive step invokes `gf_generic_rank_ses` to produce the SES but the assembly (steps 1–5 of the blueprint's enumeration) is `sorry`'d, blocked on `gf_torsion_reindex`
- **notes**: known issue per directive for the inner `sorry`; the missing `% LEAN SIGNATURE` / `% NOTE` is a new finding (see severity)

---

### `\lean{AlgebraicGeometry.GenericFreeness.exists_flat_localizationAway_of_finite}` (chapter: `lem:gf_flat_finite`)
- **Lean target exists**: yes (L120)
- **Signature matches**: yes — noetherian domain, finite A-module, `∃ f ≠ 0` with `LocalizedModule (Submonoid.powers f) M` flat over `Localization.Away f`
- **Proof follows sketch**: yes — calls `exists_free_localizationAway_of_finite` then `Module.Flat.of_free`
- **notes**: axiom-clean

---

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_moduleFinite}` (chapter: `lem:gf_free_moduleFinite`)
- **Lean target exists**: yes (L135)
- **Signature matches**: yes — noetherian domain `A`, module-finite A-algebra `B`, finite B-module `M` with scalar tower; conclusion `∃ f ≠ 0` with `M_f` free over `A_f`
- **Proof follows sketch**: yes — `Module.Finite.trans B M` + `exists_free_localizationAway_of_finite A M`
- **notes**: axiom-clean

---

### `\lean{AlgebraicGeometry.genericFlatnessAlgebraic}` (chapter: `thm:generic_flatness_algebraic`)
- **Lean target exists**: yes (L771)
- **Signature matches**: yes — exact match with `% INTENDED LEAN SIGNATURE` block in the chapter: `(A B M : Type*)` with standard class assumptions, conclusion `∃ f : A, f ≠ 0 ∧ Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) M)`
- **Proof follows sketch**: yes — `by_cases hAM : Module.Finite A M` splits into the primary route (axiom-clean) and the surviving residue (`sorry`); matches blueprint's "Primary route — the finite A-module case" and "Surviving residue — finite-type B-algebra case"
- **notes**: known issue per directive for the surviving-residue `sorry`

---

### `\lean{AlgebraicGeometry.genericFlatness}` (chapter: `thm:generic_flatness`)
- **Lean target exists**: yes (L833)
- **Signature matches**: yes — `{S X : Scheme.{u}} [IsIntegral S] [IsLocallyNoetherian S] (p : X ⟶ S) [LocallyOfFiniteType p] (F : X.Modules) [F.IsQuasicoherent] [F.IsFiniteType] : ∃ (V : S.Opens), (V : Set S).Nonempty ∧ ∀ {U : S.Opens} (_ : IsAffineOpen U) (_ : U ≤ V) {W : X.Opens} (_ : IsAffineOpen W) (e : W ≤ p ⁻¹ᵁ U), letI : Module Γ(S, U) Γ(F, W) := ...; Module.Flat Γ(S, U) Γ(F, W)` — the blueprint's `% LEAN SIGNATURE HEADER` comment says "verbatim form in the .lean file, the source of truth", and the Lean file is exactly that
- **Proof follows sketch**: partial — the proof begins the geometric assembly correctly (extracting a non-empty affine open `U₀` via `exists_isAffineOpen_mem_and_subset`); the remaining four steps are `sorry`'d
- **notes**: known issue per directive (deferred geo leg)

---

## Red flags

### Placeholder / suspect bodies

All `sorry` bodies are documented scaffolding sorries carried over from prior iterations and explicitly enumerated in the directive's known-issues list. None are new or undocumented. For completeness:

- `exists_localizationAway_finite_mvPolynomial` (L516): L4 assembly not yet complete (Mathlib-absent denominator-clearing fold)
- `gf_torsion_reindex` (L649): Nagata change-of-variables, Mathlib-absent
- `exists_free_localizationAway_polynomial` (L734): inner `sorry` in the inductive step, blocked solely on `gf_torsion_reindex`
- `genericFlatnessAlgebraic` (L801): surviving-residue dévissage, assembly deferred
- `genericFlatness` (L868): geometric leg deferred

None of these constitute a "placeholder failure" per the directive's pre-exemption. No new, undocumented `sorry` bodies found.

### Excuse-comments

None found. The detailed comment blocks in the Lean file (e.g., the five-step assembly note at L699–735) are accurate descriptions of the remaining gap and blocked dependencies, not excuses for wrong or weak definitions.

### Axioms / Classical.choice on non-trivial claims

No unauthorized `axiom` declarations. LSP verification confirms:
- `gf_generic_rank_ses`: `[propext, Classical.choice, Quot.sound]` ✓
- `gf_clear_one_denominator`: `[propext, Classical.choice, Quot.sound]` ✓

All other completed declarations have the same standard Mathlib axiom set.

---

## Unreferenced declarations (informational)

Every declaration in the Lean file has a corresponding `\lean{...}` reference in the blueprint chapter. No unreferenced declarations found.

---

## Blueprint adequacy for this file

- **Coverage**: 18/18 Lean declarations have a corresponding `\lean{...}` block (including two Mathlib anchors tagged `\mathlibok`). Zero unreferenced substantive declarations. Coverage is complete.

- **Proof-sketch depth**: adequate for all completed declarations. The `gf_generic_rank_ses` and `gf_clear_one_denominator` proofs in particular align closely with the blueprint sketches. The `lem:gf_torsion_reindex` proof sketch (Nagata change-of-variables + division algorithm argument) is detailed enough to guide a prover once the relevant Mathlib API is located. The `lem:gf_polynomial_core` induction structure note is precise and load-bearing (it correctly identifies the `generalizing A N` fix and the base-domain change as the key insight). Overall: adequate.

- **Hint precision**: precise for all declarations except the one finding below.

- **Generality**: matches need — the polynomial-ring core `lem:gf_polynomial_core` is stated at the right level of generality (quantifying over the base domain `A` in the motive, which the Lean implements via `Nat.strong_induction_on generalizing A N`).

- **Recommended chapter-side actions**:
  1. **(Major)** Add a `% NOTE` (or `% LEAN SIGNATURE`) to `lem:gf_polynomial_core` recording that the signature now uses a shared universe `(A N : Type u)` rather than independent `Type*`s, explaining that this is load-bearing for the strong induction (the IH must be applied at base `A_g = Localization.Away g`, so the universe of `A` must be pinned to match `N`'s). The existing `% LEAN PROOF STRUCTURE` comment notes the `generalizing` tactic but does not record the universe signature.
  2. **(Minor)** Update the `% LEAN SIGNATURE` comment for `lem:gf_clear_one_denominator` to replace `MvPolynomial.map (algebraMap (Localization.Away g) (FractionRing A))` with `MvPolynomial.map (IsLocalization.map (FractionRing A) (RingHom.id A) ...)` (or a note explaining that the `algebraMap` shorthand expands to this explicit construction in the Lean encoding), to prevent future prover confusion when the two forms do not unify syntactically.

---

## Severity summary

| Finding | Severity |
|---------|----------|
| `lem:gf_polynomial_core` (`exists_free_localizationAway_polynomial`): chapter missing `% LEAN SIGNATURE` / `% NOTE` recording the shared-universe `(A N : Type u)` change from `Type*` | **major** |
| `lem:gf_clear_one_denominator`: blueprint's `% LEAN SIGNATURE` comment uses `algebraMap ...` shorthand but Lean uses explicit `IsLocalization.map ...`; same map, imprecise spec | **minor** |
| All other `\lean{...}` blocks: signatures match exactly, proofs follow sketches, all sorries are pre-exempted known scaffolding | pass |

**Overall verdict**: The file follows the blueprint faithfully across all 16 project-internal declarations; `gf_generic_rank_ses` and `gf_clear_one_denominator` are axiom-clean with proofs matching their sketches. One major blueprint-side gap: `lem:gf_polynomial_core` lacks a `% LEAN SIGNATURE` recording the iter-008 universe change `(A N : Type*)` → `(A N : Type u)` — the review agent should add a `% NOTE` with the shared-universe form. One minor blueprint-side imprecision in `lem:gf_clear_one_denominator`'s `% LEAN SIGNATURE` comment. No must-fix-this-iter findings.
