# Blueprint-reviewer directive — slug ts218fp (HARD-GATE fast path)

This is a same-iter fast-path re-review. You read the whole blueprint (the cross-chapter
view is always your value), but the gate decision this iter hinges on ONE chapter:

## Focus chapter: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

A blueprint-writer (slug ts218) just edited this chapter to resolve the iter-217
must-fix findings. Confirm the chapter is now `complete: true` AND `correct: true` with
NO must-fix-this-iter finding, so a prover may be dispatched on
`AlgebraicJacobian/Picard/TensorObjSubstrate.lean` THIS iter. Specifically verify:

1. **The two previously-malformed `\uses{...}` blocks are now well-formed** — each
   contains ONLY a comma-separated list of labels (no `\leanok`, no other macros inside
   the braces):
   - proof of `lem:tensorobj_assoc_iso` (should now be
     `\uses{def:scheme_modules_tensorobj, lem:tensorobj_restrict_iso}`);
   - proof of `thm:rel_pic_addcommgroup_via_tensorobj` (single well-formed list of its
     six labels).
2. **The 5 new iter-217 presheaf helpers are pinned** in a new block
   (`lem:presheaf_pushforward_adj_substrate` per the writer): `pushforwardNatTrans`,
   `pushforwardCongr`, `pushforwardPushforwardAdj`, `isIso_of_isIso_app`,
   `restrictScalarsMonoidalOfBijective`.
3. **The associator re-route is now the realized proof** of `lem:tensorobj_assoc_iso`
   (gluing local `tensorObj_restrict_iso` isos via Hom-is-a-sheaf), and the old
   whiskering "current realization" paragraph is gone.
4. **The whiskering/stalk apparatus blocks are unpinned + marked superseded** (no
   dangling `\lean{}` pins): `lem:flat_whisker_localizer`,
   `lem:isiso_sheafification_map_of_W`, `lem:stalk_linear_map`,
   `lem:islocallyinjective_whisker_of_W`, `lem:whisker_of_W`, `lem:jw_ismonoidal`.
   Confirm no `\cref`/`\uses` elsewhere points at a now-deleted label (the blocks should
   still carry their `\label{}` as prose, so cross-refs remain resolvable).
5. **The `exists_tensorObj_inverse` (`lem:tensorobj_inverse_invertible`) proof prose is
   formalization-ready** — dual `L⁻¹ = Hom(L,O_X)`, local contraction iso via
   `tensorObj_restrict_iso` + `tensorObj_unit_iso`, glued over a trivialising cover.

Report a per-chapter verdict for `Picard_TensorObjSubstrate.tex` (complete?, correct?,
must-fix list) plus your usual whole-blueprint pass. If the focus chapter is
`complete + correct` with no must-fix, say so explicitly so the gate clears.
