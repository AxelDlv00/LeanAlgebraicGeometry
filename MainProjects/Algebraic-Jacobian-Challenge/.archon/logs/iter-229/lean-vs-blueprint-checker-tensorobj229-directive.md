# Directive — lean-vs-blueprint-checker (iter-229)

Verify ONE Lean file against ONE blueprint chapter, bidirectionally.

## Lean file
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

## Blueprint chapter
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## Focus — the iter-229 additions only (do not re-audit the whole file)
This iter added a project-local Mathlib supplement: the open-immersion ↔ slice
sheaf-site equivalence (completing the Mathlib TODO at `Topology/Sheaves/Over.lean:19-22`).
The new declarations live near the END of the Lean file (after `end AlgebraicGeometry`,
in a `section OverSliceSheafEquiv` inside `namespace AlgebraicGeometry.Scheme.Modules`),
approximately lines 2250–2300:

- `AlgebraicGeometry.Scheme.Modules.overSliceSheafEquiv` — the sheaf-site equivalence
  `Sheaf ((Opens.grothendieckTopology X).over U) A ≌ Sheaf (Opens.grothendieckTopology ↥U) A`,
  built via `CategoryTheory.Equivalence.sheafCongr` on `TopologicalSpace.Opens.overEquivalence U`.
- `AlgebraicGeometry.Scheme.Modules.overEquivInverseIsDenseSubsite` — the supporting
  `Functor.IsDenseSubsite` instance.
- the pointwise cover-correspondence lemma underlying that instance (a sieve is a covering
  in the slice site iff its functor-pushforward image is a covering in the open-immersion
  site).

The matching blueprint block is `lem:open_immersion_slice_sheaf_equiv` (added by the
iter-229 blueprint-writer round), in `Picard_TensorObjSubstrate.tex`.

## What to report (bidirectional)
1. Lean → blueprint: do the new Lean declarations match the blueprint block's statement
   (signature, the `Sheaf … ≌ Sheaf …` shape, the value-category-parametric `A`)? Any
   fake/placeholder/over-claimed statements? Is the `\lean{...}` pin name correct?
2. Blueprint → Lean: is `lem:open_immersion_slice_sheaf_equiv` detailed enough to have
   guided this formalization, or too thin? Are its `\uses{}` targets defined?
3. Any must-fix-this-iter discrepancy (name mismatch, signature drift, missing pin).

Report only on this file/chapter pair. Write your report to your task_results file.
