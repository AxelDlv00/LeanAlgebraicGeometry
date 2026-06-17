# Blueprint-reviewer directive — slug `rescope065` (HARD GATE fast-path)

Read the whole blueprint as you always do. This is a fast-path re-review to clear the prover-dispatch
HARD GATE for the consolidated chapter
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
(`% archon:covers` includes `CechSectionIdentification.lean` and `OpenImmersionPushforward.lean`), after
a writer round (`gate065`) addressed the must-fix items the iter-064 per-file Lean↔blueprint check raised.

## What changed this iter (focus your gate verdict here)
1. NEW dedicated lemma `lem:coprodToProd_isIso_of_equiv` (reindexing induction leaf) — this was the iter-064
   must-fix: previously the reindexing step was a single under-specified sentence inside
   `lem:pushPull_coprod_prod`'s proof, leaving the Lean leaf an un-formalizable full `sorry`. Confirm the
   new block's proof is detailed enough for a prover to formalize (names the source/target reindexing isos,
   the projection-wise identification, and the IH usage).
2. NEW `def:coprodOverIncl`, `def:coprodToProdMap` (the framing definitions) + NEW
   `lem:coprodToProd_isIso_option` (closed Option-step) — confirm coverage is now wired (no isolated nodes)
   and `\uses{}` edges into `lem:pushPull_coprod_prod` are correct.
3. REALIGNED proof of `lem:pushPull_coprod_prod_empty` to the `IsZero`-over-empty-scheme route (matching the
   Lean proof) — confirm the prose now matches the formal obligation `IsZero ((pullback q).obj F)` over the
   initial scheme.
4. EXPANDED proof of `lem:slice_reverse_ring_map` (φ'') with concrete part (a)
   `sheafPushforwardContinuousComp'` + part (b) object-relabel iso pointers — confirm it is no longer
   under-specified for the keystone leaf.

## The gate question
Return your standard per-chapter checklist. The specific gate decision I need: is
`Cohomology_CechHigherDirectImage.tex` now **complete: true AND correct: true** with **no must-fix-this-iter
finding** for the material backing `CechSectionIdentification.lean` and `OpenImmersionPushforward.lean`?
(`complete: false` solely due to not-yet-built downstream build-targets is expected and does NOT block the
gate — call those out separately.) If any of the 4 changed blocks above is still inadequate, name it as a
must-fix so it stays deferred.
