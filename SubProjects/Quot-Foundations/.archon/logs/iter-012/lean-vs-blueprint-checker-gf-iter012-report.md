# Lean ↔ Blueprint Check Report

## Slug
gf-iter012

## Iteration
012

## Files audited
- Lean: `AlgebraicJacobian/Picard/FlatteningStratification.lean`
- Blueprint: `blueprint/src/chapters/Picard_FlatteningStratification.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_finite}` (chapter: `lem:gf_finite_module`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(A M : Type*) [CommRing A] [IsDomain A] [IsNoetherianRing A] [AddCommGroup M] [Module A M] [Module.Finite A M] : ∃ f : A, f ≠ 0 ∧ Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) M)` matches prose exactly.
- **Proof follows sketch**: yes — proof uses `Module.finitePresentation_of_finite` + `Module.FinitePresentation.exists_free_localizedModule_powers` at the generic point; blueprint says exactly that.
- **Notes**: Proof is sorry-free (axiom-clean).

### `\lean{Module.FinitePresentation.exists_free_localizedModule_powers}` (chapter: `lem:fp_free_descent`, Mathlib)
- **Lean target exists**: yes (Mathlib); `\mathlibok` in blueprint.
- **Signature matches**: yes.
- **Proof follows sketch**: N/A (Mathlib anchor).
- **Notes**: Correctly marked `\mathlibok`.

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_torsion}` (chapter: `lem:gf_torsion_base`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(A B M : Type*) [CommRing A] [IsDomain A] [CommRing B] [Algebra A B] [AddCommGroup M] [Module B M] [Module.Finite B M] [Module A M] [IsScalarTower A B M] (htors : Subsingleton (LocalizedModule (nonZeroDivisors A) M)) : ∃ f : A, f ≠ 0 ∧ Module.Free ...`. Encoding of `M_K = 0` as `Subsingleton` is documented in the docstring and is correct.
- **Proof follows sketch**: yes — finds a finite B-generating set, takes product of annihilators, checks annihilation, concludes M_f = 0 is free; matches Nitsure §4 base-case exactly.
- **Notes**: Proof is sorry-free.

### `\lean{IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime}` (chapter: `lem:noeth_prime_filtration`, Mathlib)
- **Lean target exists**: yes (Mathlib); `\mathlibok`.
- **Signature matches**: yes.
- **Proof follows sketch**: N/A.

### `\lean{AlgebraicGeometry.GenericFreeness.exact_localizedModule_powers_of_shortExact}` (chapter: `lem:gf_splice_shortExact_localized_exact`)
- **Lean target exists**: yes
- **Signature matches**: yes — returns a conjunction of `Function.Injective`, `Function.Surjective`, `Function.Exact` for the localised maps; matches the blueprint's SES-exactness claim.
- **Proof follows sketch**: yes — direct application of `LocalizedModule.map_injective`, `map_surjective`, `map_exact`.
- **Notes**: Proof is sorry-free.

### `\lean{AlgebraicGeometry.GenericFreeness.free_localizationAway_of_free_of_eq_mul}` (chapter: `lem:gf_splice_shortExact_free_transport`)
- **Lean target exists**: yes
- **Signature matches**: yes — blueprint says "N_{f'} free over A_{f'}, f = f'f'' ⟹ N_f free over A_f". Lean has `(hf : f = f' * f'') (hN' : Module.Free (Localization.Away f') ...) : Module.Free (Localization.Away f) ...`. Note: blueprint mentions "B-module" in the prose but the formal target correctly drops B (the B-structure is irrelevant to the statement, as documented).
- **Proof follows sketch**: yes — factors the localisation through `A_{f'} → A_{f'f''}` via `IsLocalization.Away.awayToAwayLeft`, builds the base-change chain, concludes by `IsBaseChange.free`.
- **Notes**: Proof is sorry-free. Blueprint is slightly imprecise saying "N is a B-module" but the `\lean{...}` pin correctly targets the more general statement.

### `\lean{AlgebraicGeometry.GenericFreeness.free_of_shortExact_of_free_free}` (chapter: `lem:gf_splice_shortExact_split`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(R P Q T : Type*) ... [Module.Free R P] ... [Module.Free R T] (iota : P →ₗ[R] Q) (pi : Q →ₗ[R] T) (hiota ...) (hpi ...) (hexact ...) : Module.Free R Q`.
- **Proof follows sketch**: yes — uses `Module.projective_lifting_property` to split, then `Function.Exact.splitSurjectiveEquiv`, then `Module.Free.of_equiv`.
- **Notes**: Proof is sorry-free.

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_shortExact}` (chapter: `lem:gf_splice_shortExact`)
- **Lean target exists**: yes
- **Signature matches**: yes.
- **Proof follows sketch**: yes — takes `f := f'*f''`, applies L3a + L3b (twice) + L3c in exactly the order the blueprint describes.
- **Notes**: Proof is sorry-free.

### `\lean{exists_finite_inj_algHom_of_fg}` (chapter: `lem:noether_normalization_fg`, Mathlib)
- **Lean target exists**: yes (Mathlib); `\mathlibok`.
- **Signature matches**: yes.
- **Proof follows sketch**: N/A.

### `\lean{AlgebraicGeometry.GenericFreeness.gf_clear_one_denominator}` (chapter: `lem:gf_clear_one_denominator`)
- **Lean target exists**: yes
- **Signature matches**: yes — blueprint prose says "∃ g ≠ 0, p ∈ image of A_g[X_1,…,X_n] → K[X_1,…,X_n]". Lean uses `IsLocalization.map (FractionRing A) (RingHom.id A) hle` rather than `algebraMap (Localization.Away g) (FractionRing A)` — the `% NOTE (iter-008 encoding)` in the blueprint explicitly documents this well-typed encoding, which is mathematically identical.
- **Proof follows sketch**: yes — uses `IsLocalization.exist_integer_multiples` to find a common denominator, constructs the preimage polynomial scaled by the unit inverse.
- **Notes**: Proof is sorry-free. Blueprint's encoding note is accurate and necessary for a reader.

### `\lean{AlgebraicGeometry.GenericFreeness.exists_localizationAway_finite_mvPolynomial}` (chapter: `lem:gf_noether_clear_denominators`)
- **Lean target exists**: yes
- **Signature matches**: yes — matches the `% LEAN SIGNATURE` comment in the blueprint verbatim: five existentials (`n`, `g`, `g ≠ 0`, `Algebra A_g B_g` instance, `φ : MvPolynomial (Fin n) A_g →ₐ B_g`), then `Function.Injective φ ∧ (letI := φ.toAlgebra; Module.Finite ...)`.
- **Proof follows sketch**: partial — Step 1 (Noether normalisation over K) is implemented and axiom-clean; Step 2 (denominator-clearing fold over integral-dependence equations, the "Mathlib-absent residue") carries a `sorry` at line 516.
- **Notes**: The sorry is on the expected in-progress step. Blueprint statement block has `\leanok` (declaration exists) and proof block has no `\leanok` (proof not yet closed). State is consistent.

### `\lean{AlgebraicGeometry.GenericFreeness.gf_generic_rank_ses}` (chapter: `lem:gf_generic_rank_ses`)
- **Lean target exists**: yes
- **Signature matches**: yes — matches the `% LEAN SIGNATURE` comment exactly.
- **Proof follows sketch**: yes — constructs a `K`-basis of `NK`, clears denominators to get `v : Fin m → N`, establishes linear independence over `K` then over `P`, builds `φ := Fintype.linearCombination P v`, proves injectivity via `LinearIndependent P v`, proves cokernel torsion by clearing denominators and using `IsLocalizedModule.eq_zero_iff`.
- **Notes**: Proof is sorry-free.

### `\lean{Submodule.annihilator_top_inter_nonZeroDivisors}` (chapter: `lem:annihilator_meets_nonZeroDivisors`, Mathlib)
- **Lean target exists**: yes (Mathlib); `\mathlibok`.
- **Signature matches**: yes.
- **Proof follows sketch**: N/A.

### `\lean{AlgebraicGeometry.GenericFreeness.gf_torsion_annihilator}` (chapter: `lem:gf_torsion_annihilator`)
- **Lean target exists**: yes
- **Signature matches**: yes — matches `% LEAN SIGNATURE` comment exactly.
- **Proof follows sketch**: yes — applies `Submodule.annihilator_top_inter_nonZeroDivisors`, extracts the non-zero-divisor, converts via `nonZeroDivisors.ne_zero`.
- **Notes**: Proof is sorry-free.

### `\lean{AlgebraicGeometry.GenericFreeness.gf_nagata_monic_lastVar}` (chapter: `lem:gf_nagata_monic_lastVar`)
- **Lean target exists**: yes
- **Signature matches**: yes — matches `% LEAN SIGNATURE` comment exactly: `(A : Type*) [CommRing A] [IsDomain A] (m : ℕ) (F : MvPolynomial (Fin (m + 1)) A) (hF : F ≠ 0) : ∃ (g : A) (_ : g ≠ 0) (e : MvPolynomial (Fin (m + 1)) A ≃ₐ[A] MvPolynomial (Fin (m + 1)) A), IsUnit (...)`.
- **Proof follows sketch**: yes — applies the domain-adapted `T_leadingcoeff_eq` to extract the top-degree coefficient `c = coeff v F`, sets `g := c`, uses `IsLocalization.Away.algebraMap_isUnit` to get the unit, then proves the leading-coefficient claim. The private `NagataNormalization` section (lines 662–822) is the full implementation of the Nagata machinery described in the blueprint.
- **Notes**: Proof is sorry-free. The private helper cascade (`finSuccEquiv_map_comm`, `T1`, `T`, `degreeOf_zero_t`, etc.) is not blueprint-covered, correctly being `private` internal scaffolding.

### `\lean{Polynomial.Monic.finite_quotient}` (chapter: `lem:polynomial_monic_quotient_finite`, Mathlib)
- **Lean target exists**: yes (Mathlib); `\mathlibok`.
- **Signature matches**: yes.
- **Proof follows sketch**: N/A.

### `\lean{AlgebraicGeometry.GenericFreeness.mvPolynomial_quotient_finite_of_monic_lastVar}` (chapter: `lem:gf_mvPolynomial_quotient_finite_monic`)
- **Lean target exists**: yes
- **Signature matches**: yes — the blueprint `% LEAN SIGNATURE` block (iter-012 resync, F-3a) now matches the landed declaration verbatim: conclusion is `RingHom.Finite` of the composite `MvPolynomial (Fin n) R →+* MvPolynomial (Fin (n+1)) R ⧸ Ideal.span {p}`.
- **Proof follows sketch**: yes — rescales `finSuccEquiv p` by `hp.unit⁻¹` to get a monic polynomial, applies `Polynomial.Monic.finite_quotient`, transports finiteness along the `S`-linear isomorphism `ψ`.
- **Notes**: Proof is sorry-free. The iter-012 blueprint resync (`% NOTE (iter-012 resync, F-3a)`) correctly documents the `RingHom.Finite` vs `Module.Finite` encoding change. The private helper `finSuccEquiv_rename_succ` (line 829) is used here and correctly omitted from blueprint coverage.

### `\lean{AlgebraicGeometry.GenericFreeness.gf_torsion_reindex}` (chapter: `lem:gf_torsion_reindex`)
- **Lean target exists**: yes
- **Signature matches**: yes — matches `% LEAN SIGNATURE` comment exactly (with the 7-existential form including the three module-structure witnesses).
- **Proof follows sketch**: partial — L5b.1 (annihilator), L5b.2 (Nagata), L5b.3 (elimination) are all assembled. The remaining assembly — base-changing `e` to `ebar`, transporting finiteness through the ring isomorphism `ψ : Pg/(Fg) ≃+* Pg/(G)`, and transporting the module structures to the goal's `LocalizedModule (Submonoid.powers g) T` — carries a `sorry` at line 1016.
- **Notes**: The in-code roadmap (lines 1002–1015) spells out the remaining five steps (a)–(e) explicitly. Blueprint proof sketch (lines 844–873) matches. State is acknowledged in-progress.
  - Minor: the comment at line 1003 writes `ebar : Pg ≃ₐ[A] Pg` but should be `≃ₐ[A_g] Pg` (since `e` is an `A`-automorphism but the basechange targets `A_g`). This is a typo in a proof-strategy comment, not the formal type.
  - Minor: line 1009 says `Module.Finite R (Pg/(Fg))` but `mvPolynomial_quotient_finite_of_monic_lastVar` yields `RingHom.Finite`, not `Module.Finite`. Consistent with the iter-012 resync flag in the blueprint — the Lean roadmap comment predates the resync; it describes the right structure but uses older notation.

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_polynomial}` (chapter: `lem:gf_polynomial_core`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(A : Type u) ... (d : ℕ) (N : Type u) ...` with shared universe `u` as required by the blueprint's `% NOTE (iter-008 signature)`.
- **Proof follows sketch**: partial — base case `d = 0` is implemented and axiom-clean; the torsion sub-case `N_K = 0` redirects to `exists_free_localizationAway_of_torsion`. The generic-rank dévissage (inductive step, steps 1–5 from the blueprint proof) carries a `sorry` at line 1101, pending `gf_torsion_reindex` being closed.
- **Notes**: The Lean comment (lines 1084–1101) explains exactly which steps are in hand (generic-rank SES via `gf_generic_rank_ses`) and which are blocked on `gf_torsion_reindex`. State is consistent with blueprint.

### `\lean{AlgebraicGeometry.GenericFreeness.exists_flat_localizationAway_of_finite}` (chapter: `lem:gf_flat_finite`)
- **Lean target exists**: yes
- **Signature matches**: yes — `∃ f : A, f ≠ 0 ∧ Module.Flat (Localization.Away f) (LocalizedModule (Submonoid.powers f) M)`.
- **Proof follows sketch**: yes — applies `exists_free_localizationAway_of_finite` then `Module.Flat.of_free`.
- **Notes**: Proof is sorry-free.

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_moduleFinite}` (chapter: `lem:gf_free_moduleFinite`)
- **Lean target exists**: yes
- **Signature matches**: yes.
- **Proof follows sketch**: yes — `Module.Finite.trans B M` to get A-finiteness, then `exists_free_localizationAway_of_finite`.
- **Notes**: Proof is sorry-free.

### `\lean{AlgebraicGeometry.GenericFreeness.genericFlatnessAlgebraic}` (chapter: `thm:generic_flatness_algebraic`)
- **Lean target exists**: yes
- **Signature matches**: yes — matches the `% INTENDED LEAN SIGNATURE` block verbatim.
- **Proof follows sketch**: partial — the "primary route" (M module-finite over A) is implemented axiom-clean using `exists_free_localizationAway_of_finite`. The "surviving residue" (M finite over a finite-type B, not over A) carries a `sorry` at line 1168, pending the full dévissage assembly.
- **Notes**: Blueprint proof outline (lines 97–140) matches the proof structure exactly.

### `\lean{AlgebraicGeometry.genericFlatness}` (chapter: `thm:generic_flatness`)
- **Lean target exists**: yes
- **Signature matches**: yes — matches the `% LEAN SIGNATURE HEADER` comment verbatim: `{S X : Scheme.{u}} [IsIntegral S] [IsLocallyNoetherian S] (p : X ⟶ S) [LocallyOfFiniteType p] (F : X.Modules) [F.IsQuasicoherent] [F.IsFiniteType] : ∃ (V : S.Opens), (V : Set S).Nonempty ∧ ∀ ...`.
- **Proof follows sketch**: partial — the geometric starting point (extracting a non-empty affine open `U₀ ⊆ S` via `exists_isAffineOpen_mem_and_subset`) is implemented; the full assembly (Steps 1–4: finite affine cover, section modules, `genericFlatnessAlgebraic` per patch, flatness-from-freeness) carries a `sorry` at line 1235.
- **Notes**: Blueprint proof sketch (lines 1103–1138) is detailed and matches the Lean's in-code assembly roadmap (lines 1208–1234).

---

## Red flags

No red-flag section triggered. Details:

- **Placeholder/suspect bodies**: Five declarations carry `sorry` bodies (`exists_localizationAway_finite_mvPolynomial`, `gf_torsion_reindex`, `exists_free_localizationAway_polynomial`, `genericFlatnessAlgebraic`, `genericFlatness`). All five are in an acknowledged in-progress state: the blueprint marks their statement blocks with `\leanok` (declaration exists, possibly with sorry) and leaves their proof blocks without `\leanok` (proof not yet closed). No sorry is on a declaration the blueprint claims is fully proved.
- **Excuse-comments**: None. The in-code comments at lines 1002–1015, 1084–1101, etc. explain the remaining proof steps constructively — they are roadmaps, not excuses for wrong code.
- **Axioms / Classical.choice**: No new `axiom` declarations. No suspect `Classical.choice _` on non-trivial claims.
- **Weakened-wrong definitions**: None. Every definition uses the correct Mathlib predicates: `Module.Flat`, `Module.Free`, `LocalizedModule`, `Localization.Away`, `MvPolynomial`, `Algebra.FiniteType`.

---

## Unreferenced declarations (informational)

The following declarations appear in the Lean file but have no `\lean{...}` blueprint reference. All are `private`:

| Declaration | Kind | Notes |
|---|---|---|
| `finSuccEquiv_map_comm` | `private theorem` | Helper for `gf_nagata_monic_lastVar` proof |
| `lt_up` | `private lemma` | Nagata degree bound |
| `T1` | `private noncomputable abbrev` | Nagata substitution ring map |
| `t1_comp_t1_neg` | `private lemma` | Invertibility of `T1` |
| `T` | `private noncomputable abbrev` | Nagata automorphism as `AlgEquiv` |
| `sum_r_mul_ne` | `private lemma` | Injectivity of the digit-encoding |
| `degreeOf_zero_t` | `private lemma` | Degree after Nagata transform |
| `degreeOf_t_ne_of_ne` | `private lemma` | Distinctness of leading degrees |
| `leadingCoeff_finSuccEquiv_t` | `private lemma` | Leading coefficient of Nagata image |
| `T_leadingcoeff_eq` | `private lemma` | Top-degree coefficient extraction |
| `finSuccEquiv_rename_succ` | `private theorem` | Compatibility of `finSuccEquiv` with `rename Fin.succ` |

All are `private`, implementing the domain-adapted Nagata normalisation infrastructure for `gf_nagata_monic_lastVar`. Their omission from the blueprint is correct — they are implementation details, not mathematical content the blueprint needs to pin.

---

## Blueprint adequacy for this file

### Coverage
18/18 substantive public declarations have a corresponding `\lean{...}` block in the chapter. 3 Mathlib anchors are correctly marked `\mathlibok`. 11 `private` helpers are uncovered (acceptable). Coverage: **18/18 public + 3 Mathlib = complete**.

### Proof-sketch depth
**Adequate**, with one informational note:

- All sorry-free declarations (13) have proof sketches that match the implemented proof structures. The `gf_generic_rank_ses` proof sketch (lines 572–596) is particularly detailed and was faithfully followed in the Lean.
- The in-progress declarations have proof sketches detailed enough to guide formalization:
  - `gf_torsion_reindex` (lines 843–874): four named steps (Annihilator, Nagata normalisation, Elimination, Transitivity) — adequate; the Lean comment identifies exactly which bookkeeping steps remain.
  - `exists_free_localizationAway_polynomial` (lines 911–982): five enumerated steps with explicit references — adequate.
  - `genericFlatnessAlgebraic` (lines 97–140): primary route + fallback dévissage with `\uses` chain — adequate.
  - `genericFlatness` (lines 1103–1138): four steps with API names — adequate.
  - `exists_localizationAway_finite_mvPolynomial` (lines 481–521): three steps, the denominator-clearing Finset fold explicitly described — adequate but this step (Step 2) is the current sorry; the prose level is high but correct.

### Hint precision
**Precise**. All `\lean{...}` pins resolve to declared names in the Lean file with matching namespaces (`AlgebraicGeometry.GenericFreeness.*`, `AlgebraicGeometry.genericFlatness*`). Encoding deviations (e.g., `IsLocalization.map` form for `gf_clear_one_denominator`, `RingHom.Finite` for `mvPolynomial_quotient_finite_of_monic_lastVar`) are documented in `% NOTE` or `% LEAN SIGNATURE` comments and are mathematically equivalent.

### Generality
**Matches need**. No parallel API was written because the blueprint was too narrow. The Lean follows the blueprint's generality in all cases.

### Informational: proof-block `\leanok` gap
13 declarations have sorry-free Lean proofs but their blueprint proof blocks lack `\leanok` markers. By the project's `\leanok` convention (proof-block `\leanok` = proof closed, no sorry), these blocks should carry `\leanok`. This may indicate that `sync_leanok` has not yet been run on this iteration, or that the project currently only uses statement-block `\leanok`. This is not a blueprint-adequacy failure, but it means the blueprint does not accurately advertise which proofs are axiom-clean.

Affected declarations (sorry-free, proof block lacks `\leanok`):
`exists_free_localizationAway_of_finite`, `exists_flat_localizationAway_of_finite`, `exists_free_localizationAway_of_moduleFinite`, `exists_free_localizationAway_of_torsion`, `exact_localizedModule_powers_of_shortExact`, `free_localizationAway_of_free_of_eq_mul`, `free_of_shortExact_of_free_free`, `exists_free_localizationAway_of_shortExact`, `gf_clear_one_denominator`, `gf_generic_rank_ses`, `gf_torsion_annihilator`, `gf_nagata_monic_lastVar`, `mvPolynomial_quotient_finite_of_monic_lastVar`.

### Recommended chapter-side actions
1. After `sync_leanok` runs (or is next triggered), verify the 13 sorry-free declarations' proof blocks receive `\leanok` markers.
2. Update the in-code Lean roadmap comment in `gf_torsion_reindex` (line 1003) to correct the typo `≃ₐ[A] Pg` → `≃ₐ[A_g] Pg`, and line 1009 to note `RingHom.Finite` rather than `Module.Finite` (the blueprint `% NOTE` already flags this; the Lean comment should be kept in sync).

---

## Severity summary

### must-fix-this-iter
*None.*

All five in-progress sorries (`exists_localizationAway_finite_mvPolynomial`, `gf_torsion_reindex`, `exists_free_localizationAway_polynomial`, `genericFlatnessAlgebraic`, `genericFlatness`) are on declarations whose blueprint statement blocks carry `\leanok` (indicating scaffolded-in-progress state) and whose proof blocks carry no `\leanok` (proof not yet claimed closed). No sorry contradicts any blueprint claim of completeness.

### major
*None.*

### minor
1. **Proof-block `\leanok` gap**: 13 sorry-free declarations have proof blocks missing `\leanok` in the blueprint — likely a `sync_leanok` scheduling issue, not a correctness problem. A blueprint-writing subagent pass (or the next `sync_leanok` run) should close this.
2. **In-code comment typos** (informational): `gf_torsion_reindex` line 1003 (`≃ₐ[A]` → `≃ₐ[A_g]`) and line 1009 (`Module.Finite` → `RingHom.Finite`). Not in formal Lean types; no correctness impact.

---

**Overall verdict**: The Lean file faithfully follows the blueprint in all formal respects — 18/18 `\lean{...}`-pinned declarations have matching signatures, 5 acknowledged in-progress sorries are consistent with the blueprint's `\leanok` markers, proof strategies follow the Nitsure §4 dévissage sketch, and no placeholder, axiom, weakened definition, or excuse-comment is present. The blueprint chapter is adequately detailed for guiding formalization. — 18 declarations checked, 0 red flags.
