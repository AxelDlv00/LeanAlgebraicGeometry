# Directive: lean-vs-blueprint check — SheafOverEquivalence

Verify ONE Lean file against ONE blueprint chapter, bidirectionally.

## Lean file
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/SheafOverEquivalence.lean`

## Blueprint chapter
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_SheafOverEquivalence.tex`

## What to check
This is a NEW shared-root file (iter-258). It constructs the modules-level lift of
`TopologicalSpace.Opens.overEquivalence U` as `Scheme.Modules.overEquivalence`
(an equivalence of sheaf-of-modules categories), plus consumer isos
`restrictOverIso`, `unitOverIso`, and the engine corollary `chartOverIso`.

Report bidirectionally:
- Lean → blueprint: do the Lean declarations (`overEquivalence`, `phiOver`, `psiOver`,
  `restrictOverIso`, `unitOverIso`, `chartOverIso`) match the chapter's `\lean{...}`
  pins and statements? Any fake/placeholder statements, signature mismatches?
- Blueprint → Lean: is the chapter detailed enough to guide the two OPEN sorries
  (`restrictOverIso` full body L235; `unitOverIso` 1 leaf L276)? Does the chapter give
  the pushforwardComp/pushforwardNatIso route for `restrictOverIso` and the
  `unitToPushforwardObjUnit` reflection route for `unitOverIso`?

`overEquivalence` is CLOSED axiom-clean. Flag any must-fix-this-iter blueprint inadequacy.
Write your report to your task_results file.
