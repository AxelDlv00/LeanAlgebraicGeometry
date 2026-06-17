# Iter 058 — Plan (Quot-Foundations)

## TL;DR
RESUMED a partially-run iter-058 (progress-critic, full blueprint-reviewer, 2 blueprint-writers, and a
SNAP carrier-refactor had already fired). Assessed actual Lean state first-hand: all 3 modules build
green-with-sorries. 2 prover lanes: **GF close `flatV`** + **SNAP fill the refactor's aligned sorries
+ build `relTensorActL`**. GR blueprint-paused (cocycle written this iter; prover iter-059).

## What the prior (interrupted) instance did this iter
- progress-critic / full blueprint-reviewer / blueprint-writer-snap / blueprint-writer-grquot ran.
- **refactor `snap-carrier`** dispatched + LANDED but interrupted before reporting. It built
  `objRestrict` (distinct `↥(P.obj U)`-carrier `ℤ`-linear restriction = Handle 1) and rebuilt both
  presheaves to use it, sorrying map_id/map_comp (473/474/490/491). `lake build SectionGradedRing` = OK.

## Decision made — SNAP becomes a PROVER lane (rebuttal to literal "don't prove on CHURNING")
progress-critic SNAP=CHURNING, corrective = REFACTOR not scaffold-prover. That refactor RAN and landed
the carrier redesign (structural change). Dispatching a prover now to fill the *now-aligned* sorries +
build `relTensorActL` is NOT "another churning round" — the wall (`↥(P.obj U)` vs `↥((P.presheaf).obj U)`
unification failure in `map_tmul`) is gone *by construction*. Reversal signal: if the prover reports
`map_tmul` STILL won't unify after `objRestrict`, the gap is deeper than carriers → escalate (Mathlib
apply-lemma, Handle 3). Weighed: the refactor is the sanctioned must-fix; capitalizing same-iter saves a
full cycle and the functoriality sorries are mechanical.

## HARD GATE handling
- **GF** CONDITIONAL PASS (reviewer): flatV route prose complete+correct; chapter `complete:false` only
  from coverage debt on proved helpers. Dispatched GF hygiene writer (`gf-hygiene-iter058`) → added
  `lem:gf_stalk_flat_localBase` + `Module.free_of_isLocalizedModule` mathlibok anchor + `\uses` wiring.
  Condition met → gate clear. No re-review needed (conditional pass, not fail).
- **SNAP** reviewer FAIL → blueprint-writer-snap added `def:relTensorActL`/`def:relTensorTriplePresheaf`
  → scoped fast-path re-review (`recheck-iter058`) = `complete:true/correct:true/must-fix:no`. Gate clear.

## GR — blueprint-paused (no prover this iter)
blueprint-writer-grquot wrote the GL_d bundle-cocycle decomposition (`def:gr_bundleTransition`,
`lem:gr_bundleCocycle_id`, `lem:gr_bundleCocycle_mul`) + removed 3 phantom blocks + rewrote `glue`
construction to the equalizer route. progress-critic endorsed prover-iter-059. Scaffold deferred to 059
(fresh-written cocycle chapter not yet full-reviewed; scaffolding off it is cheap but premature).

## Coverage debt
- `gf_stalk_flat_localBase` → block added by GF hygiene writer (+wired `mathlib_localization_flat`,
  `mathlib_flat_trans`). `relTensorTriplePresheaf` → `def:` block added by writer. `opensTopology`,
  `objRestrict`/`objRestrict_apply` → private (no debt). Unmatched should be ~0 after sync.
- NON-BLOCKING: re-review flagged `def:relTensorTriplePresheaf` `\uses{lem:relativeTensor_as_coequalizer}`
  is backwards (triple presheaf is an *input* to the coequalizer). Defer to next writer pass.

## Subagent skips
- strategy-critic: STRATEGY.md SHA-unchanged this iter; prior verdict SOUND, no live CHALLENGE; routes
  unchanged (SNAP carrier refactor is an implementation detail, not a route swap; GF still epi-route).
- progress-critic / blueprint-reviewer / blueprint-writers: ALREADY ran this iter (reports on disk) —
  re-dispatch would be redundant; acted on their outputs instead. Only NEW dispatches this resume were
  the GF hygiene writer + the SNAP scoped re-review (gate fast-path).
