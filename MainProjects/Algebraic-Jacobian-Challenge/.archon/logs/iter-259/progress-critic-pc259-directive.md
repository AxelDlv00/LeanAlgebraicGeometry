# progress-critic directive — iter-259 (pc259)

Assess convergence of the two routes the planner is considering for prover dispatch this iter.
Verdict per route (CONVERGING / CHURNING / STUCK / UNCLEAR) + named corrective for any CHURNING/STUCK.

## Route 1 — SHARED ROOT `Picard/SheafOverEquivalence.lean` (`SheafOfModules.overEquivalence` + 3 consumer isos)

Strategy estimate: Iters-left ~2–4. Entered phase iter-258 (1 iter elapsed).

Per-iter signals:
- iter-258 (lane opened): sorry 4 → 2. Status PARTIAL-with-major-close. Closed the LINCHPIN
  `overEquivalence` axiom-clean (`{propext, Classical.choice, Quot.sound}`) — the genuine content
  (open-immersion ring iso φ, inverse ψ, coherences H₁/H₂, 3 continuity instances, 2 image-equality
  lemmas). Helpers added this iter: 6 (phiOver, psiOver, overEquivInverseIsContinuous,
  overEquivFunctorIsContinuous, image_overEquiv_functor_obj, left_overEquiv_inverse_obj). `chartOverIso`
  is a closed one-liner (sorry-transitive only).
  Remaining 2 sorries: `restrictOverIso` (full body; route documented — `pushforwardComp` +
  `pushforwardNatIso`, mirror of `restrictFunctorAdjCounitIso`, ~30–60 LOC) and `unitOverIso`
  (ONE leaf — `IsIso` of the additive map underlying a sectionwise ring iso; reflection chain already
  built, `IsIso (phiOver U)` already proven; ~5–10 LOC).
- No recurring blocker phrase: the two carrier/`Functor.map_comp` walls that fought `overEquivalence`
  were CRACKED this iter (recipes recorded).

iter-259 proposal: close `restrictOverIso` + `unitOverIso` (the 2 remaining sorries). One prover lane.

## Route 2 — D3′ `Picard/TensorObjSubstrate.lean` (`pullbackTensorMap_restrict`, via the "Sq2b" `pullbackComp` monoidality)

Strategy estimate: Iters-left ~10–16 for A.1.c.sub overall. In-phase ~24 iters.

Per-iter signals:
- iter-256: D3′ scaffolded, PARTIAL. Planner recipe ("mirror `pullbackObjUnitToUnit_comp`") DISPROVEN
  by the prover (reversing signal as armed — `pullbackTensorMap` is a 4-fold composite, not a transpose).
  sorry 1 → 2 (new scaffold). Blocker phrase: "mirror recipe structurally false".
- iter-257: closed only `toRingCatSheafHom_comp_hom_reconcile` (found to be `rfl` — a triviality the
  blueprint had mislabelled "non-trivial transport"). The genuine content "Sq2b" (= monoidality of
  `PresheafOfModules.pullbackComp`) exposed as Mathlib-absent + 3 documented frictions. sorry 2 → 2.
  Status PARTIAL. Blocker phrase: "Sq2b Mathlib-absent, 3 frictions".
- iter-258: lane was DISPATCHED but produced NO edits and NO task_result (it silently did not run; the
  prover budget went to held-consumer finishes instead). sorry 2 → 2. A NEW recipe was produced this
  iter by a mathlib-analogist (η→δ port of the COMPILING `pullbackObjUnitToUnit_comp` at the
  PresheafOfModules level, claimed to dissolve all 3 iter-257 frictions) but was NEVER ATTEMPTED.

iter-259 proposal: attempt the analogist's η→δ Sq2b recipe (its FIRST real attempt — the iter-258
dispatch never ran). One prover lane. Reversing signal armed: if the η→δ port hits a step with no analog
in the compiling `pullbackObjUnitToUnit_comp`, leave a typed sorry + report the exact failing step; do
NOT stack a new abstract helper.

Planner note for your judgment (not a rebuttal request): the iter-256/257 PARTIALs were on a DISPROVEN
recipe; the corrective (analogist consult) is already DONE (iter-258, `analogies/d3sq2b258.md`). iter-259
is the first execution of that corrective's output, not another helper-round on the broken recipe. Please
state whether you read this as CHURNING (and if so, what corrective beyond "execute the fresh recipe once"
you'd require) or UNCLEAR/CONVERGING.

## Dispatch-sanity

Current Objectives proposal for iter-259 (2 files, within the 10 cap):
1. `Picard/SheafOverEquivalence.lean` — close `restrictOverIso` + `unitOverIso`.
2. `Picard/TensorObjSubstrate.lean` — D3′ Sq2b (η→δ port).

Files are import-independent (SheafOverEquivalence imports `TensorObjSubstrate.Vestigial` + Mathlib, NOT
`TensorObjSubstrate.lean`). `DualInverse.lean` + `LineBundleCoherence.lean` are HELD (gated on / consuming
the shared root; DualInverse held also to avoid the iter-257 cross-lane compile race). Confirm the 2-file
set is sane.
