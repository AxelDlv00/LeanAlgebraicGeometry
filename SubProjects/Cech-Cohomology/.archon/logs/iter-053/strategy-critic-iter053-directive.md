# Directive: strategy-critic (iter-053)

Provide a fresh-context soundness verdict on the project strategy. Read ONLY these inputs:

- `STRATEGY.md` (verbatim — read it).
- `references/summary.md` (the reference index).
- The blueprint chapter set (titles + topics):
  - `Cohomology_HigherDirectImage.tex` — Higher direct images `R^i f_*` of quasi-coherent sheaves (i≥1).
  - `Cohomology_AcyclicResolution.tex` — Acyclic resolutions compute right-derived functors (Leray, Stacks 015E).
  - `Cohomology_CechHigherDirectImage.tex` — consolidated chapter: Čech nerve/complex, the Čech↔derived
    bridge, absolute cohomology (Ext Form B), 01EO basis comparison, 02KG affine Serre vanishing,
    `cechAugmented_exact` (augmented Čech complex is a resolution), the open-immersion pushforward
    lemma, and the top comparison `cech_computes_higherDirectImage` (Route A).

Do NOT read: iter sidecars, task_pending/task_done, PROGRESS.md, recent prover/review reports.

## Project goal (one paragraph)
Prove `AlgebraicGeometry.cech_computes_higherDirectImage` (protected, frozen signature): for
`f : X ⟶ S` separated + quasi-compact, `F` quasi-coherent, `𝒰` a finite affine open cover, an
isomorphism `Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)` (under
`[HasInjectiveResolutions X.Modules]`). Route A: the augmented Čech complex is a termwise
`f_*`-acyclic resolution of `F`, and the P4 abstract acyclic-resolution lemma converts this to the
isomorphism. End-state: 0 inline sorry in the cone, 0 project axioms, kernel-only axioms.

## What changed since your last verdict (iter-052: SOUND; lone CHALLENGE on the stalk sub-route, addressed)
- 02KG affine Serre vanishing is now CLOSED (both `affine_serre_vanishing` +
  `affine_cech_vanishing_qcoh` unconditional, axiom-clean). Its row moves to `## Completed`.
- The `cechAugmented_exact` route remains the sections/sheafification route (no stalk functor),
  unchanged. The only new detail: the theorem must be PLACED in a downstream file (import-cycle
  finding), a Lean file-placement decision, not a route change.
- This iter activates two P5a targets: `cechAugmented_exact` (the resolution input) and
  `higherDirectImage_openImmersion_comp` (the open-immersion `f_*`-acyclicity consumer of
  `affine_serre_vanishing`).

## What to check
Is Route A (acyclic-resolution comparison) still the right spine now that 02KG is closed? Are the
remaining P5a/P5b phases (cechAugmented resolution → termwise acyclicity → comparison assembly)
correctly ordered and non-circular against the references? Flag any silent assumption, missing
prerequisite, or hidden circularity in the P5a→P5b arc. Confirm or CHALLENGE.
