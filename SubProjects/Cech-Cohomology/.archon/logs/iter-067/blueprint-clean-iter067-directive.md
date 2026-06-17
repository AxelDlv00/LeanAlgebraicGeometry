# Blueprint-clean directive — slug `iter067`

## Scope

`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` received two writer rounds this iter:
1. Three augmentation-helper blocks added (`lem:mapHC_augment_iso`, `lem:map_augment_cond`,
   `lem:augmentCochainIso`) + an expanded `hcompat`/`coreIso` proof-sketch in `lem:cechSection_complex_iso`.
2. A 3-lemma decomposition of the `coreIso` residual (`lem:coverInterOpen_inf_distrib`,
   `lem:coreIso_obj_iso`, `lem:coreIso_comm`) wired into `lem:cechSection_complex_iso`.

## Task

Run the standard blueprint-purity pass over the regions edited this iter (the new helper blocks, the
new `coreIso` chain, and the `lem:cechSection_complex_iso` proof body):
- Strip any Lean-syntax leakage / tactic strings / raw Lean identifiers that crept into prose (keep
  `\lean{}` pins and `\uses{}` labels — those are structural, not prose).
- Remove project-history / iteration-narrative verbosity if any was introduced.
- Confirm all `\ref`/`\uses` references in the edited regions resolve.
- Do NOT touch `\leanok`/`\mathlibok` markers. Do NOT alter any mathematical statement or `% NOTE:`.
- Do NOT touch `lem:cechSection_contractible` or unrelated chapters.

No new external sources are needed.
