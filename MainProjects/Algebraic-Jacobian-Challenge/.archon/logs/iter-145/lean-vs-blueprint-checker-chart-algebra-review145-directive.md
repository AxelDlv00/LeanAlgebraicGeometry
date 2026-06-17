# Lean ↔ Blueprint Checker Directive

## Slug
chart-algebra-review145

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cotangent/ChartAlgebra.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/RigidityKbar.tex

(The chart-algebra piece-(ii) first-class blocks were added iter-145 inside
this chapter at the new subsection `\subsection{Chart-algebra piece (ii)
first-class decomposition}`. Focus your verification window on that
subsection; the rest of the chapter has separate prover-traceability
checks that have already run iter-143/144.)

## Known issues
- The Lean file is brand-new iter-145 with **intentional `: True := sorry`
  placeholders** on all five declarations. The iter-145 refactor directive
  explicitly authorised this shape, citing the iter-128–iter-131 cotangent
  body-shape refactor as a cautionary tale on committing wrong signatures
  prematurely. The blueprint chapter, by contrast, has FULL informal
  signatures and 3–5-step proof sketches per block. This means the
  Lean ↔ blueprint signature mismatch on each block is EXPECTED in
  iter-145 and is NOT a must-fix finding — flag it informationally so
  the iter-146 prover lane is on notice. Do classify the mismatch as
  critical IF the in-file `TODO iter-146: real signature; placeholder
  is `: True`.` annotations are missing or misleading.
- The blueprint chapter cross-references `\thm:GrpObj_eq_of_eqOnOpen`
  (Rigidity.tex), `\thm:Scheme_AffineCoverMVSquare_HModule_prime_sequence_exact`
  (Cohomology_MayerVietoris.tex), and `\def:relative_kaehler_presheaf`
  (Differentials.tex). Verify the `\uses{...}` cross-references resolve
  (the iter-145 blueprint-writer report claims they do; second-pass
  confirmation desired).

Write your report per the descriptor's template, with explicit weight on
the bidirectional audit:
(A) Lean → blueprint: are the five `\lean{...}` target names landed
    in the Lean file at the right namespace? Are the `TODO iter-146`
    annotations honest and present on every placeholder?
(B) Blueprint → Lean: do the five first-class blocks have detailed
    enough proof sketches for an iter-146+ prover to formalize without
    further informal-prose expansion? Specifically: is the
    `\thm:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero` Char-p
    Frobenius-iteration sketch concrete enough at the prose level, or
    will it require another writer dispatch before iter-146 prover lane?
