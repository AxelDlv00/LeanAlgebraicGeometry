# blueprint-clean directive — purify the iter-046 edits to Cohomology_CechHigherDirectImage.tex

## Chapter

`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`.

## Scope

Two writer rounds edited this chapter this iter:
1. `coverage-debt` — added three general-open companion blocks (`lem:modulesRestrictBasicOpen_smul_eq_genV`,
   `lem:tile_section_ring_identity_genV`, `lem:tile_scalar_compat_genV`) plus bundled the two private
   wrappers `appIso_inv_res`/`appIso_inv_res_assoc` into the ring-identity block's `\lean{}`.
2. `step4` — rewrote Step 4/5 of `lem:tile_section_localization` to the restriction-of-scalars descent
   and removed stale planner NOTEs.

Strip any Lean-syntax leakage (tactic names, `letI`/`inferInstance`/instance identifiers, `rfl`-as-proof
mentions in prose), project-history verbosity ("this iter", "iter-0xx", "the prover"), and any
left-behind planner TODO NOTE that is now satisfied. Preserve all `\label{}`, `\lean{}`, `\uses{}`,
`% SOURCE`/`% SOURCE QUOTE` citation comments, and `% NOTE (review iter-045)` markers that record genuine
semantic facts. Do NOT alter mathematical content, do NOT touch `\leanok`/`\mathlibok`. Confirm the three
new companion blocks read as math (statement + one-line informal proof), not as Lean.
