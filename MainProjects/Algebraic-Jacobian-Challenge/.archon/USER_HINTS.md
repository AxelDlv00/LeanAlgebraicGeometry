<!--
USER_HINTS.md — two sections with different lifecycles.

## Temporary hints
  Consumed by the next plan phase and then cleared. Use for one-shot
  steering: "try route X this iter", "skip Lane F this round".

## Persistent hints
  NEVER auto-cleared. These are standing directives that survive every
  iteration reset. The plan agent treats them as HIGHER PRIORITY than
  any conflicting instruction in its own prompt or in
  .archon/prompts/plan.md. Use for project-wide constraints:
    - "never accept axiom X"
    - "don't touch theorem Y until I say so"
    - "always run mathlib-build mode on Lane I"

Format for both sections (one bullet per hint, timestamped):
  - [YYYY-MM-DDTHH:MM:SSZ] hint text

Hints are written by 'archon discuss' or directly by you. In discuss,
the agent will ask which section to target; in a direct edit, place your
bullet under the appropriate heading.

File-specific hints (one .lean file only) belong as /- USER: ... -/
comments inside that file — NOT here.
-->

## Temporary hints


## Persistent hints

- [2026-05-31T00:00:00Z] AUTONOMOUS OPERATION (permanent until user removes this hint): There is no reason for Archon to escalate to the user. It should always find the best path, think about all possibilities, and make the correct decision. In some cases refactoring may be a good option to a dead-end.
- [2026-05-31T00:00:00Z] PARALLELISM VIA FILE SPLITTING: Use more parallelism by dividing files with many theorems or lemmas into smaller, semantically relevant files that can work with parallel provers.
- [2026-06-23T00:00:00Z] ROUTE C PAUSE — now enforced by DELETION (supersedes the 2026-05-28 hint). The genus-0 lane was removed entirely on 2026-06-23: `genusZeroWitness`/`positiveGenusWitness` collapsed into the single uniform Pic⁰ witness `picardJacobianWitness`, and the files H1Vanishing/RRFormula/OCofP/OcOfD/RationalCurveIso/BareScheme/GmScaling/RigidityKbar/AbelianVarietyRigidity/Rigidity/Differentials/Cotangent/*/Genus0BaseObjects/* were deleted; the genus-0 `RiemannRoch` subproject is renamed `RiemannRoch-[obsolete]`. No genus-0 / Route-C work remains to pause. Standing intent unchanged: all prover capacity on Route A (FGA Pic⁰ representability). KEPT general material: `RigidityLemma.lean` (Milne §I.1) and general `WeilDivisor.lean`. See `memory/genus-split-removed-uniform-pic0.md`.
- [2026-05-29T00:00:00Z] PRIMARY GOAL — Pic_{C/k} representability (A.2.c): The primary near-term proof objective is a complete proof of Pic_{C/k} representability. Prove all dependencies bottom-up first, then close A.2.c itself. Do not dispatch work on A.3 or deeper gated layers before A.2.c is closed.
- [2026-05-28T00:00:00Z] REFERENCE-DRIVEN PROOFS: Every prover lane directive must cite the precise theorem/proposition number from the mathematical references (Kleiman "Picard schemes" FGA, Nitsure FGA chapter, Milne "Abelian Varieties", SGA 7, Stacks Project) corresponding to each declaration being proved. If a proof step cannot be directly traced to a reference, find the reference before dispatching the prover — do not improvise mathematical content without a reference anchor.

