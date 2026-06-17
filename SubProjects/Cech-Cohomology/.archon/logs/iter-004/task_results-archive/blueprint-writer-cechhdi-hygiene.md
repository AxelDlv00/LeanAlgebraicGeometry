# Blueprint Writer Report

## Slug
cechhdi-hygiene

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made
- **Rewrote proof body** of `lem:push_pull_comp` (`\lean{AlgebraicGeometry.pushPullMap_comp}`) —
  replaced the now-misleading `conjugateEquiv_comp` / injectivity-of-`conjugateEquiv` sketch
  with the route actually used: reduce the comparison map to its transport-free *raw* form
  (definitional bridge), eliminate the two over-triangle `eqToHom` coercions by substituting
  the structure-map equalities, then combine (i) the composite-unit decomposition via the mate
  core `lem:push_pull_unit_mate` + naturality of the inner adjunction unit, (ii) the pullback
  pseudofunctor pentagon coherence, and (iii) the transport discharge of
  `lem:push_pull_transport_cancel`. Stated purely mathematically — no Lean tactics, no mention
  of project history/`whnf`/`infeasible`. Statement-block `\uses{}` left unchanged.
- **Removed** the stale `% NOTE: (review iter-002)` comment block above the proof (directive
  authorized removal once the body reflects the real route).
- **Added definition** `\definition`/`\label{def:push_pull_functor}`/`\lean{AlgebraicGeometry.pushPullFunctor}`
  — the push–pull functor \(G : (X/\mathbf{Sch})^{\mathrm{op}} \to \operatorname{QCoh}(X)\)
  assembling obj-map + morphism-map into a functor; functoriality = identity + composition laws.
  `\uses{def:push_pull_obj, def:push_pull_map, lem:push_pull_id, lem:push_pull_comp}`.
- **Added definition** `\definition`/`\label{def:cech_nerve_cosimplicial}`/`\lean{AlgebraicGeometry.cechNerveCosimplicial}`
  — the non-augmented cosimplicial \(\mathcal{O}_X\)-module obtained by transporting the
  geometric backbone through the push–pull functor; the object `def:cech_nerve` augments.
  `\uses{def:cover_cech_nerve, def:push_pull_functor}`.
- **Fixed dependencies** `def:cech_nerve` — extended `\uses{}` to include the now-realised
  `def:push_pull_functor` and `def:cech_nerve_cosimplicial` so the DAG shows the construction edges.

Both new blocks are project-bespoke (no external source) → no `% SOURCE` lines, per directive.
No `\leanok` added anywhere.

## Cross-references introduced
- `def:push_pull_functor` `\uses{def:push_pull_obj, def:push_pull_map, lem:push_pull_id, lem:push_pull_comp}` — all exist in this chapter.
- `def:cech_nerve_cosimplicial` `\uses{def:cover_cech_nerve, def:push_pull_functor}` — both exist in this chapter.
- `def:cech_nerve` now also `\uses{def:push_pull_functor, def:cech_nerve_cosimplicial}`.

## References consulted
None — both new blocks are Archon-original (no external source per directive); Fix 1 is a
prose rewrite of an existing block whose citations were unchanged. No citation blocks authored.

## Verification
- `archon dag-query node --node def:push_pull_functor` → matched, `\lean{AlgebraicGeometry.pushPullFunctor}`, deps 4, used-by 2.
- `archon dag-query node --node def:cech_nerve_cosimplicial` → matched, `\lean{AlgebraicGeometry.cechNerveCosimplicial}`, deps 2, used-by 1.
- `leandag build --json` → `unknown_uses: []`, `isolated_count: 0`. No broken or isolated edges.
- Confirmed all referenced Lean decls exist in `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`
  (`pushPullFunctor` L640, `cechNerveCosimplicial` L670, plus `rawPushPullMap`, `pushPullMap_eq_raw`,
  `rawPushPullMap_comp`, `pushPull_unit_comp`, `pushPull_pentagon`, `pseudofunctor_associativity`).

## Macros needed (if any)
None.

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- Out-of-scope items (`lem:cech_acyclic_affine` / P3, all P5 blocks) were left untouched.
- `lem:push_pull_unit_mate` and `lem:push_pull_transport_cancel` still carry placeholder
  "Proved directly in Lean." proof bodies — not in scope this round, but candidates for a future
  hygiene pass if 1-to-1 prose detail is wanted.

## Strategy-modifying findings
None — this was a hygiene pass; no mathematical content changed.
