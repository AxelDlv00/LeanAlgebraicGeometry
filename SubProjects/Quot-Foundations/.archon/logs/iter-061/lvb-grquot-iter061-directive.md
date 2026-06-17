# Per-file Lean ↔ blueprint check

Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianQuot.lean
Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_GrassmannianQuot.tex

This iter the prover closed (axiom-clean) two new theorems and left C2 open:
- `lem:gr_matrixToFreeIso_mul`  → `AlgebraicGeometry.Grassmannian.matrixToFreeIso_mul`
- `lem:gr_bundleCocycle_matrix` → `AlgebraicGeometry.Grassmannian.bundleTransition_cocycle_matrix`
- `lem:gr_bundleCocycle_mul` (C2) → `AlgebraicGeometry.Grassmannian.bundleTransition_cocycle` (STILL sorry)
- `lem:gr_bundleCocycle_transport` (L3) → `...bundleTransition_cocycle_transport` (decl ABSENT; blueprint-only)

Verify bidirectionally:
(a) Do the L1/L2 Lean statements faithfully match their blueprint blocks? Any signature/name drift?
(b) Is `lem:gr_bundleCocycle_transport`'s `\lean{...}` naming a decl that does NOT exist in the file
    (it is blueprint-only this iter) — flag as a pin pointing at an absent decl.
(c) Is the C2 proof block correctly UNMARKED for proof (it carries a real sorry)?
(d) Are the 7 ported `private … '` helpers (cocycle_imageMatrix_eq', etc.) absent from the blueprint
    (coverage debt) — list them.
Report must-fix vs minor.
