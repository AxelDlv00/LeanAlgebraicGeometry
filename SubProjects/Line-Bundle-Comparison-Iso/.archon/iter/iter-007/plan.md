# Iter 007 — Plan

## Decision made
- **DUAL multi-iter RED deadlock broken structurally (must-fix).** `DualInverse.lean` was RED for
  ≥2 iters (6 errors L407/436/556/566/799/803); iter-006's prover delivered nothing (plan-validate
  DROPPED the objective — a RED file shows 0 sorry-tactics → "no work"). Corrective the progress-critic
  named for the STUCK verdict = structural refactor. Executed it: a refactor (a) GREENED the file by
  inserting typed `sorry` at the 6 broken sites, and (b) split the churning `sliceDualTransport`/
  `sliceDualTransportInv` + ring-swap helpers into `DualInverse/SliceTransport.lean` (612 LOC).
  Result: ALL DUAL modules build green (8323 jobs); the 4 hard sorries (inv-naturality=root,
  fwd-naturality, left/right_inv) are now REAL, dispatchable sorries in one isolated file →
  plan-validate won't drop them; the `dualnat006.md` morphism-level recipe gets its FIRST prover
  execution this iter. Reversal signal: if the recipe (`IsIso.inv_comp_eq` → forward ε-square) still
  doesn't close the inv-naturality root next iter, the `sliceDualTransport` *shape* becomes the
  effort-breaker target (decompose the naturality into the forward-ε square lemma + the gluing).
- **User hint #1 (split >1000-LOC files):** done for `DualInverse.lean` (1235 → 638 + 612).
  `TensorObjSubstrate.lean` (3152, GREEN) split DEFERRED to next iter to avoid racing the must-fix
  DUAL repair on the central import; recorded as the `Coverage + file-split cleanup` STRATEGY phase.
- **D3′ (UNCLEAR, 1-iter pause sanctioned):** converted the pause into decomposition-prep — an
  effort-breaker split the `pullbackTensorMap_restrict` Sq3/Sq4 residual into 3 named bricks
  (`lem:sheafify_pullbackcomp_hom_inv_cancel`, Sq3 `lem:sheafify_tensor_unit_iso_comp`, Sq4
  `lem:pullback_val_iso_comp`) + a `comp_δ`-split assembly, `\uses` wired, doctor clean. Next iter:
  scaffold these 3 bricks into Lean + prove bottom-up. (Avoids the ≥2-iter avoidance flag.)

## Prior critique status (strategy-critic arc7 — CHALLENGE ×2, addressed)
- **D3′ self-contradiction** (route prose "Sq3/Sq4 CLOSED" vs risk "don't exist yet"): FIXED —
  route now states Sq1/Sq2/Sq2b CLOSED, Sq3/Sq4 are the residual (effort-broken this iter).
- **Format: per-iter narrative + stale LOC 3411**: FIXED — narrative trimmed, LOC corrected to 3152.
- **DUAL "deadlock broken" over-claim** (sorries relocated not closed): REBUTTAL — the refactor never
  claimed to close sorries; its purpose was to break the RED/plan-validate-drop deadlock + isolate the
  proof so the recipe can run. Sorry-closing is the prover's job THIS iter (the matched corrective the
  progress-critic endorsed). STRATEGY wording softened to "none yet closed." Did not re-dispatch the
  critic — the fixes are mechanical reconciliations of its exact findings.

## Subagent skips
- lean-vs-blueprint-checker / lean-auditor: review-phase subagents, not plan-phase.
- blueprint-clean: no blueprint-writer round this iter (effort-breaker edits are math-only,
  doctor-clean); chapter purity unchanged.
