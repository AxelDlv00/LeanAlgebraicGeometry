# Lean ↔ Blueprint Check Report

## Slug
gf-iter019

## Iteration
019

## Files audited
- Lean: `AlgebraicJacobian/Picard/FlatteningStratification.lean` (1867 lines)
- Blueprint: `blueprint/src/chapters/Picard_FlatteningStratification.tex` (1526 lines)

---

## Per-declaration

### Mathlib anchors (7 declarations marked `\mathlibok`)

All seven Mathlib anchors are correctly tagged `\mathlibok` and have no project proof obligation:
- `Module.FinitePresentation.exists_free_localizedModule_powers` (`lem:fp_free_descent`)
- `IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime` (`lem:noeth_prime_filtration`)
- `exists_finite_inj_algHom_of_fg` (`lem:noether_normalization_fg`)
- `Submodule.annihilator_top_inter_nonZeroDivisors` (`lem:annihilator_meets_nonZeroDivisors`)
- `Polynomial.Monic.finite_quotient` (`lem:polynomial_monic_quotient_finite`)
- `IsLocalization.Away.mul_of_associated` (`lem:isLocalization_away_mul_of_associated`)
- `Module.Free.of_ringEquiv` (`lem:module_free_of_ringEquiv`)

No action required on any of these.

---

### Non-private, axiom-clean declarations (21 declarations)

The following are public, non-`private` declarations whose proofs contain no `sorry`:

#### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_finite}` (`lem:gf_finite_module`)
- **Lean target exists**: yes (line 105)
- **Signature matches**: yes — `(A M : Type*) [CommRing A] [IsDomain A] [IsNoetherianRing A] [AddCommGroup M] [Module A M] [Module.Finite A M] : ∃ f : A, f ≠ 0 ∧ Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) M)`
- **Proof follows sketch**: yes — uses `Module.FinitePresentation.exists_free_localizedModule_powers` at the fraction field `Frac A`, then descends
- **notes**: axiom-clean

#### `\lean{AlgebraicGeometry.GenericFreeness.exists_flat_localizationAway_of_finite}` (`lem:gf_flat_finite`)
- **Lean target exists**: yes (line 120)
- **Signature matches**: yes
- **Proof follows sketch**: yes — one-liner via `Module.Flat.of_free`
- **notes**: axiom-clean

#### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_moduleFinite}` (`lem:gf_free_moduleFinite`)
- **Lean target exists**: yes (line 135)
- **Signature matches**: yes — adds `[CommRing B] [Algebra A B] [Module.Finite A B] [Module B M] [Module.Finite B M] [IsScalarTower A B M]`
- **Proof follows sketch**: yes — `Module.Finite.trans B M`
- **notes**: axiom-clean

#### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_torsion}` (`lem:gf_torsion_base`)
- **Lean target exists**: yes (line 168)
- **Signature matches**: yes — hypothesis is `Subsingleton (LocalizedModule (nonZeroDivisors A) M)`, which correctly encodes `M_K = 0`
- **Proof follows sketch**: yes — picks generators, products their `A`-annihilators, deduces `f • M = 0`, then `M_f` subsingleton is free
- **notes**: axiom-clean

#### `\lean{AlgebraicGeometry.GenericFreeness.exact_localizedModule_powers_of_shortExact}` (`lem:gf_splice_shortExact_localized_exact`)
- **Lean target exists**: yes (line 220)
- **Signature matches**: yes — returns the triple (injective, surjective, exact) for the localised maps
- **Proof follows sketch**: yes — one refine calling the three `LocalizedModule.map_*` lemmas
- **notes**: axiom-clean

#### `\lean{AlgebraicGeometry.GenericFreeness.free_localizationAway_of_free_of_eq_mul}` (`lem:gf_splice_shortExact_free_transport`)
- **Lean target exists**: yes (line 248)
- **Signature matches**: yes
- **Proof follows sketch**: yes — base-change route via `IsLocalization.Away.awayToAwayLeft` and `IsBaseChange.free`
- **notes**: axiom-clean; proof is substantially more detailed than the blueprint sketch (uses explicit `IsBaseChange.of_comp` chain), but mathematically correct

#### `\lean{AlgebraicGeometry.GenericFreeness.free_of_shortExact_of_free_free}` (`lem:gf_splice_shortExact_split`)
- **Lean target exists**: yes (line 336)
- **Signature matches**: yes
- **Proof follows sketch**: yes — projective lifting + `splitSurjectiveEquiv` + `Module.Free.of_equiv`
- **notes**: axiom-clean

#### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_shortExact}` (`lem:gf_splice_shortExact`)
- **Lean target exists**: yes (line 360)
- **Signature matches**: yes
- **Proof follows sketch**: yes — assembles L3a, L3b (both ends), L3c
- **notes**: axiom-clean

#### `\lean{AlgebraicGeometry.GenericFreeness.gf_clear_one_denominator}` (`lem:gf_clear_one_denominator`)
- **Lean target exists**: yes (line 409)
- **Signature matches**: yes — the `IsLocalization.map` encoding instead of the literal `algebraMap (Localization.Away g) (FractionRing A)` is correctly documented in the blueprint `% NOTE (encoding)` comment
- **Proof follows sketch**: yes — `IsLocalization.exist_integer_multiples` over the support, builds preimage polynomial
- **notes**: axiom-clean; the encoding deviation from the blueprint's "simple" form is correctly documented in both places

#### `\lean{AlgebraicGeometry.GenericFreeness.gf_generic_rank_ses}` (`lem:gf_generic_rank_ses`)
- **Lean target exists**: yes (line 768)
- **Signature matches**: yes — full signature with `Fintype.linearCombination P v` as the map `φ`
- **Proof follows sketch**: yes — takes `FractionRing(P_d)`-basis, clears denominators, linear independence, torsion cokernel
- **notes**: axiom-clean; proof is detailed and follows the blueprint step-by-step

#### `\lean{AlgebraicGeometry.GenericFreeness.gf_torsion_annihilator}` (`lem:gf_torsion_annihilator`)
- **Lean target exists**: yes (line 875)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `Submodule.annihilator_top_inter_nonZeroDivisors` + domain → nonzero-divisor = nonzero
- **notes**: axiom-clean

#### `\lean{AlgebraicGeometry.GenericFreeness.gf_nagata_monic_lastVar}` (`lem:gf_nagata_monic_lastVar`)
- **Lean target exists**: yes (line 1034)
- **Signature matches**: yes — `∃ (g : A) (_ : g ≠ 0) (e : ... ≃ₐ[A] ...), IsUnit (...).leadingCoeff`
- **Proof follows sketch**: yes — calls `T_leadingcoeff_eq` to find the top-degree monomial's coefficient, inverts it via `IsLocalization.Away.algebraMap_isUnit`
- **notes**: axiom-clean; the proof correctly adapts the field argument from Mathlib's `NoetherNormalization` to a domain

#### `\lean{AlgebraicGeometry.GenericFreeness.mvPolynomial_quotient_finite_of_monic_lastVar}` (`lem:gf_mvPolynomial_quotient_finite_monic`)
- **Lean target exists**: yes (line 1091)
- **Signature matches**: yes — `RingHom.Finite` of the composite map; the blueprint `% NOTE (F-3a)` comment correctly documents this encoding
- **Proof follows sketch**: yes — rescales to monic, `Polynomial.Monic.finite_quotient`, transport via `finSuccEquiv` iso
- **notes**: axiom-clean

#### `\lean{AlgebraicGeometry.GenericFreeness.pullbackModuleAddEquiv}` / `finite_of_pullbackModuleAddEquiv` / `pullback_isScalarTower` (`lem:gf_pullback_module_transport`)
- **Lean target exists**: yes (lines 1150, 1168, 1183)
- **Signature matches**: yes — three lemmas covering the three claims of `lem:gf_pullback_module_transport`
- **Proof follows sketch**: yes
- **notes**: axiom-clean

#### `\lean{AlgebraicGeometry.GenericFreeness.finite_of_quotientRingEquiv}` (`lem:gf_finite_of_quotient_ringequiv`)
- **Lean target exists**: yes (line 1200)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `AlgEquiv.ofRingEquiv` + `Module.Finite.trans`
- **notes**: axiom-clean

#### `\lean{AlgebraicGeometry.GenericFreeness.isLocalizedModule_restrictScalars}` (`lem:gf_islocalizedmodule_restrictscalars`)
- **Lean target exists**: yes (line 1218)
- **Signature matches**: yes
- **Proof follows sketch**: yes — verifies the three `IsLocalizedModule` axioms by descending from the image-submonoid localisation
- **notes**: axiom-clean

#### `\lean{AlgebraicGeometry.GenericFreeness.gf_torsion_reindex}` (`lem:gf_torsion_reindex`)
- **Lean target exists**: yes (line 1265)
- **Signature matches**: yes — the dropped `Module A_g T_g` existential is correctly noted in the blueprint `% NOTE`
- **Proof follows sketch**: yes (detailed assembly of L5b.1, L5b.2, L5b.3 with the `P`-localisation `LocalizedModule MC T` as intermediate)
- **notes**: axiom-clean; this was a heavy formalization, the blueprint's "Action-diamond subtlety" and "Localisation transport" sections were clearly needed and are present

#### `\lean{AlgebraicGeometry.GenericFreeness.free_localizationAway_of_away_tower}` (`lem:gf_away_tower_descent`)
- **Lean target exists**: yes (line 1508)
- **Signature matches**: yes — uses universe `(A T : Type u)`, consistent with the blueprint `% NOTE (signature)` comment about shared universes
- **Proof follows sketch**: yes — clears denominator, `mul_of_associated`, `IsBaseChange.comp`, `Free.of_equiv'`
- **notes**: axiom-clean; the blueprint note that the "no packaged lemma" remark was superseded by `IsBaseChange.comp` is correctly reflected

#### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_polynomial}` (`lem:gf_polynomial_core`)
- **Lean target exists**: yes (line 1630)
- **Signature matches**: yes — universe-shared `(A : Type u) (N : Type u)` per blueprint `% NOTE (signature)` comment
- **Proof follows sketch**: yes — strong induction on `d` with `generalizing A N`, base case `d = 0` via `isEmptyAlgEquiv`, inductive step via `gf_generic_rank_ses` + `gf_torsion_reindex` + IH at `Localization.Away g` + `free_localizationAway_of_away_tower` + splice
- **notes**: axiom-clean; this is a major formalization achievement this iter

---

### Declarations with `sorry` bodies

#### `\lean{AlgebraicGeometry.GenericFreeness.exists_localizationAway_finite_mvPolynomial}` (`lem:gf_noether_clear_denominators`)
- **Lean target exists**: yes (line 505)
- **Signature matches**: yes — signature including the `Algebra A_g B_g` existential matches the blueprint `% LEAN SIGNATURE` block verbatim
- **Proof follows sketch**: partial — the injectivity half (`hφ_inj`, lines 719–738) is axiom-clean and follows Steps 3a/3b of the blueprint. The finiteness half (`hfin`, line 751–754) has `sorry`.
- **notes**: `sorry` at line 754 (`have hfin : ... := by sorry`). The Lean roadmap comment correctly identifies that `g0` must be refined to `g0 * g1` (clearing integral-dependence denominators via a `Finset.fold` of `gf_clear_one_denominator`) before the blueprint Step 3c can be assembled. This is the genuine remaining gap: the module-finiteness of `B_g` over `A_g[X_1,...,X_n]` via `φ.toAlgebra`.

#### `\lean{AlgebraicGeometry.genericFlatnessAlgebraic}` (`thm:generic_flatness_algebraic`)
- **Lean target exists**: yes (line 1767)
- **Signature matches**: yes — matches the blueprint `% INTENDED LEAN SIGNATURE` comment exactly
- **Proof follows sketch**: partial — the `Module.Finite A M` primary route (line 1775–1777) is axiom-clean (calls `exists_free_localizationAway_of_finite`). The `sorry` at line 1797 covers the "surviving residue" case: when `M` is finite over a finite-type `B` but not module-finite over `A`.
- **notes**: The dévissage assembly (prime-filtration induction principle + L3 + L4 + L5) is the remaining wiring, correctly described in the Lean comment. The `sorry` is consistent with the blueprint's "Surviving residue" section.

#### `\lean{AlgebraicGeometry.genericFlatness}` (`thm:generic_flatness`)
- **Lean target exists**: yes (line 1829)
- **Signature matches**: yes — matches the detailed blueprint `% LEAN SIGNATURE HEADER` comment: `[IsIntegral S] [IsLocallyNoetherian S]`, `[F.IsQuasicoherent] [F.IsFiniteType]`, open `V` with `Nonempty` and affine-local `Module.Flat` conclusion
- **Proof follows sketch**: partial — opens `U₀` (line 1843–1845) is axiom-clean. The `sorry` at line 1864 covers the entire geometric assembly (finite affine cover of `p⁻¹(U₀)`, reading off `M_j`, applying `genericFlatnessAlgebraic`, taking common basic open `D(∏ f_j)`).
- **notes**: the blueprint's Step 1–4 proof sketch is detailed and correct; the Lean comment mirrors it accurately. The sorry is the full geometric plumbing on top of `genericFlatnessAlgebraic`.

---

### Private declarations with `\lean{...}` blueprint pins

**All 11 of the following declarations are declared `private` in Lean but are referenced by their "public" qualified name in the blueprint's `\lean{...}` pins.** In Lean 4, `private` gives the declaration a mangled environment name; the clean name (e.g. `AlgebraicGeometry.GenericFreeness.T1`) does not exist in the public environment. The `sync_leanok` phase, which looks up each `\lean{...}` declaration by name, will fail to find any of these, and `\leanok` will not be added even though the proofs are axiom-clean.

| Blueprint label | `\lean{...}` pin | Lean declaration | Status |
|---|---|---|---|
| `lem:gf_finSuccEquiv_map_comm` | `...GenericFreeness.finSuccEquiv_map_comm` | `private theorem finSuccEquiv_map_comm` (line 907) | axiom-clean, private |
| `lem:gf_lt_up` | `...GenericFreeness.lt_up` | `private lemma lt_up` (line 929) | axiom-clean, private |
| `def:gf_nagata_T1` | `...GenericFreeness.T1` | `private noncomputable abbrev T1` (line 933) | axiom-clean, private |
| `lem:gf_t1_comp_t1_neg` | `...GenericFreeness.t1_comp_t1_neg` | `private lemma t1_comp_t1_neg` (line 938) | axiom-clean, private |
| `def:gf_nagata_T` | `...GenericFreeness.T` | `private noncomputable abbrev T` (line 942) | axiom-clean, private |
| `lem:gf_sum_r_mul_ne` | `...GenericFreeness.sum_r_mul_ne` | `private lemma sum_r_mul_ne` (line 946) | axiom-clean, private |
| `lem:gf_degreeOf_zero_t` | `...GenericFreeness.degreeOf_zero_t` | `private lemma degreeOf_zero_t` (line 955) | axiom-clean, private |
| `lem:gf_degreeOf_t_ne_of_ne` | `...GenericFreeness.degreeOf_t_ne_of_ne` | `private lemma degreeOf_t_ne_of_ne` (line 971) | axiom-clean, private |
| `lem:gf_leadingCoeff_finSuccEquiv_t` | `...GenericFreeness.leadingCoeff_finSuccEquiv_t` | `private lemma leadingCoeff_finSuccEquiv_t` (line 978) | axiom-clean, private |
| `lem:gf_T_leadingcoeff_eq` | `...GenericFreeness.T_leadingcoeff_eq` | `private lemma T_leadingcoeff_eq` (line 999) | axiom-clean, private |
| `lem:gf_finSuccEquiv_rename_succ` | `...GenericFreeness.finSuccEquiv_rename_succ` | `private theorem finSuccEquiv_rename_succ` (line 1067) | axiom-clean, private |

All 11 proofs are axiom-clean; the issue is purely the `private` keyword conflicting with the blueprint's `\lean{...}` lookup infrastructure.

---

## Red flags

### Placeholder / suspect bodies

- `GenericFreeness.exists_localizationAway_finite_mvPolynomial` at line 754: `have hfin : letI := φ.toAlgebra; Module.Finite ... := by sorry`. Blueprint (`lem:gf_noether_clear_denominators`) claims a full proof. The `sorry` covers the integral-dependence-clearing assembly (refining `g0` to `g0 * g1`).

- `genericFlatnessAlgebraic` at line 1797: `sorry` covers the surviving-residue dévissage assembly for the finite-type-but-not-module-finite case. Blueprint (`thm:generic_flatness_algebraic`) claims the full theorem.

- `genericFlatness` at line 1864: `sorry` covers the entire geometric assembly. Blueprint (`thm:generic_flatness`) claims the full theorem.

### Axioms / Classical.choice on non-trivial claims
None found beyond the `sorry` items above. No `axiom` declarations present.

### Excuse-comments
None found. All `sorry`-adjacent comments are legitimate roadmap/technical-gap explanations, not statements that "wrong code works for now."

---

## Unreferenced declarations (informational)

### `AlgebraicGeometry.GenericFreeness.isLocalization_lift_injective` (line 472)
- Not referenced by any `\lean{...}` blueprint block.
- Substantive theorem: injectivity of `IsLocalization.lift` when both the source localisation map and the target ring map are injective. Used twice inside `exists_localizationAway_finite_mvPolynomial` for the injectivity of `ν` and `ψ`.
- The blueprint's proof of L4 Step 3a describes the injectivity of `ν` but calls it a consequence of "a localisation of a domain at non-zerodivisors is injective into any further such localisation" — it's a named helper that could plausibly earn a `\lean{...}` block (minor; helper-only is acceptable).

---

## Blueprint adequacy for this file

### Coverage
- **Project declarations**: 33 total (22 non-private + 11 private); all have `\lean{...}` blocks.
- **Mathlib anchors**: 7; all correctly marked `\mathlibok`.
- **Unreferenced helpers**: 1 (`isLocalization_lift_injective`).
- **Coverage ratio**: 33/34 project declarations are blueprint-referenced. The one unreferenced helper is plausibly internal.

### Proof-sketch depth
**Adequate** for the axiom-clean declarations. Notably:
- The "Action-diamond subtlety" and "Localisation transport" subsections of `lem:gf_torsion_reindex` are unusually detailed and demonstrably necessary — the Lean proof follows them very closely.
- The `lem:gf_polynomial_core` induction structure (strong induction with generalised base domain) is precisely specified in the `% LEAN PROOF STRUCTURE` comment and the prose; this was load-bearing for the correct `generalizing A N` tactic.
- The `exists_localizationAway_finite_mvPolynomial` proof sketch covers all three steps (Noether normalisation, denominator clearing, AlgHom assembly). The sorry in `hfin` is because the integral-dependence clearing assembly across a finite generator set was not yet assembled, but the blueprint does describe it (Step 2, "fold over the finite set of (generator, coefficient) pairs"). **Verdict: adequate; sorry is a proof residue, not a blueprint gap.**

**Under-specified**: none identified (all sorry-bearing gaps are described in the blueprint).

### Hint precision
**Mostly precise**. Notable deviations are all documented:
- `lem:gf_clear_one_denominator`: the `\lean{...}` pin names `gf_clear_one_denominator`, which uses `IsLocalization.map` instead of `algebraMap (Localization.Away g) (FractionRing A)` — the blueprint `% NOTE (encoding)` comment explains this correctly.
- `lem:gf_noether_clear_denominators`: the LEAN SIGNATURE block lists the `(_ : Algebra A_g B_g)` existential — this matches what was actually landed.
- `lem:gf_torsion_reindex`: the dropped `Module A_g T_g` existential is documented.
- `lem:gf_away_tower_descent`: the universe constraint is documented.

**Problematic**: the 11 private declarations are pinned with names that will not resolve. These `\lean{...}` hints are technically wrong (the names don't exist publicly).

### Generality
**Matches need**: no cases where the Lean needed a different level of generality than the blueprint specified.

### Recommended chapter-side actions
1. **Private-name fix (major)**: Either remove `private` from the 11 Nagata-normalization declarations (`T1`, `T`, `t1_comp_t1_neg`, `lt_up`, `sum_r_mul_ne`, `degreeOf_zero_t`, `degreeOf_t_ne_of_ne`, `leadingCoeff_finSuccEquiv_t`, `T_leadingcoeff_eq`, `finSuccEquiv_map_comm`, `finSuccEquiv_rename_succ`) — or, if keeping them private is intentional (e.g. to avoid polluting the namespace), remove their `\lean{...}` blueprint pins and replace with prose-only blocks. The `sync_leanok` phase will be broken for these 11 entries until this is resolved.

2. **L4 finiteness sorry**: When `exists_localizationAway_finite_mvPolynomial` is proved, no blueprint prose changes are needed (the sketch already covers the assembly). The `\leanok` marker should be added by `sync_leanok` once the sorry is gone.

3. **Minor**: Consider adding a `\lean{AlgebraicGeometry.GenericFreeness.isLocalization_lift_injective}` block with a short description (used as the injectivity-of-localisation-lift helper for `ν` and `ψ`). Low priority.

---

## Severity summary

### Must-fix-this-iter
1. **`GenericFreeness.exists_localizationAway_finite_mvPolynomial` line 754**: `:= sorry` in `hfin` (the finiteness half of L4). Blueprint `lem:gf_noether_clear_denominators` claims the full statement. Blocks `genericFlatnessAlgebraic` (which calls L4) and `genericFlatness` downstream.
2. **`genericFlatnessAlgebraic` line 1797**: `:= sorry` in the finite-type-not-module-finite branch. Blueprint `thm:generic_flatness_algebraic` claims the full theorem. Blocks `genericFlatness` downstream.
3. **`genericFlatness` line 1864**: `:= sorry` throughout (geometric form). Blueprint `thm:generic_flatness` claims the full theorem.

### Major
4. **11 private declarations with public `\lean{...}` pins**: `T1`, `T`, `t1_comp_t1_neg`, `lt_up`, `sum_r_mul_ne`, `degreeOf_zero_t`, `degreeOf_t_ne_of_ne`, `leadingCoeff_finSuccEquiv_t`, `T_leadingcoeff_eq`, `finSuccEquiv_map_comm`, `finSuccEquiv_rename_succ`. The `sync_leanok` phase cannot look up private names; `\leanok` will not be added for these 11 proved-and-axiom-clean declarations. Blueprint progress dashboard will show them as unformalized.

### Minor
5. `isLocalization_lift_injective` (line 472): substantive unreferenced helper; could earn a `\lean{...}` block.

---

**Overall verdict**: The file is in good mathematical shape — 21 declarations are axiom-clean and correctly aligned with the blueprint, and the sorry-bearing declarations (`exists_localizationAway_finite_mvPolynomial`, `genericFlatnessAlgebraic`, `genericFlatness`) have the right signatures and are genuinely hard residues, not weakened stubs — but 3 must-fix-this-iter sorries and 11 private declarations with broken `\lean{...}` pins require attention before the blueprint infrastructure accurately reflects formalization progress. — 33 declarations checked, 14 red flags (3 sorries + 11 private-name mismatches).
