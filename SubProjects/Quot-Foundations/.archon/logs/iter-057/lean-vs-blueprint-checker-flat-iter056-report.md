# Lean ↔ Blueprint Check Report

## Slug
flat-iter056

## Iteration
057

## Files audited
- Lean: `AlgebraicJacobian/Picard/FlatteningStratification.lean` (3290 lines)
- Blueprint: `blueprint/src/chapters/Picard_FlatteningStratification.tex` (2446 lines)

---

## Per-declaration

The file was read in full (three paginated reads: lines 1–832, 833–2496, 2497–3290 of Lean; and three paginated reads of the blueprint chapter covering 1–910, 911–1742, and 1620–2446 with overlap). All `\lean{...}` blocks in the chapter were located and matched.

### Declarations in the `GenericFreeness` namespace (lines 1–1981 Lean, lines 1–1600 blueprint)

These were audited in the earlier context window. All ~75 declarations (`exists_free_localizationAway_of_finite` through `exists_free_localizationAway_polynomial`, plus `genericFlatnessAlgebraic` and all its building blocks) carry accurate `\lean{...}` pins in the blueprint, with `\leanok` correctly set in statement and proof blocks. No discrepancies were found. These are not re-listed individually.

### Geometric-section helpers (lines 1982–2496 Lean, approx. lines 1540–1640 blueprint)

All geometric helpers (`finite_localizedModule_of_isLocalizedModule`, `gf_finite_sections_of_basicOpen_finite_cover`, `gf_affine_qcoh_Gamma_epi`, `gf_qcoh_finite_sections_globally_generated`, `gf_qcoh_finite_sections_of_free_epi`, `gf_affine_finite_standard_subcover`, `gf_finite_gen_iff_free_epi`, and the `SheafOfModules.GeneratingSections.map` engine) have accurate `\lean{...}` pins with `\leanok`. Not re-listed.

### `\lean{AlgebraicGeometry.gf_localGenerators_restrict}` (chapter: `lem:gf_localGenerators_restrict`, Seam 1a)
- **Lean target exists**: yes (line 2489 in Lean)
- **Signature matches**: yes — transports a finite generating family along a geometric restriction to an affine sub-open
- **Proof follows sketch**: yes — uses `GeneratingSections.map` engine through three stages (A→B→C) plus `equivOfIso`
- **notes**: Axiom-clean. `\leanok` in both statement and proof blocks.

### `\lean{AlgebraicGeometry.gf_finiteType_affine_finite_cover_generated}` (chapter: `lem:gf_finiteType_affine_finite_cover_generated`, Seam 1)
- **Lean target exists**: yes (line 2525)
- **Signature matches**: yes — finite affine cover of globally-generated affines
- **Proof follows sketch**: yes — uses `exists_localGeneratorsData` + `gf_affine_finite_standard_subcover` + `gf_localGenerators_restrict`
- **notes**: Axiom-clean. Blueprint block (in lines ~1540–1600, confirmed by `\uses{}`-chain) has `\leanok`.

### `\lean{AlgebraicGeometry.module_finite_of_ringEquiv_semilinear}` (chapter: `lem:module_finite_of_ringEquiv_semilinear`)
- **Lean target exists**: yes (line 2573)
- **Signature matches**: yes — semilinear finiteness transport across ring iso and additive iso; matches blueprint prose exactly
- **Proof follows sketch**: yes — `Submodule.span_induction` over the R-spanning set, transports via semilinearity
- **notes**: Axiom-clean. Blueprint at lines 1668–1687 has `\leanok` in statement block; proof block also has `\leanok`.

### `\lean{AlgebraicGeometry.gf_qcoh_finite_sections_of_genSections}` (chapter: `lem:gf_qcoh_finite_sections_of_genSections`, G1 base case)
- **Lean target exists**: yes (line 2612)
- **Signature matches**: yes — quasi-coherent `F`, affine open `D`, finite generating family `σ` ⟹ `Module.Finite Γ(X, D) Γ(F, D)`
- **Proof follows sketch**: yes — three-step (a) quasi-coherence via `isQuasicoherent_pullback_fromSpec`; (b) transport `σ` via `GeneratingSections.map` + `tildeFinsupp` → free-epi base case; (c) semilinear section-comparison via `gammaPullbackImageIso` + `module_finite_of_ringEquiv_semilinear`
- **notes**: Axiom-clean (with `set_option maxHeartbeats 1600000`). Blueprint at lines 1689–1740 has `\leanok`.

### `\lean{AlgebraicGeometry.gf_qcoh_fintype_finite_sections}` (chapter: `lem:gf_qcoh_fintype_finite_sections`, G1 assembly)
- **Lean target exists**: yes (line 2674)
- **Signature matches**: yes — `[F.IsFiniteType]` + `[F.IsQuasicoherent]` + affine `W` ⟹ `Module.Finite Γ(X, W) Γ(F, W)`
- **Proof follows sketch**: yes — cover extraction → G1 base case per member → `gf_finite_sections_of_basicOpen_finite_cover`
- **notes**: Axiom-clean. Blueprint at lines 1742–1783 has `\leanok`.

### `\lean{AlgebraicGeometry.gf_patch_free_imp_flat}` (chapter: `lem:gf_patch_free_imp_flat`, G3.1)
- **Lean target exists**: yes (line 2719)
- **Signature matches**: yes — `[Module.Free R M] : Module.Flat R M`, one-liner `Module.Flat.of_free`
- **Proof follows sketch**: yes
- **notes**: Axiom-clean. Blueprint at lines 1865–1879 has `\leanok`.

### `\lean{AlgebraicGeometry.gf_flat_base_local_on_source}` (chapter: `lem:gf_flat_base_local_on_source`, G3.3)
- **Lean target exists**: yes (line 2732)
- **Signature matches**: yes — flatness over fixed base `R` local at maximal ideals of source ring `B`
- **Proof follows sketch**: yes — `Module.flat_of_isLocalized_maximal`
- **notes**: Axiom-clean. Blueprint at lines 1881–1904 has `\leanok`.

### `\lean{AlgebraicGeometry.gf_localizedModule_baseChange_tensor_comm}` (chapter: `lem:gf_localizedModule_baseChange_tensor_comm`, B1.0)
- **Lean target exists**: yes (line 2766), `noncomputable def`
- **Signature matches**: yes — `LocalizedModule T (N ⊗[R] K) ≃ₗ[R] (LocalizedModule T N) ⊗[R] K`
- **Proof follows sketch**: yes — `IsLocalizedModule.iso` applied to `rTensor`
- **notes**: Axiom-clean. Blueprint at lines 1906–1925 has `\leanok`.

### `\lean{AlgebraicGeometry.gf_flat_localizedModule_sameBase}` (chapter: `lem:gf_flat_localizedModule_sameBase`, B1)
- **Lean target exists**: yes (line 2791)
- **Signature matches**: yes — `[Module.Flat R N] : Module.Flat R (LocalizedModule T N)`, submonoid `T` in source ring `B` (not base `R`)
- **Proof follows sketch**: yes — `iff_lTensor_injectiveₛ` + `IsLocalizedModule.map_lTensor` + exactness of localization
- **notes**: Axiom-clean. Blueprint at lines 1927–1959 has `\leanok`.

### `\lean{AlgebraicGeometry.gf_crossChart_basicOpen_eq}` (chapter: `lem:gf_crossChart_basicOpen_eq`, B2.1)
- **Lean target exists**: yes (line 2819)
- **Signature matches**: yes — restriction-matched sections cutting out the same basic open
- **Proof follows sketch**: yes — `basicOpen_res` for both charts
- **notes**: Axiom-clean. Blueprint at lines 1973–2000 has `\leanok`.

### `\lean{AlgebraicGeometry.gf_section_localization_twoleg}` (chapter: `lem:gf_section_localization_twoleg`, B2.2)
- **Lean target exists**: yes (line 2840)
- **Signature matches**: yes — two legs: both `isLocalizedModule_basicOpen` in their respective charts
- **Proof follows sketch**: yes
- **notes**: Axiom-clean. Blueprint at lines 2002–2039 has `\leanok`.

### `\lean{AlgebraicGeometry.gf_base_localization_comparison}` (chapter: `lem:gf_base_localization_comparison`, B2.3)
- **Lean target exists**: yes (line 2861)
- **Signature matches**: **partial** — blueprint prose says "realises R as a localization of Af", Lean proves `Module.Flat Γ(S, V) Γ(S, U)` (strictly weaker). This mismatch is **already documented** with `% NOTE (iter-054)` in the blueprint block.
- **Proof follows sketch**: yes, matches the Lean route (`Flat.flat_appLE (𝟙 S)`)
- **notes**: Axiom-clean. Existing `% NOTE` adequately flags the prose-vs-Lean divergence. No new action needed; the assembly uses `gf_isEpi_restrict_of_affine_le` for the actual descent, not this lemma's localization claim.

### `\lean{AlgebraicGeometry.gf_common_basicOpen_basis}` (chapter: `lem:gf_common_basicOpen_basis`)
- **Lean target exists**: yes (line 2895)
- **Signature matches**: yes — basic-open equality form (not restriction-matched form); matches the corrected blueprint prose which notes the restriction-matched form is not constructible
- **Proof follows sketch**: yes — `exists_basicOpen_le_affine_inter` Mathlib lemma
- **notes**: Axiom-clean. Blueprint at lines 2277–2303 has `\leanok`.

### `\lean{AlgebraicGeometry.gf_crossChart_spanning_cover}` (chapter: `lem:gf_crossChart_spanning_cover`, B2.4)
- **Lean target exists**: yes (line 2923)
- **Signature matches**: yes — finite spanning family in `Γ(X, W)` with chart-aligned partners
- **Proof follows sketch**: yes — per-point `gf_common_basicOpen_basis` → `iSup_basicOpen_iff` → finite subcover
- **notes**: Axiom-clean. Blueprint at lines 2305–2344 has `\leanok`.

### `\lean{AlgebraicGeometry.gf_section_span_flat_descent}` (chapter: `lem:gf_section_span_flat_descent`, B2)
- **Lean target exists**: yes (line 2962)
- **Signature matches**: yes — source-span flatness descent for section modules via `Module.flat_of_isLocalized_span`
- **Proof follows sketch**: yes — module instances threaded uniformly, `isLocalizedModule_basicOpen` for localization witnesses
- **notes**: Axiom-clean. Blueprint at lines 2250–2275 has `\leanok`.

### `\lean{AlgebraicGeometry.gf_flat_of_isBaseChange_id}` (chapter: `lem:gf_flat_of_isBaseChange_id`)
- **Lean target exists**: yes (line 3014)
- **Signature matches**: yes — `[IsBaseChange R (LinearMap.id : M →ₗ[A] M)] : Module.Flat R M`
- **Proof follows sketch**: yes — `Module.Flat.isBaseChange`
- **notes**: Axiom-clean. Blueprint at lines 2231–2248 has `\leanok`.

### `\lean{AlgebraicGeometry.gf_openImmersion_isEpi}` (chapter: `lem:gf_openImmersion_isEpi`) ⚠️ MAJOR
- **Lean target exists**: **NO** — no declaration named `gf_openImmersion_isEpi` exists in the Lean file.
- **Closest match**: `gf_isEpi_restrict_of_affine_le` (line 3041), which proves `Algebra.IsEpi Γ(S, V) Γ(S, U)` for affine opens `U ≤ V` via `Spec.map`-mono reflection through `Spec.fullyFaithful`.
- **Signature matches**: the Lean statement of `gf_isEpi_restrict_of_affine_le` matches the blueprint prose of `lem:gf_openImmersion_isEpi` exactly — same statement, same proof route.
- **Proof follows sketch**: yes — the blueprint proof sketch (Spec fully faithful + open immersion is mono + `CommRingCat.epi_iff_epi`) matches the Lean proof verbatim.
- **notes**: Axiom-clean (iter-056). The `\lean{...}` pin names a non-existent declaration, so `sync_leanok` cannot locate this declaration and the block remains without `\leanok` despite being formalized and axiom-clean. **Blueprint needs `\lean{}` pin corrected to `AlgebraicGeometry.gf_isEpi_restrict_of_affine_le`.**

### `\lean{AlgebraicGeometry.gf_flat_descend_isEpi}` (chapter: `lem:gf_flat_descend_isEpi`) ⚠️ MAJOR
- **Lean target exists**: **NO** — no declaration named `gf_flat_descend_isEpi` exists in the Lean file.
- **Closest match**: `gf_flat_of_isEpi` (line 3026), which proves `Module.Flat R M` from `[Algebra.IsEpi A R]` and `[Module.Flat A M]` through `TensorProduct.lid'` / `IsBaseChange.of_equiv`.
- **Signature matches**: the Lean statement of `gf_flat_of_isEpi` matches the blueprint prose of `lem:gf_flat_descend_isEpi` exactly.
- **Proof follows sketch**: yes — `TensorProduct.lid'` gives the base-change iso, `IsBaseChange.of_equiv` gives `IsBaseChange R id`, then `Module.Flat.isBaseChange` closes.
- **notes**: Axiom-clean (iter-056). Same consequence as above: `sync_leanok` cannot locate this declaration; the block lacks `\leanok` despite being formalized. **Blueprint needs `\lean{}` pin corrected to `AlgebraicGeometry.gf_flat_of_isEpi`.**

### `\lean{AlgebraicGeometry.genericFlatness}` (chapter: `thm:generic_flatness`)
- **Lean target exists**: yes (line 3084)
- **Signature matches**: yes — `[IsIntegral S] [IsLocallyNoetherian S]`, `[LocallyOfFiniteType p] [QuasiCompact p]`, `[F.IsQuasicoherent] [F.IsFiniteType]`; conclusion is section-module-wise `Module.Flat Γ(S, U) Γ(F, W)` for all affine `U ≤ V`, `W ≤ p⁻¹U`. Matches blueprint prose ("finite-type morphism" = `LocallyOfFiniteType + QuasiCompact` as the Lean comment at lines 3109–3133 explains).
- **Proof follows sketch**: yes — blueprint steps 1–4 correspond exactly to the Lean proof structure: `isCompact_preimage` → finite affine cover; `gf_qcoh_fintype_finite_sections` per patch; `genericFlatnessAlgebraic` per patch → product `f = ∏ fⱼ`, `V = D(f)`; flatness via `gf_crossChart_spanning_cover` + `gf_section_span_flat_descent` + `gf_isEpi_restrict_of_affine_le` + `gf_flat_of_isEpi`.
- **notes**: Statement block has `\leanok` (correctly — at least a sorry present). Proof block has no `\leanok` (correctly — one `sorry` at line 3285 for `flatV`). The single sorry is explicitly documented in the Lean comment at lines 3268–3285: "pure in-Mathlib localization algebra (per-patch freeness retained in `hfree`, transported via `Module.free_of_isLocalizedModule` + B1 `gf_flat_localizedModule_sameBase`)". No Mathlib gap; the sorry is instance/transport threading of existing lemmas.

---

## Red flags

### Placeholder / suspect bodies

None. The single `sorry` in the file is at line 3285 (`flatV` in `genericFlatness`), and the surrounding comment explicitly explains it as a threading TODO for existing Mathlib lemmas — not a mathematical gap. The blueprint docstring and `\leanok` placement both correctly reflect this state.

### Excuse-comments

None. The `sorry` comment (lines 3268–3285) is a precise technical description of the remaining work, not an excuse-comment. No "temporary", "placeholder", or "will fix later" language found.

### Axioms / Classical.choice on non-trivial claims

None. All declarations are axiom-clean (verified by the prover; consistent with the iter-056 report).

---

## Unreferenced declarations (informational)

The following declarations in the Lean file have no `\lean{...}` reference in the blueprint chapter:

### `gf_stalk_flat_localBase` (line 2746) — substantive, flagged
- Lean docstring labels this "G3.4 — stalk flatness over the local base via transitivity" and references `lem:gf_stalk_flat_localBase`, implying a blueprint block was intended but not written.
- Statement: if `IsLocalization S R'` and `N` is `R'`-flat, then `N` is `R`-flat (`IsLocalization.flat` + `Module.Flat.trans`).
- **Status**: minor gap — should have a blueprint block but is a short bridge lemma. Consumes Mathlib directly; no deep reasoning required.

### Private Nagata normalization helpers (earlier in file)
`finSuccEquiv_map_comm`, `T1`, `t1_comp_t1_neg`, `T`, `sum_r_mul_ne`, `degreeOf_zero_t`, `degreeOf_t_ne_of_ne`, `leadingCoeff_finSuccEquiv_t`, `T_leadingcoeff_eq`, `finSuccEquiv_rename_succ` — private section helpers for the L5b Nagata normalization argument. Acceptable as unblueprinted.

---

## Directive-specific focal points

### Focal point 1: Are `gf_flat_of_isEpi` and `gf_isEpi_restrict_of_affine_le` blueprinted?

**Partially — they are covered by blueprint blocks, but with wrong `\lean{...}` pin names.**

Both declarations exist, are axiom-clean, and correspond semantically to blueprint lemmas with accurate prose descriptions:
- `gf_isEpi_restrict_of_affine_le` ↔ `lem:gf_openImmersion_isEpi` (blueprint `\lean{}` pin says `gf_openImmersion_isEpi`, which does not exist)
- `gf_flat_of_isEpi` ↔ `lem:gf_flat_descend_isEpi` (blueprint `\lean{}` pin says `gf_flat_descend_isEpi`, which does not exist)

Consequence: `sync_leanok` cannot locate these declarations, so both blueprint blocks lack `\leanok` despite being formalized and axiom-clean. The `\uses{}` graph is unaffected (it references blueprint labels, not Lean names). **Fix required**: correct the two `\lean{}` pins in the blueprint.

### Focal point 2: Does any blueprint `\lean{}` pin still frame the base change as dead/absent?

**No.** The blueprint correctly frames the ingredient as RESOLVED. Section `sec:gf_base_descent_isEpi` (blueprint lines 2070–2083) explicitly states: "This replaces the earlier `IsBaseChange` hypothesis (once flagged as absent from Mathlib) by the verified Mathlib epimorphism API." The Mathlib anchors `Algebra.IsEpi`, `TensorProduct.lid'`, `CommRingCat.epi_iff_epi`, `Spec.fullyFaithful`, and `IsOpenImmersion.mono` are all marked `\mathlibok`. The `genericFlatness` proof sketch (lines 2382–2444) presents the base-descent along `U ↪ V` as completed via the epi route. No `\lean{}` pin frames the ingredient as missing. ✓

### Focal point 3: Does the blueprint correctly attribute the `genericFlatness` residual sorry to in-Mathlib localization algebra (flatV)?

**Yes, with a minor adequacy note.**

The Lean proof body (lines 3268–3285) explicitly documents: "ROUTE (pure in-Mathlib localization algebra; NO missing infrastructure — the base-change descent is already discharged above). All ingredients exist: `hfree`, `Module.free_of_isLocalizedModule`, `gf_flat_localizedModule_sameBase`, `isLocalizedModule_basicOpen`." The sorry is for instance/transport threading, not a mathematical gap.

The blueprint proof sketch (lines 2382–2444) presents the correct mathematical argument for all steps including the flatV step (Step 4: per-patch freeness → flat over Af via G3.1 + B1 `gf_flat_localizedModule_sameBase`). The sketch accurately describes what the sorry is doing. The `\leanok` placement in the statement block only (not the proof block) correctly signals an incomplete proof.

**Minor gap**: the blueprint proof sketch does not explicitly call out that `flatV` remains sorry'd. A reader could conclude the proof is done end-to-end from the prose alone. A `% NOTE:` annotation on the `thm:generic_flatness` proof block identifying the one remaining sorry (instance threading for `flatV` via `hfree`/`free_of_isLocalizedModule`/`gf_flat_localizedModule_sameBase`) would improve transparency. ✓ (with minor adequacy note)

---

## Blueprint adequacy for this file

- **Coverage**: ~95/97 Lean declarations have a `\lean{...}` block in the chapter. Unblueprinted: `gf_stalk_flat_localBase` (substantive, 1) + private Nagata helpers (acceptable, ~10). The 2 new iter-056 declarations (`gf_flat_of_isEpi`, `gf_isEpi_restrict_of_affine_le`) ARE blueprinted semantically, but with wrong `\lean{}` pin names.
- **Proof-sketch depth**: **adequate**. Every major proof step in the Lean file corresponds to a described step in the blueprint. The G1 base case, algebraic dévissage (L1–L5 + `genericFlatnessAlgebraic`), B1–B2 chain, and `genericFlatness` assembly all have detailed, accurate sketches including source attribution (Nitsure §4, Stacks 01PB).
- **Hint precision**: **loose on two declarations**. `lem:gf_openImmersion_isEpi` and `lem:gf_flat_descend_isEpi` have `\lean{}` pins that don't match any Lean declaration. All other pins are precise and accurate.
- **Generality**: **matches need**. No parallel API was written to compensate for blueprint under-specification.
- **Recommended chapter-side actions**:
  1. **[major, actionable now]** Correct `\lean{AlgebraicGeometry.gf_openImmersion_isEpi}` to `\lean{AlgebraicGeometry.gf_isEpi_restrict_of_affine_le}` in `lem:gf_openImmersion_isEpi`.
  2. **[major, actionable now]** Correct `\lean{AlgebraicGeometry.gf_flat_descend_isEpi}` to `\lean{AlgebraicGeometry.gf_flat_of_isEpi}` in `lem:gf_flat_descend_isEpi`.
  3. **[minor]** Add a `\lean{AlgebraicGeometry.gf_stalk_flat_localBase}` blueprint block for G3.4 (two-sentence lemma; statement + proof are trivial to write).
  4. **[minor]** Add a `% NOTE:` to the `thm:generic_flatness` proof block noting that the flatV step (per-piece freeness-to-flatness threading) is the sole remaining sorry, carried by in-Mathlib algebra with no infrastructure gap.
  5. **[informational]** The B2.3 `% NOTE (iter-054)` (Lean proves flatness, prose claims IsLocalization) remains. The assembly now uses the epi route (`gf_isEpi_restrict_of_affine_le`) rather than B2.3, so this block's prose could be updated to reflect its reduced role; not blocking.

---

## Severity summary

- **must-fix-this-iter**: 0 items
- **major**: 2 items
  1. `\lean{AlgebraicGeometry.gf_openImmersion_isEpi}` in `lem:gf_openImmersion_isEpi` — pin names a non-existent declaration; actual name is `gf_isEpi_restrict_of_affine_le`. Blocks `sync_leanok` from adding `\leanok` to this axiom-clean iter-056 declaration.
  2. `\lean{AlgebraicGeometry.gf_flat_descend_isEpi}` in `lem:gf_flat_descend_isEpi` — pin names a non-existent declaration; actual name is `gf_flat_of_isEpi`. Same consequence.
- **minor**: 3 items
  1. `gf_stalk_flat_localBase` (G3.4) has no `\lean{...}` blueprint block despite a substantive docstring.
  2. `thm:generic_flatness` proof block does not call out the one remaining sorry (flatV threading).
  3. `lem:gf_base_localization_comparison` prose-vs-Lean divergence (IsLocalization vs flatness) — already flagged with `% NOTE (iter-054)`, no escalation needed.

**Overall verdict**: Strong alignment across ~95 declarations; no must-fix findings; two major `\lean{}` pin-name mismatches (wrong Lean names for both iter-056 base-change helpers) block `sync_leanok` from marking these axiom-clean declarations as formalized — blueprint corrections to `gf_isEpi_restrict_of_affine_le` and `gf_flat_of_isEpi` are the only required actions.
