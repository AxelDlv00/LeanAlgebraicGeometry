# Lean-vs-blueprint check

Verify ONE Lean file against its blueprint chapter, bidirectionally.

## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean

## Blueprint chapter (consolidated; declares `% archon:covers` for this file)
/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

Focus on the blocks relevant to `OpenImmersionPushforward.lean`: the open-immersion pushforward
lemmas `higherDirectImage_openImmersion_acyclic` and `higherDirectImage_openImmersion_comp`
(and `lem:open_immersion_pushforward_comp` / related labels) plus
`isAffineHom_of_affine_separated`.

## What to check
- Does the Lean follow the blueprint? Fake/placeholder statements, signature mismatches, vacuous
  reformulations?
- This iter the prover: (a) re-signed `higherDirectImage_openImmersion_comp` from
  `Nonempty (A ≅ B)` to canonical `A ≅ B` (now a `noncomputable def`) per the planner directive D2 —
  confirm this now MATCHES the blueprint (the blueprint claims a canonical `≅`);
  (b) wired the `_acyclic` reduction down to a single residual sorry (line ~224)
  `IsZero (((pushforwardSectionsFunctor j W).rightDerived q).obj H)` for affine `W`, `q>0` (Serre
  vanishing on `j⁻¹W`) — confirm this residual matches the blueprint's intended leaf;
  (c) `_comp` body still `sorry` (line ~290), depends on `_acyclic`.
- New non-private helpers needing blueprint coverage: `pushforwardSectionsFunctor`,
  `pushforwardSectionsFunctor_additive`,
  `CategoryTheory.GrothendieckTopology.isZero_presheafToSheaf_of_sections_locally_zero`,
  `CategoryTheory.Functor.isZero_of_faithful_preservesZeroMorphisms` (a copy of the
  CechAugmentedResolution helper — note the duplicate). Report which lack a `\lean{}` block.
- Is the blueprint adequate to guide the remaining `_acyclic`/`_comp` work, or too thin?

## Output
Bidirectional report with must-fix-this-iter items called out.
