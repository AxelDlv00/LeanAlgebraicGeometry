# Lean ↔ blueprint check — iter-251 — TensorObjSubstrate.lean

Verify exactly one Lean file against its blueprint chapter, bidirectionally.

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex
(This consolidated chapter `% archon:covers` TensorObjSubstrate.lean among others.)

## What changed this iter (the D1′ comparison-naturality lane)
- New closed helpers: `pullbackValIso_hom_natural` (axiom-clean), `sheafifyTensorUnitIso_hom_eq` (rfl).
- Authored + PARTIAL (one typed `sorry` each): `sheafifyTensorUnitIso_hom_natural`,
  `pullbackTensorMap_natural` (the D1′ target, `lem:pullback_tensor_map_natural` or similar).
- D3′/D4′ NOT started.

## Report
- Whether the D1′ target statement `pullbackTensorMap_natural` matches its `\lean{...}` block
  and blueprint statement (signature faithful, not a placeholder/weakened form).
- Whether the chapter gives enough proof detail to guide the D1′ 4-square paste, or whether the
  blueprint is too thin (the prover reduced one helper to a single whisker identity blocked on a
  carrier-normalisation — is that step blueprinted?).
- Any `\lean{...}` hint pointing at a renamed/nonexistent decl.
- Whether the new helpers (`pullbackValIso_hom_natural`, `sheafifyTensorUnitIso_hom_eq`) need
  blueprint pinning or are correctly project-local supplements.
