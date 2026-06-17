# Lean ↔ Blueprint Check Report

## Slug
gf

## Iteration
014

## Files audited
- Lean: `AlgebraicJacobian/Picard/FlatteningStratification.lean`
- Blueprint: `blueprint/src/chapters/Picard_FlatteningStratification.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.genericFlatnessAlgebraic}` (chapter: `thm:generic_flatness_algebraic`)
- **Lean target exists**: yes (line 1374)
- **Signature matches**: yes — `(A B M : Type*)` with `[CommRing A] [IsDomain A] [IsNoetherianRing A] [CommRing B] [Algebra A B] [Algebra.FiniteType A B] [AddCommGroup M] [Module B M] [Module.Finite B M] [Module A M] [IsScalarTower A B M] : ∃ f : A, f ≠ 0 ∧ Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) M)` matches the blueprint's intended signature block verbatim
- **Proof follows sketch**: partial — the primary route (finite A-module case) is axiom-clean; the surviving residue is `sorry`. Axioms: `{propext, sorryAx, Classical.choice, Quot.sound}`.
- **notes**: Honest scaffolding sorry; inline comments detail the dévissage assembly route blocked on L5. Acceptable per directive.

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_finite}` (chapter: `lem:gf_finite_module`)
- **Lean target exists**: yes (line 105)
- **Signature matches**: yes — `(A M : Type*)` noetherian domain, finite A-module; conclusion `∃ f ≠ 0, Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) M)`
- **Proof follows sketch**: yes — invokes `Module.finitePresentation_of_finite` then `Module.FinitePresentation.exists_free_localizedModule_powers` at `FractionRing A`, exactly as the blueprint's proof sketch (finite module → finitely presented → localise at Frac A → free → descend)
- **notes**: Axiom-clean `{propext, Classical.choice, Quot.sound}`.

### `\lean{Module.FinitePresentation.exists_free_localizedModule_powers}` (chapter: `lem:fp_free_descent`)
- **Lean target exists**: Mathlib anchor, `\mathlibok` in blueprint
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Correctly marked `\mathlibok`.

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_torsion}` (chapter: `lem:gf_torsion_base`)
- **Lean target exists**: yes (line 168)
- **Signature matches**: yes — torsion hypothesis `Subsingleton (LocalizedModule (nonZeroDivisors A) M)` encoding `M_K = 0`; conclusion `∃ f ≠ 0, Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) M)`
- **Proof follows sketch**: yes — finite B-generating set → product of annihilators `f = ∏ a_i` → `f • M = 0` → `M_f` subsingleton → free. Matches Nitsure §4 base case and blueprint proof verbatim.
- **notes**: Axiom-clean.

### `\lean{IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime}` (chapter: `lem:noeth_prime_filtration`)
- **Lean target exists**: Mathlib anchor, `\mathlibok`
- **notes**: Correctly marked `\mathlibok`.

### `\lean{AlgebraicGeometry.GenericFreeness.exact_localizedModule_powers_of_shortExact}` (chapter: `lem:gf_splice_shortExact_localized_exact`)
- **Lean target exists**: yes (line 220)
- **Signature matches**: yes — SES `M' →[B] M →[B] M''` with `f : A`; returns triple `(injective i_f, surjective q_f, exact)`
- **Proof follows sketch**: yes — direct application of `LocalizedModule.map_injective`, `map_surjective`, `map_exact`
- **notes**: Axiom-clean.

### `\lean{AlgebraicGeometry.GenericFreeness.free_localizationAway_of_free_of_eq_mul}` (chapter: `lem:gf_splice_shortExact_free_transport`)
- **Lean target exists**: yes (line 248)
- **Signature matches**: yes — `{f f' f'' : A}` with `hf : f = f' * f''`; `N_{f'}` free → `N_f` free
- **Proof follows sketch**: yes — factors `A_f` through `A_{f'} → A_f`, builds the `A_{f'}`-linear map via `IsLocalizedModule.lift`, uses `IsBaseChange.of_comp` and `.free`
- **notes**: Axiom-clean. Proof is more involved than the blueprint sketch ("a localisation of a free module is free") but mathematically equivalent.

### `\lean{AlgebraicGeometry.GenericFreeness.free_of_shortExact_of_free_free}` (chapter: `lem:gf_splice_shortExact_split`)
- **Lean target exists**: yes (line 336)
- **Signature matches**: yes — SES with free `P`, free `T`; conclusion `Module.Free R Q`
- **Proof follows sketch**: yes — projectivity of free `T` → section → `Q ≅ P × T` via `Function.Exact.splitSurjectiveEquiv` → `Module.Free.of_equiv`
- **notes**: Axiom-clean.

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_shortExact}` (chapter: `lem:gf_splice_shortExact`)
- **Lean target exists**: yes (line 360)
- **Signature matches**: yes
- **Proof follows sketch**: yes — assembles L3a + L3b + L3c in exactly the order sketched in the blueprint proof
- **notes**: Axiom-clean.

### `\lean{exists_finite_inj_algHom_of_fg}` (chapter: `lem:noether_normalization_fg`)
- **Lean target exists**: Mathlib anchor, `\mathlibok`
- **notes**: Correctly marked `\mathlibok`.

### `\lean{AlgebraicGeometry.GenericFreeness.gf_clear_one_denominator}` (chapter: `lem:gf_clear_one_denominator`)
- **Lean target exists**: yes (line 409)
- **Signature matches**: yes — takes `p : MvPolynomial (Fin n) (FractionRing A)`; returns `∃ g ≠ 0, p ∈ Set.range (MvPolynomial.map φ)` where `φ : Localization.Away g →+* FractionRing A`. Blueprint NOTE block acknowledges the encoding divergence (`IsLocalization.map` instead of `algebraMap (Localization.Away g) (FractionRing A)` which has no canonical instance).
- **Proof follows sketch**: yes — `IsLocalization.exist_integer_multiples` for all coefficients, product denominator `s`, numerator polynomial scaled by `s⁻¹`
- **notes**: Axiom-clean.

### `\lean{AlgebraicGeometry.GenericFreeness.exists_localizationAway_finite_mvPolynomial}` (chapter: `lem:gf_noether_clear_denominators`)
- **Lean target exists**: yes (line 486)
- **Signature matches**: yes — complex existential signature with `Algebra (Localization.Away g) (Localization.Away (algebraMap A B g))` binder matches the blueprint LEAN SIGNATURE block exactly
- **Proof follows sketch**: partial — Step 1 (Noether normalisation via `exists_finite_inj_algHom_of_fg`) is in place; Step 2 (denominator-clearing fold) is `sorry` with inline explanation
- **notes**: Axiom: `{propext, sorryAx, Classical.choice, Quot.sound}`. Honest scaffolding sorry; the missing piece is the Finset-fold over integral-dependence equations (blueprint NOTE iter-007).

### `\lean{AlgebraicGeometry.GenericFreeness.gf_generic_rank_ses}` (chapter: `lem:gf_generic_rank_ses`)
- **Lean target exists**: yes (line 529)
- **Signature matches**: yes — `(A d N)` with `P_d := MvPolynomial (Fin d) A`; conclusion `∃ m φ, Function.Injective φ ∧ Module.IsTorsion P_d (N ⧸ range φ)` matches blueprint LEAN SIGNATURE block
- **Proof follows sketch**: yes — `Module.finrank K NK` as generic rank, denominator-clearing of basis lifts via `IsLocalization.exist_integer_multiples`, `LinearIndependent.of_comp`, `IsFractionRing.injective` for scalar restriction
- **notes**: Axiom-clean. Proof is substantially more detailed than the blueprint's proof sketch (blueprint says "choose a Q-basis, clear denominators, define φ, linear independence, cokernel torsion"); the Lean proof fills in the right tools. No mismatch.

### `\lean{Submodule.annihilator_top_inter_nonZeroDivisors}` (chapter: `lem:annihilator_meets_nonZeroDivisors`)
- **Lean target exists**: Mathlib anchor, `\mathlibok`
- **notes**: Correctly marked.

### `\lean{AlgebraicGeometry.GenericFreeness.gf_torsion_annihilator}` (chapter: `lem:gf_torsion_annihilator`)
- **Lean target exists**: yes (line 636)
- **Signature matches**: yes — `(A d T)` torsion module; `∃ F ≠ 0, F ∈ Module.annihilator P_d T` matches blueprint LEAN SIGNATURE block
- **Proof follows sketch**: yes — `Submodule.annihilator_top_inter_nonZeroDivisors` → `nonZeroDivisors.ne_zero` → `Submodule.annihilator_top` membership
- **notes**: Axiom-clean.

### `\lean{AlgebraicGeometry.GenericFreeness.T1}` / `\lean{AlgebraicGeometry.GenericFreeness.T}` / Nagata sub-lemmas (chapter: `def:gf_nagata_T1`, `lem:gf_t1_comp_t1_neg`, `def:gf_nagata_T`, `lem:gf_lt_up`, etc.)
- **Lean target exists**: yes — these are `private` declarations in the `NagataNormalization` section (lines 668–822). Verified: `lean_verify` resolves `AlgebraicGeometry.GenericFreeness.T1` and returns axioms `{propext, Classical.choice, Quot.sound}`.
- **Signature matches**: yes — verified for key representatives (`T1`, `T`, `gf_nagata_monic_lastVar`).
- **Proof follows sketch**: yes — the Nagata degree bookkeeping (`degreeOf_zero_t`, `degreeOf_t_ne_of_ne`, `leadingCoeff_finSuccEquiv_t`, `T_leadingcoeff_eq`) faithfully implements the blueprint description ("distinct monomials acquire distinct X_0-degrees, top monomial's coefficient is c_v ≠ 0")
- **notes**: All `private` within the file. Despite the `private` modifier, `lean_verify` finds them by their qualified names (Lean 4 private declarations remain accessible within the same file context, and blueprint tooling resolves them). No false-negative issue.

### `\lean{AlgebraicGeometry.GenericFreeness.gf_nagata_monic_lastVar}` (chapter: `lem:gf_nagata_monic_lastVar`)
- **Lean target exists**: yes (line 795)
- **Signature matches**: yes — `(A m F hF)` → `∃ g ≠ 0, ∃ e : MvPoly ≃ₐ[A] MvPoly, IsUnit (finSuccEquiv A_g m (map (algebraMap A A_g) (e F))).leadingCoeff`
- **Proof follows sketch**: yes — `T_leadingcoeff_eq` gives `v ∈ supp f` with `lc = C (coeff v F)`; set `g := coeff v F`; `IsLocalization.Away.algebraMap_isUnit g` makes it a unit after inverting
- **notes**: Axiom-clean.

### `\lean{Polynomial.Monic.finite_quotient}` (chapter: `lem:polynomial_monic_quotient_finite`)
- **Lean target exists**: Mathlib anchor, `\mathlibok`
- **notes**: Correctly marked.

### `\lean{AlgebraicGeometry.GenericFreeness.mvPolynomial_quotient_finite_of_monic_lastVar}` (chapter: `lem:gf_mvPolynomial_quotient_finite_monic`)
- **Lean target exists**: yes (line 852)
- **Signature matches**: yes — `RingHom.Finite` encoding (composite `MvPolynomial (Fin n) R →+* MvPolynomial (Fin (n+1)) R ⧸ (p)`) matches blueprint NOTE F-3a resync block exactly
- **Proof follows sketch**: yes — rescale leading coefficient to monic (`C (u⁻¹) * finSuccEquiv p`), invoke `Polynomial.Monic.finite_quotient`, transport along `finSuccEquiv`-induced quotient iso using `finSuccEquiv_rename_succ`
- **notes**: Axiom-clean.

### `\lean{AlgebraicGeometry.GenericFreeness.gf_torsion_reindex}` (chapter: `lem:gf_torsion_reindex`) ← **iter-014 primary target**
- **Lean target exists**: yes (lines 1021–1252)
- **Signature matches**: yes — verified by hover and `lean_verify`. Full signature:
  ```
  (A : Type*) [CommRing A] [IsDomain A] [IsNoetherianRing A]
  (d : ℕ) (hd : 0 < d) (T : Type*) [AddCommGroup T]
  [Module (MvPolynomial (Fin d) A) T] [Module.Finite (MvPolynomial (Fin d) A) T]
  [Module A T] [IsScalarTower A (MvPolynomial (Fin d) A) T]
  (htors : Module.IsTorsion (MvPolynomial (Fin d) A) T) :
  ∃ (g : A) (_ : g ≠ 0) (m' : ℕ) (_ : m' < d)
    (_ : Module (MvPolynomial (Fin m') (Localization.Away g)) (LocalizedModule (Submonoid.powers g) T))
    (_ : Module (Localization.Away g) (LocalizedModule (Submonoid.powers g) T))
    (_ : IsScalarTower (Localization.Away g) (MvPolynomial (Fin m') (Localization.Away g))
            (LocalizedModule (Submonoid.powers g) T)),
    Module.Finite (MvPolynomial (Fin m') (Localization.Away g)) (LocalizedModule (Submonoid.powers g) T)
  ```
  Matches blueprint LEAN SIGNATURE block and the blueprint theorem statement verbatim.
- **Proof follows sketch**: yes (with a significant depth gap — see Blueprint adequacy section)
  - **L5b.1** (annihilator): line 1044 `gf_torsion_annihilator A (m + 1) T htors` → `F, hF0, hFann` ✅
  - **L5b.2** (Nagata normalisation): line 1047 `gf_nagata_monic_lastVar A m F hF0` → `g, hg0, e, hunit` ✅
  - **L5b.3** (single-variable elimination): line 1051 `mvPolynomial_quotient_finite_of_monic_lastVar` ✅
  - **Assembly/Transitivity**: lines 1053–1252 — sets up `MC`-localisation `Tg'`, ring automorphism `ebar : P_g ≃+* P_g` extending `e`, quotient iso `ψ : P_g/(F) ≃+* P_g/(G)`, ring map `ρ : R → P_g/(G)`, and transports finiteness via `finite_of_quotientRingEquiv`; finally builds the equivalence `T_g ≃ₗ[A_g] Tg'` and pulls back the `R`-module structure via `pullbackModuleAddEquiv` ✅
- **Witness**: `m' = m = d - 1` (via `Nat.lt_succ_self m`), matching the blueprint's "one may always take m' = d − 1" ✅
- **Axioms**: `{propext, Classical.choice, Quot.sound}` — sorry-free and axiom-clean ✅
- **notes**: Proof requires `set_option maxHeartbeats 4000000` and `synthInstance.maxHeartbeats 1000000` due to deep instance search over doubly-indexed polynomial rings. These are performance settings, not correctness issues.

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_polynomial}` (chapter: `lem:gf_polynomial_core`)
- **Lean target exists**: yes (line 1267)
- **Signature matches**: yes — `(A N : Type u)` (shared universe, load-bearing for the IH), `MvPolynomial (Fin d) A`-module; `∃ f ≠ 0, Module.Free (A_f) (N_f)` matches blueprint
- **Proof follows sketch**: partial — strong induction on `d generalizing A N` (matching blueprint's "generalising the base domain A" note), base case `d = 0` axiom-clean; inductive step has `gf_generic_rank_ses` invoked correctly but the assembly is `sorry`
- **notes**: Axiom: `{propext, sorryAx, Classical.choice, Quot.sound}`. Comment at line 1323 says "gf_torsion_reindex (L5b, still `sorry`)" — this is now **stale** since L5b was closed this iter. Minor issue; the sorry itself remains legitimate (wiring steps 1–5 is the remaining work).

### `\lean{AlgebraicGeometry.GenericFreeness.exists_flat_localizationAway_of_finite}` (chapter: `lem:gf_flat_finite`)
- **Lean target exists**: yes (line 120)
- **Signature matches**: yes
- **Proof follows sketch**: yes — one-liner via `exists_free_localizationAway_of_finite` + `Module.Flat.of_free`
- **notes**: Axiom-clean.

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_moduleFinite}` (chapter: `lem:gf_free_moduleFinite`)
- **Lean target exists**: yes (line 135)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `Module.Finite.trans B M` + `exists_free_localizationAway_of_finite`
- **notes**: Axiom-clean.

### `\lean{AlgebraicGeometry.genericFlatness}` (chapter: `thm:generic_flatness`)
- **Lean target exists**: yes (line 1436)
- **Signature matches**: yes — `{S X : Scheme.{u}} [IsIntegral S] [IsLocallyNoetherian S] (p : X ⟶ S) [LocallyOfFiniteType p] (F : X.Modules) [F.IsQuasicoherent] [F.IsFiniteType]` with the fibrewise flatness conclusion; matches blueprint LEAN SIGNATURE block and `\mathlibok` note about coherence encoding
- **Proof follows sketch**: partial — non-empty affine open `U₀` obtained, then `sorry` with detailed assembly plan (steps 1–4 spelled out)
- **notes**: Axiom: `{propext, sorryAx, Classical.choice, Quot.sound}`. Honest scaffolding sorry awaiting `genericFlatnessAlgebraic`.

---

## Red flags

### Stale comment (minor)
- `FlatteningStratification.lean:1323`: comment reads `"gf_torsion_reindex (L5b, still \`sorry\`)"` inside the body of `exists_free_localizationAway_polynomial`. This is factually incorrect as of iter-014: `gf_torsion_reindex` was closed this iter and is sorry-free. The sorry in `exists_free_localizationAway_polynomial` remains, but the reason is no longer "blocked on L5b" — it is the remaining wiring of steps 1–5 of the inductive assembly. The stale comment could mislead the next prover about what's blocking.

### Placeholder bodies (scaffolding, pre-approved)
Per directive, the following sorries are pre-classified as honest downstream scaffolding:
- `exists_localizationAway_finite_mvPolynomial` (L4, line ~516): Mathlib-absent denominator-clearing fold
- `exists_free_localizationAway_polynomial` (L5, line ~1337): assembly of steps 1–5 of the induction, now unblocked
- `genericFlatnessAlgebraic` (line ~1404): blocked on L5
- `genericFlatness` (line ~1471): blocked on algebraic form

All four have detailed inline proof plans. No action required this iter per directive.

---

## Unreferenced declarations (informational)

The following five declarations in `AlgebraicGeometry.GenericFreeness` have no `\lean{...}` blueprint reference. Per the directive, these are known coverage debt tracked for blueprinting next iter:

| Declaration | Line | Role |
|---|---|---|
| `pullbackModuleAddEquiv` | 911 | Module structure pullback along `AddEquiv`; central to `gf_torsion_reindex` assembly |
| `finite_of_pullbackModuleAddEquiv` | 929 | Finiteness transport along the pullback |
| `pullback_isScalarTower` | 944 | Scalar tower for pulled-back structures |
| `finite_of_quotientRingEquiv` | 961 | Finiteness transport across a ring iso |
| `isLocalizedModule_restrictScalars` | 979 | Scalar restriction for `IsLocalizedModule` |

All five are substantive project-local lemmas (not trivial one-liners) that were required to bridge the gap between the blueprint's "Transitivity" sketch and the actual Lean proof of `gf_torsion_reindex`. They share no `\lean{...}` coverage.

---

## Blueprint adequacy for this file

- **Coverage**: 29/34 blueprint-referenced Lean declarations exist and are substantive (4 are `\mathlibok` Mathlib anchors; the remaining 5 uncovered are the new helpers listed above). For the 29 non-Mathlib declarations: 24 are axiom-clean, 5 carry `sorryAx` (4 honest scaffolding sorries + `exists_localizationAway_finite_mvPolynomial`).

- **Proof-sketch depth**: **under-specified** for `lem:gf_torsion_reindex`. The blueprint's "Transitivity" step reads:
  > "Composing the two module-finite extensions, T_g is finite over A_g[X_1,…,X_{m'}]."
  
  In practice, this step required ~200 lines of Lean including:
  1. Setting up two distinct localizations: the `MC`-localisation `Tg' := LocalizedModule MC T` (at the image of `powers g` under `C : A → P`) and the goal's `T_g := LocalizedModule (powers g) T` (at `powers g` directly under `A → P`).
  2. Proving `Tg'` is finite over `P_g` via `Module.Finite.of_isLocalizedModule`, then over `Qf := P_g/(F_g)` via `Module.IsTorsionBySet`, then over `R := MvPolynomial (Fin m) A_g` via `finite_of_quotientRingEquiv` (a project-local helper).
  3. Building the ring automorphism `ebar : P_g ≃+* P_g` extending `e` (using `IsLocalization.ringEquivOfRingEquiv`) and verifying `ebar Fg = G`.
  4. Transporting the `R`-action from `Tg'` to `T_g` via `pullbackModuleAddEquiv` along the `A_g`-linear equivalence `eAgL : T_g ≃ₗ[A_g] Tg'`.
  5. Establishing the required scalar tower via `IsScalarTower.of_algebraMap_smul`.

  A prover working from the blueprint's four-line sketch would not have known this approach. The 5 new unmatched helpers are direct evidence of the blueprint gap.

- **Hint precision**: **precise** for all `\lean{...}` blocks verified. The blueprint notes about encoding choices (e.g., `gf_clear_one_denominator` using `IsLocalization.map` vs `algebraMap`, `gf_noether_clear_denominators` retaining the `Algebra (A_g) (B_g)` binder, `mvPolynomial_quotient_finite_of_monic_lastVar` using `RingHom.Finite`) are all accurate and match the landed signatures.

- **Generality**: **matches need** — `exists_free_localizationAway_polynomial` correctly uses `(A N : Type u)` with shared universe for the base-domain-generalising IH to work; the blueprint LEAN SIGNATURE note flags this as load-bearing. No generality mismatch.

- **Recommended chapter-side actions for a blueprint-writing subagent**:
  1. **Expand the "Transitivity" step of `lem:gf_torsion_reindex`** (the most important item): add a sub-step "Localisation transport" describing the two-localisation strategy (`MC`-localisation vs `powers g`-localisation), the `ebar` construction, and the `pullbackModuleAddEquiv` transport. The current 4-line sketch is insufficient to guide a future prover repeating this work.
  2. **Add `\lean{...}` blocks** for the 5 new helper declarations, specifically:
     - `\lean{AlgebraicGeometry.GenericFreeness.pullbackModuleAddEquiv}` as a helper definition
     - `\lean{AlgebraicGeometry.GenericFreeness.finite_of_quotientRingEquiv}` with a brief statement
     - `\lean{AlgebraicGeometry.GenericFreeness.isLocalizedModule_restrictScalars}` with a brief statement
     - `finite_of_pullbackModuleAddEquiv` and `pullback_isScalarTower` as subsidiary helpers
  3. **Update the stale `exists_free_localizationAway_polynomial` comment** in the blueprint's L5 proof sketch: the "blocked on gf_torsion_reindex" language can now be replaced with "assembly of steps 1–5".

---

## Severity summary

| Finding | Severity |
|---|---|
| Blueprint "Transitivity" step of `lem:gf_torsion_reindex` is under-specified (4 lines; 200-line Lean proof; 5 new unmatched helpers as evidence) | **major** |
| Stale comment in `exists_free_localizationAway_polynomial` (line 1323): says L5b "still sorry" when it was closed this iter | **minor** |
| 5 unmatched helper declarations (known debt, tracked per directive) | **minor** |
| `gf_torsion_reindex` (iter-014 primary target): sorry-free, axiom-clean `{propext, Classical.choice, Quot.sound}`, signature and proof content match blueprint ← clean | — |
| 4 honest downstream sorries (L4, L5, genericFlatnessAlgebraic, genericFlatness) ← pre-approved per directive | — |

**Overall verdict**: The Lean file is faithful to the blueprint with no signature mismatches or fake/placeholder bodies on blueprint-claimed declarations; `gf_torsion_reindex` landed correctly with mathematical content matching the L5b decomposition, but the blueprint's "Transitivity" step is under-specified relative to the ~200-line Lean assembly it required — 1 major chapter-side debt, 2 minor issues, 0 must-fix-this-iter.
