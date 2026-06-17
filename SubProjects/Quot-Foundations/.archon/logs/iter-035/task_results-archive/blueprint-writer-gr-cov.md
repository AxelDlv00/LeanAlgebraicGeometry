# Blueprint Writer Report

## Slug
gr-cov

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_GrassmannianCells.tex

## Changes Made
Added six new declaration blocks in the separatedness section (immediately after
`def:gr_pullbackιIso`, before `lem:gr_separated`), restoring 1-to-1 Lean↔blueprint
correspondence for the iter-034 `Grassmannian.isSeparated` assembly machinery. No
`\leanok` added (sync phase owns it). All blocks are project-bespoke infrastructure —
no external SOURCE QUOTE (none required per directive).

- **Added definition** `\definition`/`\label{def:gr_to_specZ}`/`\lean{AlgebraicGeometry.Grassmannian.toSpecZ}` — the structure morphism `Gr(r,d) → Spec ℤ` as the unique map to the terminal object. `\uses{def:gr_glued_scheme}`.
- **Added lemma** `\label{lem:gr_ι_toSpecZ}`/`\lean{...ι_toSpecZ}` — chart map ∘ structure morphism = `Spec(ℤ → R^I)`. Proof: both are maps into terminal `Spec ℤ`, equal by uniqueness. `\uses{def:gr_to_specZ, def:gr_glued_scheme}`.
- **Added lemma** `\label{lem:gr_pullbackιIso_inv_fst}`/`\lean{...pullbackιIso_inv_fst}` — first projection leg `e₂⁻¹ ∘ pr₁ = ι^I_J`. Proof: limit-cone comparison-iso leg compatibility (left cospan leg). `\uses{def:gr_pullbackιIso, def:gr_chart_incl}`.
- **Added lemma** `\label{lem:gr_pullbackιIso_inv_snd}`/`\lean{...pullbackιIso_inv_snd}` — second projection leg `e₂⁻¹ ∘ pr₂ = t_{I,J} ∘ ι^J_I`. Same proof on right cospan leg. `\uses{def:gr_pullbackιIso, def:gr_chart_incl, def:gr_chart_transition}`.
- **Added lemma** `\label{lem:gr_chartTransition_comp_chartIncl}`/`\lean{...chartTransition_comp_chartIncl}` — `t_{I,J} ∘ ι^J_I = Spec θ̃_{I,J}`. Proof: away-localisation universal property (`IsLocalization.Away.lift_comp`). `\uses{def:gr_chart_transition, def:gr_chart_incl, def:gr_transition_pre}`.
- **Added lemma** `\label{lem:gr_separated_toSpecZ}`/`\lean{...isSeparatedToSpecZ}` — `IsSeparated (toSpecZ d r)`, the morphism-form of separatedness. Proof (one paragraph): local-on-target on the `U^I ×_ℤ U^J` patch cover; per patch the restricted diagonal is `Spec δ_{I,J}` (source iso `pullbackιIso` with its two computed legs, target tensor-product affine iso), a closed immersion by surjectivity of `δ_{I,J}`. `\uses{def:gr_to_specZ, def:gr_glued_scheme, def:gr_pullbackιIso, def:gr_diagonalRingMap, lem:gr_diagonalRingMap_surjective, lem:gr_ι_toSpecZ, lem:gr_pullbackιIso_inv_fst, lem:gr_pullbackιIso_inv_snd, lem:gr_chartTransition_comp_chartIncl}`.
- **Fixed dependencies** `lem:gr_separated` — added `lem:gr_separated_toSpecZ` to its `\uses{}` (both statement and proof blocks), since the keystone now consumes the morphism-form lemma.

## Cross-references introduced
All `\uses{}` targets verified present in this same chapter before wiring:
- `def:gr_glued_scheme` (L1607), `def:gr_pullbackιIso` (L1864), `def:gr_diagonalRingMap` (L1753), `lem:gr_diagonalRingMap_surjective` (L1830), `def:gr_transition_pre` (L332), `def:gr_chart_incl` (L1151), `def:gr_chart_transition` (L1204) — all exist.
- The five new labels reference each other and the above; `lem:gr_separated` now `\uses{lem:gr_separated_toSpecZ}`.

leandag verification (`leandag build --json`): `unknown_uses = 0`; all six Lean
declarations now matched (none in `unmatched_lean`); none of the six new blocks
isolated (`leandag show isolated` clean for them). Note: directive said `toSpecZ`'s
`ι_toSpecZ` uses `def:gr_glued_scheme`; I used the actual `def:gr_transition_pre`
label (which exists) for `chartTransition_comp_chartIncl` rather than the directive's
shorthand `def:gr_transition` — `transitionPreMap` is the pre-localisation map the
Lean proof actually produces, and `def:gr_transition_pre` is its blueprint anchor.

## References consulted
None — all six blocks are project-bespoke infrastructure (no external SOURCE QUOTE
required per directive); justifications are project-internal. No reference-retriever
dispatched.

## Notes for Plan Agent
- The Lean `chartTransition_comp_chartIncl` produces `Spec.map (transitionPreMap …)`,
  i.e. the *pre-localisation* transition `θ̃_{I,J}` (blueprint `def:gr_transition_pre`),
  not the localised `θ_{I,J}` (`def:gr_transition`). I wired `\uses{def:gr_transition_pre}`
  accordingly (the directive's shorthand named `def:gr_transition`); both labels exist
  and the choice matches the Lean. No gap.
- All other directive `\uses` targets matched exactly.
