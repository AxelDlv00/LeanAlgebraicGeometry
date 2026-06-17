# Blueprint-writer directive — Picard_GrassmannianQuot.tex coverage debt

Chapter: `blueprint/src/chapters/Picard_GrassmannianQuot.tex` (Lean file
`AlgebraicJacobian/Picard/GrassmannianQuot.lean`). NOTE: an effort-breaker edited this chapter
earlier this phase (split of `lem:gr_baseChange_bridge`) — read the chapter fresh; do not undo
its edits.

## Task — blueprint entries for 16 unmatched Lean decls (coverage debt)
All project-bespoke (NO `% SOURCE` lines): each block = faithful statement + `\label` +
`\lean{}` + accurate `\uses{}` + one-line (or few-line) informal proof. Read each decl in the
Lean file to state it faithfully and derive the real `\uses{}` from what its proof uses.
Namespace prefix `AlgebraicGeometry.Grassmannian.` throughout. Place blocks adjacent to the
material they support.

Substantive (session-063 recs; give these real proof sketches):
1. `ιFree_matrixEnd` — `ιFree j ≫ matrixEnd M = ∑ k, scalarEnd (M k j) ≫ ιFree k`. Label
   `lem:gr_iFree_matrixEnd`, near `def:gr_matrixEnd`.
2. `pullbackBaseChangeTransport_matrixToFreeIso` — the reusable transport bridge: a
   bundle-transition-shaped iso `pullbackFreeIso a ≪≫ matrixToFreeIso M N ≪≫ (pullbackFreeIso
   b).symm` transports through `pullbackBaseChangeTransport p a b` to the same shape over the
   base-changed matrix `p^♯·M`. Label `lem:gr_matrixToFreeIso_transport` (the Lean docstring
   already names this label). Then UPDATE the `% NOTE:` above `lem:gr_bundleCocycle_transport`
   that says this block is "to be added by the planner" (it now exists), and add the new label to
   `lem:gr_bundleCocycle_transport`'s `\uses{}`.

Terse helper blocks (one-liners are fine; they exist to carry dependency edges):
3. `scalarEnd_val_app`, 4. `scalarEnd_val_app_one`, 5. `unitHomEquiv_scalarEnd`,
6. `unitToPushforward_scalarEnd_comm` — scalarEnd evaluation/naturality API near
   `def:gr_scalarEnd`.
7. `biproduct_matrix_comp`, 8. `bundleMatrix_cancel`, 9. `hasFiniteBiproducts_modules` —
   biproduct infrastructure.
10–16. The seven private Cells-helper ports `cocycle_imageMatrix_eq'`, `imageMatrix_map_eq'`,
   `inv_mul_inv_mul_cancel'`, `isUnit_algebraMap_away_left'`, `map_map_eq_of_comp'`,
   `map_nonsing_inv'`, `mul_submatrix_col'` — matrix/localisation algebra over the Away rings;
   group them in one short "ported matrix helpers" subsection near `lem:gr_bundleCocycle_matrix`,
   each with its own block (private decls still get entries; the graph needs the edges).

## Task 2 — wire the isolated node
`lem:gr_homEquiv_conjugateEquiv_app` (exists, `\leanok`, but has NO `\uses{}` in or out). Read
the Lean proof (`homEquiv_conjugateEquiv_app`) and give the block an accurate `\uses{}`; add it
to the `\uses{}` of the blocks whose Lean proofs consume it (`pullbackObjUnitToUnit_comp` /
`pullbackFreeIso_comp` cluster blocks, e.g. `lem:gr_pullbackFreeIso_comp` — verify in the Lean).

## Constraints
- NEVER add/remove `\leanok`. No `\mathlibok` (no Mathlib anchors here).
- Do NOT alter existing blocks' mathematical statements (the `% NOTE` update and `\uses{}`
  additions in Tasks 1.2/2 are the only edits to existing blocks).
- Math-only prose; Lean names appear only inside `\lean{}` fields.
