# iter-074 plan — build wall RESOLVED by file split; 2 parallel CSI lanes dispatched

## Situation
- iter-073 was a **pure tooling outage**: the 2475-LOC CSI monolith OOM/timeout-killed every inline
  `lake build`/`lake env lean` (exit 137/144), so the prover landed **0 edits**. The 2 atomic leaves
  (`sectionCechAugV_π`, `coreIso_comm_leg`) are NOT the obstacle — both are complete-blueprinted and reduce
  to PROVED seams. The iter-073 review hand-off: fix the build wall (split or LSP-mode) BEFORE re-dispatch.

## Actions this phase (some executed by the prior incarnation of this session; reused per user hint)
- **refactor `refactor-split-csi`** (this iter): SPLIT the CSI monolith into 3 modules — `…Base.lean`
  (1486 LOC, 0 sorry, proved engine + push–pull seams), `CechSectionIdentification.lean` (764 LOC, the
  `sectionCechAugV_π` leaf @370), `CechSectionIdentificationLeg.lean` (273 LOC, the `coreIso_comm_leg`
  leaf @68). **Verified build GREEN (`.archon/iter/iter-074/build.log`, EXIT=0; main module 9.8s).** The
  refactor also added the two `% archon:covers` lines to the consolidated chapter (mechanical bookkeeping,
  no math change). Frozen `\lean{}` decl names preserved.
- **progress-critic `iter074`** = **CONVERGING** with a one-iter watch flag: the build-wall split IS the
  corrective (structural change in approach, not "more helpers"); full 2-lane dispatch is OK. **Watch: if
  iter-074 provers close NEITHER sorry, reclassify STUCK** (math, not tooling, would then be the wall).
- Wrote 2 PARALLEL prover lanes into PROGRESS.md (now separate small modules — user standing directive:
  parallelism via file splitting). Inline `lake build <module>` re-enabled as the verification gate.
- STRATEGY.md P5a row refreshed: split recorded, iter-073 reclassified as a tooling outage (not route wall).

## Decision made
- **Split over LSP-only-sanction.** The iter-073 recommendation offered two correctives; the split is the
  cheapest DURABLE fix (re-enables real `lake` verification + unlocks parallelism + avoids the
  kernel-soundness trap that LSP-only would risk). It was already executed + build-verified this iter.
- **Order: both lanes run in parallel** (separate files, separate provers). `sectionCechAugV_π` carries the
  hard PARTIAL BAR (degree-0, cheap — must close to satisfy the convergence watch-flag and make the Base
  Stub-6 homotopy sorry-free). `coreIso_comm_leg` is the wall; a genuine attempt + typed (a)–(d) sub-split
  on stall is acceptable, full effort-break is next iter's escalation.
- Cheapest reversal signal: if BOTH provers report inline-build success but still cannot close their leaf,
  that confirms a math wall (not tooling) → next iter pivots to effort-break / fine-grained per the watch.

## Subagent skips
- blueprint-reviewer: the consolidated chapter's MATH is unchanged since iter-073's HARD GATE PASS for CSI;
  the only edit this iter is the refactor's mechanical `% archon:covers` additions for the 2 new split
  files (no statement/prose/`\uses` change to either targeted lemma). No live must-fix on CSI. Gate stands.
- strategy-critic: STRATEGY.md route + decomposition UNCHANGED (the split is a tooling/file-layout fix, not
  a route or phase change — only a within-phase status refresh of the P5a cell); prior verdict SOUND, no
  live CHALLENGE. Re-blessing the identical route is the hollow-dispatch failure mode.
- progress-critic: NOT skipped — dispatched this iter (`iter074`, CONVERGING).
