# Directive — strategy-critic

Fresh-context review of the project strategy. Read ONLY these inputs (do not read iter sidecars,
task_pending/done, PROGRESS.md, or any per-iter narrative):

- `.archon/STRATEGY.md` (verbatim — the strategy under review).
- `references/summary.md` (the reference index).
- Blueprint chapter titles + one-line topics: list the `\chapter{...}`/`% archon:covers` headers of
  `blueprint/src/chapters/*.tex` (one line each) to see the decomposition's coverage. Do not read the
  chapter bodies in full.

## Project goal (one paragraph)
Prove `AlgebraicGeometry.cech_computes_higherDirectImage` (protected, frozen signature): for
`f : X ⟶ S` separated quasi-compact, `F` quasi-coherent, `𝒰` a finite affine open cover, the weak
isomorphism `Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)` under
`[HasInjectiveResolutions X.Modules]`. Zero `sorry` in the cone, kernel-only axioms, 0 project axioms.

## What changed in STRATEGY this iter (focus your review here)
1. The **02KG** row moved to `CLOSING` — its residual leaf `sectionCech_homology_exact_of_localizationAway`
   landed axiom-clean (route B, change-of-ring); only a mechanical discharge of the two unconditional tops
   remains.
2. A **new Mathlib gap** was added: a "complex of `X.Modules` exact iff stalkwise exact" reflection
   criterion, which is the gating infrastructure for `cechAugmented_exact` (P5a's augmented-resolution
   input on the chosen Route A). It is ~150–250 LOC of genuinely new infra.

## Questions for you
- Is **Route A** (acyclic-resolution comparison: augmented Čech complex is a resolution + termwise
  `f_*`-acyclic, fed to the abstract Leray lemma `rightDerivedIsoOfAcyclicResolution`) still the
  soundest route to the protected goal, given that its resolution input `cechAugmented_exact` now
  reveals a sizeable new Mathlib gap (stalkwise-exactness reflection)? Or does the size of that gap
  argue for an alternative resolution-exactness route (e.g. proving exactness on an affine basis via
  the already-built tilde/section machinery instead of stalks)?
- Is anything in the decomposition redundant or missing a prerequisite, judged against the Stacks
  sources (02KE/02KG comparison; 015E Leray acyclicity)?
- Any silent assumption or hallucinated dependency you can see from the strategy + reference index?

Return SOUND / CHALLENGE / REJECT with specifics. If you CHALLENGE the Route-A resolution-input plan,
name the alternative concretely.
