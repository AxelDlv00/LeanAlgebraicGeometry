# Blueprint-writer directive — Picard_GrassmannianCells.tex (coverage debt only)

## Chapter to edit
`blueprint/src/chapters/Picard_GrassmannianCells.tex` (ONLY this file).

## Task — clear DAG-unmatched coverage debt (terse blocks)
The Grassmannian properness lane is CLOSED (`Gr(d,r)` proper over ℤ, axiom-clean). Six prover-created
helper declarations in `AlgebraicJacobian/Picard/GrassmannianCells.lean` are DAG-unmatched (they appear
in `archon dag-query unmatched` with no blueprint entry), silently corrupting the 1-to-1 Lean↔tex
correspondence. Give EACH a TERSE blueprint block: `\begin{lemma}` or `\begin{definition}` as
appropriate, with `\label`, `\lean{<exact name>}`, an accurate `\uses{}` reflecting what the Lean proof
actually consumes, and a ONE- to TWO-line informal statement/proof. A trivial entry for a trivial helper
is fine and is the point — the entry carries the dependency edges.

Read each declaration's Lean signature and proof to get the `\uses{}` right. The six:

1. `AlgebraicGeometry.Grassmannian.det_one_updateCol` — determinant of the identity matrix with one column
   replaced by a vector `v` equals the entry `v p` (no sign), via `Matrix.cramer_apply` + `mulVec_cramer`.
2. `AlgebraicGeometry.Grassmannian.liftToBaseOfMemRange` — the base-point lift used in the valuative
   existence step (factor a generator through `(algebraMap R K).range`).
3. `AlgebraicGeometry.Grassmannian.algebraMap_comp_liftToBaseOfMemRange` — the compatibility square
   `algebraMap ∘ liftToBaseOfMemRange = …` for the lift.
4. `AlgebraicGeometry.Grassmannian.rotMid` — the middle-rotation matrix identity used to recover
   `cocycleΘJK` in the I,J,K frame (cocycle telescoping).
5. `AlgebraicGeometry.Grassmannian.transitionInvImageMatrix` — the inverse image matrix closing the single
   residual inverse pair in the cocycle condition.
6. `AlgebraicGeometry.Grassmannian.transitionInvPair` — the inverse-pair helper feeding (5).

Place them near the existing cocycle / existence blocks they support, and `\uses` those existing labels
(`lem:gr_cocycle`, `lem:gr_existence_*`, etc.) where the Lean proof actually depends on them.

## Out of scope
- Do NOT add `\leanok` (deterministic sync owns it).
- Do NOT modify any existing proved block's math.
- Do NOT edit any other chapter.

## Deliverable
The updated chapter with six terse coverage blocks. Report the labels you created.
