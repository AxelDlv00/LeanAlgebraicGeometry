# Blueprint Reviewer Directive — DAG iter-010 (pre-COMPLETE audit)

## Context

This is the first dedicated DAG-elaboration audit of the project. The blueprint was
built incrementally by the loop's plan agents (iters 006–009). The DAG is currently
clean by `leandag`: 0 ∞-effort nodes, 0 broken `\uses{}`, 0 isolated nodes, 0 unmatched
Lean declarations, `content.tex` inputs all six chapters. I am considering declaring the
blueprint **COMPLETE** and need a fresh-context correctness + completeness audit first.

## Scope

Audit the WHOLE blueprint (all six chapters — do NOT scope-narrow):
- `Cohomology_RegroupHelper.tex`
- `Cohomology_FlatBaseChange.tex`
- `Picard_RelativeSpec.tex`
- `Picard_FlatteningStratification.tex`
- `Picard_QuotScheme.tex`
- `Picard_GrassmannianCells.tex`

## What I need from you

1. **Per-chapter checklist** (`complete` / `correct` per chapter) — the standard whole-
   blueprint audit. For a roadmap I'm about to call COMPLETE, I especially need:
   - Every statement is mathematically correct and faithful to its cited source
     (Nitsure §1/§4/§5, Stacks 02KH/01I9/01LL-family, Hartshorne). Flag any statement
     that looks subtly wrong, over/under-hypothesised, or unsupported by its `% SOURCE`.
   - Every proof sketch is finite-effort and detailed enough to formalize (not a
     hand-wave that hides a real gap). Flag any proof that reads complete but conceals
     an ∞ step.
   - Every `\lean{}` target is well-formed (placeholder `TODO`/absent-Lean names are
     acceptable — tex may precede Lean).

2. **`### Dependency & isolation findings`** — the dependency-graph audit. In particular,
   rule on these TWO proved-in-Lean helper lemmas in `Picard_FlatteningStratification.tex`
   (§ "gf_finite_helpers"), which are the only blueprint nodes NOT reachable from any goal
   cone (they are leaves nothing `\uses{}`):
   - `lem:gf_flat_finite` (`AlgebraicGeometry.GenericFreeness.exists_flat_localizationAway_of_finite`)
   - `lem:gf_free_moduleFinite` (`AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_moduleFinite`)

   Both are proved sorry-free in Lean and have correct blueprint blocks, so 1-to-1 Lean
   coverage REQUIRES keeping their blocks. But the goal-cone theorem `thm:generic_flatness`
   (geometric form) currently proves its Step 3–4 directly through
   `thm:generic_flatness_algebraic` + `Module.Flat.of_free` and does NOT route through
   either helper; their hypotheses (M finite over a finite-*type* B_j, not A-finite) do not
   match the geometric proof's data, so a `\uses{}` edge to them would be INACCURATE.
   The intro prose at the top of § "gf_finite_helpers" claims they are "consumed by the
   chain and the geometric globalization" — verify whether that claim is true or aspirational.

   Tag each of the two as `wire-up` (name the precise honest edge + which proof should cite
   it), `keep` (proved-in-Lean leaf helper, acceptable for COMPLETE — say why), or `remove`
   (dead; but note removal needs the Lean decl gone too, which is the prover loop's job).
   I will NOT fabricate an inaccurate `\uses{}` edge, so only propose `wire-up` if the edge
   is mathematically genuine.

3. **`## Unstarted-phase blueprint proposals`** — every STRATEGY.md phase with no blueprint
   coverage. (Phases per STRATEGY.md: FBC-A/B, GF-alg/geo, QUOT-defs, SNAP, QUOT-repr.) If
   any phase has zero blueprint coverage, give a concrete chapter outline.

## Out of scope

- Do not assess Lean proof completeness / `\leanok` / sorry counts — that is the prover
  loop's domain and does NOT block the COMPLETE gate.
- Do not propose strategy changes; only flag if a statement's correctness depends on one.
