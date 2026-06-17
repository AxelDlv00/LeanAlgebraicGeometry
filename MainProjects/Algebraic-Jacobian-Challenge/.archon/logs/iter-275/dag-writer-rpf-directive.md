# Blueprint Writer Directive

## Slug
cov275-rpf

## Target chapter
blueprint/src/chapters/Picard_RelPicFunctor.tex

## Strategy context
This chapter covers `AlgebraicJacobian/Picard/RelPicFunctor.lean` (Route A,
relative Picard functor `Pic^\sharp`). The project keeps a strict 1-to-1 Lean ↔
blueprint correspondence. The five `PicSharp` helper declarations below currently
have NO blueprint entry. Add one additive, faithful 1-to-1 coverage block per
declaration. Purely additive.

## Required content
Read each Lean signature from RelPicFunctor.lean, then add a block for:

- `theorem` (private) `AlgebraicGeometry.Scheme.PicSharp.isLocallyTrivial_unit`
  (line 303) — the structure-sheaf unit is locally trivial (the identity element
  of the relative Picard group is an invertible/locally-trivial sheaf).
- `theorem` (private) `AlgebraicGeometry.Scheme.PicSharp.pInverseUnique`
  (line 320) — uniqueness of the tensor inverse of a relative line bundle.
- `def` (private) `AlgebraicGeometry.Scheme.PicSharp.relTensorObj` (line 333) —
  the tensor-product (group multiplication) operation on relative line bundles.
- `def` (private) `AlgebraicGeometry.Scheme.PicSharp.relAdd` (line 339) — the
  additive group operation on `Pic^\sharp` classes (induced by `relTensorObj`).
- `def` (private) `AlgebraicGeometry.Scheme.PicSharp.relNeg` (line 352) — the
  negation (tensor-inverse) group operation on `Pic^\sharp` classes.

## Proof notes
- For decls proved sorry-free in Lean: one-line `\begin{proof} Proved directly in
  Lean. \end{proof}`.
- For any `sorry`-bodied decl: brief honest informal sketch.

## Wiring (critical — leandag quirk)
leandag builds edges ONLY from **statement-level** `\uses{}`. Each block must
carry a statement-level `\uses{}` into the chapter cone — `relAdd`/`relNeg`
naturally `\uses{}` `relTensorObj`/`pInverseUnique`; `isLocallyTrivial_unit` ties
into the existing relative-Picard group-structure block. After writing, run
`leandag build --json` and `leandag query --isolated --chapter Picard_RelPicFunctor`;
ensure no new isolated nodes.

## Out of scope
- Do NOT touch existing blocks. Do NOT add `\leanok`. Do NOT cover TensorObj/Modules helpers.
- Do NOT attempt to fix the chapter's pre-existing bare `\cref{}` issues (Kleiman
  internal labels) — that is the review agent's domain, separate from this coverage task.

## References
- `references/kleiman-picard.md` (Kleiman, "The Picard scheme") — only if you cite
  an external statement; these `PicSharp` group-operation helpers are project-
  internal, so a "proved directly in Lean" note with no external citation is
  acceptable. Do NOT fabricate a citation.

## Expected outcome
Five additive 1-to-1 coverage blocks, statement-level-wired, no new isolated
nodes, no broken `\uses{}`.
