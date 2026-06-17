# Blueprint Review: iter072
**Iter:** 072

## Top-level summaries

- **Isolated nodes**: 0 (leandag confirmed)
- **Broken \uses{}**: 0 (leandag `unknown_uses: []`)
- **Rendering**: 0 malformed_refs (blueprint-doctor clean)
- **Lean targets**: `lem:coreIso_comm_leg`, `lem:coreIso_comm_coface`, `lem:coreIso_comm_sum`, `lem:cechSection_isZero_homology` all `unmatched_lean` (expected — pending formalization, not broken)
- **Stale \uses**: `lem:cechSection_contractible` statement `\uses{}` includes `def:cech_free_presheaf_complex`; the statement talks only about `D'_aug` (from `lem:cechSection_complex_iso`) and the dep\* engine (from `lem:cech_acyclic_affine` / `lem:cech_engine_complex`) — `def:cech_free_presheaf_complex` not needed for the statement and is not in the proof `\uses{}` either.

## Directive-specific checks

**1. New chain `lem:coreIso_comm_leg` → `lem:coreIso_comm_coface` → `lem:coreIso_comm_sum`:**

- `lem:coreIso_comm_leg` (line 8783): statement complete; statement `\uses{lem:coreIso_obj_iso, lem:pushPull_eval_prod_iso, lem:pushPull_sigma_iso, lem:pushPull_leg_sections, lem:section_cech_product_equiv, lem:coverInterOpen_inf_distrib}` carries all proof deps (including `lem:coreIso_obj_iso` which the proof cites as "Unwind (objIso (p+1)).hom through its construction in Lemma lem:coreIso_obj_iso" but is only in statement \uses, not proof \uses — but rule "statement-level \uses carry proof deps" is satisfied). Proof sketch adequate.
- `lem:coreIso_comm_coface` (line 8830): statement `\uses{lem:coreIso_comm_leg, lem:section_cech_product_equiv, lem:section_cech_objd_apply}`; statement/proof \uses match; proof (coordinate-check via lem:coreIso_comm_leg) adequate. `lem:coreIso_obj_iso` referenced in text "with notation of Lemma lem:coreIso_obj_iso" but available transitively via `lem:coreIso_comm_leg` — not a broken edge.
- `lem:coreIso_comm_sum` (line 8860): statement `\uses{lem:coreIso_comm_coface, lem:section_cech_objd_apply, lem:section_cech_product_equiv}`; statement/proof \uses match; proof (termwise comparison) adequate.
- `lem:coreIso_comm` (line 8888): `\leanok` on statement; proof `\uses{lem:coreIso_comm_sum, lem:coreIso_obj_iso}` correctly delegates to the new chain. ✓

**2. `sectionCechAugV` blocks (from iter-070):**

- `def:sectionCechAugV` (line 8926): well-formed, `\uses{lem:coreIso_obj_iso, def:cech_augmentation}` ✓
- `lem:sectionCechAugV_comp_d` (line 8950): statement and proof `\uses{def:sectionCechAugV, lem:cech_augmentation_comp_d, lem:coreIso_comm}` match, proof sketch adequate ✓
- Both feed `lem:cechSection_complex_iso` which lists them in `\uses{}` ✓

**3. `lem:cechSection_contractible` adequacy:**

- Has `\leanok` on statement (line 9100) ✓
- Statement specifies: `V ≤ coverOpen 𝒰 i_fix` → augmented section Čech complex over V has contracting homotopy `id ≃ 0`
- NOTE clarifies prover target: `Homotopy (𝟙 D'_aug) 0` (augmented form, not bare complex) ✓
- Proof covers: (a) positive degrees via dep\* engine (from `lem:cech_acyclic_affine`), (b) augmentation node explicitly (projection + complementary term = id). Adequate for prover. ✓

**4. `lem:cech_acyclic_affine` `\lean{}` check:**

- `\lean{AlgebraicGeometry.sectionCech_affine_vanishing, AlgebraicGeometry.CombinatorialCech.combDifferential, ...}` — does NOT contain `AlgebraicGeometry.CechAcyclic.affine` ✓
- Dead-placeholder NOTE at line 1347–1352 explains the old decl is superseded and not a live obligation ✓

## Unstarted-phase proposals

*Omit — all strategy phases (P5a-resolution, P5b comparison assembly) covered by `Cohomology_CechHigherDirectImage.tex`.*

## Per-chapter

### `Cohomology_CechHigherDirectImage.tex`
- **Complete**: true (all needed declarations for active prover lane present with adequate proof sketches)
- **Correct**: true (0 `unknown_uses`, proof sketches mathematically sound)
- **Notes**:
  - New sub-lemma chain `lem:coreIso_comm_leg/coface/sum`: not leanok'd (pending, expected)
  - `def:sectionCechAugV`, `lem:sectionCechAugV_comp_d`, `lem:cechSection_complex_iso`: not leanok'd (pending, expected)
  - Stale \uses: `lem:cechSection_contractible` statement lists `def:cech_free_presheaf_complex` unnecessarily — this entry predates iter-072 and is not a new issue

### `Cohomology_AcyclicResolution.tex`
- **Complete**: true
- **Correct**: true
- All major theorems `\leanok` on statement and proof. No issues.

### `Cohomology_HigherDirectImage.tex`
- **Complete**: true
- **Correct**: true
- Thin chapter, `def:higher_direct_image` `\leanok`. No issues.

## Severity summary

- **must-fix**: none
- **soon**: `Cohomology_CechHigherDirectImage.tex` — `lem:cechSection_contractible` statement `\uses{}` contains stale `def:cech_free_presheaf_complex` entry (not needed for statement; remove at next writer pass)

## HARD GATE verdict

**PASS**: `CechSectionIdentification.lean` may be dispatched to prover.
- Chapter `Cohomology_CechHigherDirectImage.tex`: `complete: true`, `correct: true`, no must-fix touching it.
- New chain (`lem:coreIso_comm_leg/coface/sum`) has adequate blueprint coverage. `lem:coreIso_comm` has `\leanok` on statement, delegating to new chain. `lem:cechSection_contractible` has `\leanok` and adequate proof sketch.
- leandag: 0 unknown_uses, 0 isolated, blueprint-doctor: 0 malformed_refs.
