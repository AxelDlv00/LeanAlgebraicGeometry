# Progress-critic directive — iter-007 convergence audit

Two active routes. Verdict each (CONVERGING / CHURNING / STUCK / UNCLEAR) with the named corrective.

## Route DUAL — `DualInverse.lean` (seed `dual_isLocallyTrivial`, inverse chain)
Signals (last 4 iters):
- iter-003→006: file RED / non-compiling. Persistent blocker phrase: "`sliceDualTransport.naturality`
  whnf heartbeat timeout — pointwise `ext z; simp [dualUnitRingSwap_apply]` forces `inv ε` through whnf"
  (~30-iter churn on this one naturality square).
- Compile errors held at 6 (L407/436/556/566/799/803) across iters 005 and 006; UNCHANGED.
- iter-006: NO prover edits landed (objective dropped by plan-validate: a RED file shows zero
  `sorry`-tactics → looked like "no work"). Helpers accreted over history: `dualUnitRingSwap`,
  `unitRelabelSwap`, `isIso_ε_restrictScalars_appIso`, `dualUnitRingSwapHom`, etc.
- Prover statuses: INCOMPLETE / no-commit.
- STRATEGY `Iters left`: ~3–5. Route has been ACTIVE many iters (entered current phase long ago).
This iter's plan proposal: refactor-GREEN the file (typed sorry at the 6 sites) + split off
`sliceDualTransport` into its own file, THEN a single prover lane fills the naturality sorries via the
NEW morphism-level recipe `analogies/dualnat006.md` (rotate `inv ε` via `IsIso.inv_comp_eq` →
forward ε-square; never apply `inv ε` pointwise). This is the FIRST execution of that recipe.

## Route D3′ — `TensorObjSubstrate.lean` (seed `pullback_tensor_iso_loctriv`)
Signals (last 4 iters):
- iter-006: strong convergence — closed `sheafificationCompPullback_comp_tail` (the 6-iter STUCK node),
  `comp_natTrans`, `comp` (end-to-end sorry-free), and the `hδ`/Sq2b sub-sorry. sorry-decls 3 → 2. GREEN.
- Remaining: `pullbackTensorMap_restrict` residual = Sq3/Sq4 coherence sub-lemmas that DO NOT EXIST yet
  (project construction, not a tactic gap); `exists_tensorObj_inverse` deferred (import-cycle).
- Prover status iter-006: PARTIAL (committed `erw [hδ]` advance).
- STRATEGY `Iters left`: ~3–5. This iter's plan proposal: NO prover lane on D3′ (residual needs new
  sub-lemmas first — decomposition pending), so route is paused-by-design this iter.

Report per route: verdict + whether the proposed corrective matches the verdict.
