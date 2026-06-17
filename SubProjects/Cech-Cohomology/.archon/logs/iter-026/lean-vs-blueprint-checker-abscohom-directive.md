# lean-vs-blueprint-checker directive — iter-026

Bidirectional verification of ONE Lean file against its blueprint chapter.

## Lean file
`/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/AbsoluteCohomology.lean`

## Blueprint chapter
`/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
(this consolidated chapter declares `% archon:covers ... AbsoluteCohomology.lean`; the
relevant section is "Absolute sheaf cohomology as Ext of the corepresenting object",
roughly from `\section{Absolute sheaf cohomology...}` onward — blocks `def:jshriek_ou`,
`lem:jshriek_corepr`, `def:absolute_cohomology`, and the five Ext `\mathlibok` anchors
`lem:ext_bifunctor_mathlib`, `lem:hasext_standard_mathlib`, `lem:ext_homequiv_zero_mathlib`,
`lem:ext_eq_zero_of_injective_mathlib`, `lem:ext_covariant_les_mathlib`).

## What to verify
1. **Lean → blueprint**: do the 10 Lean declarations match the blueprint statements?
   In particular: is `absoluteCohomology := AddCommGrpCat.of (Ext (jShriekOU U) F p)`
   faithful to `def:absolute_cohomology`? Are the three covariant-exact wrappers and the
   injective-vanishing theorem faithful realizations of the LES / injective-vanishing the
   blueprint cites? Is `jShriekOU = sheafify(free(yoneda U))` matching `def:jshriek_ou`?
2. **blueprint → Lean**: does the blueprint over-claim anything the Lean does not deliver
   (e.g. naturality of the LES wrappers, the H⁰≅Γ clause)? Is the chapter detailed enough
   that the formalization was well-guided, or did the Lean have to invent structure the
   prose omits?
3. Flag any fake/placeholder statements, signature mismatches with `\lean{}` pins, or
   `\mathlibok` anchors whose named Mathlib decl does not exist / has a different signature.

Report to your task_results file.
