# Lean ↔ blueprint check — DualInverse (dual_restrict_iso Step-4)

Verify bidirectionally:

- Lean file: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`
- Blueprint chapter: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex`
  (this chapter `% archon:covers` DualInverse.lean)

Focus on `dual_restrict_iso` Step-4 and the new helper `sliceDualTransport` (~L171,
typed `sorry` body with an in-file construction plan). This iter the prover
decomposed the single Step-4 residual `sorry` into (i) the `sliceDualTransport`
sectionwise body and (ii) the `dual_restrict_iso` assembly naturality, wiring the
Step-4 assembly through `sliceDualTransport` (per-V app verified to typecheck).

Report:
(a) Lean → blueprint: does the chapter sketch for `dual_restrict_iso` Step-4 match the
    Lean route (the `sliceDualTransport` leg-(A)∘leg-(B) sectionwise construction)?
    Is the chapter's Step-4 leg(A)/leg(B) description still aligned with the Lean H1
    approach, or stale?
(b) blueprint → Lean: is the chapter detailed enough on the `sliceDualTransport`
    sectionwise dual-transport (component reindex across `f.opensFunctor` +
    `f.appIso` ring iso; presheaf shadow of `restrictScalarsRingIsoDualEquiv`), or
    too thin to guide the ~200-LOC body?

Flag must-fix-this-iter findings. Report to your task_results file.
