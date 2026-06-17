# Blueprint Reviewer — iter-009 (whole-blueprint audit)

Perform your standard whole-blueprint audit. Read every chapter under
`blueprint/src/chapters/` and produce your per-chapter completeness + correctness
checklist plus the unstarted-phase proposals section.

## Context for prioritisation (not a scope limit — audit the WHOLE blueprint)

The project's sole goal is `lem:cech_computes_cohomology`
(`AlgebraicGeometry.cech_computes_higherDirectImage`) and its dependency cone.

Two chapters matter most for this iter's gate decision:

1. **`Cohomology_AcyclicResolution.tex`** (covers `AcyclicResolution.lean`) — the P4
   abstract comparison theorem. It is the **active prover lane this iter**. The file has
   0 sorry; 3 of 5 target leaves are formalized. The remaining 2 leaves
   (`lem:acyclic_one_iso_coker` and the assembly `lem:acyclic_resolution_computes_derived`)
   are about to be dispatched to a prover. **I need a current HARD-GATE verdict on this
   chapter**: is it complete + correct, with the two remaining frontier-leaf blocks
   carrying adequate, sourced informal proofs that a prover can formalize directly?
   (Note: Lean-level input-type encoding decisions — e.g. `QuasiIso` vs `ExactAt` family
   — are the prover's domain and live in PROGRESS.md hints, NOT the math-only blueprint;
   do not flag their absence from the blueprint as a defect.)

2. **`Cohomology_CechHigherDirectImage.tex`** (covers `CechHigherDirectImage.lean`) — the
   main-goal chapter and the P3/P5 cone. The project's chosen Route A is the
   acyclic-resolution / Cartan–Leray route with **NO spectral sequences**. However three
   of this chapter's proof sketches currently still invoke spectral sequences that are
   ABSENT from Mathlib:
   - `lem:cech_to_cohomology_on_basis` — uses a "Čech-to-derived-functor spectral
     sequence";
   - `lem:open_immersion_pushforward_comp` — uses the "relative Leray spectral sequence";
   - `lem:cech_term_pushforward_acyclic` — uses the "Grothendieck composition spectral
     sequence".
   These contradict Route A and must be rewritten to acyclic-resolution / basis-comparison
   arguments before the chapter's frontier leaves (`lem:cech_augmented_resolution`,
   `lem:higher_direct_image_presheaf`, `lem:cech_to_cohomology_on_basis`) can pass the
   gate for prover dispatch. **For this chapter I need**: a precise per-lemma verdict on
   which blocks are Route-A-clean vs spectral-sequence-contaminated, and for each
   contaminated block, whether a Route-A rewrite is feasible from the cited Stacks
   sources (01EO basis comparison; relative affine vanishing). This directly seeds a
   blueprint-writer directive.

3. `Cohomology_HigherDirectImage.tex` — audit and report its status (is it live in the
   cone, orphaned, or a thin pointer?).

Report per your descriptor. The per-chapter checklist and the
`## Unstarted-phase blueprint proposals` section are what I act on.
