# lean-vs-blueprint-checker — SectionGradedRing iter-056

Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/SectionGradedRing.lean
Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_SectionGradedRing.tex

Verify bidirectionally. Pay attention to:
- New `relTensorTriplePresheaf` (the domain row triple-tensor presheaf) — is it blueprinted? (likely lean_aux; flag for coverage as a sibling of `def:relTensorDomainPresheaf`).
- The `relTensorActL` action nat-trans is NOT added (blocked by a carrier gap). Does the blueprint over-claim the action rows are formalized?
- Confirm no fake/placeholder statements in the new declaration.
