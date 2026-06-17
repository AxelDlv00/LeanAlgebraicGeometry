# Lean ↔ blueprint check — AcyclicResolution

Verify bidirectionally that the Lean file follows its blueprint chapter and that
the chapter is detailed enough to guide the formalization.

- Lean file: `/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/AcyclicResolution.lean`
- Blueprint chapter: `/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_AcyclicResolution.tex`

Focus on the two declarations proved this iter and their blocks:
- `CategoryTheory.Functor.rightDerivedOneIsoCokerOfAcyclic` ↔ `lem:acyclic_one_iso_coker`
- `CategoryTheory.Functor.rightDerivedIsoOfAcyclicResolution` ↔ `lem:acyclic_resolution_computes_derived`

Report:
(a) Lean → blueprint: any fake/placeholder statements, signature mismatches with
    the `\lean{}`-named decls, or over-claiming `\leanok` blocks.
(b) Blueprint → Lean: whether each block's informal statement and hypotheses
    match the actual Lean signature (e.g. the TARGET-3 input encoding
    `e : A ≅ K.cycles 0`, `hexact : ∀ n, K.ExactAt (n+1)`,
    `[∀ n, G.IsRightAcyclic (K.X n)]`), and whether any block is too thin.

Note any must-fix-this-iter findings explicitly.
