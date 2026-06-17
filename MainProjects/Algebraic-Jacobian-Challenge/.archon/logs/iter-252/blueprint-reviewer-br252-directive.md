# blueprint-reviewer br252 — directive

Whole-blueprint audit. Read every chapter under
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/`.
Produce your standard per-chapter checklist (complete? correct? Lean targets well-formed? proofs
detailed enough to formalize?) plus the HARD-GATE verdict for the files under active prover work
this iter, and your `## Unstarted-phase blueprint proposals` section.

## Files under active prover work this iter (HARD GATE applies)
Both are covered by the consolidated chapter `Picard_TensorObjSubstrate.tex`
(`% archon:covers` lists `TensorObjSubstrate.lean`, `StalkTensor.lean`, `Vestigial.lean`, `DualInverse.lean`):
1. `Picard/TensorObjSubstrate.lean` — D1′ comparison-iso naturality (`pullbackTensorMap_natural`),
   then D3′ (`pullbackTensorMap_restrict`), D4′ (`pullbackTensorIsoOfLocallyTrivial`).
2. `Picard/TensorObjSubstrate/DualInverse.lean` — `homOfLocalCompat`, `dual_restrict_iso`, `dual_isLocallyTrivial`.

Confirm the chapter is complete + correct for these targets (your iter-251 verdict br251 was HARD GATE
PASS, 0 must-fix). Two non-must-fix MAJOR findings from the per-file checkers this iter that you should
re-judge as a blueprint-completeness matter:
- The proof sketch for `lem:pullback_tensor_map_natural` (D1′) does not mention the carrier-normalisation
  technique the prover needed for the 4th naturality square (`sheafifyTensorUnitIso_hom_natural`): after a
  `sheafifyTensorUnitIso_hom_eq`-style rewrite onto the `⋙ forget₂` carrier, the Mathlib whisker lemmas
  fire. A planned blueprint-writer pass will add this note — flag whether you agree it's needed.
- `dual_unit_iso` is named in the proof of `lem:dual_isLocallyTrivial` (Step 3) but has no `\lean{}`
  block, so it is untracked. A planned writer pass will add a block. Confirm.

These are improvements to a chapter you already passed; tell me whether either rises to must-fix (i.e.
would block the prover from making real progress this iter) or is genuinely non-gating documentation.

Do NOT restrict yourself to these — audit the whole blueprint as usual and surface anything else.
