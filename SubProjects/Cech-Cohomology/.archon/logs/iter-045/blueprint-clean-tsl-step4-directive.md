# Blueprint-clean directive

## Chapter
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Context
A blueprint-writer (`tsl-step4`) just edited this chapter: it added 5 new lemma blocks in the
`TileSectionLocalization` section (`lem:appTop_appIso_inv_eq_res`, `lem:key_morph`, `lem:tile_appIso_comp`,
`lem:tile_section_ring_identity`, `lem:tile_scalar_compat`), revised the `lem:tile_section_comparison`
proof (underlying-type vs bundled-module distinction), and rewrote `lem:tile_section_localization` Step 4
to the underlying-type descent path. See `.archon/task_results/blueprint-writer-tsl-step4.md`.

## Task
Purify the edited region (the `TileSectionLocalization` section and the surrounding tile blocks):
- Strip any Lean syntax / tactic leakage that crept into prose (raw `\texttt{}` Lean names are fine as
  references, but no tactic strings, no `rw`/`simp`/`congr`, no `.olean`/heartbeat-count prose dressed as math).
- Remove project-history / iteration narrative ("iter-044", "the prover landed", "PARTIAL this iter",
  review-process commentary) from VISIBLE prose — these belong in `% NOTE` comments at most, not in the
  typeset statement/proof bodies.
- Keep the mathematics intact: the 5 new blocks, the corrected `tile_section_comparison` proof, and the
  rewritten Step 4 must remain mathematically complete and faithful. Do NOT delete the `% NOTE` warnings
  about the unsound `restrict_obj`-rfl recipe or the unformalized status of `lem:tile_section_comparison`.
- Do NOT touch `\leanok` / `\lean{}` / `\mathlibok` markers.
- Validate that the displayed ring identity and the `\uses{}` edges read as math, not as a changelog.
