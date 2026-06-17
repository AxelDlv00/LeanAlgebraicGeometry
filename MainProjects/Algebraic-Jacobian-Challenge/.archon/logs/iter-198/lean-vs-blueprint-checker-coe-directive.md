# lean-vs-blueprint-checker — CodimOneExtension (slug coe-iter198)

## File

`AlgebraicJacobian/Albanese/CodimOneExtension.lean`

## Blueprint chapter

`blueprint/src/chapters/Albanese_CodimOneExtension.tex`

## Context (minimal)

iter-198 added 3 new axiom-clean private substrate helpers in the
file (L373–L459):
- `finrank_residueField_tensor_kaehlerDifferential_of_free_rank_eq`
  (L373–L401)
- `finrank_residueField_tensor_kaehlerDifferential_of_isStandardSmoothOfRelativeDimension`
  (L403–L435)
- `exists_isStandardSmoothOfRelativeDimension_of_isStandardSmooth`
  (L437–L459)

The body of `isRegularLocalRing_stalk_of_smooth` was extended
(L498–L630) to consume these helpers; trailing `sorry` retained,
now narrowed to two named bridges:
- Sub-gap (ii.A) Stacks 02JK — cotangent ↔ Kähler iso over a field.
- Sub-gap (ii.B) Stacks 00OE — Krull-dim formula for standard-smooth.

Docstring at L498–L529 was updated to reflect the iter-198 substrate
landing.

## Questions

- **Lean → blueprint**: do the 3 new helpers correspond to chapter
  sub-lemmas (the blueprint-writer `coe-stage6-expansion` chapter
  edit at L373+ added 6.A / 6.B / 6.C decomposition)? If so, are the
  `\lean{...}` pins (a) accurate, (b) present?
- **Blueprint → Lean**: does the chapter's Stage 6 sub-section
  match the iter-198 state, or does it still describe the
  iter-194/195 framing? Are sub-gaps (ii.A) and (ii.B) clearly
  named with their Stacks tags?
- L820 `extend_of_codimOneFree_of_smooth` and L888
  `indeterminacy_pure_codim_one_into_grpScheme` were NOT edited this
  iter. Verify their chapter pins still resolve.

## What to flag

- Missing `\lean{...}` pin for the 3 new helpers (if the chapter
  refers to them by informal name without a pin).
- `\leanok` mismatches (sync_leanok ran iter=198; check what it
  added).
- Any chapter prose that overstates the closure progress (e.g.
  "Stage 6 closed" when only sub-gap (i) and 6.B-RHS landed).
