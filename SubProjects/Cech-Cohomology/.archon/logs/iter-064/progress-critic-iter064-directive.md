# Progress-critic directive — iter-064

Assess convergence per route. Two active routes, each one prover lane per iter, both `mathlib-build` mode.

## Route A — CSI: `CechSectionIdentification.lean` (Sub-brick A, P5a-resolution)
Target leaf sorry: `pushPull_sigma_iso` (Stub 2) + 3 downstream stubs (4/5/6). The sorry sits ATOP a long
dependency chain; closing it requires building the whole chain first.

Signals (last 4 iters):
- iter-060: project sorry 11→9 (this route closed Stub 1 `cechBackbone_left_sigma`). Status PARTIAL.
- iter-061: 9→9. Added 3 axiom-clean helpers (L1 `isIso_modules_of_toPresheaf` + 2 prep). Status PARTIAL.
  Blocker: "L2 binary node blocked by instance trap, precise fix handed off."
- iter-062: 9→9. Added 2 (`isIso_coprodDecompMap` + `isIso_map_prodLift_of_isLimit`). Status PARTIAL.
  Blocker: "iter-061 readiness claim WRONG — L2 is the full q_*-coherence assembly ~200-300 LOC, not the leaf."
- iter-063: 9→9. FIXED a red build (file arrived broken) + added 3 axiom-clean (`pushPull_binary_leg_coherence`
  the ★, `pushPull_binary_coprod_prod` the substantive canonical L2 node, `sigmaOptionIso`). Status PARTIAL.
  Blocker: "residual = `pushPull_coprod_prod` finite-index induction, fully decomposed into 6 small mechanical
  pieces (pushPullObjCongr ~6 LOC, Over-lift of sigmaOptionIso ~15, piOptionIso ~15, induction_empty_option
  ~20-30, of_equiv ~20, h_option ~30, specialization ~15); declined the ~120-LOC monolith near budget."

STRATEGY estimate: ACTIVE (OVER_BUDGET), ~3–5 iters left; P5a entered ~iter 056 (≈7 iters elapsed).

## Route B — OpenImm: `OpenImmersionPushforward.lean` (P5a-consumer)
Target leaf sorry: `hqc` (line ~690) + `_comp` (line ~827). `hqc` needs the full comparison-iso chain.

Signals (last 4 iters):
- iter-060: 11→9 contribution (this route closed `hjt`). Status PARTIAL.
- iter-061: 9→9. Added 2 (`coversTop_preimage_of_iso` + `pushforward_iso_qcoh_of_slice_qcoh`); reduced hqc to
  per-slice. Status PARTIAL. Blocker: "residual = cross-ring slice ring hom ψ_r ~100-150 LOC absent from Mathlib."
- iter-062: 9→9. Added 6 (`sliceStructureSheafHom` = ψ_r + 4 instances). Status PARTIAL. Blocker: "ψ_r 'genuine
  wall' CLEARED; residual = comparison iso `pushforwardSlicePullbackIso`; blueprint proof was WRONG (unit-only)."
- iter-063: 9→9. Added 6 (`sliceOversEquiv` + both continuity instances incl. the inverse-continuity that was
  the 3-iter stuck `[F.IsContinuous]` metavar). Status PARTIAL. Blocker: "metavar wall CLEARED; residual =
  φ''/H₁/H₂ coherence ~150 LOC; φ'' now identified as object-level correction-FREE with precise recipe, H₁/H₂
  reduce to eqToHom squares — implementation depth, not blueprint."

STRATEGY estimate: ACTIVE (OVER_BUDGET), ~3–5 iters left; P5a-consumer ≈9 iters elapsed.

## This iter's proposed objectives (for dispatch-sanity)
2 files: `CechSectionIdentification.lean` and `OpenImmersionPushforward.lean`. The planner is considering
a MODE SWITCH (mathlib-build → fine-grained) + finer blueprint decomposition (effort-breaker on both leaf
chains) rather than a bare mathlib-build re-dispatch.

## Question
Per route: CONVERGING / CHURNING / STUCK / UNCLEAR. Both routes have flat project-sorry for 4 iters but each
iter cleared a DISTINCT named wall and the residual is now fully decomposed/precisely specified. Is this genuine
deep-chain convergence (sorry is a lagging indicator) or churning (walls being discovered endlessly)? Name the
corrective TYPE per route if CHURNING/STUCK. Assess whether the proposed mode-switch + finer-decomposition is a
genuine structural action or a dressed-up bare re-dispatch.
