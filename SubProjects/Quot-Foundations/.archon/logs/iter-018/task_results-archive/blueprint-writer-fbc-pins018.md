# Blueprint Writer Report

## Slug
fbc-pins018

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Changes Made
All five new blocks are project-bespoke tactic-decomposition helpers — no `% SOURCE`
lines, per directive. All `\lean{}` pins verified to match live Lean declarations via
`leandag` (the three Γ-collapse lemmas are `private` in Lean and still matched cleanly).

- **Added lemma** `lem:base_change_mate_codomain_read_legs` / `\lean{AlgebraicGeometry.base_change_mate_codomain_read_legs}` — the variable-legs form of the codomain read: codomain read with the two pullback cone legs `g' f'` lifted to free variables carrying their identification hypotheses (`hfst`/`hsnd`), enabling `subst` on a well-typed motive. Placed immediately after `lem:base_change_mate_codomain_read`'s proof.
  - Proof sketch added: Y — verbatim construction of `lem:base_change_mate_codomain_read` with legs as free variables; legs identified via `lem:pullback_fst_snd_specMap_tensor`, dictionaries applied, `e`-equivalence unit absorbed.
  - `\uses{lem:base_change_mate_codomain_read, lem:pullback_fst_snd_specMap_tensor, lem:pullback_spec_tilde_iso, lem:pushforward_spec_tilde_iso, lem:pullback_isEquivalence_of_iso}`
- **Added lemma** `lem:gammaMap_pushforwardComp_hom_eq_id` / `\lean{AlgebraicGeometry.gammaMap_pushforwardComp_hom_eq_id}` — Γ-collapse of the `pushforwardComp` hom coherence to the identity. Placed before `lem:base_change_mate_fstar_reindex`.
  - Proof sketch added: Y — component is `id` by definitional transparency; global-sections functor preserves `id`.
  - `\uses{lem:gammaPushforwardIso}` (the block naming the global-sections functor `moduleSpecΓFunctor`).
- **Added lemma** `lem:gammaMap_pushforwardComp_inv_eq_id` / `\lean{AlgebraicGeometry.gammaMap_pushforwardComp_inv_eq_id}` — same Γ-collapse for the inverse coherence.
  - Proof sketch added: Y. `\uses{lem:gammaPushforwardIso}`
- **Added lemma** `lem:gammaMap_pushforwardCongr_hom` / `\lean{AlgebraicGeometry.gammaMap_pushforwardCongr_hom}` — Γ-collapse of the `pushforwardCongr` hom coherence to the canonical `eqToHom` transport.
  - Proof sketch added: Y — substitute the equality; congruence becomes identity; Γ-image is `eqToHom rfl`. `\uses{lem:gammaPushforwardIso}`
- **Added lemma** `lem:base_change_mate_fstar_reindex_legs` / `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs}` — the variable-legs form of the whole Seam-2 reindex identity; carries the live Seam-2 proof content. Placed before `lem:base_change_mate_fstar_reindex`.
  - Proof sketch added: Y — step (i) subst on well-typed motive; step (ii) Γ-collapses; step (iii) reduction to Seam-1 via `pullbackPushforward_unit_comp` + `base_change_mate_unit_value`, landing on `base_change_mate_inner_value` (mate-unwinding crux).
  - `\uses{lem:base_change_mate_codomain_read_legs, lem:gammaMap_pushforwardComp_hom_eq_id, lem:gammaMap_pushforwardComp_inv_eq_id, lem:gammaMap_pushforwardCongr_hom, lem:pullbackPushforward_unit_comp, lem:base_change_mate_unit_value, def:base_change_mate_inner_value}` — I added `lem:gammaMap_pushforwardComp_hom_eq_id` beyond the directive's listed set because the hom-collapse genuinely participates in step (iii) of this proof; this keeps it from being an isolated-but-for-incoming node and matches the mathematics.
- **Revised** `lem:base_change_mate_fstar_reindex` — added `lem:base_change_mate_fstar_reindex_legs` to both the statement and proof `\uses{}`, and added a short opening paragraph to the proof stating the concrete identity is the instantiation of the abstract variable-legs reindex at the literal projection legs.
- **Revised (optional prose)** `lem:base_change_mate_fstar_reindex` step (ii) — added one parenthetical clause noting the `pushforwardComp.hom` Γ-collapse is most naturally accounted for together with the step-(iii) leg-reindex (transparent re-association); kept purely mathematical.

## Cross-references introduced
- `\uses{lem:gammaPushforwardIso}` on the three Γ-collapse lemmas — `lem:gammaPushforwardIso` exists in this chapter (the block naming the global-sections-of-pushforward functor `moduleSpecΓFunctor`).
- `\uses{lem:base_change_mate_codomain_read_legs}` from `lem:base_change_mate_fstar_reindex_legs` — both new in this chapter.
- `\uses{lem:base_change_mate_fstar_reindex_legs}` from `lem:base_change_mate_fstar_reindex` — new in this chapter.
- All remaining edges (`lem:base_change_mate_codomain_read`, `lem:pullback_fst_snd_specMap_tensor`, `lem:pullback_spec_tilde_iso`, `lem:pushforward_spec_tilde_iso`, `lem:pullback_isEquivalence_of_iso`, `lem:pullbackPushforward_unit_comp`, `lem:base_change_mate_unit_value`, `def:base_change_mate_inner_value`) point at pre-existing blocks in this chapter.

## leandag verification
- `leandag build --json`: 0 conflicts, 0 `unknown_uses`. All five new `\lean{}` pins matched their live Lean declarations (not in `unmatched_lean`).
- `leandag query --isolated --chapter Cohomology_FlatBaseChange`: 0 isolated nodes.
- Seam-2 neighbourhood edges confirmed: the three Γ-collapse lemmas have incoming (`lem:gammaPushforwardIso`) and outgoing (`…_fstar_reindex_legs`) edges; `…_codomain_read_legs` and `…_fstar_reindex_legs` are fully wired; concrete `…_fstar_reindex` now consumes `…_fstar_reindex_legs`.
- The 11 remaining project-wide isolated nodes are all `AlgebraicGeometry.GradedModule.*` `lean_aux` declarations — unrelated to Seam-2 and out of scope for this directive.
- LaTeX balance: 79 `\begin` / 79 `\end` for the declaration/proof environments.

## References consulted
None — all five blocks are project-bespoke tactic-decomposition helpers with no external source (no citation blocks written).

## Macros needed (if any)
None — all commands used (`\operatorname`, `\widetilde`, etc.) are already in use throughout the chapter.

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- **Optional fix on `lem:base_change_mate_regroupEquiv` (`\uses{lem:base_change_regroup_linearEquiv}`): left as-is, no annotation added.** I verified `base_change_regroup_linearEquiv` is a *live* Lean declaration (`AlgebraicJacobian/Cohomology/RegroupHelper.lean:59`) with its own real blueprint block in `Cohomology_RegroupHelper.tex` (`lem:base_change_regroup_linearEquiv`). It is therefore NOT an inlined pure-blueprint helper — the directive's premise for that optional note does not hold, so the existing `\uses{}` is correct and was not touched.
- The three Γ-collapse helper lemmas are `private` in Lean; `leandag` matched them via the `\lean{}` pins regardless. If a future `sorry_analyzer`/`sync_leanok` pass ever fails to resolve a `private` declaration by its unqualified `AlgebraicGeometry.` name, these three pins would be the first place to check — but the current DAG resolves them cleanly.

## Strategy-modifying findings
None.
