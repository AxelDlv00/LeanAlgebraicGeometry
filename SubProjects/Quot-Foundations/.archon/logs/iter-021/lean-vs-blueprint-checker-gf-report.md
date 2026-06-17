# Lean ↔ Blueprint Check Report

## Slug
gf

## Iteration
021

## Files audited
- Lean: `AlgebraicJacobian/Picard/FlatteningStratification.lean` (2112 lines)
- Blueprint: `blueprint/src/chapters/Picard_FlatteningStratification.tex` (1547 lines)

---

## Per-declaration

### `\lean{AlgebraicGeometry.genericFlatnessAlgebraic}` (chapter: `thm:generic_flatness_algebraic`)
- **Lean target exists**: yes (`genericFlatnessAlgebraic`, line 1960)
- **Signature matches**: yes — `(A B M : Type*) [CommRing A] [IsDomain A] [IsNoetherianRing A] [CommRing B] [Algebra A B] [Algebra.FiniteType A B] [AddCommGroup M] [Module B M] [Module.Finite B M] [Module A M] [IsScalarTower A B M] : ∃ f : A, f ≠ 0 ∧ Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) M)` matches blueprint LEAN SIGNATURE exactly.
- **Proof follows sketch**: partial — the primary route (finite A-module) is closed and axiom-clean; the B/𝔭 cascade branch (`sorry` at line 2021) is the documented known residue. The code comment correctly describes the 4-step assembly needed (all of L1/L4/L5 now closed).
- **notes**: Documented `sorry`. Blueprint covers both routes in its proof sketch. Honest residue.

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_finite}` (chapter: `lem:gf_finite_module`)
- **Lean target exists**: yes (line 105)
- **Signature matches**: yes
- **Proof follows sketch**: yes — uses `Module.finitePresentation_of_finite` + `Module.FinitePresentation.exists_free_localizedModule_powers` at the non-zero divisors, exactly as described.
- **notes**: Sorry-free, axiom-clean.

### `\lean{Module.FinitePresentation.exists_free_localizedModule_powers}` (chapter: `lem:fp_free_descent`)
- **Lean target exists**: Mathlib (`\mathlibok`)
- **Signature matches**: N/A
- **Proof follows sketch**: N/A

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_torsion}` (chapter: `lem:gf_torsion_base`)
- **Lean target exists**: yes (line 168)
- **Signature matches**: yes
- **Proof follows sketch**: yes — product of finitely many annihilators via `LocalizedModule.subsingleton_iff` + `Submodule.span_induction`, matching the source's "product of annihilating elements" argument.
- **notes**: Sorry-free, axiom-clean.

### `\lean{IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime}` (chapter: `lem:noeth_prime_filtration`)
- **Lean target exists**: Mathlib (`\mathlibok`)
- **Signature matches**: N/A
- **Proof follows sketch**: N/A

### `\lean{AlgebraicGeometry.GenericFreeness.exact_localizedModule_powers_of_shortExact}` (chapter: `lem:gf_splice_shortExact_localized_exact`)
- **Lean target exists**: yes (line 220)
- **Signature matches**: yes — injectivity, surjectivity, and exactness as three conjuncts.
- **Proof follows sketch**: yes — direct `LocalizedModule.map_injective`, `map_surjective`, `map_exact`.
- **notes**: Sorry-free, axiom-clean.

### `\lean{AlgebraicGeometry.GenericFreeness.free_localizationAway_of_free_of_eq_mul}` (chapter: `lem:gf_splice_shortExact_free_transport`)
- **Lean target exists**: yes (line 248)
- **Signature matches**: yes — `{f f' f'' : A} (hf : f = f' * f'') ... Module.Free (Localization.Away f) ...`
- **Proof follows sketch**: yes — uses `IsLocalization.Away.awayToAwayLeft` + `IsBaseChange` + `IsBaseChange.of_comp` to show the finer localisation is a base change; matches blueprint's "A localisation of a free module is free" route.
- **notes**: Sorry-free, axiom-clean. The 70-line Lean proof is substantially more elaborate than the blueprint's two-sentence sketch (setting up the algebra tower and multiple scalar-tower instances is mechanically heavy). The chapter's prose is adequate in describing the *conclusion* but silent on the instance-engineering cost.

### `\lean{AlgebraicGeometry.GenericFreeness.free_of_shortExact_of_free_free}` (chapter: `lem:gf_splice_shortExact_split`)
- **Lean target exists**: yes (line 336)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `Module.projective_lifting_property` + `Function.Exact.splitSurjectiveEquiv` + `Module.Free.of_equiv`.
- **notes**: Sorry-free, axiom-clean.

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_shortExact}` (chapter: `lem:gf_splice_shortExact`)
- **Lean target exists**: yes (line 360)
- **Signature matches**: yes
- **Proof follows sketch**: yes — calls L3b then L3a then L3c; matches `\uses` chain.
- **notes**: Sorry-free, axiom-clean.

### `\lean{exists_finite_inj_algHom_of_fg}` (chapter: `lem:noether_normalization_fg`)
- **Lean target exists**: Mathlib (`\mathlibok`)
- **Signature matches**: N/A
- **Proof follows sketch**: N/A

### `\lean{AlgebraicGeometry.GenericFreeness.gf_clear_one_denominator}` (chapter: `lem:gf_clear_one_denominator`)
- **Lean target exists**: yes (line 409)
- **Signature matches**: yes — the blueprint's NOTE about the `IsLocalization.map` encoding (rather than a canonical `algebraMap`) matches the landed signature exactly.
- **Proof follows sketch**: yes — `IsLocalization.exist_integer_multiples` on the support, then constructs the scaled numerator polynomial with coefficient `unit⁻¹`, then extends coefficient-by-coefficient via `MvPolynomial.ext`.
- **notes**: Sorry-free, axiom-clean. Closed this iter.

### `\lean{AlgebraicGeometry.GenericFreeness.isLocalization_lift_injective}` (chapter: `lem:gf_isLocalization_lift_injective`)
- **Lean target exists**: yes (line 472)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `IsLocalization.lift_injective_iff` + injectivity of the localisation map and of `g`.
- **notes**: Sorry-free, axiom-clean.

### `\lean{AlgebraicGeometry.GenericFreeness.exists_localizationAway_finite_mvPolynomial}` (chapter: `lem:gf_noether_clear_denominators`)
- **Lean target exists**: yes (line 505)
- **Signature matches**: yes — the long LEAN SIGNATURE block in the blueprint matches verbatim including the `Algebra (Localization.Away g) (Localization.Away (algebraMap A B g))` binder.
- **Proof follows sketch**: partial — see **Red flags / blueprint adequacy** below for the step-2 divergence; steps 1, 3a–3c match the blueprint sketch.
- **notes**: Sorry-free, axiom-clean. Closed this iter. Signature exact. Step-2 route diverges from chapter description (see below).

### `\lean{AlgebraicGeometry.GenericFreeness.gf_generic_rank_ses}` (chapter: `lem:gf_generic_rank_ses`)
- **Lean target exists**: yes (line 961)
- **Signature matches**: yes — `∃ (m : ℕ) (φ : (Fin m → MvPolynomial (Fin d) A) →ₗ[…] N), Function.Injective φ ∧ Module.IsTorsion … (N ⧸ LinearMap.range φ)` matches blueprint LEAN SIGNATURE.
- **Proof follows sketch**: yes — takes `m = Module.finrank K NK`, constructs `Fintype.linearCombination P v` as `φ`, linear independence by `restrict_scalars` from K, torsion by clearing denominators via `IsLocalization.exist_integer_multiples`.
- **notes**: Sorry-free, axiom-clean. Proof is substantially detailed; blueprint sketch adequately covers the main steps.

### `\lean{Submodule.annihilator_top_inter_nonZeroDivisors}` (chapter: `lem:annihilator_meets_nonZeroDivisors`)
- **Lean target exists**: Mathlib (`\mathlibok`)
- **Signature matches**: N/A
- **Proof follows sketch**: N/A

### `\lean{AlgebraicGeometry.GenericFreeness.gf_torsion_annihilator}` (chapter: `lem:gf_torsion_annihilator`)
- **Lean target exists**: yes (line 1068)
- **Signature matches**: yes — `∃ F : MvPolynomial (Fin d) A, F ≠ 0 ∧ F ∈ Module.annihilator … T` matches blueprint LEAN SIGNATURE.
- **Proof follows sketch**: yes — direct from `Submodule.annihilator_top_inter_nonZeroDivisors`.
- **notes**: Sorry-free, axiom-clean.

### Nagata machinery declarations (`def:gf_nagata_T1`, `lem:gf_t1_comp_t1_neg`, `def:gf_nagata_T`, `lem:gf_lt_up`, `lem:gf_sum_r_mul_ne`, `lem:gf_degreeOf_zero_t`, `lem:gf_degreeOf_t_ne_of_ne`, `lem:gf_leadingCoeff_finSuccEquiv_t`, `lem:gf_T_leadingcoeff_eq`, `lem:gf_finSuccEquiv_map_comm`, `lem:gf_finSuccEquiv_rename_succ`)
- **Lean targets exist**: yes (lines 1100–1267), but all are `private`
- **Signature matches**: yes, where verifiable
- **Proof follows sketch**: yes for each sub-lemma
- **notes**: All sorry-free. **Private declarations with public `\lean{...}` pins** — known recurring debt (per directive); the blueprint pinned names (`AlgebraicGeometry.GenericFreeness.T1`, `.T`, `.lt_up`, etc.) are not the actual exported Lean names because of the `private` modifier. This is noted, not newly flagged.

### `\lean{AlgebraicGeometry.GenericFreeness.gf_nagata_monic_lastVar}` (chapter: `lem:gf_nagata_monic_lastVar`)
- **Lean target exists**: yes (line 1227)
- **Signature matches**: yes — `∃ (g : A) (_ : g ≠ 0) (e : MvPolynomial (Fin (m+1)) A ≃ₐ[A] …), IsUnit (… .leadingCoeff)` matches blueprint LEAN SIGNATURE.
- **Proof follows sketch**: yes — extracts `v ∈ f.support` with maximal `degreeOf 0` after `T`-transform, uses `coeff v F ≠ 0` as `g`, and `IsLocalization.Away.algebraMap_isUnit` to conclude.
- **notes**: Sorry-free, axiom-clean.

### `\lean{Polynomial.Monic.finite_quotient}` (chapter: `lem:polynomial_monic_quotient_finite`)
- **Lean target exists**: Mathlib (`\mathlibok`)
- **Signature matches**: N/A
- **Proof follows sketch**: N/A

### `\lean{AlgebraicGeometry.GenericFreeness.mvPolynomial_quotient_finite_of_monic_lastVar}` (chapter: `lem:gf_mvPolynomial_quotient_finite_monic`)
- **Lean target exists**: yes (line 1284)
- **Signature matches**: yes — `RingHom.Finite` of the composite ring map matches blueprint LEAN SIGNATURE verbatim.
- **Proof follows sketch**: yes — rescales to monic via `Polynomial.leadingCoeff_C_mul_of_isUnit`, invokes `Polynomial.Monic.finite_quotient`, transports via `Ideal.quotientEquiv` + `AlgEquiv.ofRingEquiv`.
- **notes**: Sorry-free, axiom-clean.

### `\lean{AlgebraicGeometry.GenericFreeness.gf_torsion_reindex}` (chapter: `lem:gf_torsion_reindex`)
- **Lean target exists**: yes (line 1458)
- **Signature matches**: yes — matches blueprint LEAN SIGNATURE including the dropped `Module A_g T_g` existential (noted in blueprint comment).
- **Proof follows sketch**: yes — the detailed proof in the chapter (annihilator → Nagata → elimination → localisation transport → action-diamond subtlety → transitivity) matches the Lean proof structure closely. The lengthy transport helpers (`pullbackModuleAddEquiv`, `finite_of_quotientRingEquiv`, `isLocalizedModule_restrictScalars`) are all landed and called as documented.
- **notes**: Sorry-free, axiom-clean. The proof is ~225 lines with heavy instance engineering. The blueprint's "Localisation transport" and "Action-diamond subtlety" paragraphs cover the key conceptual steps accurately.

### `\lean{AlgebraicGeometry.GenericFreeness.pullbackModuleAddEquiv}` / `finite_of_pullbackModuleAddEquiv` / `pullback_isScalarTower` (chapter: `lem:gf_pullback_module_transport`)
- **Lean target exists**: yes (lines 1343, 1361, 1376)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: Sorry-free, axiom-clean.

### `\lean{AlgebraicGeometry.GenericFreeness.finite_of_quotientRingEquiv}` (chapter: `lem:gf_finite_of_quotient_ringequiv`)
- **Lean target exists**: yes (line 1393)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: Sorry-free, axiom-clean.

### `\lean{AlgebraicGeometry.GenericFreeness.isLocalizedModule_restrictScalars}` (chapter: `lem:gf_islocalizedmodule_restrictscalars`)
- **Lean target exists**: yes (line 1411)
- **Signature matches**: yes
- **Proof follows sketch**: yes — verifies the three `IsLocalizedModule` axioms by descent from the image-submonoid statements.
- **notes**: Sorry-free, axiom-clean.

### `\lean{IsLocalization.Away.mul_of_associated}` (chapter: `lem:isLocalization_away_mul_of_associated`)
- **Lean target exists**: Mathlib (`\mathlibok`)
- **Signature matches**: N/A
- **Proof follows sketch**: N/A

### `\lean{Module.Free.of_ringEquiv}` (chapter: `lem:module_free_of_ringEquiv`)
- **Lean target exists**: Mathlib (`\mathlibok`)
- **Signature matches**: N/A
- **Proof follows sketch**: N/A

### `\lean{AlgebraicGeometry.GenericFreeness.free_localizationAway_of_away_tower}` (chapter: `lem:gf_away_tower_descent`)
- **Lean target exists**: yes (line 1701)
- **Signature matches**: yes — `(hg : g ≠ 0) (hh : h ≠ 0) (hfree : Module.Free (Localization.Away h) (LocalizedModule (Submonoid.powers h) (LocalizedModule (Submonoid.powers g) T))) : ∃ f : A, f ≠ 0 ∧ Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) T)`.
- **Proof follows sketch**: yes — clears denominator of `h` via `IsLocalization.surj`, identifies `Away(g*a) ≃ Away h` via `IsLocalization.Away.mul_of_associated`, constructs the `A`-linear equivalence `ε` and upgrades to `Away(g*a)`-linear via `LinearEquiv.extendScalarsOfIsLocalization`, transports freeness via `Module.Free.of_basis` with `mapCoeffs`. The blueprint's note that the `IsBaseChange.comp` route was found (rather than the direct three-axiom verification) is confirmed in the Lean.
- **notes**: Sorry-free, axiom-clean. The blueprint's LEAN DEPS comment accurately records the API consumed.

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_polynomial}` (chapter: `lem:gf_polynomial_core`)
- **Lean target exists**: yes (line 1823)
- **Signature matches**: yes — shared universe `(A : Type u) ... (N : Type u)` as noted in blueprint. `Nat.strong_induction_on ... generalizing A N` matches the blueprint's key comment about needing to revert `A` into the motive.
- **Proof follows sketch**: yes — base case `d = 0` via `MvPolynomial.isEmptyAlgEquiv` + finite-module leaf; inductive step uses `gf_generic_rank_ses` → `gf_torsion_reindex` → IH at `A_g` → `free_localizationAway_of_away_tower` → splice.
- **notes**: Sorry-free, axiom-clean. The shared-universe note in the blueprint is load-bearing and the Lean matches it.

### `\lean{AlgebraicGeometry.GenericFreeness.exists_flat_localizationAway_of_finite}` (chapter: `lem:gf_flat_finite`)
- **Lean target exists**: yes (line 120)
- **Signature matches**: yes
- **Proof follows sketch**: yes — calls `exists_free_localizationAway_of_finite` then `Module.Flat.of_free`.
- **notes**: Sorry-free, axiom-clean.

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_moduleFinite}` (chapter: `lem:gf_free_moduleFinite`)
- **Lean target exists**: yes (line 135)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `Module.Finite.trans B M` then delegates to `exists_free_localizationAway_of_finite`.
- **notes**: Sorry-free, axiom-clean.

### `\lean{AlgebraicGeometry.genericFlatness}` (chapter: `thm:generic_flatness`)
- **Lean target exists**: yes (line 2074)
- **Signature matches**: yes — `{S X : Scheme.{u}} [IsIntegral S] [IsLocallyNoetherian S] (p : X ⟶ S) [LocallyOfFiniteType p] (F : X.Modules) [F.IsQuasicoherent] [F.IsFiniteType]` with the fibrewise flatness conclusion matches the blueprint's re-signed NOTE.
- **Proof follows sketch**: partial — the non-empty affine open `U₀` extraction is done; the geometric assembly (`sorry` at line 2109) is the documented out-of-scope residue.
- **notes**: Documented `sorry`. Code comment accurately describes the remaining 4 assembly steps. Honest residue.

---

## Red flags

### Placeholder / suspect bodies
- `genericFlatnessAlgebraic` at line 2021: `sorry` in the `N ≅ B/𝔭` branch. **Known documented residue** per directive. The code comment records that L4 and L5 are now closed and the remaining work is pure assembly of 4 explicit steps. This `sorry` does not represent a missing mathematical idea — it represents unfinished Lean wiring.
- `genericFlatness` at line 2109: `sorry` in the geometric assembly. **Known out-of-scope per directive**. Accurately described in the code comment and in the chapter.

### Excuse-comments
None. The `sorry` comments in the file are technical and accurate (they describe what remains, not why an incorrect shortcut is acceptable).

### Private declarations with public `\lean{...}` pins
The following declarations are `private` in the Lean file but appear with unqualified public names in `\lean{...}` blueprint pins:
- `T1` (line 1126): `private noncomputable abbrev`; `\lean{AlgebraicGeometry.GenericFreeness.T1}`
- `T` (line 1135): `private noncomputable abbrev`; `\lean{AlgebraicGeometry.GenericFreeness.T}`
- `t1_comp_t1_neg` (line 1131): `private lemma`; `\lean{AlgebraicGeometry.GenericFreeness.t1_comp_t1_neg}`
- `lt_up` (line 1122): `private lemma`; `\lean{AlgebraicGeometry.GenericFreeness.lt_up}`
- `sum_r_mul_ne` (line 1139): `private lemma`; `\lean{AlgebraicGeometry.GenericFreeness.sum_r_mul_ne}`
- `degreeOf_zero_t` (line 1148): `private lemma`; `\lean{AlgebraicGeometry.GenericFreeness.degreeOf_zero_t}`
- `degreeOf_t_ne_of_ne` (line 1164): `private lemma`; `\lean{AlgebraicGeometry.GenericFreeness.degreeOf_t_ne_of_ne}`
- `leadingCoeff_finSuccEquiv_t` (line 1171): `private lemma`; `\lean{AlgebraicGeometry.GenericFreeness.leadingCoeff_finSuccEquiv_t}`
- `T_leadingcoeff_eq` (line 1192): `private lemma`; `\lean{AlgebraicGeometry.GenericFreeness.T_leadingcoeff_eq}`
- `finSuccEquiv_map_comm` (line 1100): `private theorem`; `\lean{AlgebraicGeometry.GenericFreeness.finSuccEquiv_map_comm}`
- `finSuccEquiv_rename_succ` (line 1260): `private theorem`; `\lean{AlgebraicGeometry.GenericFreeness.finSuccEquiv_rename_succ}`

**Known recurring debt per directive** — noted but not newly flagged this iter.

---

## Unreferenced declarations (informational)

All substantive non-private declarations in the `GenericFreeness` namespace have corresponding `\lean{...}` blueprint pins. The following are helpers/plumbing that do not have their own blueprint blocks but are consumed by nearby blocks:
- `pullbackModuleAddEquiv` (def, line 1343) — three `\lean{...}` pins bundled in `lem:gf_pullback_module_transport`, acceptable.
- `finite_of_pullbackModuleAddEquiv` and `pullback_isScalarTower` — likewise bundled in the same block.

No substantive unreferenced declarations found.

---

## Blueprint adequacy for this file

### Coverage
40/40 blueprint-pinned Lean declarations (excluding Mathlib anchors) have corresponding Lean declarations. 11 Nagata helper declarations are `private` but present. 0 substantive declarations are unreferenced.

### Proof-sketch depth: **under-specified for one sub-step**

The chapter is generally well-specified and most proof sketches are detailed enough to guide formalization. One specific sub-step of `lem:gf_noether_clear_denominators` (step 2) is **inaccurately described**:

**Blueprint step 2** (proof of `lem:gf_noether_clear_denominators`, lines 462–475 in the .tex):
> "each generator satisfies an equation of integral dependence whose coefficients are polynomials in K[b̄₁,…,b̄ₙ], and there are finitely many such coefficient polynomials in total. Applying `gf_clear_one_denominator` to each coefficient polynomial yields a non-zero element of A over which that polynomial's coefficients become integral; folding over the finite collection (multiplying the finitely many elements) produces a single g ∈ A"

The chapter's `% NOTE` at the top of the proof also says: "the denominator-clearing middle of this proof is a Finset-fold of `lem:gf_clear_one_denominator` over the finite generating set."

**What the landed Lean proof actually does** (lines 619–641):
It uses `IsIntegral.exists_multiple_integral_of_isLocalization` applied to each generator `x ∈ σ` as a whole, directly obtaining `aGen x ∈ nonZeroDivisors A` such that `C(aGen x) • algebraMap B B_K x` is integral over `MvPolynomial (Fin s) A`. It then sets `g1 := ∏_{x∈σ} aGen x`. The construction does NOT go through individual coefficient polynomials and does NOT call `gf_clear_one_denominator` as part of the `g1` step.

`gf_clear_one_denominator` is used elsewhere (it is proved separately and cited in the `\uses` chain), but the landed `g1` factor is produced by `IsIntegral.exists_multiple_integral_of_isLocalization`, not by folding `gf_clear_one_denominator` over coefficient polynomials. A prover reading the chapter's step 2 description would reach for `gf_clear_one_denominator` and face a mismatch with the Mathlib API that produces `g1` most directly.

The mathematical conclusions are equivalent, but the procedural description is inaccurate for the landed proof.

### Hint precision: **precise (signatures match verbatim)**
All LEAN SIGNATURE blocks in the chapter match the landed declarations exactly, including non-obvious encodings (the `IsLocalization.map` form for `gf_clear_one_denominator`, the `Algebra A_g B_g` existential binder in `lem:gf_noether_clear_denominators`, the dropped `Module A_g T_g` existential in `lem:gf_torsion_reindex`, and the `RingHom.Finite` encoding for `lem:gf_mvPolynomial_quotient_finite_monic`).

### Generality: **matches need**
No parallel API found; the blueprint's abstraction level is appropriate.

### Recommended chapter-side actions
1. **[major]** Update the proof sketch for `lem:gf_noether_clear_denominators` step 2: replace the description of "applying `gf_clear_one_denominator` to each coefficient polynomial" with the correct route via `IsIntegral.exists_multiple_integral_of_isLocalization` applied per generator. Concretely, step 2 should read: "For each generator `x ∈ σ`, apply `IsIntegral.exists_multiple_integral_of_isLocalization` (Mathlib) to the element `algebraMap B B_K x`, which is integral over `MvPolynomial K` by step 1; this yields `a_x ∈ nonZeroDivisors A` such that `C(a_x) • x` is integral over `MvPolynomial A`. Set `g1 := ∏_{x∈σ} a_x` (non-zero since A is a domain); then `g := g0 · g1`." Remove or correct the note claiming `gf_clear_one_denominator` is folded to produce `g1`.
2. **[minor]** Make the private Nagata helper declarations public (or remove their `\lean{...}` pins from the blueprint). The 11 pinned private declarations can never be checked by an automated `\lean{...}` verifier because the names are mangled by `private`. The preferred fix is to make them non-private (they are substantive sub-lemmas, not implementation detail).

---

## Severity summary

- **must-fix-this-iter**: 0
- **major** (1): Blueprint proof sketch for `lem:gf_noether_clear_denominators` step 2 inaccurately attributes the `g1` denominator-clearing witness to `gf_clear_one_denominator` (applied per coefficient polynomial), while the landed Lean proof uses `IsIntegral.exists_multiple_integral_of_isLocalization` per generator. A future prover reading step 2 would be misled. No Lean error results from this (the mathematical conclusion is correct), but the chapter-to-Lean correspondence is broken for this sub-step.
- **minor** (1): 11 Nagata helper declarations are `private` with public `\lean{...}` pins — known recurring debt per directive.

**Overall verdict**: The Lean file is faithful to the blueprint in all signatures and conclusions, all L3/L4/L5 sub-lemmas are sorry-free and axiom-clean, and the documented sorries (`genericFlatnessAlgebraic` B/𝔭 branch, `genericFlatness` geometric assembly) are honest residues explicitly covered by the chapter — one major blueprint adequacy deficiency: step 2 of the L4 proof sketch describes the wrong Mathlib API for constructing `g1`.
