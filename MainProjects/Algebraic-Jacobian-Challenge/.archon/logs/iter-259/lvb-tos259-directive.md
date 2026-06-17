# Lean ↔ blueprint check — TensorObjSubstrate (D3′ Sq2b)

Verify bidirectionally:

- Lean file: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint chapter: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

Context: this iter added two new declarations supporting D3′
(`pullbackTensorMap_restrict`, `lem:pullback_tensor_map_basechange`):
- `pullbackComp_δ` — the presheaf-level Sq2b (monoidality of `pullbackComp`), a
  ~90-line mate-calculus proof, PROVEN modulo the residual below.
- `pushforwardComp_lax_μ` — the genuine residual (typed `sorry`): the
  "pushforwardComp is monoidal" ModuleCat base-change coherence. The prover
  EMPIRICALLY REFUTED the earlier blueprint sketch (bw258-d3) that predicted this
  residual would be "rfl / short ext" — it is a ~150-LOC `extendScalars`/
  `restrictScalars` coherence.

Check:
1. Does the chapter's Sq2/Sq2b paragraph still claim the residual is rfl/trivial
   transport? If so, flag it as a must-fix (the Lean disproves it).
2. Are `pullbackComp_δ` and `pushforwardComp_lax_μ` represented in the chapter, or
   should the plan agent add `\lean{...}` hints / split the Sq2b paragraph?
3. Lean → blueprint and blueprint → Lean signature/statement fidelity for D3′.
4. Whether `pullbackTensorMap_restrict`'s statement matches the chapter (recall
   iter-257 found a statement-vs-Lean mismatch: base-change-square form vs the
   Lean general-composition form).

Report bidirectionally with must-fix-this-iter findings clearly flagged.
