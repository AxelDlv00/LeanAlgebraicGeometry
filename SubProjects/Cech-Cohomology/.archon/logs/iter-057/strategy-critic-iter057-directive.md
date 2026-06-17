# Strategy-critic directive — iter-057

Give a fresh-eyes verdict on the project strategy. Read ONLY the inputs named below; do NOT read any
iter sidecars, task results, PROGRESS.md, or review narrative.

## Inputs to read
- `/home/archon/proj/Cech-Cohomology/.archon/STRATEGY.md` (verbatim — the strategy under review).
- `/home/archon/proj/Cech-Cohomology/references/summary.md` (the reference index).
- Blueprint chapter titles/topics (3 chapters under `blueprint/src/chapters/`):
  - `Cohomology_AcyclicResolution.tex` — "Acyclic resolutions compute right-derived functors" (Leray 015E).
  - `Cohomology_CechHigherDirectImage.tex` — the consolidated chapter: Čech nerve/complex, push–pull
    functor, absolute cohomology = Ext of corepresenting object `jShriekOU` (Form B), 01EO basis
    comparison, 02KG affine Serre vanishing, 01I8 `F≅~ΓF`, the augmented-Čech resolution
    `cechAugmented_exact`, and the open-immersion acyclicity two-need split.
  - `Cohomology_HigherDirectImage.tex` — "Higher direct images R^i f_* of quasi-coherent sheaves".

## Project goal (one paragraph)
Prove `AlgebraicGeometry.cech_computes_higherDirectImage` (`lem:cech_computes_cohomology`): for
`f : X ⟶ S` separated quasi-compact, `F` quasi-coherent, `𝒰` a finite affine open cover, an iso
`(CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F` under `[HasInjectiveResolutions X.Modules]`.
The chosen route is Route A (acyclic-resolution comparison via the abstract Leray lemma P4).

## Focus questions for this iter
1. Route A requires (i) the augmented Čech complex is a resolution of F (`cechAugmented_exact`), and
   (ii) termwise f_*-acyclicity (open-immersion acyclicity). Both have now bottomed out at genuine
   multi-iter builds: (i) a missing-Mathlib scheme-level coproduct/fibre-product distribution (Sub-brick A
   degreewise section iso); (ii) a change-of-ring "section Čech vanishing for a cover of a GENERAL affine
   open V (V≅SpecΓ(V), Γ(V) not a localization of R)" seed. Are these the genuinely irreducible
   foundations of Route A, or is there a cheaper path the strategy is missing?
2. Is there hidden circularity? The open-immersion acyclicity (ii) reduces to general-affine-open Serre
   vanishing via `cech_eq_cohomology_of_basis` (01EO), whose condition (3) is the change-of-ring Čech seed.
   Does any step covertly depend on the main theorem or on f_*-acyclicity itself?
3. The whole-scheme isoSpec Ext transport (Need#1) is carried as a TODO. Is transporting an AMBIENT Ext
   `Ext^q_{(Spec R).Modules}(jShriekOU V, H)` along V≅SpecΓ(V) sound, given the iter-056 finding that the
   OPEN-SUBSCHEME transport `j⁻¹V≅SpecΓ(j⁻¹V)` is the restriction-of-injectives wall? (Note: the project
   routes the seed through the concrete SECTION Čech complex specifically to avoid ambient-Ext transport.)

Per the descriptor: any CHALLENGE/REJECT must be addressed in STRATEGY.md or explicitly rebutted by the
planner. Keep the view fresh — challenge sunk cost.
