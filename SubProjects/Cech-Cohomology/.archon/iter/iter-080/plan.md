# iter-080 plan — user dropped the false frozen decl; project now 0-sorry; blueprint reconciled

## Situation (reconciled ground truth)
- **User edit (this iter's USER_HINTS + git diff):** removed the false-as-signed protected
  `cech_computes_higherDirectImage` from `CechHigherDirectImage.lean` (429+/201− diff) and its
  `archon-protected.yaml` entry; renamed the correct sibling to the canonical
  `cech_computes_higherDirectImage` (`CechToHigherDirectImage.lean:198`). User asked me to verify
  the drop is correct.
- **Verification (user request):** peer `Algebraic-Jacobian-Challenge` carries that same general
  signature (general `X.OpenCover`, only `[IsSeparated f]`) at `CechHigherDirectImage.lean:577` as a
  `sorry` (comment: needs absent Mathlib spectral sequences) and does NOT list it in its
  `archon-protected.yaml`. The general statement is FALSE (ℙ¹/O(-2), `𝒰={𝟙 X}`). ⟹ dropping it is
  sound; freezing a false sig would have made the headline deliverable unprovable.
- **Project-wide inline `sorry` = 0.** grep for `\bsorry\b` (minus `sorryAx`) finds only stale
  docstrings (Leg:15, CSI:20).

## Actions
- Blueprint reconciled: upgraded `lem:cech_computes_cohomology` (live `\lean{}`) statement to the precise
  hypotheses + scope note + ℙ¹/O(-2) counterexample; added `lem:pushforward_mapHC_cechComplexOnX`,
  `lem:cechAugmented_to_acyclicResolutionInput` to its `\uses`; deleted the orphaned `..._affineCover`
  block (dead `\lean{}`, nothing `\uses` it). No dangling refs.
- STRATEGY: §Goal scoped honestly as "separated relative case of 02KE" (strategy-critic labeling point);
  §P5b frozen-block marked RESOLVED; §Completed P5b row + content-complete note updated.
- TO_USER rewritten (frozen-decl bullet was stale); PROGRESS rewritten.
- Launched a full `lake build` of the capstone cone (background) to confirm the user's large unverified
  CHDI edit compiles.

## Decision made
- **No prover dispatch (mechanical hard gate): 0 inline sorries project-wide — nothing to prove.** The
  remaining confirmation is the deterministic full-build + axiom-clean gate (review-build), which both
  critics named as the one outstanding condition before declaring complete. Reversal signal: if the build
  flags an error in the user's CHDI edit, next iter dispatches `refactor` (0-sorry file ⟹ not a `prove`
  lane) with the diagnostic. Do NOT advance stage to polish/COMPLETE until the build is green.
- **Stage stays `prover`** this iter (sorries filled but not yet full-build-verified); advance to polish
  next iter on a green review-build.

## Prior critique status
- strategy-critic `finish`: SOUND. Labeling CHALLENGE (oversold "Tag 02KE") ADDRESSED — §Goal now scopes
  it as the separated relative case. Format DRIFTED (per-iter narrative bloat) noted; the canonical
  skeleton is intact, trim deferred to a polish edit. "0 axioms not yet verified" ⟹ gated on review-build.
- blueprint-reviewer `finish`: PASS. 2 soon-fix items recorded as polish items in PROGRESS (reading-order;
  dormant `tile_section_comparison` marker inconsistency — review-agent's domain).

## Subagent skips
- progress-critic: the only active route just completed (sorry count → 0 in the prior iter; nothing left
  to dispatch) — the descriptor's "only active route just completed" skip condition. No prover trajectory
  to extrapolate.
