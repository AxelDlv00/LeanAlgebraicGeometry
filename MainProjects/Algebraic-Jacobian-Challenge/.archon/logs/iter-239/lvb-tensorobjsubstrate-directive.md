# lean-vs-blueprint-checker directive — iter-239 — TensorObjSubstrate

Verify ONE Lean file against ONE blueprint chapter, bidirectionally.

- Lean file: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint chapter: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

Key context for this iter:
- The chapter section `sec:tensorobj_pullback_monoidality` defines three blocks
  `lem:pullback_tensor_iso`, `lem:pullback_unit_iso`, `lem:isinvertible_pullback` (pinning `pullbackTensorIso`
  / `pullbackUnitIso` / `IsInvertible.pullback`). **None of these three Lean declarations exist** — the prover
  found the dispatched route (sectionwise strong-monoidality via `(extendScalars f).Monoidal`) is
  STRUCTURALLY IMPOSSIBLE: `(Sheaf|Presheaf)OfModules.pullback` is an abstract left adjoint with no sectionwise
  formula. Report whether the chapter's proof sketches for these three blocks describe a route that can actually
  be formalized, or whether the chapter must be rewritten to reflect the abstract-pullback wall + the pivot
  (local-chart-finality via `isIso_of_isIso_restrict`, or a FLAT-restricted variant). This is a
  blueprint→Lean adequacy question and likely a must-fix for the next prover round.
- The prover DID land `sheafifyTensorUnitIso` (private decl, ~L884) — it is NOT `\lean{}`-pinned and is a
  reusable internal brick; confirm no marker/pin action is needed for it.
- The two pre-existing sorries (`exists_tensorObj_inverse` ~L715, PicSharp scaffold ~L1005) are untouched.

Report bidirectionally and mark any must-fix-this-iter finding explicitly (especially: does
`sec:tensorobj_pullback_monoidality` describe a formalizable route?). Write to
`task_results/lean-vs-blueprint-checker-tensorobjsubstrate.md`.
