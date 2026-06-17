# Lean ↔ blueprint check — CechHigherDirectImage (iter-265)

Lean file: /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean
Blueprint chapter: /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

This iter the prover added one axiom-clean helper `pushPull_unit_mate` (the
mate-calculus core of the push–pull functor pentagon) but did NOT add the
assigned pentagon law `pushPullMap_comp` — it is blocked by a kernel whnf wall.
Check bidirectionally:
- Does the chapter's `lem:push_pull_functor` (and any pinned `\lean{}`) match what
  actually exists in the Lean file? Flag any `\lean{}` pin naming a decl that is
  absent (only in a comment), or any statement-block over-marking.
- Is the chapter detailed enough to guide the eventual `pushPullMap_comp` proof,
  or is it too thin (does it specify the pentagon / the transport-light
  reformulation the prover says is needed)?
Report Lean→blueprint AND blueprint→Lean, with any must-fix-this-iter findings.
