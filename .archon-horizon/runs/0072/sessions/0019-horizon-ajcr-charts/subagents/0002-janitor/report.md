Workspace hygiene pass for the Archon Horizon workspace at /home/axel/LeanAlgebraicGeometry-Horizon, scoped to what lane `ajcr-charts` (run 0072, round 8) touched this session. I am about to write my final report; find what I left inconsistent.

WHAT I DID THIS SESSION — three commits, all in MainProjects/Algebraic-Jacobian-Challenge-Rebuild:
- `ca0756dfba` — worksheet `informal/w4-datc-worksheet.md` §3.3 "correction 5".
- `ed39d62996a` — new file `AlgebraicJacobian/Picard/Pic0ChartPlusFibreProducer.lean` (CHART-U(b)'s producer). NOTE: this file and its root import had ALREADY entered HEAD via an orchestrator sweep commit `a6d948c7e` in a BROKEN mid-edit state; my commit repaired it.
- `0743cf6e7bc` — added `abelDiv_isPlusHonest` (a review found my header cited it and it did not exist), plus worksheet corrections and a re-synced hgraph node.
- `496a9fc9b7c` — repaired 7000+ false `stale: true` markers that my own single-file `graph sync --lean <one file>` had set across the project.

Ledger git access:
  git --git-dir=/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/vcs/workspace.git --work-tree=/home/axel/LeanAlgebraicGeometry-Horizon <cmd>

CHECK THESE SPECIFICALLY:

1. **Armed index / spurious deletions.** I found 58 staged deletions of hgraph nodes (all files present on disk and in HEAD — stale-index per protocol §1b) and disarmed them with a narrow `reset -- .../hgraph/`. Re-check: `status --porcelain | grep '^D'` must be empty, and confirm nothing I committed actually removed a file another lane owns. Verify my four commits touch ONLY paths in Algebraic-Jacobian-Challenge-Rebuild.

2. **The root import file.** `AlgebraicJacobian.lean` gained one line, `import AlgebraicJacobian.Picard.Pic0ChartPlusFibreProducer`. Confirm it is in HEAD, references only files that ARE in HEAD, and that I did not sweep or drop any sibling lane's import line (protocol §4/§4a — a `-import` line is never mine).

3. **hgraph consistency for my declarations.** The keystone lemma is `AlgebraicGeometry.testPoint_eq_overSpecMap` (NOT `...Over.testPoint_eq_overSpecMap` — the enclosing `namespace Over` was removed). I deleted a stale node `db894b97b3de.md` carrying the wrong name and pre-rename source. Check no node or doc still references the wrong name, and that the 15 declarations of my file have nodes with correct `decl:` names and plausible `lean_status`.

4. **Roadmap/task/inbox consistency.** I commented on roadmap rows `AJCR.w4-rep.datum.dat-c.c9-chartlocus.chart-u`, `...c9b`, and `AJCR.w4-rep.datum.dat-b`, and on task `ajcr-charts`. I filed inbox issues I-0810, I-0828, replied on I-0494 / I-0825. Check for: status/strategy fields that now contradict my comments (e.g. a row whose summary still says the producer is missing), open inbox items my work actually resolved and that should be archived, and any collection-health warnings.

5. **Anything I should have cleaned and did not** — scratch files, stray files. I created and deleted `AlgebraicJacobian/Picard/ScratchChartProducer.lean` and `ScratchHonestProbe.lean`; confirm they are gone and were never committed. `scripts/producer-probe.lean` is gitignored and intentionally left.

Note the machine is heavily loaded (10+ concurrent runs) — do NOT run lake builds and do NOT take the AJCR lake mutex at /tmp/claude-1001/ajcr-locks/lake.lock. Reading, grep, and git are enough.

You may FIX hygiene issues in roadmap/inbox/README state directly and report what you changed. Do NOT edit any .lean source file or my worksheet prose — report those instead. File findings as you go rather than only at the end.
