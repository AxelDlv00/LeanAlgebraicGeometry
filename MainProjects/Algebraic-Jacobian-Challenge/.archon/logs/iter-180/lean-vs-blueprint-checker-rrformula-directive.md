# lean-vs-blueprint-checker — RRFormula.lean ↔ RiemannRoch_RRFormula.tex

## File pair

- **Lean**: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/RRFormula.lean`
- **Blueprint**: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/RiemannRoch_RRFormula.tex`

## What changed this iter (Lane E — iter-180)

- `Scheme.WeilDivisor.l_eq_degree_plus_one_of_genus_zero` body closed axiom-clean (modulo transitive sorryAx from upstream `eulerCharacteristic_eq_degree_plus_one_minus_genus`). 3-line proof: `have h := eulerCharacteristic_eq_degree_plus_one_minus_genus C D; simp only [Scheme.eulerCharacteristic, _hg, _hH1, Nat.cast_zero, sub_zero] at h; exact h`.
- File 3 → 2 sorries.

## Report bidirectionally

1. **Lean → blueprint**: does the chapter's `thm:riemannRoch_genus_zero` `\lean{...}` pin reference `l_eq_degree_plus_one_of_genus_zero`? Verify (the prover's task_result claims it does + carries `\leanok` on the statement block).
2. **Blueprint → Lean**: is the chapter detailed enough on the substantive upstream `eulerCharacteristic_eq_degree_plus_one_minus_genus` body for iter-181+ work (the next-smallest sorry)? Per task_result, the body is Hartshorne IV.1.3's inductive `D ↔ D + [P]` step.

Output to `task_results/lean-vs-blueprint-checker-rrformula.md`.
