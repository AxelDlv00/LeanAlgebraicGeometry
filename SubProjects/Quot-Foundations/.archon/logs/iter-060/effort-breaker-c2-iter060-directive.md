## Target
`lem:gr_bundleCocycle_mul` (Lean: `AlgebraicGeometry.Grassmannian.bundleTransition_cocycle`) in
`blueprint/src/chapters/Picard_GrassmannianQuot.tex` (block @ ~L730–773). This is C2, the "hard step"
of the GL_d bundle cocycle. It is a FRONTIER node (deps done) and the lone bottleneck for the whole
GR-quot → representability chain.

## Granularity
One level (the proof's main steps), each its own \uses-linked sub-lemma with statement + informal proof.

## Proof structure (cut along these real seams)
The current proof collapses three distinct difficulties into one block. Split into:
1. **Matrix-level cocycle identity** on the triple overlap V_IJK:
   `(X^J_K)⁻¹ · (X^I_J)⁻¹ = (X^I_K)⁻¹`. Pure matrix algebra over the overlap ring, from
   `lem:gr_cocycle_imageMatrix_eq` (minor multiplicativity, the matrix form of `lem:gr_cocycle`) +
   `lem:gr_universalMinorInv_identities` (Cramer-inverse identities). Cite `Matrix.nonsing_inv_mul`/
   `submatrix_mul` as the Mathlib mechanism.
2. **Matrix-product → scalarEnd-composition linkage** (THE GAP iter-059 review flagged as missing):
   a sub-lemma stating that under the rank-d biproduct presentation `matrixToFreeIso`, multiplication of
   matrices over the overlap ring corresponds to composition of the assembled scalar-endomorphisms —
   i.e. `matrixToFreeIso (A * B) = matrixToFreeIso A ≫ matrixToFreeIso B` (or the bundleTransition form).
   This is the `matrixEnd_comp`/`matrixToFreeIso` linkage. Name the existing helpers
   `matrixEnd_comp`, `matrixToFreeIso`, `matrixToFreeIso_hom` it should build on.
3. **Endpoint transport/bridge bookkeeping**: align the three transitions g_IJ, g_JK, g_IK — living on
   three different pairwise overlaps — onto the common V_IJK via `lem:modules_pullback_basechange_transport`,
   match source/middle/target sheaves via `lem:gr_glueData_bridges`, reassociate iterated pullbacks via
   `def:modules_pullbackComp`. Acknowledge this as the "substantive difficulty" and give the explicit
   domain/codomain matching so the composite typechecks against ĝ_IK^J.

## Constraints
- Each sub-lemma gets \label, \lean{} (use a clear planned name, e.g.
  `bundleTransition_cocycle_matrix`, `matrixToFreeIso_mul`, `bundleTransition_cocycle_transport`),
  accurate \uses, and an informal proof.
- Do NOT add \leanok or \mathlibok.
- Keep prose mathematical (no Lean tactics).
