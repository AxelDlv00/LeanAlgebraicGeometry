# Progress-critic directive — iter-022

Assess convergence per active route. Two routes are under consideration for this
iter's prover dispatch. Signals are the last 4 iters (018–021).

## Route 1 — `AlgebraicJacobian/Cohomology/CechAcyclic.lean` (P3 L1 affine vanishing)

Goal of route: close `sectionCech_affine_vanishing` (standard-cover section Čech
homology vanishes in positive degree), the absolute-section-complex form of
`lem:cech_acyclic_affine`.

Per-iter signals:
- iter-018: +1 named (`dDiff_exact` skeleton begun). status PARTIAL. sorry 2.
- iter-019: +24 axiom-clean decls; landed `dDiff_exact` (step a: positive-degree
  `Function.Exact` of the un-localised module complex `D•`, incl. the
  localisation-transitivity keystone). status COMPLETE (named sub-target). sorry 2.
- iter-020: +4 decls; landed `qcohSectionsAwayLocalized` (step b, tilde case) +
  two step-(c) bricks. status PARTIAL. sorry 2.
- iter-021: +5 axiom-clean decls; landed the *abstract* categorical→module homology
  bridge (steps c1–c3 abstract half: `sectionCechProductEquiv`, `sectionCechFaceRestr`,
  `sectionCech_objD_apply`, `sectionCech_isZero_homology_of_objD_exact`). status PARTIAL.
  sorry 2 (unchanged — the 2 are intentional/superseded). Blocked on the "tilde
  F-bridge": a per-coordinate AddEquiv reconciling the `toPresheafOfModules`
  underlying-Ab section presheaf with the localised module, plus a naturality square.
  The prover handed off a precise A/B/C assembly.

Recurring blocker phrase: "tilde F-bridge" / "three distinct presheaf accessors"
(new in iter-021; not present 018–020).
Last verdict (iter-021): CONVERGING (SLIPPING — close steps c+d).
STRATEGY `Iters left` for this phase (P3): ~4–6. Phase entered: long-running (P3
active since early iters).

## Route 2 — `AlgebraicJacobian/Cohomology/FreePresheafComplex.lean` (P3b free side)

Goal of route: land `cechFreeComplex_quasiIso` (the free-presheaf complex is a
quasi-iso resolution of `O_𝒰`).

Per-iter signals:
- iter-018: built `quasiIso_of_evaluation` (objectwise reduction). status PARTIAL.
  sorry 0 (target is an all-or-nothing `def`, so no sorry pin).
- iter-019: `quasiIso_of_evaluation` end-to-end (recipe step 1). status PARTIAL. sorry 0.
- iter-020: +10 decls — the `FreeCechEngine.*` combinatorial homotopy engine + empty-case
  quasi-iso + per-summand evaluation bridges. status PARTIAL. sorry 0. Named target
  `cechFreeComplex_quasiIso` NOT landed; reduced to one sub-step: the
  evaluated-differential ↔ `combDifferential` match on coproduct injections.
- iter-021: **NO PROVER RAN.** The objective was NOOP-DROPPED at plan-validate (the file
  has 0 sorries and the scaffold keyword was on the line after the `.lean` path instead of
  on it). The planned CHURNING corrective (attack the differential-match node
  `cechFreeEvalEngineIso` first) never executed. No new prover data this iter.

Recurring blocker phrase: `cechFreeComplex_quasiIso` not landed in 3 iters; the
differential-match node `cechFreeEvalEngineIso` has NEVER been attempted by a prover
(blueprint node `lem:cech_free_eval_engine_iso` added iter-021, ready).
Last verdict (iter-021): CHURNING.
STRATEGY `Iters left` for this phase (P3b): ~4–7.

## This iter's objectives proposal (2 files)

1. `FreePresheafComplex.lean` — dispatch the prover on the differential-match node
   `cechFreeEvalEngineIso` (the never-attempted bottleneck), then the nonempty homotopy
   + glue, with the noop-keyword bug fixed so it actually runs.
2. `CechAcyclic.lean` — dispatch the prover on the tilde F-bridge (handoff A) + ladder
   transport (handoff B) + step d, after a blueprint-writer pass decomposes the coface
   match and a mathlib-analogist consults the three-accessor reconciliation.

## What I need from you

Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) and, for any
CHURNING/STUCK, the corrective TYPE. In particular: for Route 2, is dispatching the
prover on the never-attempted differential-match node the right corrective, or should
the CHURNING verdict force an immediate structural/mathlib-idiom escalation BEFORE the
prover round? For Route 1, is the tilde-bridge a genuine convergence step or a sign the
section-accessor design should be reconsidered?
