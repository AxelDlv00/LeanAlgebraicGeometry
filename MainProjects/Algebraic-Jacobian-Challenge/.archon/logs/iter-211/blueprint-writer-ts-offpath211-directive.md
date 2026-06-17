# Blueprint-writer — fix stale off-path section in `Picard_TensorObjSubstrate.tex`

## Chapter to edit (ONLY this file)
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## The single fix

The chapter's final section, "Off-path declarations (retained, not on the
critical path)", currently asserts that the declarations `monoidalCategory`,
`tensorObj_restrict_iso`, `exists_tensorObj_inverse`, and
`addCommGroup_via_tensorObj` are "retained in the Lean file" and "carry
`sorry`". This is factually stale: the Lean file
`Picard/TensorObjSubstrate.lean` contains ONLY `tensorObj_substrate` and
`tensorObj` — none of those off-path declarations are present.

Rewrite that section so it correctly states that those earlier-route
declarations were **abandoned and removed** from the Lean file during the
⊗-invertibility pivot — they are NOT retained and carry no `sorry`. Keep a one-
or two-sentence historical note naming them and the reason each was abandoned
(the δ-mate / `MonoidalClosed` wall for `monoidalCategory` and
`tensorObj_restrict_iso`; superseded by `IsInvertible` / the iso-class group
for `exists_tensorObj_inverse` / `addCommGroup_via_tensorObj`), so the record
is preserved without claiming they exist in the file.

## Out of scope
- Do NOT touch any other section of the chapter (the critical-path
  definitions, lemmas, and proofs are correct and complete — leave them
  verbatim).
- Do NOT add or remove any `\leanok` / `\mathlibok` markers.
- Do NOT touch any other chapter.

## Context
This is a prose-only consistency correction flagged by the iter-211 blueprint
review. No new source material is needed.
