# Blueprint Writer Directive

## Slug
cov275-relspec

## Target chapter
blueprint/src/chapters/Picard_RelativeSpec.tex

## Strategy context
This chapter covers `AlgebraicJacobian/Picard/RelativeSpec.lean` (Route A, the
relative-spectrum / quasi-coherent-algebra `QcohAlgebra` machinery). Strict 1-to-1
Lean ↔ blueprint correspondence. One helper currently has NO blueprint entry. Add
one additive, faithful 1-to-1 coverage block. Purely additive.

## Required content
- `def` `AlgebraicGeometry.Scheme.QcohAlgebra.pullback` (RelativeSpec.lean:390) —
  the pullback (base change) `g^* 𝒜` of a quasi-coherent `𝒪_X`-algebra `𝒜` along
  a morphism `g : T → X`, packaged as a `QcohAlgebra T`. Its `coequifibered`
  field is supplied by the already-covered helpers
  `QcohAlgebra.pullback_fst_isAffineHom` and `QcohAlgebra.pullback_coequifibered`.

## Proof notes
- Proved sorry-free in Lean: one-line `\begin{proof} Proved directly in Lean. \end{proof}`.

## Wiring (critical — leandag quirk)
leandag builds edges ONLY from **statement-level** `\uses{}`. The block must carry
a statement-level `\uses{}` to the existing `QcohAlgebra` structure block and to
the existing `pullback_fst_isAffineHom` / `pullback_coequifibered` helper blocks
(whose `\lean{}` pins are
`AlgebraicGeometry.Scheme.QcohAlgebra.pullback_fst_isAffineHom` and
`...pullback_coequifibered`), so it is not isolated. After writing, run
`leandag build --json` and `leandag query --isolated --chapter Picard_RelativeSpec`;
ensure not isolated.

## Out of scope
- Do NOT touch existing blocks. Do NOT add `\leanok`.

## References
- `references/stacks-constructions.md` (relative-spectrum tags) — only if you cite
  an external statement; `QcohAlgebra.pullback` is the project's base-change
  constructor, so a "proved directly in Lean" note with no external citation is
  acceptable. Do NOT fabricate a citation.

## Expected outcome
One additive 1-to-1 coverage block for `QcohAlgebra.pullback`, statement-level-
wired to its `coequifibered`-feeding helpers, not isolated, no broken `\uses{}`.
