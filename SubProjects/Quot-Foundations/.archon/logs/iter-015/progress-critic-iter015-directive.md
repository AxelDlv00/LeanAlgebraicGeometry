# Progress-critic — iter-015

Fresh-context convergence audit. Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) and,
for any CHURNING/STUCK, the corrective TYPE. Also run the dispatch-sanity check on the proposed
objective list (item 6).

## Route: FBC — `Cohomology/FlatBaseChange.lean`

Strategy `Iters left`: 1–2. Entered FBC-A phase: iter-008 (long-running). Signals (last 4 iters):

- iter-011: sorry 5→? ; re-closed `base_change_mate_regroupEquiv` (`map_smul'` wall broken). PARTIAL→progress.
- iter-012: sorry 5 ; `section_identity` body sorry-free + `inner_value` proven; decomposed into 3
  typed seam holes (intentional). PARTIAL (decomposition).
- iter-013: DAG-only (no prover).
- iter-014: sorry 5→4 ; **Seam 1 `base_change_mate_unit_value` CLOSED axiom-clean** via the
  mathlib-analogist conjugate-unit calculus. COMPLETE on the must-close.
- Recurring blocker phrase (now resolved): "opaque conjugateIsoEquiv element chase" — replaced by the
  abstract calculus that landed Seam 1.
- Next target: Seam 2 `fstar_reindex` (typed sorry, roadmap written) → Seam 3 → cascade.

## Route: GF — `Picard/FlatteningStratification.lean`

Strategy `Iters left`: 1–3. Entered GF-alg phase: ~iter-007. Signals (last 4 iters):

- iter-011: sorry 5 ; +3 Nagata dévissage sub-lemmas (axiom-clean), wired into reindex.
- iter-012: sorry 5 ; hard content `Module.Finite (P_g/⟨F_g⟩) T_g'` landed; (a)–(e) residue open. PARTIAL.
- iter-013: DAG-only (no prover).
- iter-014: sorry 5→4 ; **`gf_torsion_reindex` CLOSED axiom-clean** via top-level helper factoring
  (+5 transport helpers). COMPLETE on the must-close.
- Recurring blocker phrase (now resolved): "inline (a)–(e) stacking blows isDefEq heartbeats" — fixed
  by factoring into standalone helpers.
- Next target: L5 `exists_free_localizationAway_polynomial` (typed sorry, 5-step roadmap written) →
  L4 → `genericFlatnessAlgebraic`.

## Route: QUOT — `Picard/QuotScheme.lean`

Strategy `Iters left`: 2–4 (SNAP-S2). Entered SNAP-S2 phase: iter-012. Signals (last 4 iters):

- iter-012: sorry 4 ; SNAP-S2 power-series engine landed (8 axiom-clean decls — the whole
  power-series half of Stacks 00K1). COMPLETE on that sub-build.
- iter-013: DAG-only (no prover).
- iter-014: sorry 4 ; **NO prover lane** — instead set up the graded-API: mathlib-analogist consult +
  blueprint-writer authored `subsec:gradedModuleApi` (G1–G5/D5 over existing Mathlib scaffold).
- iter-015 (proposed): **first graded-API prover lane** — `mathlib-build` on G1→G2→G5→G3→G4.
- Meta-pattern flagged iter-012/014: QUOT had 3 consecutive iters with no prover dispatch (012 engine,
  013 dag, 014 setup). The iter-014 plan made an **unconditional iter-015 prover commitment** for QUOT.
- Note: a typed-sorry count flat at 4 for QUOT reflects the 4 downstream-blocked stubs, NOT the
  building-block work (the graded-API decls don't exist yet — they're a build/scaffold lane).

## Proposed iter-015 objective list (for dispatch-sanity)

3 import-independent prover lanes, different files:
1. `Cohomology/FlatBaseChange.lean` [prove] — Seam 2 → Seam 3 cascade.
2. `Picard/FlatteningStratification.lean` [prove] — L5 `gf_polynomial_core` → L4 → genericFlatnessAlgebraic.
3. `Picard/QuotScheme.lean` [prover-mode: mathlib-build] — graded-API building blocks G1→G2→G5→G3→G4.

Assess each route's trajectory and whether 3 lanes is the right load. Flag any route where the
"looks like progress" reading masks churn.
