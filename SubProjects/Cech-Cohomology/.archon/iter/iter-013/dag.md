# DAG iteration 013 — wire the P3b cone + cover prover helpers → COMPLETE

## Starting state (leandag, after `build`)
- 52 blueprint nodes, 28 lean-aux (uncovered Lean helpers), 0 ∞-sources, 0 broken `\uses{}`.
- **Isolated: 30 (2 blueprint)** — `lem:injective_of_adjoint`, `lem:mod_pmod_adjunction`.
- Goal cone reached only 44/52 blueprint nodes; **8 blueprint nodes outside the cone** (the
  entire P3b presheaf-Čech machinery).

## Root cause found
`leandag` in this project graphs **statement-level `\uses{}` only** — it does NOT count `\uses{}`
placed inside `\begin{proof}` blocks. Confirmed empirically: `lem:injective_cech_acyclic` had
`deps=1` (its statement `\uses{def:cech_complex}`) while its proof block `\uses` listed 6. The goal
node works because it mirrors its deps in both blocks (statement ≡ proof). The P3b chain kept its
real dependencies only in proof blocks, severing 8 nodes from the cone and isolating the two
`\mathlibok` anchors.

## Actions (direct surgical edits — no writers needed; pure structural wiring, no math change)
1. **Connectivity** — mirrored proof-block deps into the statement `\uses` of two nodes
   (`Cohomology_CechHigherDirectImage.tex`), matching the goal node's own pattern:
   - `lem:injective_cech_acyclic` += {def:section_cech_complex, lem:cech_complex_hom_identification,
     lem:cech_free_complex_quasi_iso, lem:injective_of_adjoint, lem:mod_pmod_adjunction}.
   - `lem:cech_to_cohomology_on_basis` += {lem:injective_cech_acyclic, lem:ses_cech_h1,
     lem:cech_acyclic_affine}.
   → de-isolated both anchors; pulled all 8 P3b nodes into the goal cone.
2. **1-to-1 coverage** — bundled all 28 internal Lean helpers into the `\lean{}` list of the most
   mathematically-related existing declaration (the established bundling pattern, e.g.
   `lem:horseshoe_chainMap` already lists ~10 names):
   - `Cohomology_CechHigherDirectImage.tex`: push–pull `raw*`/`pentagon`/`unit_comp`/`eq_raw`/
     `pushforwardComp_hom_app_id` → `def:push_pull_map` & `lem:push_pull_comp`;
     `coverCechNerveOver(Aug)` → `def:cover_cech_nerve`.
   - `Cohomology_AcyclicResolution.tex`: twistedBiprod object/diff/projection helpers →
     `lem:horseshoe_chainMap`; cosyzygy short-complex/fork/cycles helpers → `lem:cosyzygy_ses`;
     `gCosyzygyIsoCocycles_*` → `lem:applied_cosyzygy_cycles`; degreewise-split + acyclic-vanishing
     helpers → `lem:right_derived_shift_split_resolution`.

## blueprint-reviewer (iter013-postwire, fresh context)
Verdict: **HARD GATE CLEARS — 3 chapters audited, 0 findings, 0 unstarted-phase proposals.**
- Both structural edits confirmed mathematically faithful (proof blocks read against the added
  statement deps; every bundled helper under a related declaration).
- DAG: 0 isolated, 0 unknown_uses, 24 unmatched_lean (all expected: Mathlib anchors + BLOCKED-phase
  scaffolding not yet written). Mathlib anchors verified to exist. blueprint-doctor: 0 malformed,
  0 orphans, 0 broken refs.

## Ending state (leandag)
- 52 blueprint nodes, **0 lean-aux**, **0 isolated (0 blueprint)**, **0 nodes outside goal cone**,
  0 ∞-sources, 0 broken `\uses{}`, `Needs \lean{}` = 0, content.tex inputs all 3 chapters.
- **All six DAG gate criteria hold → `## Status: COMPLETE`** written to DAG_STATUS.md.

## What remains (NOT blueprint gaps — prover-loop domain)
- P3 `lem:cech_acyclic_affine` (Lean `sorry`), P3b machinery, P5a vanishing inputs, P5b assembly
  `lem:cech_computes_cohomology` (Lean `sorry`) — all have written informal proofs; formalization is
  the `archon loop` prover phase's job. PROGRESS.md objectives (P3 + P3b lanes) remain consistent
  with the blueprint and were left unchanged.

## External references
None unobtainable. All sources present under `references/` and cited.

## Subagent skips
- strategy-critic: STRATEGY.md was NOT modified this dag iter (edits were pure DAG wiring + helper
  coverage that serve the existing strategy unchanged); per dag.md, strategy-critic is dispatched
  only after establishing/changing STRATEGY.md.
