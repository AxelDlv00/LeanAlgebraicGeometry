# Blueprint Writer Directive

## Slug
dag-writer-grassmannian

## Target chapter
blueprint/src/chapters/Picard_GrassmannianCells.tex

## Strategy context
This chapter blueprints the **Grassmannian big-cells** construction (GR-cells / GR-glue): for each
size-`d` index set `I ⊆ Fin r`, an affine chart `U^I ≅ 𝔸^{d(r-d)}_S`, and the **Plücker cocycle**
gluing of these charts via the transition maps `Θ_{I,J}` built from the universal matrix and its
minors. The Lean file `GrassmannianCells.lean` carries a cluster of helper declarations (namespace
`AlgebraicGeometry.Grassmannian`) implementing the matrix-algebra and localization bookkeeping that
the cocycle condition `lem:gr_cocycle` rests on. They are proved in Lean (`leanok`) but have **no
blueprint entry**, breaking the 1-to-1 correspondence. Add a concise blueprint entry for each.

## Required content
Add one concise block (`\definition` / `\lemma` / `\theorem`) for **each** of the following Lean
declarations. Read `AlgebraicJacobian/Picard/GrassmannianCells.lean` for each exact signature and
role; **the namespace is `AlgebraicGeometry.Grassmannian`** so `\lean{}` targets are e.g.
`AlgebraicGeometry.Grassmannian.cocycleΘIJ`. These are **project-internal, Archon-original**
matrix/localization helpers — **no external citation block required** (no `% SOURCE QUOTE:`).
Where a helper merely restates a Mathlib matrix identity in the project's setting (e.g.
`map_nonsing_inv` mirroring `Matrix.map` commuting with `nonsing_inv`), still write it as a project
block (it has nonzero hypotheses), not a `\mathlibok` anchor.

Matrix/minor bookkeeping:
- `universalMatrix_submatrix_self` — the `I`-indexed column submatrix of the universal matrix on
  chart `I` is the identity (the normalization defining the chart).
- `universalMatrix_map_transitionPreMap` — image of the universal matrix under `transitionPreMap`.
- `imageMatrix_submatrix_self`, `imageMatrix_submatrix_I` — the analogous submatrix identities for
  the image matrix.
- `mul_submatrix_col` — multiplying a matrix by a column-submatrix equals the column-submatrix of
  the product (a `Matrix.submatrix`/multiplication compatibility). One-line.
- `map_nonsing_inv` — a ring map `f` commutes with `nonsing_inv` of an invertible matrix:
  `f.mapMatrix M⁻¹ = (f.mapMatrix M)⁻¹`. One-line.
- `map_map_eq_of_comp` — functoriality: applying two ring maps in sequence equals applying their
  composite (matrix entrywise). One-line.
- `imageMatrix_map_eq` — naturality of the image matrix under a ring map.
- `transitionPreMap_minorDet` — the value of `transitionPreMap` on the minor determinant `minorDet K`.

Localization plumbing (the doubly-localised rings inverting two minors):
- `awayInclLeft`, `awayInclRight` (definitions) — the `algebraMap`s from a single
  `Localization.Away x` (resp. `Away y`) into the double localization `Away (x·y)`.
- `awayInclLeft_comp_algebraMap`, `awayInclRight_comp_algebraMap` — these inclusions compose with
  the base `algebraMap` to give the double-localization `algebraMap`.
- `isUnit_algebraMap_away_left`, `isUnit_algebraMap_away_right` — `x` (resp. `y`) is a unit in
  `Away (x·y)`. One-line each.
- `isUnit_incl_transitionPreMap_cross` — the relevant cross minor becomes a unit after the
  localization inclusion (the invertibility making the transition map defined).
- `inv_mul_inv_mul_cancel` — a matrix-inverse cancellation identity `(AB)⁻¹·A·(B'...) ` used to
  collapse a composite of transition matrices (read the statement). One-line.

The cocycle transition maps and their identity:
- `cocycleΘIJ`, `cocycleΘJK`, `cocycleΘIK` (definitions) — the localized transition ring maps
  `Θ_{I,J}`, `Θ_{J,K}`, `Θ_{I,K}` between the doubly-localised rings, each via
  `IsLocalization.Away.lift` of the matching `transitionPreMap`.
- `cocycle_imageMatrix_eq` — the image-matrix identity over the triple overlap that powers
  the cocycle condition (`Θ_{I,K} = Θ_{I,J}∘Θ_{J,K}` reduced to a matrix equation).

For each block: a short statement in project notation, `\label{}` (suggest `lem:gr_*` / `def:gr_*`
from the Lean basename), the exact `\lean{}`, accurate `\uses{}`, and a one-to-two line proof or
`Proved directly in Lean.` note (do NOT add `\leanok`).

**Wire `\uses{}`:** after reading the .lean, add edges from `lem:gr_cocycle` (and the cocycle-Θ
definitions) to the helpers their Lean proofs actually invoke, and edges among the helpers
themselves (e.g. `cocycleΘIJ \uses{def:gr_away_incl_left, lem:gr_isunit_...}`). Mathlib anchors
already present in the chapter (`IsLocalization.Away.lift`, `Matrix.nonsing_inv_mul`, etc.) should
be reused via `\uses{}`, not re-authored. Run `leandag build --json`; confirm zero isolated/broken
for this cluster.

## Out of scope
- Do NOT modify existing meaningful statements (`def:gr_affine_chart`, `def:gr_universal_matrix`,
  `def:gr_transition`, `lem:gr_cocycle`, `def:gr_glued_scheme`, etc.) beyond adding `\uses{}` edges.
- Do NOT add `\leanok`. Do NOT touch other chapters. Do NOT author Mathlib anchors for these
  project helpers (they are project-proved, not Mathlib re-exports).

## References
None required — these blocks are project-internal matrix-algebra/localization helpers with no
external source. (The geometric construction's source, Nitsure §1/§5, already backs the chapter's
main blocks; the helpers need no new citation.)

## Expected outcome
The chapter gains ~21 concise helper blocks (namespace `AlgebraicGeometry.Grassmannian`), each with
`\label`/`\lean`/`\uses` and a short proof or "Proved directly in Lean." note, wired into the
cocycle machinery so `leandag` reports zero unmatched-lean and zero isolated nodes for this cluster.
