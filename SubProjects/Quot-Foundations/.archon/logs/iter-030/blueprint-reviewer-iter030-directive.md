# Blueprint-reviewer directive — iter-030 (whole-blueprint audit, HARD GATE)

Audit the WHOLE blueprint at `blueprint/src/chapters/*.tex`. Produce your standard per-chapter
checklist (complete? correct? Lean targets well-formed? proofs detailed enough to formalize?) plus
the cross-chapter view and any `## Unstarted-phase blueprint proposals`.

This iter's HARD GATE depends on your verdict for the three chapters about to receive prover work:

1. **`Cohomology_FlatBaseChange.tex`** — an effort-breaker split the crux
   `lem:base_change_mate_fstar_reindex_legs` into 5 `\uses`-linked clean-term link sub-lemmas
   (`..._link_distribute`, `..._link_collapseComp`, `..._link_cancelEUnit`,
   `..._link_cancelPullbackComp`, `..._link_survivor`, L1693–L1860) + a rewritten target proof.
   **Check:** each link is a single mathematical move with a faithful statement + informal proof; the
   target's `\uses{}` lists the 5 links; the cone is `∞`-effort-free; the 5 new `\lean{}` pins name
   decls a fine-grained prover will scaffold (they do not yet exist in Lean — that is expected/correct
   for a build target, not a divergence).

2. **`Picard_QuotScheme.tex`** — a blueprint-writer rewrote the gap1 cone (L2462–L3130) per a
   mathlib-analogist corrected decomposition: mathlib anchors
   (`lem:isLocalization_basicOpen_mathlib`, `lem:presentation_map_mathlib`,
   `lem:quasicoherentData_bind_mathlib`, `lem:existsUnique_gluing_mathlib`,
   `lem:isLocalizedModule_linearEquiv_mathlib`, `lem:isLocalizedModule_linearMap_ext_mathlib`); the two
   project keystones `lem:over_restrict_iso` (C, `\lean{...Scheme.Modules.overRestrictIso}`, NOT yet in
   Lean) and `lem:section_localization_descent` (D); the transport `lem:qcoh_affine_section_localization`;
   the gap1 keystone `lem:qcoh_affine_isIso_fromTildeΓ`. **Check:** the decomposition is mathematically
   sound (does C+P1+D+assembly actually prove `IsIso M.fromTildeΓ` for QC `M` on `Spec R`?); the mathlibok
   anchors faithfully re-state real Mathlib decls; the `\uses{}` edges are accurate; the descent (D) cites
   Stacks 01HA / properties tags with a verbatim source quote; no `∞`-effort node remains in the gap1 cone.

3. **`Picard_GrassmannianCells.tex`** — NOT edited this iter (last cleared GATE iter-029). Re-confirm
   `def:gr_glued_scheme`, `def:gr_chart_transition'`, `lem:gr_chartTransition'_fac`, and the cocycle
   `Φ=id` ring-identity block are still complete + correct (the GR-glue prover works from them).

Flag any must-fix-this-iter blocker per chapter. For the three above, state explicitly whether each is
`complete: true` AND `correct: true` with no must-fix — that is what clears the prover-dispatch gate.

You may NOT add/remove `\leanok`. Report only.
