# Lean ↔ blueprint check — TensorObjSubstrate (D3′)

Verify bidirectionally:

- Lean file: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint chapter: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

Focus on D3′ `pullbackTensorMap_restrict` (blueprint `lem:pullback_tensor_map_basechange`).
This iter the prover: closed a NEW standalone helper `toRingCatSheafHom_comp_hom_reconcile`
by `rfl` (and found the Sq2 ring-map reconciliation the blueprint flags as
"non-trivial transport" is in fact DEFINITIONAL); left `pullbackTensorMap_restrict`
as a typed `sorry` with an in-proof ROADMAP; the real Sq2 content ("Sq2b" =
monoidality of `PresheafOfModules.pullbackComp`) is Mathlib-absent.

Report:
(a) Lean → blueprint: does the chapter statement of `lem:pullback_tensor_map_basechange`
    match the Lean signature (general composition coherence vs base-change-square form)?
    Does the chapter's proof sketch still claim the Sq2 reconcile is "non-trivial
    transport" (now disproven — it is `rfl`)? Any other stale/divergent sketch?
(b) blueprint → Lean: is the chapter detailed enough on the Sq2b `pullbackComp`
    monoidality / mate-calculus route (mirroring `Adjunction.isMonoidal_comp`), or
    is the sketch too thin to guide the genuinely-Mathlib-absent step?

Flag must-fix-this-iter findings. Report to your task_results file.
