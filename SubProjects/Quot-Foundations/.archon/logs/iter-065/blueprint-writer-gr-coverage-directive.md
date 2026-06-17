# Blueprint-writer directive — Picard_GrassmannianQuot.tex coverage debt (iter-065)

Chapter: `blueprint/src/chapters/Picard_GrassmannianQuot.tex` (Lean file
`AlgebraicJacobian/Picard/GrassmannianQuot.lean`). NOTE: an effort-breaker edited this chapter
earlier THIS phase (decomposition blocks under `def:tautological_quotient`, rectangular
matrixEnd sub-lemmas) — read the chapter fresh; do not undo or duplicate its edits.

## Task 1 — blueprint entries for 22 unmatched Lean decls (coverage debt)
All project-bespoke (NO `% SOURCE` lines): each block = faithful statement + `\label` +
`\lean{}` + accurate `\uses{}` + one-line (or few-line) informal proof. Read each decl in the
Lean file to state it faithfully and derive the real `\uses{}` from what its proof uses.
Namespace prefix `AlgebraicGeometry.Grassmannian.` unless noted. Place blocks adjacent to the
material they support. Skip any decl that already has a block (the effort-breaker or a prior
writer may have covered some — check with grep before writing each).

Substantive (give these real proof sketches):
1. `ιFree_matrixEnd` — `ιFree j ≫ matrixEnd M = ∑ k, scalarEnd (M k j) ≫ ιFree k`. Label
   `lem:gr_iFree_matrixEnd`, near `def:gr_matrixEnd`.
2. `pullbackBaseChangeTransport_matrixToFreeIso` — the reusable transport bridge: a
   bundle-transition-shaped iso `pullbackFreeIso a ≪≫ matrixToFreeIso M N ≪≫ (pullbackFreeIso
   b).symm` transports through `pullbackBaseChangeTransport p a b` to the same shape over the
   base-changed matrix. Label `lem:gr_matrixToFreeIso_transport`; ensure
   `lem:gr_bundleCocycle_transport`'s `\uses{}` cites it (verify current state — it may already).
3. `AlgebraicGeometry.Scheme.Modules.glueLift` (substantive, lvb iter-064): the lift primitive
   into `glue D M g _ _` from a compatible family `k i : W ⟶ (ι_i)_* M_i` (universal property of
   the descent equalizer). It currently REALIZES the role of the forward-declared
   `def:gr_modules_glueHom`: if its statement faithfully matches that block, repoint that block's
   `\lean{}` to `AlgebraicGeometry.Scheme.Modules.glueLift` and update its prose/NOTE; otherwise
   give glueLift its own block adjacent to `def:scheme_modules_glue` and clarify the relationship
   in one sentence.
4. `tripleOverlapSections` — the common codomain `S_I = R^I[1/(P^I_J P^I_K)] ⟶ Γ(V_IJK,⊤)`
   packaging used by the three base-change bridges; near the `lem:gr_baseChange_bridge*` blocks.
5. `tautologicalQuotientComponent` — the adjoint transpose along `ι_I` of
   `pullbackFreeIso.hom ≫ chartQuotientMap`; near `def:tautological_quotient`.

Terse helper blocks (one-liners fine; they exist to carry dependency edges):
6. `scalarEnd_val_app`, 7. `scalarEnd_val_app_one`, 8. `unitHomEquiv_scalarEnd`,
9. `unitToPushforward_scalarEnd_comm` — scalarEnd evaluation/naturality API near `def:gr_scalarEnd`.
10. `biproduct_matrix_comp`, 11. `bundleMatrix_cancel`, 12. `hasFiniteBiproducts_modules` —
   biproduct infrastructure.
13. `AlgebraicGeometry.Scheme.Modules.pullbackCongr_hom_app_free`,
14. `AlgebraicGeometry.Scheme.Modules.pullbackFreeIso_inv_congr`,
15. `AlgebraicGeometry.Scheme.Modules.pullbackFreeIso_inv_congr_hom` — the three generic
   `pullbackCongr` cast-collapse lemmas (subst-generic, no immersion whnf); group as a short
   subsection near the transport material.
16–22. The seven private Cells-helper ports `cocycle_imageMatrix_eq'`, `imageMatrix_map_eq'`,
   `inv_mul_inv_mul_cancel'`, `isUnit_algebraMap_away_left'`, `map_map_eq_of_comp'`,
   `map_nonsing_inv'`, `mul_submatrix_col'` — matrix/localisation algebra over the Away rings;
   group in one "ported matrix helpers" subsection, each with its own block (private decls still
   get entries; the graph needs the edges).

## Task 2 — wire the isolated node
`lem:gr_homEquiv_conjugateEquiv_app` (exists, but NO `\uses{}` edges in or out). Read the Lean
proof (`homEquiv_conjugateEquiv_app`) and give the block an accurate `\uses{}`; add it to the
`\uses{}` of blocks whose Lean proofs consume it (the `pullbackObjUnitToUnit_comp`/
`pullbackFreeIso_comp` cluster blocks — verify in the Lean; the effort-breaker's new
transposition block may also cite it, do not duplicate).

## Constraints
- NEVER add/remove `\leanok`. No `\mathlibok` (no Mathlib anchors here).
- Do NOT alter existing blocks' mathematical statements (the `\lean{}` repoint in Task 1.3 and
  `\uses{}` additions in Tasks 1.2/2 are the only edits to existing blocks).
- Math-only prose; Lean names appear only inside `\lean{}` fields.
