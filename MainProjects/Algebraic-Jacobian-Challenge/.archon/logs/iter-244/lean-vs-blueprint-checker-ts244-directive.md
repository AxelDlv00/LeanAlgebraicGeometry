# lean-vs-blueprint-checker directive — iter-244

Verify exactly one file against its blueprint chapter, bidirectionally.

- Lean file: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint chapter: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## What changed this iter (the new content to check most carefully)

The prover landed "D1" of the general strong-monoidal pullback build
(`sec:tensorobj_pullback_monoidality`): 7 axiom-clean declarations realising
`lem:pullback_lan_decomposition` (L2862 in the chapter). The key Lean decl is
`AlgebraicGeometry.Scheme.Modules.pullbackLanDecomposition`, with carriers
`extendScalars`, `pullback0`, and their adjunctions.

Check specifically:
- Does the Lean `pullbackLanDecomposition` statement match the blueprint
  `lem:pullback_lan_decomposition` (the iso `pullback φ ≅ extendScalars φ ⋙ pullback0`)?
- The chapter now carries `\lean{AlgebraicGeometry.Scheme.Modules.pullbackLanDecomposition}`
  on that lemma (added by review this iter) — confirm the name resolves to the actual decl.
- Are the downstream still-absent lemmas (`lem:pullback0_tensor_iso` /
  `pullback0TensorIso`, `lem:pullback_tensor_iso` / `pullbackTensorIso`,
  `lem:isinvertible_pullback`) correctly UN-pinned-or-pinned-but-absent, i.e. no
  `\lean{}` pin pointing at a decl that does not exist in the file?
- Is the blueprint detailed enough to guide the D2/D3 build the prover handed off,
  or is any chapter section too thin?
- Any signature mismatch, fake/placeholder statement, or `\lean{}` pin pointing at a
  renamed/missing declaration.

Report bidirectionally (Lean → blueprint AND blueprint → Lean) with must-fix flags.
