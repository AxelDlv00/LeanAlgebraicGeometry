# Blueprint Writer Report

## Slug
cov275-rpf

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_RelPicFunctor.tex

## Changes Made
Added a new subsection `\subsection{Helper constructions underlying the group law}`
(`\label{subsec:relpic_group_helpers}`) at the end of
`\section{Group structure on the relative Picard quotient}` (right after the
`lem:rel_pic_sharp_groupoid` proof, before the next `\section`). It contains five
additive, faithful 1-to-1 coverage blocks — one per Lean helper named in the
directive. All are project-internal helpers; per the directive each carries a
"Proved directly in Lean." proof note with no external citation (no fabricated
source).

- **Added definition** `\definition`/`\label{def:rel_tensor_obj}`/`\lean{AlgebraicGeometry.Scheme.PicSharp.relTensorObj}` — the tensor-product (group-multiplication) operation `L ⊗ L'` on the locally-trivial `OnProduct` carrier.
  - Statement-level `\uses{def:line_bundle_on_product, lem:tensorobj_lift_onproduct, lem:tensorobj_preserves_locally_trivial}`.
- **Added lemma** `\lemma`/`\label{lem:rel_pic_sharp_unit_loctriv}`/`\lean{AlgebraicGeometry.Scheme.PicSharp.isLocallyTrivial_unit}` — the structure-sheaf unit is locally trivial (the zero element of the relative Picard group).
  - Statement-level `\uses{def:line_bundle_on_product, lem:pullback_unit_iso}`; proof note "Proved directly in Lean" (affine-chart trivialisation via `lem:pullback_unit_iso`).
- **Added lemma** `\lemma`/`\label{lem:rel_pic_sharp_inverse_unique}`/`\lean{AlgebraicGeometry.Scheme.PicSharp.pInverseUnique}` — uniqueness of the tensor inverse of a relative line bundle.
  - Statement-level `\uses{lem:tensorobj_lift_onproduct, lem:tensorobj_unit_iso, lem:tensorobj_comm_iso, lem:tensorobj_assoc_iso}`; proof note sketches the coherence-iso chain `N ≅ … ≅ N'`.
- **Added definition** `\definition`/`\label{def:rel_add}`/`\lean{AlgebraicGeometry.Scheme.PicSharp.relAdd}` — descended addition `[L]+[L'] := [L⊗L']` on the quotient.
  - Statement-level `\uses{def:rel_tensor_obj, thm:relative_pic_quotient_well_defined, lem:tensorobj_lift_onproduct}`; proof note "Proved directly in Lean" (well-defined by bifunctoriality).
- **Added definition** `\definition`/`\label{def:rel_neg}`/`\lean{AlgebraicGeometry.Scheme.PicSharp.relNeg}` — descended negation `-[L] := [L^inv]`.
  - Statement-level `\uses{def:rel_tensor_obj, lem:rel_pic_sharp_inverse_unique, lem:tensorobj_inverse_invertible}`; proof note "Proved directly in Lean" (well-defined by `lem:rel_pic_sharp_inverse_unique`).

No existing blocks were touched; no `\leanok` added; no TensorObj/Modules helper blocks added; pre-existing bare `\cref{}` / Kleiman-internal-label issues left untouched (out of scope).

## Cross-references introduced
All `\uses{}` targets verified to resolve via `leandag build --json` (0 `unknown_uses`):
- `def:line_bundle_on_product`, `thm:relative_pic_quotient_well_defined` — A.1.b (`Picard_LineBundlePullback`).
- `lem:pullback_unit_iso`, `lem:tensorobj_lift_onproduct`, `lem:tensorobj_preserves_locally_trivial`, `lem:tensorobj_assoc_iso`, `lem:tensorobj_comm_iso`, `lem:tensorobj_unit_iso`, `lem:tensorobj_inverse_invertible` — `Picard_TensorObjSubstrate`.
- Intra-chapter: `def:rel_add`/`def:rel_neg` → `def:rel_tensor_obj`; `def:rel_neg` → `lem:rel_pic_sharp_inverse_unique`.

## Wiring verification
- `leandag build --json`: `unknown_uses = 0`; all five new `\lean{}` targets matched (none in `unmatched_lean`).
- `leandag query --isolated --chapter Picard_RelPicFunctor`: 0 isolated nodes (before and after).

## References consulted
None for citation purposes — the five blocks are project-internal helpers, so per
the directive they carry "Proved directly in Lean." notes and no external `% SOURCE`
citation. (Read `references/summary.md` to confirm no Kleiman statement was needed
for these group-operation helpers.)

## Macros needed (if any)
None. All commands used (`\otimes`, `\mathbin`, `\Pic`, `\cref`, etc.) are already
in use in this chapter.

## Notes for Plan Agent
- `def:rel_tensor_obj` corresponds to `relTensorObj := Modules.tensorObjOnProduct`,
  which in the chapter prose is the same upstream object covered by
  `lem:tensorobj_lift_onproduct`. The new block is the relative-Picard-side
  *wrapper* (per the Lean file's iter-247 note), so the 1-to-1 correspondence is
  preserved without duplicating the substrate lemma.
- The directive asked `isLocallyTrivial_unit` to "tie into the existing
  relative-Picard group-structure block." Since existing blocks may not be edited,
  the new `lem:rel_pic_sharp_unit_loctriv` is wired *outward* to `lem:pullback_unit_iso`
  (shared neighbour of `lem:rel_pic_sharp_groupoid`); it is non-isolated and sits in
  the chapter cone. If a direct edge `lem:rel_pic_sharp_groupoid → lem:rel_pic_sharp_unit_loctriv`
  is desired, that requires editing the (protected-adjacent) group-structure block's
  `\uses{}` — a separate, non-additive change.

## Strategy-modifying findings
None.
