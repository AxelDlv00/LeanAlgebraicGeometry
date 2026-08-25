## Progress

- [Pic0FiniteStageGluePackage.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluePackage.lean): reproduced the line-72 RingHom/CommRing source-cache mismatch and added reducible generic/package carrier wrappers. Direct source compilation passed in 3:34.19 with 7,605,416 KB peak RSS; the direct `.olean` and `.ilean` are present. Their `.olean.hash`/`.trace` companions predate the direct output, so cache metadata remains a stated residual risk.
- [Pic0FiniteStageGluingDiagramIso.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluingDiagramIso.lean): normalized the overlap helper with `overlapFinalBaseChangeEquiv`. An exact two-helper probe for `overlapBaseChangeIso_hom_ι` passes in 27.72s with 7,245,776 KB peak RSS; theorem statements and imports are unchanged.
- Horizon state: source files and forbidden-file checks are clean; the sibling AJC project has no corresponding finite-stage modules and was not edited. Commits `4a96f3dee9`, `7ee65bbccf`, `c176dfab08`, `7fa393c358`, and `4c22a0c6bf` record the work. Resolved conversation `I-2028` is archived.

## Issues

- Full DiagramIso with project output reached the 900.07s cap with no Lean diagnostic or `.olean`; sampled child RSS reached about 8.86 GB. An authoritative dependency overlay reached its 480.52s cap (1,075.85s user, 224% CPU, 7,871,676 KB peak RSS), again with no diagnostic or artifact.
- Per-declaration caps were 12,800,000 heartbeats (synthesis 3,200,000), with 32,000,000 on the terminal gluing declaration; no heartbeat exhaustion was reported. A final-theorem `sorry` probe also remained active, so the cost is a downstream file-level cone rather than only `gluingOverlapIso_fst`.

## Why I stopped

The objective is partly advanced but blocked: `Pic0FiniteStageGluingDiagramIso.olean` was not produced. The measured remaining cone starts after `overlapBaseChangeIso_hom_ι`, chiefly `overlapBaseChangeIso_hom_atlas_f_ι`, `restrictionBaseChangeMap_fromSpec`, and their final assembly. No full project build was run; the task is marked `blocked`.

## Next

Split the atlas projection and transport in `overlapBaseChangeIso_hom_atlas_f_ι` into separate private helpers, then benchmark `restrictionBaseChangeMap_fromSpec` independently with one-at-a-time probes. Preserve imports and theorem statements, and regenerate the `.olean.hash`/`.trace` companions in an isolated cache before the next DiagramIso retry.

## Workspace hygiene

After the authored commits, the remaining modified ledger paths are concurrent Horizon synchronization (blueprint, events, inbox, search, and hgraph state); they are outside this task and were not staged. This session's saved attempts and narrow-check records are staged separately below; locks, notify caches, logs, and other writers' state remain untouched.
