# lean-vs-blueprint-checker — CechHigherDirectImage (iter-262)

Bidirectional check of ONE Lean file against ONE blueprint chapter.

- Lean file: `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`
- Blueprint chapter: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

This iter the prover added `coverArrow`, `coverCechNerve`,
`relativeCechComplexOfNerve` (all axiom-clean) and rewrote `CechComplex` to a
genuine body (defined via the nerve), reducing sorries 5→4 (remaining: CechNerve
L97, CechAcyclic.affine L214, cech_computes_higherDirectImage L251,
cech_flatBaseChange L313). Report:
(a) whether the Lean decls follow the blueprint statements (`\lean{...}` names
    resolve; signatures match; no placeholder/fake statements — esp. that
    `CechComplex`'s new body is a real reduction not a disguised sorry),
(b) whether the chapter is adequate to guide the remaining `CechNerve` push-pull
    functor `G` build (the documented `eqToHom`-along-Over-triangle +
    pushforwardComp/pullbackComp coherence wall) and the three downstream theorems,
    or is too thin / has broken `\uses`.

Read only the two files named. Absolute paths:
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
