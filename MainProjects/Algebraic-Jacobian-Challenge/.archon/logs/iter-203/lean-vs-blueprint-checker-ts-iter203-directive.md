# Lean ↔ Blueprint Checker Directive

## Slug
ts-iter203

## Lean file
AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## Blueprint chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Known issues
- This iter the prover closed two scaffold sorries axiom-clean:
  `tensorObj` (def) and `tensorObj_functoriality` (def). Four typed `sorry`s
  remain by design: `monoidalCategory` (instance, deferred — kept as a
  contained typed sorry per a contamination guard), `tensorObj_isLocallyTrivial`,
  `exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`. Do not flag those
  four as placeholders unless the blueprint MIS-describes their status.
- A known structural defect already detected by blueprint-doctor: the chapter
  contains a malformed `\uses{\leanok lem:tensorobj_lift_onproduct}` — a `\uses`
  call with a stray `\leanok` token pointing at a label no `\label` defines.
  You may confirm it but it is already on the fix-list; focus your effort on the
  Lean↔prose correspondence for the two newly-closed defs and whether the
  chapter's `\lean{...}` pins for them match the landed names
  (`AlgebraicGeometry.Scheme.Modules.tensorObj`,
  `...tensorObj_functoriality`).
