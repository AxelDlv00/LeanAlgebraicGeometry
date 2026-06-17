# Directive: lean-vs-blueprint-checker (FBC, iter-030)

## Files to audit (exactly one Lean file + its blueprint chapter)
- Lean: `/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- Blueprint: `/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

## Context (what changed this iter)
The prover targeted `base_change_mate_fstar_reindex_legs` (sorry @ ~1461). It added ONE new
compiling, axiom-clean helper lemma
`AlgebraicGeometry.base_change_mate_fstar_reindex_legs_link_distributeCollapse` (@ ~1333) and
spliced it into the locked `_legs` goal in term mode (`refine (congrArg … link_distributeCollapse …).trans ?_`),
leaving the residual eCancel telescoping as `sorry`. Net sorry count FBC 4→4.

NOTE FOR YOUR CHECK: the iter-030 blueprint (via an effort-breaker) decomposed
`lem:base_change_mate_fstar_reindex_legs` into FIVE `\uses`-linked link sub-lemmas with these
`\lean{}` pins (search the chapter):
  - `..._legs_link_distribute`
  - `..._legs_link_collapseComp`
  - `..._legs_link_cancelEUnit`
  - `..._legs_link_cancelPullbackComp`
  - `..._legs_link_survivor`
The prover did NOT build those five; it built a single fused helper `..._legs_link_distributeCollapse`
(≈ distribute + collapseComp fused). Assess: (a) do the blueprint's five `\lean{}` pins resolve to
real Lean declarations, or are they dangling? (b) is the single fused Lean helper an honest
realization of the blueprint's decomposition, or a blueprint↔Lean correspondence mismatch the
planner must reconcile? (c) any fake/placeholder/over-claimed statements, signature mismatches with
`\lean{}` pins, or `\leanok` on sorry-bearing blocks beyond the authorized 4 sorries
(`_legs`@1461, `gstar_transpose`@1833, affine@2014, FBC-B@2036)?

## Output
Per-declaration bidirectional check (Lean→blueprint AND blueprint→Lean), red-flags block, blueprint
adequacy assessment, severity summary. Report must be self-contained.
