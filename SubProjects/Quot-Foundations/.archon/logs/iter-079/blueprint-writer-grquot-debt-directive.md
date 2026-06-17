Target chapter: `blueprint/src/chapters/Picard_GrassmannianQuot.tex` (ONLY this chapter).

Three tasks (coverage debt + correctness, from blueprint-reviewer iter-079):

## 1. Rewrite the `lem:chartLocus_isOpenCover` proof block (lines ~2004–2036)
The current PROOF prose describes a stalkwise-Nakayama route; the FORMALIZED proof uses a different,
affine-projective-splitting route (see the `% NOTE (review iter-078)` already in that block). Replace the
proof prose to faithfully describe the formalized route, so future provers/readers match the Lean:
1. On an affine `W` trivialising `F`, the epi `q` of free sheaves SPLITS globally via projectivity
   (`exists_section_of_epi_free_spec` → `exists_rightInverse_of_epi_matrixEndRect`): a `d×r` presenting
   matrix `M` of `q` admits a right inverse `G` (`M·G = 1`) over `Γ(W)`.
2. Evaluate `G` at the residue field `κ(t)` of the stalk at `t`: a right-invertible matrix over a field
   has an invertible `d`-column minor (`exists_isUnit_submatrix`) — pick that index set `I`, size `d`.
3. The minor determinant `P_I = det(M_I)` is a unit at `t` (its residue ≠ 0), so `t ∈ W_{P_I}`, the basic
   open where `P_I` is invertible; there `M_I` is invertible and the chart composite restricts to an iso,
   i.e. `t ∈ T_I`. Hence the `T_I` cover `T`.
KEEP the existing `% SOURCE`/`% SOURCE QUOTE`/`\textit{Source: [Nitsure], §1.}` lines verbatim.
Also fix `\uses{}`: in the STATEMENT `\uses` (line ~1986) REMOVE the spurious `lem:isIso_pullback_isoLocus_map`
(the covering statement does not depend on it); in the PROOF `\uses` ADD `def:isoLocus`.

## 2. Add blueprint blocks for 15 matrix-calculus helpers (currently NO block — DAG coverage debt)
Insert a new subsection "Matrix-calculus toolbox" before the `def:gr_matrixEndRect` block. One block per
helper: human name, `\label{lem:gr_<name>}` (or `def:` for `presentedMatrix`), `\lean{AlgebraicGeometry.Grassmannian.<name>}`,
an accurate `\uses{}`, and a ≥1-line informal statement+proof. These are Archon-original infra (no external
source — omit SOURCE lines). Helpers + their dependency hints (from the prover's report):
- `matrixEnd_eq_matrixEndRect` — rfl bridge square `matrixEnd`=`matrixEndRect`. uses: defs only.
- `matrixEndRect_one` — identity law. uses: `lem:gr_matrixEnd_one` (if present) else defs.
- `matrixEndRect_comp_rect` — fully rectangular composition law. uses: scalarEnd comp/sum, biproduct calculus.
- `matrixEndRect_injective` — uniqueness of the presenting matrix. uses: `ιFree_matrixEndRect_projFree`, `unitEndSection_scalarEnd`.
- `freeMap_matrixEndRect` — column-restriction law. uses: `ιFree_freeMap`, `ιFree_matrixEndRect_projFree`, `isColimitFreeCofan`.
- `exists_section_of_epi_free_spec` — epis of free sheaves on `Spec R` split. uses: Mathlib `tildeFinsupp`, `tilde.fullyFaithfulFunctor`, `ModuleCat.epi_iff_surjective`, `Module.projective_lifting_property`.
- `exists_rightInverse_of_epi_matrixEndRect_spec` — matrix right inverse on `Spec R`. uses: prev + `matrixEndRect_unitEndSection`, `matrixEndRect_comp_rect`, `matrixEndRect_injective`, `matrixEndRect_one`.
- `exists_rightInverse_of_epi_matrixEndRect` — affine case via `S.isoSpec`. uses: prev + `pullback_conj_matrixEndRect`, `Scheme.isoSpec`.
- `exists_isUnit_submatrix` — right-invertible matrix over a field has invertible `d`-col minor. uses: `Matrix.range_mulVecLin`, `exists_linearIndependent`, `Module.finrank_eq_card_basis`, `Matrix.linearIndependent_cols_iff_isUnit`.
- `pullbackFreeIso_inv_freeMap` — inverse index-map intertwiner. uses: `pullback_map_freeMap_pullbackFreeIso`.
- `presentedMatrix` (def) — presented matrix along a morphism with invertible `I`-chart composite. uses: `unitEndSection`, `projFree`, `pullbackFreeIso`.
- `matrixEndRect_presentedMatrix` — presentation identity. uses: `matrixEndRect_unitEndSection`.
- `matrixEndRect_presentedMatrix_minor` — `J`-minor presents `j^*c_J (j^*c_I)⁻¹`. uses: `freeMap_matrixEndRect`, `pullbackFreeIso_inv_freeMap`.
- `presentedMatrix_changeOfBasis` — Nitsure overlap matrix identity `M^I = M^I_J · M^J`. uses: the three above + `matrixEndRect_comp_rect`, `matrixEndRect_injective`.
- `isUnit_of_isIso_matrixEndRect` — converse of `matrixToFreeIso`. uses: `matrixEndRect_unitEndSection`, `matrixEndRect_comp_rect`, `matrixEndRect_injective`, `matrixEndRect_one`.
Use only `\label`s that already exist for the `uses` targets; if a named dep has no block yet, reference
it by the closest existing label or omit it (do not invent labels).

## 3. Out of scope
Do NOT add `\leanok`. Do NOT touch any other chapter. Do NOT edit Lean files.
Math-only prose, no Lean tactic strings.
