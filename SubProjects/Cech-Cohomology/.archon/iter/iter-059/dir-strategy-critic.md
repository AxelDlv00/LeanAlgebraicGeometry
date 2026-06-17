# Strategy-critic directive — iter-059

Review the project strategy with fresh eyes. A milestone just landed: **Need#2 (general-affine-open
Serre vanishing) is CLOSED axiom-clean**, so the strategy now commits to **Need#1 (whole-scheme
`U≅SpecΓU` Ext transport of jShriekOU)** as the dominant remaining wall for the open-immersion
acyclicity. The question I most want challenged: is Need#1 the right route to discharge the
open-immersion `_acyclic` leaf, or is there a structurally simpler discharge?

## Context to read (and ONLY this)
- `/home/archon/proj/Cech-Cohomology/.archon/STRATEGY.md` (verbatim — read it fully).
- `/home/archon/proj/Cech-Cohomology/references/summary.md` (reference index).

## Blueprint chapters (titles + one-line topic)
- `Cohomology_HigherDirectImage.tex` — the protected target `cech_computes_higherDirectImage` and its statement-level scaffold.
- `Cohomology_AcyclicResolution.tex` — P4 Leray acyclic-resolution lemma (Stacks 015E): an acyclic resolution computes RF.
- `Cohomology_CechHigherDirectImage.tex` — the consolidated working chapter (covers 15 Lean files): Čech nerve/complex, the absolute-cohomology Form-B realization (`H^p = Ext^p(jShriekOU U,-)`), the 01EO basis comparison, 02KG affine Serre vanishing (⊤ + general-affine), 01I8 `F≅~ΓF`, the augmented-Čech resolution (Sub-brick A), and the open-immersion acyclicity (Need#1/Need#2).

## Project goal (one paragraph)
Prove `AlgebraicGeometry.cech_computes_higherDirectImage` (frozen signature): for `f : X ⟶ S`
separated and quasi-compact, `F` quasi-coherent, `𝒰` a finite affine open cover, an isomorphism
`Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)` under
`[HasInjectiveResolutions X.Modules]`, via Route A (the augmented Čech complex is an acyclic
resolution + the P4 abstract lemma). Zero inline sorry in the cone, kernel-only axioms.

## What to challenge
- Is Need#1 (transport STANDALONE `Ext_{U.Modules}` along the module-category equivalence
  `U.Modules ≌ (SpecΓU).Modules` via `Ext.mapExt_bijective`, then apply Need#2 on `SpecΓU`) the
  soundest discharge of the open-immersion acyclicity leaf, or is there a simpler one that avoids the
  scheme-iso transport entirely?
- Are the two remaining ACTIVE phases (P5a-resolution Sub-brick A; P5a-consumer Need#1) genuinely
  independent and both necessary for the protected goal, or does one subsume the other?
- Any silent assumption / circularity risk in the Route-A decomposition you can see from the strategy text?
