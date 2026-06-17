# Blueprint Writer Report

## Slug
fbc-reroute

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Summary
Reconciled the Seam-A routing narrative with the live route the iter-026 prover established:
Seam A `inner_value_eq` is realised **through** `base_change_mate_fstar_reindex_legs` (leg
substitution → unit expansion → four-factor Γ-distribution → eCancel telescoping → Seam 1 → ρ),
**not** inline at the literal projection legs (which is walled by a dependent-motive obstruction —
the projection leg `pr_1` is only propositionally, not definitionally, equal to `e ∘ Spec ιA`).
Un-superseded the `_legs` / `fstar_reindex` machinery, repointed the inner-value dependency edge,
and extracted the residual ~100-LOC telescoping into a single named closeable target,
`lem:base_change_mate_inner_eCancel_assemble`.

## Changes Made

### Task 1 — routing narrative reconciled
- **Revised** the `% --- Seam A ...` comment block (was `% --- Seam 3, the inline inner-value
  chain`): now states the live via-`_legs` route and the four-step pipeline, explicitly records
  that the inline-at-literal-legs distribution is WALLED (propositional leg equality →
  dependent-motive obstruction), and that the four-factor formula + three eCancel atoms are reused
  unchanged — only the plumbing (via `_legs`, not inline) changes. Removed the false "retired …
  sorry-backed" claim about `fstar_reindex` / `…_legs`.
- **Revised** `lem:base_change_mate_inner_value_eq` proof body — now proves the identity by
  instantiating `lem:base_change_mate_fstar_reindex` at the literal projection legs (concrete
  codomain read = leg read definitionally; legs factor by `pullback_fst_snd_specMap_tensor`),
  plus an explicit "why the proof routes through the leg-parametrised form" paragraph recording the
  wall.
- **Revised** the LEAN INTERNAL notes of `lem:base_change_mate_inner_unitReduce` (A-1) and
  `lem:base_change_mate_inner_eCancel` (A-2): re-pinned `\lean{}` from
  `base_change_mate_inner_value_eq` to `base_change_mate_fstar_reindex_legs` (the live subsuming
  theorem where the distribution/cancellation now happen), and reframed each as a narrative node
  whose inline-at-literal-legs form is walled, with A-2 deferring to the new
  `inner_eCancel_assemble` for the live realization. Four-factor formula (A-1) and the three atoms
  (A-2a/b/c) kept verbatim.

### Task 2 — `_legs` / `fstar_reindex` un-superseded
- **Revised** the "Superseded … pending dead-code removal" notes on
  `lem:base_change_mate_fstar_reindex_legs_unitExpand` and
  `lem:base_change_mate_fstar_reindex_legs_gammaDistribute` (shared note, both updated): now "Live,
  via the inner-value route" — links of the engine that realises Seam A.
- **Revised** `lem:base_change_mate_fstar_reindex_legs` note: "Live: the realization of Seam A",
  with a dedicated "Why the legs must be parametrised" paragraph encoding the wall (propositional
  vs definitional leg equality, closed codomain-read type, dependent-motive obstruction).
- **Revised** `lem:base_change_mate_fstar_reindex` note: "Live: the concrete inner value" — the
  literal-leg instantiation consumed by `inner_value_eq`.
- **Revised** `lem:base_change_mate_codomain_read_legs` (lines ~1184–1215, within `_legs`
  machinery; not named in the directive but squarely Task 2's intent): its "Superseded … abandoned
  … unworkable … abandoned in favour of the direct domain read" framing directly asserted the
  falsified narrative. Replaced with "Live, via the inner-value route" and corrected the final
  paragraph to state that carrying the legs as free variables (definitional identification) is
  exactly what makes the reindex fire; the obstruction is only at the literal legs.
- **Fixed dependencies** `lem:base_change_mate_inner_value_eq` — `\uses{}` now points at
  `lem:base_change_mate_fstar_reindex` (which `\uses` `…_legs`), replacing the inline-chain edges
  (inner_eCancel + three atoms + pullbackPushforward_unit_comp + pullback_isEquivalence_of_iso +
  gammaMap_pushforwardComp_hom_eq_id). Retained codomain_read, pullback_fst_snd_specMap_tensor,
  unit_value, pushforward_spec_tilde_iso, def:inner_value.

### Task 3 — single named residual target
- **Added lemma** `\label{lem:base_change_mate_inner_eCancel_assemble}` —
  `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs}` (subsuming-theorem pin + LEAN
  INTERNAL note, mirroring the `inner_unitReduce` convention), `\uses{}` = the three atoms
  (`…_eCancel_eUnit`, `…_eCancel_pushforwardComp`, `…_eCancel_pullbackComp`) +
  `codomain_read_legs` + `gammaMap_pushforwardComp_hom_eq_id` + Seam 1 `unit_value`, exactly as
  directed. Informal proof = the link-(3) telescoping lifted from `_legs` step (iii): three
  ordered cancellations against the leg-parametrised codomain read, leaving the lone affine
  `(Spec ιA)`-unit evaluated by Seam 1. This is the single unproved closeable target.
  - Proof sketch added: Y — ordered three-atom cancellation + the order-of-operations / definitional-match rationale.
- **Fixed dependencies** `lem:base_change_mate_fstar_reindex_legs` — added
  `lem:base_change_mate_inner_eCancel_assemble` to both statement and proof `\uses{}`, and cited it
  in step (iii) link (3) ("This telescoping is isolated as Lemma~…"), giving the new node its
  in-edge.

## Cross-references introduced
- `inner_value_eq \uses fstar_reindex` — `fstar_reindex` exists (this chapter, ~L1796).
- `fstar_reindex_legs \uses inner_eCancel_assemble` — new node, this chapter.
- `inner_eCancel_assemble \uses {inner_eCancel_eUnit, inner_eCancel_pushforwardComp,
  inner_eCancel_pullbackComp, codomain_read_legs, gammaMap_pushforwardComp_hom_eq_id,
  base_change_mate_unit_value}` — all exist (this chapter).

Verified with `leandag build --json`: `unknown_uses: []`, `conflicts: []`, isolated count
unchanged at 7 (all in "The Quot scheme" chapter — none from this chapter). Live route chain
confirmed in `.leandag/dag.json`:
`inner_value_eq → fstar_reindex → fstar_reindex_legs → inner_eCancel_assemble → {3 atoms,
codomain_read_legs, gammaMap_pushforwardComp_hom_eq_id, unit_value}`, with
`inner_eCancel_assemble` unproved (the single target). LaTeX environments balanced (52/52 lemma,
46/46 proof).

## References consulted
None — this round is a routing/narrative reconciliation of Archon-original blueprint blocks. No
new `% SOURCE` / `% SOURCE QUOTE` lines written; the existing Stacks Project citation comments on
`inner_value_eq`, `fstar_reindex`, and `gstar_generator_close` were left untouched.

## Macros needed (if any)
None.

## Notes for Plan Agent
- `\leanok` markers were left untouched (sync_leanok's domain). NB: the shared `\lean` target
  `AlgebraicGeometry.base_change_mate_fstar_reindex_legs` is currently marked proved/`\leanok` in
  the DAG snapshot, while the new `inner_eCancel_assemble` (same `\lean` pin) is unproved by virtue
  of carrying no `\leanok`. If the real Lean `base_change_mate_fstar_reindex_legs` still holds a
  `sorry` in its step-(iii) link (3) (the assemble telescoping), sync_leanok should drop `\leanok`
  from `fstar_reindex_legs` (and transitively `fstar_reindex`, `inner_value_eq`) on its next run.
  Worth confirming the prover directive points at `base_change_mate_fstar_reindex_legs` step (iii)
  link (3) — the `inner_eCancel_assemble` content — as the single remaining target.
- The A-1 (`inner_unitReduce`) and A-2 (`inner_eCancel`) narrative nodes now have out-edges but no
  in-edges (inner_value_eq no longer routes through the inline chain). They are NOT flagged
  isolated (leandag requires no-in AND no-out) and are retained per the no-unauthorized-removal
  rule, reframed as inline-form narrative deferring to the live `_legs` route. If a future cleanup
  pass wants them gone, that is a directive-authorized removal, not a writer default.

## Strategy-modifying findings
None. The correction is a routing/plumbing reconciliation within the existing FBC strategy; the
mathematical content (four-factor distribution, three eCancel atoms, Seam 1 reduction) is
unchanged. The strategy's claim that Seam A is live and consumed by `gstar_transpose` holds — only
the realization path (via `_legs`, not inline) is corrected.
