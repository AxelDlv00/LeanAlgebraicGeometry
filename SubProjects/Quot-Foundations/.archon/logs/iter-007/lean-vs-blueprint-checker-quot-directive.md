# Directive — lean-vs-blueprint-checker (QuotScheme, iter-007)

Bidirectional verification of exactly one Lean file against its blueprint chapter.

## Lean file
`/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean`

## Blueprint chapter
`/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_QuotScheme.tex`

## What changed this iter
Two new declarations were added (both axiom-clean, no sorry):
1. `AlgebraicGeometry.SheafOfModules.IsLocallyFreeOfRank` (def) — predicate matching
   `def:is_locally_free_of_rank`. Existence of an open cover `U : ι → X.Opens`,
   `⨆ U i = ⊤`, with each `M|_{U i}` (pullback along `(U i).ι`) isomorphic to
   `SheafOfModules.free (ULift (Fin d))`.
2. `Module.annihilator_isLocalizedModule_eq_map` (theorem) — `Ann(S⁻¹M) = (Ann M)·S⁻¹R`
   for finitely generated `M`. This is a NEW project-local engine lemma with **no
   blueprint block yet** (it is an unmatched `lean_aux`); flag the coverage gap.

Two planner targets were left BLOCKED (no Lean added): `def:modules_annihilator`
(missing QCoh→IsLocalizedModule bridge) and `def:sectionGradedRing` (no tensor/monoidal
structure on SheafOfModules in Mathlib). I added `% NOTE:` annotations to both blocks
this iter.

## Report
(a) Lean → blueprint: does `IsLocallyFreeOfRank` faithfully encode
`def:is_locally_free_of_rank`? Is the predicate substantive (not vacuously
true/false)? Does the new engine theorem's statement match standard
annihilator-localization (no weakened hypotheses making it vacuous)? Is the
signature consistent with the `\lean{...}` hints?
(b) Blueprint → Lean: is `def:is_locally_free_of_rank` detailed enough to have guided
the Lean predicate? Is the missing blueprint block for
`Module.annihilator_isLocalizedModule_eq_map` a coverage gap the planner must fill?
Flag any must-fix-this-iter findings on either side.
