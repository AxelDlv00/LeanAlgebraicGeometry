# Blueprint Review: grquot-recheck
**Iter:** 050

## Top-level summaries

- **Lean targets (minor)**: `def:is_locally_free_of_rank` in GrassmannianQuot uses `\lean{AlgebraicGeometry.Scheme.Modules.IsLocallyFreeOfRank}` (unmatched); the existing proved implementation is `AlgebraicGeometry.SheafOfModules.IsLocallyFreeOfRank` in QuotScheme.lean. Duplicate label (`def:is_locally_free_of_rank`) appears in both `Picard_QuotScheme.tex` and `Picard_GrassmannianQuot.tex` with different `\lean{}` targets. Prover will need to add a trivial alias under `Scheme.Modules`; the math is correct and the duplicate causes no `unknown_uses` or `broken_refs`.

## GATE RESULT: CLEARED

`Picard_GrassmannianQuot.tex` is **complete: true / correct: true** for gating the GR-quot prover lane this iter. No must-fix-this-iter finding.

## Key item: def:scheme_modules_glue — ADEQUATE

The added "Realisation (construction path)" subsection (lines 138–168) provides a concrete, actionable build strategy:
1. Instantiate via `def:gr_the_glue_data` (proved, in GrassmannianCells.lean).
2. Chart restriction via the open-immersion pullback equivalence (already used in QuotScheme construction — matches existing project infrastructure).
3. Glue via locality of sections (sheaf property / descent datum from the cocycle conditions).
4. Morphism-descent via Hom locality (compatible family of local morphisms → unique global morphism).

Explicit acknowledgement that this is Archon-original (no off-the-shelf primitive). The path is realistic and commensurate with existing project technique. **Adequate for a prover.**

## Per-chapter: Picard_GrassmannianQuot.tex

- **Complete**: true
- **Correct**: true
- **Notes**:
  - `def:scheme_modules_glue` — construction path adequate (see above); `\uses{def:gr_the_glue_data}` valid (proved). No `unknown_uses`.
  - `def:is_locally_free_of_rank` — math correct, `\uses{}` clean; `\lean{}` hint names `Scheme.Modules.IsLocallyFreeOfRank` (unmatched, as expected for a new target). Duplicate label with QuotScheme chapter is a **soon** (not must-fix) issue: prover should add `alias AlgebraicGeometry.Scheme.Modules.IsLocallyFreeOfRank := AlgebraicGeometry.SheafOfModules.IsLocallyFreeOfRank` (or equivalent) and the DAG will re-link.
  - `def:gr_chart_quotient` — complete+correct; Nitsure §1 source present + verbatim quote; `\uses{def:gr_affine_chart, def:gr_universal_matrix}` both proved.
  - `def:gr_universal_quotient_sheaf` — complete+correct; cocycle condition checked; all `\uses{}` valid.
  - `def:tautological_quotient` — complete+correct; surjectivity argument via chart-local split surjections; all `\uses{}` valid.
  - `def:grassmannian_functor` — complete+correct; equivalence with Nitsure's Quot-of-trivial-sheaf form made explicit.
  - `thm:grassmannian_universal_property` — complete+correct; full proof (naturality, inverse construction via Nakayama + cover, uniqueness); `\uses{}` graph clean; Archon-original proof of external statement (no `% SOURCE QUOTE PROOF:` required).

## DAG / rendering checks

- `leandag build`: `unknown_uses: 0` — no broken `\uses{}` edges anywhere in the blueprint.
- GrassmannianQuot chapter: 0 isolated blueprint nodes (all 10 isolated nodes are `lean_aux` type — uncovered helpers, not blueprint gaps).
- `archon blueprint-doctor`: `broken_refs: []`, `malformed_refs: []` — rendering clean.
- All 7 GrassmannianQuot `\lean{}` targets are in `unmatched_lean` — expected for an un-started prover chapter (these are prover creation targets, not mathlib-anchor failures).

## Severity summary

- **soon**: `def:is_locally_free_of_rank` duplicate label + namespace mismatch (prover adds a trivial alias; writer may clean up duplicate label next iter).
- No must-fix findings.
