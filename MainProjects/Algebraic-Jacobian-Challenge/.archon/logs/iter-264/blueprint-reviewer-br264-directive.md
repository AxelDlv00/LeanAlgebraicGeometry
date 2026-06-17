# Blueprint-reviewer directive — br264 (fast-path scoped re-review)

This is a same-iter fast-path re-review after a blueprint-writer + blueprint-clean round. Two chapters
were patched this iter to clear must-fix adequacy failures flagged last iter (lvb-di263, lvb-cech263,
lvb-tos263). Confirm whether each now clears the HARD GATE (complete + correct + no must-fix) so its
prover lane can dispatch THIS iter. You may read the whole blueprint for cross-chapter context, but the
gate verdict I need is specifically for these two chapters.

## Chapter 1 — `Picard_TensorObjSubstrate.tex`
Backs two active prover lanes: DUAL (`DualInverse.lean`, `lem:slice_dual_transport` /
`lem:dual_restrict_iso`) and D3′ Sq1 (`lem:pullback_tensor_map_basechange`). Verify the bw-tos264 fixes:
1. [was must-fix] `lem:slice_dual_transport` naturality: must now correctly state that the module-map
   equation needs the ε-naturality of `restrictScalars` along `β_W` (NOT just `Subsingleton.elim`).
2. [was major] `invFun`: must name the open-image down-set coverage fact + `image_preimage_of_le`, the
   component formula, and the `Iso.inv_hom_id`/`hom_inv_id` round-trip recipe.
3. [was major] `map_smul'`: must include the β-naturality ring identity `s = (β.app W').hom c`
   (`termRingMap_naturality` + `β.naturality`) and `restrictScalars.smul_def'`.
4. [was major, lvb-tos263] D3′ Sq1 tail goal form (`sheafificationCompPullback_comp_tail`, the
   composite-adjunction-unit identity `B_{h≫f}.unit`) + the Sq4 `pullbackValIso` standalone sub-lemma.

## Chapter 2 — `Cohomology_CechHigherDirectImage.tex`
Backs the ENGINE lane (`CechHigherDirectImage.lean`, push-pull functor `G`). Verify the bw-cech264 fixes:
1. [was must-fix] `sec:cech_three_part` para (2): the Sq1-coupling claim must be REMOVED/corrected — the
   functor laws `pushPullMap_id`/`pushPullMap_comp` use only Mathlib's `Pseudofunctor (LocallyDiscrete
   Schemeᵒᵖ) (Adj Cat)` coherences, independent of project Sq1.
2. [was must-fix] A lemma block (`lem:push_pull_functor` or similar) with `\lean{}` hints +
   proof sketch for `pushPullMap_id`/`pushPullMap_comp` (the `conjugateEquiv_pullbackComp_inv` →
   `pseudofunctor_*` route).
3. [was major] `\lean{}` pins for `pushPullObj`, `pushPullMap`, `coverArrow`, `coverCechNerve`,
   `relativeCechComplexOfNerve`.

## Output
For EACH of the two chapters: `complete: true|false`, `correct: true|false`, and any remaining
must-fix-this-iter finding. If both clear with no must-fix, say so explicitly — that green-lights the
three prover lanes (DUAL, D3′, ENGINE) this iter. If a chapter still fails, name precisely what remains.
