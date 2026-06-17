# lean-vs-blueprint-checker directive (iter-263)

Verify ONE Lean file against its blueprint chapter, bidirectionally.

- Lean file: /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean
- Blueprint chapter: /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex
  (consolidated chapter; `% archon:covers ... DualInverse.lean`. Focus on the
  `sliceDualTransport` / `dual_restrict_iso` blocks — lem:slice_dual_transport.)

This iter the prover closed `sliceDualTransport.map_add'` axiom-clean (via the
ma-ihom263 recipe) and reduced `map_smul'` to a named sectionwise crux
`d.hom (s • u) = c • d.hom u` (β-naturality ring identity + restrictScalars.smul_def'
+ map_smul), leaving typed sorries for `map_smul'`, `naturality`, `invFun`,
`left_inv`, `right_inv`, and `dual_restrict_iso` naturality. Check:
(a) does the chapter (leg-A reindex ∘ leg-B restrictScalarsRingIsoDualEquiv route)
describe the `≃ₗ` field obligations at enough detail to guide closing the remaining
fields, in particular invFun + the round-trips? (b) Any signature/label mismatch
between the Lean decl `sliceDualTransport` and the chapter's lem:slice_dual_transport?
Report bidirectionally; flag must-fix if the chapter is too thin.
