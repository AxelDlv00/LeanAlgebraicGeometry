# blueprint-reviewer directive — iter-029 (whole-blueprint audit; HARD-GATE re-review)

Audit the whole blueprint as usual (cross-chapter view is the point). This dispatch follows a
blueprint-writer + blueprint-clean round that edited three chapters under active prover work; the plan
agent needs a current per-chapter HARD-GATE verdict (complete + correct + no must-fix) for each before
dispatching provers THIS iter (sanctioned same-iter fast path; `lake build` is green — only `.tex` changed).

## Chapters under active prover work this iter (give an explicit gate verdict for each)

1. `Cohomology_FlatBaseChange.tex` — prior iter-028 lvb flagged 2 must-fix blueprint-adequacy items, now
   addressed by `blueprint-writer fbc-diamond`:
   - §1: `lem:base_change_mate_inner_eCancel_assemble` now documents the `X.Modules` instance diamond +
     the term-mode mechanism (`congrArg`/`Functor.congr_map`/`.trans`/`exact` splicing the SHIPPED eCancel
     atoms; tactic names confined to `% NOTE:`). Confirm this is now adequate to guide the formalization.
   - §2: `lem:base_change_mate_gstar_transpose` step-3 no longer cites the sorry-backed
     `lem:base_change_mate_inner_value_eq` as established; it routes through `_legs` and uses the same
     mechanism. Confirm the proof sketch + `\uses{}` are now faithful.
   - The phantom `base_change_regroup_linearEquiv` `\uses` ref was removed.

2. `Picard_QuotScheme.tex` — prior iter-028 lvb flagged the G1-core sketch as over-stated; now addressed
   by `blueprint-writer quot-gap1` + `blueprint-clean`:
   - `lem:qcoh_affine_section_localization` (G1-core) rewritten as a corollary of gap1
     (`lem:qcoh_affine_isIso_fromTildeΓ`) via `lem:isIso_fromTildeΓ_iff_isLocalizedModule_restrict`.
   - gap1 elevated as the primary gap and split into the new sub-build
     `lem:exists_isIso_fromTildeΓ_basicOpen_cover` (the THIS-ITER prover target) + a Mayer–Vietoris
     assembly. Confirm this sub-build's statement + informal proof are detailed enough to formalize
     (mathlib-build) and that its `\uses{}` are accurate.
   - 2 coverage-debt helper blocks (`lem:isLocalizedModule_basicOpen_of_presentation`,
     `lem:map_units_restrict_basicOpen`) + a `tilde.isUnit_algebraMap_end_basicOpen` `\mathlibok` anchor
     added; 4 orphaned Route-F anchors removed.

3. `Picard_GrassmannianCells.tex` — prior iter-028 lvb flagged 4 coverage-debt blocks + `def:gr_glued_scheme`
   silent on partial state; now addressed by `blueprint-writer gr-glue`:
   - 4 coverage blocks added (`def:gr_chart_transition'`, `lem:gr_chartTransition'_fac`,
     `lem:gr_chartTransition'_ringIdentity`, `lem:gr_awayMulCommEquiv_comp_algebraMap`).
   - `def:gr_glued_scheme` expanded with the partial-state `% NOTE:`, the residual cocycle ring identity
     `Φ = id`, and the full `Scheme.GlueData` assembly (the THIS-ITER prover target). Confirm the cocycle
     ring-identity sketch is detailed enough to formalize.

## What I need back
- A per-chapter gate verdict: `complete: true/false`, `correct: true/false`, and any `must-fix-this-iter`
  items (with the exact block/label). If all three return complete+correct with no must-fix, I dispatch
  provers on all three this iter.
- Your usual whole-blueprint findings (other chapters, broken `\uses`, ∞-effort nodes, coverage debt) +
  any unstarted-phase proposals.
