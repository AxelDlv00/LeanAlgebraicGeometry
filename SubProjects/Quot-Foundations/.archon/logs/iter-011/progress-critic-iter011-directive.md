# Progress-critic — iter 011

Fresh-context convergence audit of the active prover routes. For each route below
return a per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR), the
corrective TYPE if not converging, and whether the iter-011 dispatch proposal is
sound. Do NOT read STRATEGY.md or the blueprint chapters — judge convergence from
the signals only.

Note: iter-005 and iter-010 were DAG (blueprint) iters with no prover phase, so the
prover-trajectory window is iters 006–009.

## Route FBC — `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- Phase: FBC-A. Strategy estimate: 2–3 iters left. Entered current phase ~iter-006.
- iter-006: prover active (parallel).
- iter-007: 4 sorries. Two targets blocked on Mathlib infra (QCoh bridge, monoidal SheafOfModules).
- iter-008: 4→5 sorries. `map_smul'` substantively proven (route (a) first end-to-end), split into 2 trivial zero-branches; blocker phrase: "transparent-instance wall".
- iter-009: ROUTE SWAP executed — abstract adjoint-mate tower (3 sub-lemmas + trace identity) DROPPED, replaced by one `lem:base_change_mate_section_identity`; `regroupEquiv` rebuilt on `Algebra.IsPushout.cancelBaseChange` (kills `map_smul'`). Prover committed ~67 edits to this file in the most recent prover phase. Build GREEN; ~5–6 sorry-bearing decls remain, with the section identity as the residual crux.
- PARTIAL/PARTIAL across the window; iter-009 critic verdict was CHURNING (the iter-008 tripwire fired: the 3 mate sub-lemmas never existed as typed decls). The route-swap corrective was then executed iter-009 and the file received substantial prover work after it.

## Route GF — `AlgebraicJacobian/Picard/FlatteningStratification.lean`
- Phase: GF-alg. Strategy estimate: 2–3 iters left. Entered current phase ~iter-006.
- iter-006: stall (induction did not generalize the base domain `A`).
- iter-007: L5 induction restructured to generalize base `A`.
- iter-008: 2 sub-lemmas landed axiom-clean (`gf_generic_rank_ses`, `gf_clear_one_denominator`); `gf_torsion_reindex` created as a new sorry. 4→5 sorries.
- iter-009: `gf_torsion_reindex` effort-broken into 4 sub-lemmas (annihilator extraction, Nagata change-of-vars, a Mathlib anchor, the shared single-variable elimination engine `gf_mvPolynomial_quotient_finite_monic`). Prover committed ~30 edits in the most recent prover phase. Build GREEN; 5 sorry-bearing decls (the effort-broken chain).
- iter-009 critic verdict: UNCLEAR→CONVERGING, NOT STUCK (iter-008 STUCK tripwire did NOT fire; 2 sub-lemmas axiom-clean; blocker narrowing across iters).

## Route GrassmannianCells — `AlgebraicJacobian/Picard/GrassmannianCells.lean`
- Phase: GR-cells. Strategy estimate: ~1–2 iters per node. Entered ~iter-007.
- iter-007: `affineChart` landed axiom-clean.
- iter-008: dispatched to build `transitionMap` (`def:gr_transition`, a Cramer-inverse ring hom on a localized polynomial ring) → committed ZERO edits, wrote no task result (no-output anomaly).
- iter-009: re-dispatched for the SAME target WITH an explicit "investigate the no-output anomaly first" instruction → again committed ZERO edits; the file is still only `affineChart` (0 real sorries, `transitionMap` does not exist).
- So: 2 consecutive dispatches at the same node, 0 output each, 0 closures, 0 structural advance.

## Route QuotScheme — `AlgebraicJacobian/Picard/QuotScheme.lean`
- Phase: QUOT-defs / SNAP. Strategy estimate: 4–7 iters left (QUOT-defs), 2–4 (SNAP). Entered ~iter-007.
- iter-007: 4 skeleton stubs scaffolded (4 sorries).
- iter-008: deferred (annihilator blueprint-writer round, no prover).
- iter-009: lane BLOCKED at the gate — `lem:qcoh_section_localization_basicOpen` (QCoh→IsLocalizedModule bridge) had a Lean name but no `% LEAN SIGNATURE`; a writer authored the bridge + SNAP-S2 signatures that iter. No prover ran on it. Still 4 skeleton sorries.

## iter-011 dispatch proposal (file count + basenames)
THREE prover lanes:
1. `FlatBaseChange.lean` [prove] — close `base_change_mate_section_identity` + the residual FBC-A sorries.
2. `FlatteningStratification.lean` [mathlib-build] — build the effort-broken GF chain bottom-up.
3. `QuotScheme.lean` [mathlib-build] — build the QCoh bridge + `sectionGradedRing`/SNAP, contingent on the fresh blueprint-reviewer clearing the signatures authored iter-009/010.

GrassmannianCells is NOT proposed as a prover lane this iter; instead I am dispatching an
effort-breaker on `def:gr_transition` (corrective for the 2-iter zero-output stall), so it
becomes a chain of small ready pieces for the next prover iter. Confirm this is the right
response to the GrassmannianCells signals, and flag if any of the three proposed lanes is
churning/stuck and should get a different corrective instead.

Write your report to `task_results/progress-critic-iter011.md`.
