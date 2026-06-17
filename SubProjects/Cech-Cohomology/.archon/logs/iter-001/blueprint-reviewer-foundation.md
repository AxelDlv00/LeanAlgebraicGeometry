# Blueprint Reviewer Directive

## Slug
foundation

## Strategy snapshot

**End-state**: zero inline `sorry` in the dependency cone of the protected theorem
`AlgebraicGeometry.cech_computes_higherDirectImage` (blueprint `lem:cech_computes_cohomology`),
zero project axioms. The cone lives in two Lean files:
`AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean` (the Čech engine) and
`AlgebraicJacobian/Cohomology/HigherDirectImage.lean` (the derived-functor target).

Three phases, all backed by the consolidated chapter
`Cohomology_CechHigherDirectImage.tex` (it declares `% archon:covers
AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`):

| Phase | Status | Key Mathlib needs | Risks |
|---|---|---|---|
| `pushPull` functor laws | `pushPullMap_id` landed; `pushPullMap_comp` open | kernel-cheap generalized `eqToHom`-cancellation | DEFINITIONAL: kernel `whnf` blow-up on over-triangle transports |
| affine acyclicity | `sorry` | Serre/Čech vanishing for QCoh on affines (Stacks 02KG) | explicit standard-cover localisation + homotopy bookkeeping |
| comparison theorem | `sorry` | two spectral sequences for `Scheme.Modules` (Leray + Čech-to-cohomology), absent from Mathlib | DOMINANT pole; gated on SS inputs; existence-only `Nonempty (… ≅ …)` form |

There are exactly three inline `sorry`s in the Lean: `CechNerve` (line 91, blocked on the
push-pull functor assembly), `CechAcyclic.affine` (line 544), and
`cech_computes_higherDirectImage` (line 581).

## Routes

Single route (the Stacks Čech-cohomology development). NOTE for your audit: the strategy
may be missing an alternative lighter route to the comparison theorem (acyclic-resolution
/ universal δ-functor comparison, avoiding spectral sequences). If you judge the blueprint's
spectral-sequence-based proof of `lem:cech_computes_cohomology` to be under-detailed or to
rest on infrastructure unlikely to be buildable, flag it as a Lean-difficulty / completeness
finding — but route-selection itself is being handled separately by a strategy auditor.

## References
- `references/stacks-coherent.tex` (the actual source; `.md` is a pointer): Stacks ch.30
  "Cohomology of Schemes". Tags 02KE, 02KG, `lemma-cech-cohomology-quasi-coherent-trivial`,
  `lemma-quasi-coherence-higher-direct-images-application`. Backs all of
  `Cohomology_CechHigherDirectImage.tex`.

## Focus areas

1. **`lem:push_pull_functor` over-statement.** The chapter's `% NOTE (iter-264)` admits
   that only `pushPullMap_id` exists in Lean while the block pins BOTH
   `\lean{AlgebraicGeometry.pushPullMap_id}` and `\lean{AlgebraicGeometry.pushPullMap_comp}`
   — and `pushPullMap_comp` is NOT a Lean declaration (it lives only as an in-file comment).
   Assess: is this a must-fix `\lean{}`-target / completeness finding? Should the block be
   split into two (one `\lean{}` pin each) so the graph tracks them independently?
2. **`lem:cech_acyclic_affine` and `lem:cech_computes_cohomology` proof detail.** Both proofs
   end with an explicit "depends on currently-absent Mathlib infrastructure" disclaimer
   (the localisation complex + contracting homotopy; the two spectral sequences). Judge
   whether the proof sketches are detailed enough for a prover to formalize, or whether they
   are effectively `∞`-effort gaps dressed as proofs (no concrete Lean-buildable decomposition).
3. **`\uses{}` integrity / cycles.** A prior note records that listing `def:cech_nerve` in
   `lem:push_pull_functor`'s `\uses` created a `cech_nerve ↔ push_pull_functor` cycle that
   crashed `leanblueprint web`. Re-verify with `leandag` that the graph is acyclic and the
   `\uses` edges are faithful.

## Known issues
- The chapter is consolidated (`% archon:covers` the Čech file); its single verdict gates
  the whole `CechHigherDirectImage.lean` prover work.
- `\leanok` markers are managed by the deterministic `sync_leanok` phase — do not treat a
  present-or-absent `\leanok` as a writer error.
