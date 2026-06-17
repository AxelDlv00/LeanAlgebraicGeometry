## Slug
iter022

## Iteration
022

## Tooling summary

| Tool | Result |
|---|---|
| `leandag build --json` | 0 `unknown_uses`, 28 `unmatched_lean` (all expected work-in-progress targets), 0 isolated nodes |
| `archon blueprint-doctor --json` | 0 malformed_refs, 0 broken_refs, 0 axiom_decls, 0 covers_problems |
| `leandag stats` | 73 blueprint nodes, 18 proved (leanok), 2 with sorry (superseded line-109 + frozen P5b), 0 isolated |
| `leandag show isolated` | empty |
| `leandag show gaps` | empty |

---

## Chapter: Cohomology_HigherDirectImage.tex

**complete:** true
**correct:** true

**notes:**
- Thin chapter. One declaration: `def:higher_direct_image` → `AlgebraicGeometry.higherDirectImage` with `\leanok`. `\uses{}` empty (leaf). Covers `HigherDirectImage.lean` (DONE, no prover lane). No action needed.

---

## Chapter: Cohomology_AcyclicResolution.tex

**complete:** true
**correct:** true

**notes:**
- All declarations formalized or `\mathlibok`. Key theorem `lem:acyclic_resolution_computes_derived` → `CategoryTheory.Functor.rightDerivedIsoOfAcyclicResolution` carries `\leanok`. Supporting chain (horseshoe, dimension-shift, cosyzygy layer) all `\leanok`. Per PROGRESS.md this chapter is DONE (0 sorries, axiom-clean). No action needed.

---

## Chapter: Cohomology_CechHigherDirectImage.tex

**complete:** true
**correct:** true

**notes:**
- Consolidated chapter (`% archon:covers` covering CechAcyclic.lean, FreePresheafComplex.lean, CechBridge.lean, PresheafCech.lean, HigherDirectImagePresheaf.lean, CechHigherDirectImage.lean).
- 0 broken `\uses{}` edges (leandag `unknown_uses = []`). 0 rendering issues (blueprint-doctor clean). All `\uses{}` targets verified to exist as blueprint labels.

### Focus item audit — Lane 2: CechAcyclic.lean (iter-022 edits)

**Lean-side pre-state (confirmed by grep):** The following declarations are already present in CechAcyclic.lean and therefore NOT in `unmatched_lean`:
- `AlgebraicGeometry.sectionCechFaceRestr` (line 1284) — the per-face restriction map
- `AlgebraicGeometry.sectionCech_objD_apply` (line 1296) — abstract cosimplicial differential unfold
- `AlgebraicGeometry.sectionCech_isZero_homology_of_objD_exact` (line 1247) — homology-zero precursor
- `AlgebraicGeometry.ab_hom_finsetSum_apply` (line 1270) — abelian sum distribution helper

The four named active targets (`sectionCechCofaceMatch`, `sectionCechAbExact`, `sectionCech_homology_exact`, `sectionCech_affine_vanishing`) remain in `unmatched_lean` — consistent with being prover objectives for this iter.

#### `lem:section_cech_objd_apply`

- **Statement:** Abstract cosimplicial differential unfold — `(sectionCechProductEquiv_{q+1} ∘ objD q) t` decomposes as the alternating signed sum of face restrictions, one per 0 ≤ i ≤ q+1.
- **\lean{}:** `AlgebraicGeometry.sectionCech_objD_apply`, `AlgebraicGeometry.sectionCechFaceRestr` — both confirmed present in the Lean file.
- **\uses{}:** `def:section_cech_complex`, `lem:section_cech_product_equiv` — both are valid blueprint labels (0 unknown_uses).
- **Proof sketch:** Unfolds `AlternatingCofaceMapComplex.objD`; distributes the categorical coproduct/sum via `ab_hom_finsetSum_apply`; identifies each summand via `Pi.lift_π`. The level of detail is sufficient for formalization — each step names the specific Lean lemma.
- **VERDICT: complete + correct.** Already partially formalized (Lean file has the declarations).

#### `lem:section_cech_coface_match`

- **Statement:** The section Čech differential, transported through `sectionCechProductEquiv`, equals the localization differential `dDiff` of `SectionCechModule` (for `F = tilde(M)`).
- **\lean{}:** `AlgebraicGeometry.sectionCechCofaceMatch` — active prover target.
- **\uses{}:** `lem:section_cech_objd_apply`, `def:qcoh_sections_localized`, `def:section_cech_module_complex` — all valid labels.
- **Tilde-bridge formalizability (directive gate):** The proof sketch explicitly specifies:
  - *Layer 1 (abstract unfold)*: uses `lem:section_cech_objd_apply` (already formalized).
  - *Layer 2 (tilde-bridge)*: the per-coordinate isomorphism φ_σ is identified as the comparison of two `IsLocalizedModule` structures, unique by `AwayComparison.comparison_unique`, supplied by `IsLocalizedModule.iso`. The naturality square is `qcohRestriction_eq_comparison` (from `def:qcoh_sections_localized`). The `basicOpen_sprod` identity with proof method (induction via `iInf_fin_succ`) is named.
  - This names every specific Lean declaration needed. **Sufficiently detailed to formalize.**
- **VERDICT: complete + correct.**

#### `lem:section_cech_ab_exact`

- **Statement:** For $p \geq 1$, the $p$-th homology of `sectionCechComplex` is zero.
- **\lean{}:** `AlgebraicGeometry.sectionCechAbExact`, `AlgebraicGeometry.sectionCech_isZero_homology_of_objD_exact` (confirmed present in Lean), `AlgebraicGeometry.ab_hom_finsetSum_apply` (confirmed present).
- **\uses{}:** `def:section_cech_complex`, `lem:section_cech_objd_apply`, `lem:section_cech_product_equiv`, `lem:section_cech_coface_match`, `lem:section_cech_module_exact` — all valid labels.
- **Two-part structure:**
  - *Precursor `sectionCech_isZero_homology_of_objD_exact`*: input `Function.Exact` on objD maps → `IsZero` on homology. Chains `exactAt_iff_isZero_homology`, `HomologicalComplex.exactAt_iff'` (short complex around the node), `ShortComplex.ab_exact_iff`. Already in Lean.
  - *Ladder transport `sectionCechAbExact`*: uses `Function.Exact.of_ladder_addEquiv_of_exact` to transport `dDiff_exact` across the product equivalence + per-coordinate comparisons. The vertical maps are specified as $e_p = (\prod_\sigma \varphi_\sigma) \circ \texttt{sectionCechProductEquiv}_p$; the commuting squares are the outputs of `lem:section_cech_objd_apply` + `lem:section_cech_coface_match`.
- **Ladder-transport formalizability (directive gate):** Every component is named. **Sufficiently detailed to formalize.**
- **Informational note:** The precursor's proof body references `ShortComplex.ab_exact_iff_function_exact` in the blueprint text, while PROGRESS.md (verified Mathlib present) lists the name as `ShortComplex.ab_exact_iff`. These appear to be the same lemma under two names; the prover should use `ShortComplex.ab_exact_iff` (the PROGRESS.md-confirmed name). **Not a must-fix — blueprint content is mathematically correct; the naming detail is resolved at proof-body time.**
- **VERDICT: complete + correct.**

#### `lem:section_cech_homology_exact`

- **Statement:** The meta-lemma aggregating the three-sub-lemma chain: `IsZero((sectionCechComplex U F).homology p)` for $p \geq 1$.
- **\lean{}:** Extensive list (30+ entries including `CechLocalized.*`, `AwayComparison.*`, `SectionCechModule.*` helpers).
- **\uses{}:** `def:section_cech_complex`, `def:qcoh_sections_localized`, `lem:section_cech_module_exact`, `lem:section_cech_product_equiv`, `lem:section_cech_objd_apply`, `lem:section_cech_coface_match`, `lem:section_cech_ab_exact` — all valid labels; iter-022 correctly added `lem:section_cech_objd_apply` to this set (was missing at iter-021 before the sub-lemma was introduced).
- **Proof sketch:** Explicitly chains the three sub-lemmas via `lem:section_cech_ab_exact` (the assembled ladder transport is the heavy lifting), citing `sectionCech_isZero_homology_of_objD_exact`, `exactAt_iff_isZero_homology`, and `ShortComplex.ab_exact_iff` in the right order.
- **VERDICT: complete + correct.**

#### `lem:cech_acyclic_affine` (§section form)

- **Statement:** `IsZero((sectionCechComplex(𝒰, F)).homology p)` for $p > 0$, where 𝒰 is the standard affine cover of `Spec R`.
- **\lean{}:** `AlgebraicGeometry.sectionCech_affine_vanishing` (the re-signed name per STRATEGY.md P3 decision) + `CombinatorialCech.*` helpers.
- **\uses{} (statement):** `def:section_cech_complex`, `def:standard_affine_cover` — minimal; correct for the statement.
- **\uses{} (proof):** `def:section_cech_complex`, `def:qcoh_sections_localized`, `lem:section_cech_homology_exact`, `lem:section_cech_module_exact`, `lem:section_cech_objd_apply`, `lem:section_cech_coface_match` — comprehensive for the proof, consistent with STRATEGY.md P3 re-sign rationale (absolute section complex, not relative pushforward).
- **Proof route:** Reduction via `def:qcoh_sections_localized` to the localized module complex, exactness node-by-node via `exact_of_isLocalized_span` + `CombinatorialCech.Dependent.depDiff_exact`, bridged to homology vanishing by `lem:section_cech_homology_exact`. The route is non-circular (P3 produces standard-cover Čech vanishing as input to the P3b bootstrap; it does NOT use affine vanishing as an input).
- **VERDICT: complete + correct.**

### Focus item audit — Lane 1: FreePresheafComplex.lean (re-confirmation, no changes)

All 8 blocks confirmed unchanged from iter-021 — leandag shows 0 `unknown_uses` and no `covers_problems`, so no `\uses{}` regression has occurred.

| Block | Statement present | Proof sketch present | \uses intact | Verdict |
|---|---|---|---|---|
| `lem:cech_free_eval_engine_iso` | ✓ | ✓ (degreewise iso + differential match via `Sigma.hom_ext`) | ✓ | clear |
| `lem:cech_free_eval_sectionwise` | ✓ | ✓ | ✓ | clear |
| `lem:cech_free_eval_empty` | ✓ | ✓ | ✓ | clear |
| `lem:cech_free_eval_prepend_homotopy` | ✓ | ✓ | ✓ | clear |
| `lem:cech_free_eval_prepend_homotopy_spec` | ✓ | ✓ | ✓ | clear |
| `lem:cech_free_eval_nonempty` | ✓ | ✓ | ✓ | clear |
| `lem:cech_free_complex_quasi_iso` | ✓ | ✓ | ✓ | clear |
| `lem:free_cech_engine` | ✓ | ✓ | ✓ | clear |

No regression. All 8 blocks CLEAR.

---

## Severity summary

**HARD GATE CLEARS — both active prover lanes.**

| Category | Count | Details |
|---|---|---|
| Must-fix (blocks gate) | 0 | — |
| Informational | 1 | `ShortComplex.ab_exact_iff_function_exact` naming in `lem:section_cech_ab_exact` proof body vs confirmed `ShortComplex.ab_exact_iff` in PROGRESS.md; mathematically equivalent, no structural issue, prover uses the confirmed name at proof-body time |
| Regressions | 0 | FreePresheafComplex blocks unchanged, all \uses intact |
| Broken \uses{} | 0 | leandag unknown_uses = [] |
| Rendering issues | 0 | blueprint-doctor clean |

**Lane 1 (FreePresheafComplex.lean):** HARD GATE CLEARS.
**Lane 2 (CechAcyclic.lean):** HARD GATE CLEARS. Key iter-022 additions (`lem:section_cech_objd_apply` new sub-lemma + two-layer tilde-bridge decomposition in `lem:section_cech_coface_match` + precursor+ladder-transport form in `lem:section_cech_ab_exact`) are complete and correct. Proof sketches are sufficiently detailed to formalize both the per-coordinate `IsLocalizedModule` iso + naturality square and the `Function.Exact.of_ladder_addEquiv_of_exact` ladder transport.

---

## Unstarted-phase blueprint proposals

*(omitted — all 4 strategy phases have ≥3 meaningful blueprint nodes with proof sketches)*

| Phase | Coverage status |
|---|---|
| P3 standard-cover Čech vanishing | Covered — `def:qcoh_sections_localized` + 3 sub-lemma chain + `lem:cech_acyclic_affine` §section form |
| P3b Čech↔derived bridge | Covered — `lem:cech_free_complex_quasi_iso` chain (8 nodes) + `lem:injective_cech_acyclic` + `lem:ses_cech_h1` + `lem:cech_vanish_basis` + `lem:cech_acyclic_affine` assembly |
| P5a vanishing inputs | Covered — `lem:higher_direct_image_presheaf` (resolution form, leanok) + `lem:open_immersion_pushforward_comp` + `lem:cech_term_pushforward_acyclic` + `lem:cech_augmented_resolution` |
| P5b comparison assembly | Covered — `lem:cech_computes_cohomology` (frozen signature) + `lem:acyclic_resolution_computes_derived` (leanok, Route A) |

---

iter022: HARD GATE CLEARS both lanes — 3 chapters audited, 0 must-fix findings, 0 unstarted-phase proposals
