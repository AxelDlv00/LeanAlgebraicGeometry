# blueprint-clean directive — chapter `Cohomology_CechHigherDirectImage.tex`

## Scope
Post-write purity pass on `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` after the
iter-048 `fix-deps` writer round, which:
- authored `lem:isLocalizedModule_of_exact` (abstract left-exact-ladder kernel comparison) and
  `lem:overlap_section_localization` (per-overlap localization corollary);
- flipped the `\uses` edge between `lem:qcoh_section_isLocalizedModule` (keystone) and
  `lem:qcoh_section_kernel_comparison` (now a one-line corollary);
- moved the equalizer→ladder→kernel chase into the keystone proof;
- updated the `% NOTE:` comments on both blocks.

## What to do
- Strip any Lean syntax / tactic leakage that crept into the two NEW blocks
  (`lem:isLocalizedModule_of_exact`, `lem:overlap_section_localization`) and the rewritten keystone /
  kernel-comparison proofs. The prose must be mathematical, not syntactic.
- Remove project-history verbosity / stale planner-narrative left in `% NOTE:` comments where it no
  longer reflects the corrected state (the inversion is fixed; do not leave "planner must flip"
  language).
- Do NOT touch `\leanok` / `\mathlibok` markers, `\lean{}` pins, or `\uses{}` lists — those are
  correct as set by the writer and the planner.
- Do NOT alter the `% SOURCE` / `% SOURCE QUOTE` citation blocks on the keystone statement.
- Validate LaTeX environment balance after editing.
