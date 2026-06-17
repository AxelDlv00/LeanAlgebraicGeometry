# Iter 008 — Plan

## Decision made
- **Both lanes dispatched (DUAL + D3′), gate cleared via fast-path.** progress-critic = CONVERGING ×2
  (no CHURNING/STUCK), strategy-critic = SOUND on all math routes. The 30-iter DUAL churn is broken:
  iter-007 closed the forward `sliceDualTransport` naturality with the morphism-level recipe; the 3
  residual sorries (inv-naturality root L444 → left/right_inv L724/L726) are downstream of that closed
  square → fill by mirroring the template. D3′ re-engages: scaffold the 3 effort-broken bricks
  (`sheafifyMap_pullbackComp_hom_inv_id`, `sheafifyTensorUnitIso_comp`, `pullbackValIso_comp`) + prove
  bottom-up → close `pullbackTensorMap_restrict` (L3144). Reversal signal: if the inv-naturality root
  still won't close by mirroring the (now proven) forward square, the `sliceDualTransport` *shape*
  becomes the effort-breaker target.
- **HARD GATE handling (blueprint-reviewer bp008 = chapter partial/partial).** The consolidated chapter
  `Picard_TensorObjSubstrate.tex` covers both objective files. Reviewer: D3′ bricks ADEQUATE; DUAL
  `lem:slice_dual_transport_inv` had must-fix B1 (missing `hβ` hypothesis) + minor B2 (stale
  `restrictScalarsLaxε` prose) + B3 (missing `unitRelabelSwap` 4th leg). Took the sanctioned fast-path:
  blueprint-writer fixed B1/B2/B3 (+ `\uses{}` on `sheafify_tensor_unit_iso_comp` proof) → blueprint-clean
  → scoped re-review (rescope008) returned **HARD GATE CLEARED**, both lanes authorized this iter.
- **strategy-critic must-fix (format DRIFTED):** removed per-iter narrative from STRATEGY.md (iter refs,
  `iter/iter-006/objectives.md` sidecar path, "30-iter … iter-006 analogist", "effort-broken iter-007"),
  fixed the stale "4 sorries none closed" → "3 left, forward closed", repointed the `restrictScalarsLaxε`
  Mathlib-gap line to the `IsIso.inv_comp_eq` rotation.
- **progress-critic must-fix (maintenance):** corrected the stale sorry line numbers in PROGRESS.md /
  task_pending.md (L365/502/604/606 → L444/L724/L726; 4 → 3 sorries).

## Coverage debt — deferred (recorded)
~97 `lean_aux` decls with no blueprint entry. blueprint-reviewer dispositioned non-blocking; it is the
scheduled `Coverage + file-split cleanup` phase. NOT cleared this iter: authoring 97 entries while two
active prover lanes edit the same consolidated chapter would race and dilute the convergence push.
Deferred deliberately, not silently.

## Carry-forward (non-blocking)
- lean-auditor iter-007 flagged 3 stale `.lean` docstring comments (Vestigial.lean:15;
  DualInverse.lean:44, :200) — neither file is a prover objective this iter, so they persist; fix in
  the Coverage/cleanup phase or when a prover next touches those files.

## Subagent skips
- None this phase. Dispatched: blueprint-reviewer (bp008 + scoped rescope008), progress-critic (conv008),
  strategy-critic (arc8), blueprint-writer (slicedualinv), blueprint-clean (tos008).
