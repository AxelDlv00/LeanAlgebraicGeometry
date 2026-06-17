# lean-vs-blueprint-checker — WeilDivisor (iter-202)

Bidirectionally verify ONE Lean file against its blueprint chapter.

- Lean file: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`
- Blueprint chapter: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/RiemannRoch_WeilDivisor.tex`

## Focus this iter

The prover (Sub-build 3) added 2 axiom-clean declarations:
`Scheme.PrimeDivisor.functionFieldIso_compat` (lines ~572-592) and
`Scheme.PrimeDivisor.order_eq_order_restrict` (lines ~594-621). Both are
sorry-free. The prover reports the chapter's §3-Sub-build-3 prose
(lines ~441-464) describes this work but has NO `\lean{...}`-pinned
environment for the two new declarations — recommend the plan agent add
`\begin{lemma}…\lean{...}` blocks so sync_leanok can mark them.

Report bidirectionally:
1. Lean → blueprint: are the 2 new declarations faithful to the blueprint?
   Any over-weak statement?
2. Blueprint → Lean: confirm the missing `\lean{...}` pins for
   `functionFieldIso_compat` and `order_eq_order_restrict` (this is a
   blueprint-side gap the plan agent should fill). Is any other Sub-build-3
   prose now stale? Flag the USER-blocked / Route-C-paused sorries only if the
   chapter misrepresents their status.

Flag must-fix items with severity. Write your report to task_results.
