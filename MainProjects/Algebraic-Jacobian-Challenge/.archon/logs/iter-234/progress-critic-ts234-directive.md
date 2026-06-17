# progress-critic directive — iter-234

Assess convergence per active route. Fresh-context: do NOT read STRATEGY.md, PROGRESS.md,
or blueprint chapters. Use only the signals below.

## Route 1 — TS / d.2 (group-law substrate): `Picard/TensorObjSubstrate/*` (critical path)

The relative-Picard group law's sole remaining bottleneck is **d.2**: the varying-ring
stalk–tensor commutation `(A ⊗ᵖ B).stalk x ≅ A.stalk x ⊗_{R.stalk x} B.stalk x`
(new file `StalkTensor.lean`). Once d.2's iso lands it closes one open obligation
(`isLocallyInjective_whiskerLeft_of_W`) ⟹ unconditional associator ⟹ the by-hand
`CommGroup` (`thm:pic_commgroup`); the inverse is free (tensor-invertibility carrier).

Signals (last 5 iters):
- iter-230: binding probe of the (now-abandoned) dual route; ~0 substantive edits; project sorry 80→80.
- iter-231: NO-EDIT STALL on the dual route (all-or-nothing gate); 0 edits; sorry 80→80.
- iter-232: STRATEGY PIVOT — carrier changed from locally-trivial to tensor-invertibility
  `IsInvertible` (inverse becomes free witness); 2375-line file split 3 ways; no TS prover lane
  (prover ran on engine). The dual / internal-hom / `dual_restrict_iso` / `exists_tensorObj_inverse`
  apparatus DELETED from the critical path. sorry 80→80.
- iter-233: d.2 first concrete construction — `StalkTensor.lean` NEW file, **7 axiom-clean decls**
  building the FORWARD comparison map `stalkTensorDesc` + germ characterisations. 0 sorries in the
  file. The blueprint-pinned full iso `stalkTensorIso` NOT yet built (blocked at the next step,
  `stalkTensorDescU_smul`, a ~20–40 LOC carrier-duality plumbing issue, then `stalkTensorLinearMap`,
  then a ~150–250 LOC reverse map, then bundle).
- iter-234 (proposed): continue `StalkTensor.lean` (mathlib-build): `stalkTensorDescU_smul` →
  `stalkTensorLinearMap` (mirror the existing d.1 `stalkLinearMap`) → reverse map → `stalkTensorIso`.

Helpers added per iter: 230:~0, 231:0, 232:0 (structural pivot/split), 233:7 (forward-map chain). 
Prover statuses: 230 PROBE, 231 NO-EDIT-STALL, 232 (engine lane), 233 PARTIAL (real axiom-clean progress).
Recurring blocker phrase pre-232: "dual commutes with pushforward has no packaged Mathlib API".
Post-232 the blocker is reframed: "d.2 varying-ring stalk-tensor is a bounded ~200–400 LOC Mathlib gap".

Strategy: A.1.c.SubT `Iters left` = ~4–7. The route entered its CURRENT phase (carrier pivot + d.2
attack) at iter-232/233 (2 iters elapsed in the new phase). The pre-iter-232 dual route had stalled
~14 iters (217→231) — that stall is what the pivot dissolved.

QUESTION: Is the d.2 attack (post-pivot, 2 iters in, forward map landed) genuine convergence toward
`stalkTensorIso`, or is it the old stall wearing new clothes (helper-churn under a renamed target)?
The cheapest reversing signal I have named: does `stalkTensorLinearMap` land next iter (the prover
gave a precise decomposition), or does the reverse-map step balloon past its ~150–250 LOC estimate?

## Route 2 — Engine: `Cohomology/FlatBaseChange.lean` (A.2.c foundation, parallel)

Signals:
- iter-232: `pushforwardBaseChangeMap` (base-change map, adjoint mate) built axiom-clean. sorry +0 (orphan).
- iter-233: file WIRED into the build (+2 honest engine sorries counted); 3 axiom-clean locality
  lemmas added (stalk/basis/affine-open iso criteria); `affineBaseChange_pushforward_iso` reduced to
  the affine-open criterion but still sorry (blocked on the Mathlib-absent tilde pushforward/pullback
  dictionary, ~350–450 LOC).
- iter-234 (proposed): build the tilde dictionary pieces (pushforward of tilde ≅ restrictScalars;
  pullback of tilde ≅ base change) so `affineBaseChange_pushforward_iso` closes via `cancelBaseChange`.

Strategy: A.2.c-engine `Iters left` = ~30–60. Entered current phase iter-232 (2 iters in).
Prover statuses: 232 COMPLETE (map), 233 PARTIAL (locality lemmas, deep theorem deferred).

## Route 3 — Engine: `Cohomology/HigherDirectImage.lean` (parallel, NOT proposed for dispatch this iter)

Signals:
- iter-233: NEW file scaffolded; `def:higher_direct_image` no-sorry (conditional on
  `[HasInjectiveResolutions]`); 3 honest sorries, each blocked on a deep Mathlib-absent infrastructure
  (explicit `Rⁱf_* = sheafify` description; relative Mayer–Vietoris; Čech-to-cohomology spectral
  sequences). No frontier-ready sub-step exists.
- iter-234 (proposed): NOT dispatched — re-dispatch would only re-confirm the deep gaps. Deferred until
  a dedicated mathlib-build sub-lane (with blueprint support) is opened for one named gap.

QUESTION: Is deferring HigherDirectImage this iter correct (no frontier step), or is there a churn risk
in leaving it scaffolded-but-untouched?

## This iter's proposed `## Current Objectives`
- 2 prover lanes: `StalkTensor.lean` (mathlib-build, d.2) + `FlatBaseChange.lean` (mathlib-build, tilde dictionary).
- HigherDirectImage deferred (gap-blocked, no frontier step).

Give a per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) and, for any CHURNING/STUCK, the
corrective TYPE.
