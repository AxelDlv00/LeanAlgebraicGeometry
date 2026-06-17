# Lean ↔ blueprint check directive — iter-151

Bidirectionally verify ONE Lean file against its blueprint chapter:

- Lean file:
  `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cotangent/ChartAlgebra.lean`
- Blueprint chapter:
  `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/RigidityKbar.tex`
  (the KDM lemma `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`
  and its proof prose — the "Chart-algebra piece (ii)" subsection and the
  route-(C)/(BR.5′) decomposition (C.a)–(C.d). NOTE: a dedicated
  `..._ChartAlgebra.tex` chapter does NOT exist; the KDM prose lives in
  `RigidityKbar.tex`.)

## What to check

1. Lean → blueprint: the Lean theorem
   `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` carries a
   `sorry` and an inline comment claiming the statement is FALSE under its
   own hypotheses (two counterexamples). Does the blueprint statement
   match the Lean signature? Does the blueprint proof prose (which frames
   (C.d) as closable via (S5.a)/(S5.b)) contradict the Lean file's
   "false as stated" finding?
2. Blueprint → Lean: is the blueprint chapter adequate to guide a
   formalization here, or did it mis-guide the prover by asserting a
   false closure path? Are the review-added `% NOTE:` blocks (iter-151)
   sufficient to warn a future reader/prover?
3. Flag the missing dedicated chapter if you judge it a real problem.

Report bidirectionally with any must-fix-this-iter findings.
