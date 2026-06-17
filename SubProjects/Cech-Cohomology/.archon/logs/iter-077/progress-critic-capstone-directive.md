# Progress-Critic Directive — iter-077

Assess convergence of the single active route below. Verdict per route.

## Route: P5b capstone — Route-A acyclic-resolution comparison (the project's final theorem)

Files: `CechToHigherDirectImage.lean` (new this iter) + upstream P5a/P5b ingredients (all 0-sorry).
Strategy estimate: `Iters left ~2–3`; route entered its current (assembly) phase ~iter-066.

### Last-5-iter signals (sorry counts are project-wide inline `sorry` in the cone)

- **iter-073**: 0 prover edits landed (tooling outage — 2475-LOC CSI monolith OOM-killed inline `lake`).
  Status: INCOMPLETE (no edits). Helpers added: 0.
- **iter-074**: CSI route sorry 2→1 (closed `backboneIncl_proj`). Refactor: split CSI monolith into 3
  files (forced by OOM). Status: PARTIAL (1 closed, 1 partial). Helpers added: ~2 (abstract-context
  reassoc lemmas).
- **iter-075**: CSI route 1→0 (closed last leaf `pushPull_interLegHom_sections`). Status: COMPLETE.
  Helpers added: 0.
- **iter-076**: closed `cechAugmented_exact`/`hSec` (P5a-resolution glue) via a 1-lemma consumer wrapper.
  Project-wide inline sorry 2→1. Status: COMPLETE. Helpers added: 1 (`cechSection_isZero_homology`).
- **iter-077 (proposed now)**: discovered the FROZEN target `cech_computes_higherDirectImage` is FALSE
  as signed (general non-affine `OpenCover`; single-element-cover counterexample). Built a correctly-
  stated sibling `cech_computes_higherDirectImage_of_affineCover` in a NEW leaf with the right hyps,
  decomposed into 5 `sorry` lemmas (1 deep acyclicity + 4 moderate seams/assembly). No prover has run
  on them yet. Recurring blocker phrases: "build wall / exit-137 on heavy modules" (074, 076).

### This iter's proposed `## Current Objectives` (2 files, split for parallelism)
1. `CechTermAcyclic.lean` — `rightAcyclic_finite_prod`, `cechTerm_pushforward_acyclic` (deep lane).
2. `CechToHigherDirectImage.lean` — `pushforward_mapHomologicalComplex_cechComplexOnX`,
   `cechAugmented_to_acyclicResolutionInput`, `cech_computes_higherDirectImage_of_affineCover`.

### Question
Is this route CONVERGING, or is the steady "close one bottleneck, open the next decomposition" pattern
actually churning/stuck? Is the 5-sorry capstone decomposition a genuine path to closure or a fresh
helper-sprawl? Flag if the new-file decomposition repeats a prior non-converging pattern.
