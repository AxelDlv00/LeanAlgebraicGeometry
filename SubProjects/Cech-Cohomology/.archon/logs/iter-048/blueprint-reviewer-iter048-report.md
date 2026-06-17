# Blueprint Review Report

## Slug
iter048

## Iteration
048

## Top-level summaries

### Dependency & isolation findings

- `Cohomology_CechHigherDirectImage.tex` / `lem:isLocalizedModule_of_exact`: `proved=False` in leandag despite the Lean decl `AlgebraicGeometry.isLocalizedModule_of_exact` existing axiom-clean in `QcohTildeSections.lean` (line 1192, not private). The blueprint block was authored this iter but `\leanok` was not set. `sync_leanok` should pick this up next cycle. **wire-up** — add `\leanok` to the statement block (not a missing `\uses` edge; the `\uses{lem:localized_module_map_exact_mathlib}` is correct). Severity: **soon** (does not block the assembly prover, whose direct deps are already proved/mathlibok).

- `Cohomology_CechHigherDirectImage.tex` / `lem:overlap_section_localization`: same situation — `proved=False` in leandag; `\leanok` absent. Additionally, the three `\lean{}` hints name `AlgebraicGeometry.overlap_section_localization`, `AlgebraicGeometry.overlap_target_eq`, `AlgebraicGeometry.presheaf_map_comp₂_apply` — but all three are `private lemma` in `QcohTildeSections.lean` (lines 1277, 1290, 1301). leandag finds them via its private-decl scan and doesn't report them as `unmatched_lean`, but `sync_leanok` looks up the public names (which don't exist), so `\leanok` will never propagate automatically. **wire-up** — add `\leanok` manually (blueprint writer, one pass), and optionally rename to `\lean{...}` with the private-internal names or annotate as `% private decls`. Severity: **soon** (not on the assembly critical path).

- `Cohomology_CechHigherDirectImage.tex` / `lem:isIso_fromTildeGamma_of_quasicoherent` (dormant Route A node, line 5999): leandag `show gaps` reports this node has no `\lean{}` hint. This is a dormant block (off the 01I8 live critical path per STRATEGY and `rem:o1i8_decomposition`) so not blocking. **keep** (intentionally dormant) — add `\lean{AlgebraicGeometry.isIso_fromTildeGamma_of_quasicoherent}` [expected] when the dormant lane is reactivated. Severity: **informational**.

- Isolated node: 1 `lean_aux` node (Lean helper with no blueprint entry). **keep** — standard uncovered-helper signal, not a blueprint gap.

## Per-chapter

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

- **complete**: true
- **correct**: true
- **notes**:

  **Gate audit — `lem:qcoh_isIso_fromTildeGamma` (assembly target):**

  - Statement is faithful: matches Stacks Tag 01I8 (`lemma-quasi-coherent-affine`) verbatim — "Let (X, O_X) = (Spec R, ...). Let F be a quasi-coherent O_X-module. Then F is isomorphic to the sheaf associated to the R-module Γ(X,F)." The `\lean{AlgebraicGeometry.isIso_fromTildeΓ_of_quasicoherent}` hint is the correct target.
  - Proof sketch (lines 5237–5257) is four named steps, each pointing to the exact lemma: (1) `lem:forget_reflectsIso_mathlib` — reflects isos + D(f) is a basis → check component-wise; (2) `lem:fromTildeGamma_mathlib` — D(f)-component IS the localization lift of ρ_f; (3) `lem:qcoh_section_isLocalizedModule` — ρ_f is `IsLocalizedModule(powers f)`; (4) `lem:isLocalizedModule_linearEquiv_mathlib` — lift between two localizations at the same set is iso. Sufficient to formalize without guessing.
  - All 5 `\uses` deps present and done:
    1. `lem:qcoh_section_isLocalizedModule` — `proved=True` (\leanok, axiom-clean, iter-047) ✓
    2. `lem:fromTildeGamma_mathlib` — `\mathlibok` ✓
    3. `lem:isIso_fromTildeGamma_iff_mathlib` — `\mathlibok` ✓
    4. `lem:forget_reflectsIso_mathlib` — `\mathlibok` ✓
    5. `lem:isLocalizedModule_linearEquiv_mathlib` — `\mathlibok` ✓
  - **HARD GATE CLEARS** for the assembly prover lane.

  **Gate audit — reconciled keystone cluster:**

  - `lem:qcoh_section_isLocalizedModule` (`proved=True`): `\uses` is `{lem:qcoh_finite_presentation_cover, lem:qcoh_section_equalizer, lem:localized_module_map_exact_mathlib, lem:tile_section_localization, lem:isLocalizedModule_of_exact, lem:section_isLocalizedModule_of_presentation}`. Direction is acyclic: the keystone uses the abstract lemma, not the other way around. This is the corrected direction from the prior iter-047 `qts` flag. Proof sketch is detailed: equalizer-at-X, equalizer-at-D(f), per-tile localizations (b, c), abstract kernel comparison via `lem:isLocalizedModule_of_exact`. Non-circularity argument is explicitly included in the proof block. Correct.

  - `lem:qcoh_section_kernel_comparison` (`proved=True`): `\uses{lem:qcoh_section_isLocalizedModule, lem:isLocalizedModule_linearEquiv_mathlib}`. Corollary uses keystone — direction correct. Proof is a one-liner (packaging). Correct.

  - `lem:isLocalizedModule_of_exact`: Archon-original, `\uses{lem:localized_module_map_exact_mathlib}`. Three-clause diagram chase proof (invertibility of S-action on A'; surjectivity via i',b; torsion condition via b localization) is complete and formalizable. No `% SOURCE:` required (Archon-original, no external source). `\lean{AlgebraicGeometry.isLocalizedModule_of_exact}` is a real decl (confirmed in `QcohTildeSections.lean:1192`). Missing `\leanok` (sync artifact — SOON, not must-fix).

  - `lem:overlap_section_localization`: Transport of `lem:tile_section_localization` along basic-open lattice identities D(ab)=D(a)∩D(b) and D(abf)=D(af)∩D(bf). `\uses{lem:tile_section_localization}` — correct and sufficient. Proof sketch adequate for formalization. `\lean{}` names three private decls with public-namespace spellings — leandag finds them via private scan but `sync_leanok` won't propagate `\leanok` automatically. SOON finding (see Dependency & isolation above).

  **leandag checks:**
  - `unknown_uses: []` — zero broken `\uses{}` edges.
  - Isolated blueprint nodes: 0 (only 1 isolated node total, and it is `lean_aux`).
  - `unmatched_lean` list: contains only Mathlib-side names (expected for `\mathlibok` anchors) and `AlgebraicGeometry.isIso_fromTildeΓ_of_quasicoherent` (the new target, not yet built).

  **blueprint-doctor:**
  - `malformed_refs: []` — zero rendering issues.
  - `orphan_chapters: []`, `broken_refs: []`, `covers_problems: []` — all clean.

  **Chapter completeness:**
  - All 12 `archon:covers` files have declaration blocks.
  - Route-B critical path (`B0–B4 → qcoh_section_equalizer → tile_section_localization → overlap_section_localization → isLocalizedModule_of_exact → qcoh_section_isLocalizedModule → qcoh_section_kernel_comparison → qcoh_isIso_fromTildeGamma`) fully blueprinted.
  - Dormant Route A blocks (P0–P4 global-generation route) present and clearly labelled dormant via `rem:o1i8_decomposition` and inline comments.

## Severity summary

**must-fix-this-iter**: none.

**soon** (2 items, do not block any active prover):
1. `lem:isLocalizedModule_of_exact` — missing `\leanok`; Lean decl is public and axiom-clean (confirmed via proved keystone). Writer: add `\leanok` to statement block.
2. `lem:overlap_section_localization` — missing `\leanok`; `\lean{}` names private decls with public-namespace prefixes (sync_leanok cannot match). Writer: add `\leanok` manually; optionally annotate the `\lean{}` as private helpers.

**informational** (1 item):
- `lem:isIso_fromTildeGamma_of_quasicoherent` (dormant Route A): no `\lean{}` hint (gap node). Add when dormant lane reactivates.

Overall verdict: `Cohomology_CechHigherDirectImage.tex` is **complete + correct** with no must-fix-this-iter findings; the HARD GATE **CLEARS** for the Route-B assembly prover lane building `AlgebraicGeometry.isIso_fromTildeΓ_of_quasicoherent` — all 5 direct `\uses` deps of `lem:qcoh_isIso_fromTildeGamma` are proved or mathlib-backed. 3 chapters audited, 3 findings (0 must-fix, 2 soon, 1 informational), 0 unstarted-phase proposals.
