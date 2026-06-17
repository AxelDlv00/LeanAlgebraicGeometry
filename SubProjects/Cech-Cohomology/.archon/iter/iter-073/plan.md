# iter-073 plan — CSI down to 2 atomic leaves; coverage debt cleared; gate passed

## Situation
- iter-072 prover made REAL progress (despite flat sorry count 2→2): PROVED the whole `coreIso_comm`
  chain (`_coface`/`_sum`/`coreIso_comm` rewired) + fully ASSEMBLED Stub 6 `cechSection_contractible`
  (dependent engine, (I0)/(I1)/(In), `mkCoinductive`). CSI residual = 2 ATOMIC LEAVES:
  `coreIso_comm_leg` (1536, the wall) + `sectionCechAugV_π` (2081, degree-0 augmentation seam).
  Both unwind through the PROVED `pushPull_sigma_iso_π` + `pushPull_leg_sections`.
- iter-072 prover was killed (exit 144) mid final-verification; no task_results written. Reconstructed
  state from the prover jsonl (last sorry-count tool result = 2, "LSP zero errors") + the file header.

## Actions this phase
- blueprint-writer `covdebt073`: cleared ALL 27 leandag coverage-debt items — authored the missing
  `lem:sectionCechAugV_π` block + bundled 26 proved private helpers into 3 existing `\lean{}` lists
  (`lem:cechSection_contractible`, `lem:pushPull_sigma_iso`, `lem:coreIso_comm_sum`). leandag
  `unmatched_lean` → 0, `unknown_uses` → [].
- progress-critic `iter073` = **CONVERGING** (residual shrank from 2 composite goals to 2 atomic leaves;
  CHURNING criterion-3 not met). **Watch-flag: count still 2 after iter-073 ⇒ two-flat-iter CHURNING
  threshold.** ⇒ this iter MUST close ≥1 sorry. Mitigation: directive orders the cheaper degree-0
  `sectionCechAugV_π` FIRST (guaranteed structural close).
- blueprint-reviewer `iter073` = **HARD GATE PASS** for CSI; new block complete+correct; 5 soon-findings
  (missing `\lean{}` hints, none on CSI path) — deferred to next-iter cleanup.
- STRATEGY P5a residual cell refreshed (coreIso_comm chain now PROVED; residual = the 2 leaves). Route /
  decomposition UNCHANGED.

## Decision made
- **Order the lane `sectionCechAugV_π` before `coreIso_comm_leg`.** Why: the degree-0 seam has no coface
  combinatorics, is the cheaper of the two, and closing it makes the whole Stub-6 homotopy sorry-free —
  guaranteeing the progress-critic's "close ≥1 this iter" watch-flag is satisfied even if the
  `coreIso_comm_leg` wall holds. Trade-off: none (same lane, sequential). Cheapest reversal signal: if
  the prover reports `sectionCechAugV_π` is itself blocked on an unproved seam, that seam becomes the
  next effort-break target.
- **No effort-break dispatched this iter.** `coreIso_comm_leg` is already the atomic leaf the iter-072
  breaker produced; its proof route (the (a)–(d) seam split) is in the directive. Further breaking is
  reserved for next iter IF it stalls — premature breaking now would churn.

## Subagent skips
- strategy-critic: route + decomposition UNCHANGED since iter-067 (only a within-phase status refresh of
  the P5a residual cell — coreIso_comm chain now proved, residual narrowed to 2 leaves); prior verdict
  SOUND, no live CHALLENGE. Re-blessing the identical route is the hollow-dispatch failure mode.
