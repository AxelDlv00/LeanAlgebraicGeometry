# Blueprint Writer Report

## Slug
gr-cov

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_GrassmannianCells.tex

## Changes Made
All six coverage blocks inserted immediately after `\label{sec:gr_separated}` and
before `\begin{lemma}` of `lem:gr_separated` (with a one-sentence lead-in
paragraph), each with `\label{}`, `\lean{}`, accurate `\uses{}`, and an informal
proof. No `% SOURCE` lines (project-bespoke ring algebra). No `\leanok` added.

- **Added lemma** `\label{lem:gr_transitionPreMap_minorDet_swap_mul}` / `\lean{…transitionPreMap_minorDet_swap_mul}` — two-sided inverse identity `θ̃_{I,J}(P^J_I)·P^I_J = 1`; proof via `lem:gr_transitionPreMap_minorDet` (K=I) + `lem:gr_universalMatrix_map_transitionPreMap` reducing to `det(X^I_J)^{-1}·det(X^I_J)=1`.
- **Added definition** `\label{def:gr_diagonalRingMap}` / `\lean{…diagonalRingMap}` — restricted-diagonal comorphism `δ_{I,J} : ℤ[X^I]⊗ℤ[X^J] → R^I_J`; construction as tensor-product lift of structure map (left) and `θ̃_{I,J}` (right).
- **Added lemma** `\label{lem:gr_diagonalRingMap_left}` / `\lean{…diagonalRingMap_left}` — `δ_{I,J}(a⊗1) = alg(a)`; immediate from the lift.
- **Added lemma** `\label{lem:gr_diagonalRingMap_right}` / `\lean{…diagonalRingMap_right}` — `δ_{I,J}(1⊗b) = θ̃_{I,J}(b)`; immediate from the lift.
- **Added lemma** `\label{lem:gr_diagonalRingMap_surjective}` / `\lean{…diagonalRingMap_surjective}` — `δ_{I,J}` surjective; localisation-surjectivity witness `a⊗(P^J_I)^n` collapses to `z` via the swap-mul identity.
- **Added definition** `\label{def:gr_pullbackιIso}` / `\lean{…pullbackιIso}` — source pullback iso `e₂ : pullback(ι_i)(ι_j) ≅ chartOverlap`; via the glue-data limit cone compared with the categorical pullback limit.
- **Revised** `lem:gr_separated` — appended `lem:gr_diagonalRingMap_surjective` to the `\uses{}` of BOTH the statement block and the proof block (kept `def:gr_glued_scheme, def:gr_transition`). Statement/proof prose untouched.

## Cross-references introduced
- `def:gr_pullbackιIso` label uses the Greek `ι` to mirror the Lean name `pullbackιIso`, as named verbatim in the directive. If the LaTeX toolchain mishandles non-ASCII in `\label`/`\hyperref`, the plan agent may wish to rename it (nothing `\uses{}` it, so a rename is local).
- Block 6 `\uses{}` includes `def:gr_chart_overlap` (in addition to the directive's `def:gr_glued_scheme`) because the iso's target is `chartOverlap`, which that definition provides — keeps the dependency edge accurate. All cited labels (`def:gr_transition_pre`, `lem:gr_universalMatrix_map_transitionPreMap`, `lem:gr_transition_pre_unit`, `lem:gr_transitionPreMap_minorDet`, `def:gr_glued_scheme`, `def:gr_chart_overlap`) verified present in this chapter.

## Verification
- `leandag build --json`: `unknown_uses: []`; no isolated nodes in `Picard_GrassmannianCells` (`leandag query --isolated --chapter Picard_GrassmannianCells` → none); all six new `\lean{}` names matched real Lean declarations (none in `unmatched_lean`). `lean_aux` isolated nodes dropped to 4 (the three `private` helpers the directive excluded, plus one unrelated), confirming the six previously-isolated decls are now wired in.
- LaTeX environment balance over the whole chapter: lemma 46/46, definition 23/23, proof 41/41.

## References consulted
None — all six blocks are Archon-original / project-bespoke ring algebra; no `% SOURCE` blocks written, no `references/` files opened.

## Macros needed (if any)
None — all commands (`\Spec`, `\det`, `\mathrm`, `\otimes`, `\tilde\theta`, `\texttt`) already in use in this chapter.

## Notes for Plan Agent
- The `lem:gr_separated` Lean target `Grassmannian.isSeparated` still does not exist (its `% NOTE (iter-033)` records the remaining glue-assembly work). The six new blocks now give the surjective-comorphism core full blueprint coverage feeding into it.
- Consider whether `def:gr_pullbackιIso` (Greek-ι label) should be ASCII-renamed for toolchain robustness; flagged above.

## Strategy-modifying findings
None.
