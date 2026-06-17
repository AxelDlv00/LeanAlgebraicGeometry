# Blueprint Review: iter050
**Iter:** 050

## Top-level summaries

- **Incomplete**: none (all directive blocks present in all three edited chapters).
- **Correct/partial**: `Picard_GrassmannianQuot.tex` — `def:scheme_modules_glue` has no Lean API path (construction described mathematically but no pointer to Mathlib gluing/descent infrastructure).
- **Mathlib anchors**: `PresheafOfModules.monoidalCategory`, `PresheafOfModules.sheafification`, `SheafOfModules.unit` all verified present in Mathlib — `\mathlibok` claims are faithful.
- **Unnamed Mathlib deps (soon)**: `lem:gf_flat_locality_assembly` (G3) cites "base-maximal locality criterion," "transitivity of flatness," and "flatness detected at source-affine points" without `\mathlibok` anchors.
- **Deps/Isolated**: `unknown_uses: 0` (no broken `\uses{}` edges); 10 isolated nodes all `lean_aux` type — no blueprint action needed. 3 gap nodes in QuotScheme (pre-existing, no `\lean{}` hints) — not new.

## Unstarted-phase proposals

OMIT — all remaining strategy phases have adequate blueprint coverage (≥3 meaningful blocks):
- FBC-A1/A2/B → FlatBaseChange.tex;  GF-geo → FlatteningStratification.tex (just completed);
- SNAP → SectionGradedRing.tex; QUOT-defs → QuotScheme.tex; QUOT-repr → GrassmannianQuot.tex + RelativeSpec.tex;
- SNAP-S1/S3 BLOCKED on Q1 — no blueprint owed.

## Per-chapter

### `Picard_FlatteningStratification.tex`
- **Complete**: true
- **Correct**: true
- **Notes**:
  - `lem:gf_localGenerators_restrict` (seam-1a): present, proof sound, no `\uses{}` needed (no internal deps). No `\leanok` yet — correct, prover target.
  - `lem:gf_finiteType_affine_finite_cover_generated` (assembly): complete. `\uses{lem:gf_localGenerators_restrict, lem:gf_affine_finite_standard_subcover, lem:gf_finite_gen_iff_free_epi}` — all valid.
  - `lem:gf_qcoh_fintype_finite_sections` (G1): complete. `\uses{lem:gf_finite_sections_of_basicOpen_finite_cover, lem:gf_finiteType_affine_finite_cover_generated, lem:gf_qcoh_sections_free_epi}` — all valid.
  - `lem:gf_flat_locality_assembly` (G3): complete, proof logically sound. **Soon-fix**: proof invokes three standard flatness-locality Mathlib facts without names — "base-maximal locality criterion for flatness," "transitivity of flatness," "stalk flatness ⟹ module flatness over local base." Recommend adding `\mathlibok` anchors (e.g., `Module.Flat.iff_localization`, `Module.Flat.comp` / `IsLocalization.flat`, and an appropriate stalk-flat criterion). Without these a prover must search blind.
  - `thm:generic_flatness`: already `\leanok`. `\uses{thm:generic_flatness_algebraic, lem:gf_qcoh_fintype_finite_sections, lem:gf_flat_locality_assembly}` — valid. Proof assembles all seams correctly.
  - **HARD GATE**: PASSES. Chapter complete + correct; GF lane may proceed.

### `Picard_GrassmannianQuot.tex`
- **Complete**: true
- **Correct**: partial
- **Notes**:
  - `def:is_locally_free_of_rank`: complete and correct. Definition clear, `\lean{AlgebraicGeometry.Scheme.Modules.IsLocallyFreeOfRank}` [expected].
  - `def:scheme_modules_glue`: **MUST-FIX.** Mathematical content is correct (module gluing along a `GlueData` with transition isomorphisms satisfying module cocycle). However:
    1. No `\lean{}` implementation path given. `AlgebraicGeometry.Scheme.Modules.glue` does not exist yet (unmatched) — the prover must build it. The blueprint says "effective descent for the Zariski cover" but names no Lean API. This is the hardest declaration in the chapter; without a construction hint (e.g., "use `SheafOfModules.pushforwardPushforwardEquivalence`-style descent, or build from `Scheme.GlueData.openCoverOfGluing` + `ShMod` restriction maps") the prover cannot determine the correct Lean approach.
    2. The morphism-descent half ("φ_i commuting on overlaps ⟹ unique glued φ") is stated but the proof strategy is "descent of Hom" — again no Lean path.
    - **Recommended fix**: add `% NOTE: Implementation path — use [specific Mathlib API]` or a concrete `\lean{}` hint, or explicitly mark as "Archon-original construction; no Mathlib API covers this directly — prover must build from GlueData.glue + SheafOfModules restriction."
  - `def:gr_chart_quotient`: complete and correct. Source citation verbatim, Nitsure §1. `\lean{AlgebraicGeometry.Grassmannian.chartQuotientMap}` [expected].
  - `def:gr_universal_quotient_sheaf`: complete. Cocycle verification `g_{I,K} = g_{J,K} g_{I,J}` asserted, not proved — acceptable for a definition; prover will need to verify. `\uses{}` includes `def:gr_universalMinorInv` and `lem:gr_cocycle` correctly.
  - `def:tautological_quotient`: complete. Key identity `g_{I,J} X^I = X^J` attributed to `def:gr_transition` — prover can verify this from the transition formula.
  - `def:grassmannian_functor`: complete and correct. References Nitsure Exercise (2) verbatim; source quote verified.
  - `thm:grassmannian_universal_property`: complete proof with explicit construction (Zariski-local trivialization, uniqueness via `ker(q)` detection). Proof is detailed enough for a prover. `\uses{}` comprehensive.
  - **HARD GATE**: PARTIAL — `def:scheme_modules_glue` correct:partial (missing Lean path). Options:
    1. **Fast path**: dispatch blueprint writer to add a `% NOTE:` / Lean-hint to `def:scheme_modules_glue`, then scoped re-review.
    2. **Default**: GR-quot prover does `sorry`-scaffold this iter (adequate for scaffold objective); defer real implementation.

### `Picard_SectionGradedRing.tex`
- **Complete**: true
- **Correct**: true
- **Notes**:
  - `\mathlibok` anchors verified in Mathlib: `PresheafOfModules.monoidalCategory` ✓ (instance), `PresheafOfModules.sheafification` ✓ (def), `SheafOfModules.unit` ✓ (def). Forms match blueprint statements.
  - `lem:isIso_sheafification_whiskerRight_unit`: proof present and sound. Key step "J.W is monoidal for Z-tensor" (local isos preserved under Z-tensor whiskering) stated without a specific Mathlib lemma name. **Prover note**: this likely needs `GrothendieckTopology`-level infrastructure; search Mathlib for `Category.J.W` + tensor monoidal or use the internal-hom-is-sheaf route directly.
  - `cor:sheafTensorObjAssoc`: proof complete, correctly uses `lem:isIso_sheafification_whiskerRight_unit` twice (right-whisker and left-whisker via braiding). Composition route is correct.
  - `lem:sheafTensorPow_add` (rewired): proof complete. Induction on `m` with base the left-unitor and step using associator + braiding + IH. **Prover note**: reindexing `(m+m')+1 = (m+1)+m'` at the final step requires explicit `Nat.succ_add`/`eqToIso` handling in Lean — not mentioned in blueprint. Not a correctness issue, just a Lean friction point.
  - `lem:sectionMul_coherent`: proof complete, adequately detailed.
  - `lem:sectionGradedRing_gcommSemiring`: complete, correct, proof references `lem:sectionMul_coherent` and `lem:sheafTensorPow_add`.
  - `lem:sectionGradedModule_gmodule`: complete, correct.
  - **HARD GATE**: PASSES. Chapter complete + correct; SNAP iter-051 prover may proceed.

### Non-edited chapters (audited for cross-chapter consistency)
- `Cohomology_FlatBaseChange.tex`: complete, correct (no changes). FBC lane status unchanged.
- `Cohomology_RegroupHelper.tex`: complete, correct.
- `Picard_GrassmannianCells.tex`: complete, correct.
- `Picard_QuotScheme.tex`: 3 pre-existing gaps (no `\lean{}` hints on `lem:composite_basic_open_immersion_isOpenImmersion`, `lem:gamma_pullback_image_iso`, `lem:composite_immersion_flocus_basicOpen` or similar) — not changed this iter.
- `Picard_RelativeSpec.tex`: 5 blocks, phase BLOCKED on Q4.

## Dependency / rendering audit

- **leandag `unknown_uses`**: 0 — no broken `\uses{}` edges in entire blueprint.
- **leandag `isolated`**: 10 nodes, all `lean_aux` type — Lean helper declarations not yet blueprinted; no removal candidates.
- **leandag `unmatched_lean`**: 78 entries. All are either: (a) `\mathlibok` anchors pointing at Mathlib (not scanned locally — expected), or (b) new unformalized prover targets this iter (GF seam lemmas, GR-quot blocks, SNAP blocks). No spurious entries detected.
- **blueprint-doctor**: 0 malformed_refs, 0 broken_refs, 0 orphan chapters — rendering CLEAN.

## Severity summary

- **must-fix**: `Picard_GrassmannianQuot.tex` — `def:scheme_modules_glue` missing Lean implementation path (correct:partial; HARD GATE partial).
- **soon**: `Picard_FlatteningStratification.tex` — `lem:gf_flat_locality_assembly` proof needs `\mathlibok` anchors for flatness-locality Mathlib lemmas.
- **prover-notes** (not blueprint fixes): (1) SNAP `lem:isIso_sheafification_whiskerRight_unit` — "J.W monoidal" step needs Mathlib search. (2) SNAP `lem:sheafTensorPow_add` — Nat reindexing `eqToIso` friction.
