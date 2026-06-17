# Blueprint Writer Report

## Slug
d2wiring

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes Made
- **Added coverage line** — `% archon:covers AlgebraicJacobian/Picard/TensorObjSubstrate/Vestigial.lean`
  appended to the existing `% archon:covers` block at the top of the chapter (matching style).
- **Added lemma** `\label{lem:W_implies_stalkwise_iso}` / `\lean{PresheafOfModules.isIso_stalkFunctor_map_of_W}`
  — the d.1-bridge: a morphism of presheaves of `R`-modules over `Opens X` lies in `J.W`
  (locally bijective) iff every `Ab`-stalk map is an isomorphism. Stated as a biconditional
  (forward + converse) so the conclusion step can run it in reverse.
  - Proof sketch added: Y. Unfolds `WEqualsLocallyBijective` to local injectivity + surjectivity,
    cites `TopCat.Presheaf.isIso_iff_stalkFunctor_map_iso`,
    `GrothendieckTopology.W.isLocallyInjective`,
    `TopCat.Presheaf.app_injective_iff_stalkFunctor_map_injective`, with the linear refinement
    deferred to `lem:stalk_linear_map`.
- **Added lemma** `\label{lem:stalk_tensor_commutation_naturality_right}` /
  `\lean{PresheafOfModules.stalkTensorIso_naturality_right}`
  — B-argument (second-factor) naturality of `stalkTensorIso`: the commuting square identifying
  `(A ◁ g)_x` with `LinearMap.lTensor A_x g_x`. This is the genuinely new ingredient.
  - Proof sketch added: Y. Reduce by `TensorProduct.induction_on` + `stalk_hom_ext` to germ
    generators `germ(a ⊗ m)`, evaluate both composites via `stalkTensorLinearMap_germ_tmul`
    and `stalkLinearMap_germ`, note the reverse-map analogue via `stalkTensorRev_germ_tmul`.
- **Revised** `lem:islocallyinjective_whiskerleft_via_stalk` proof — rewrote the thin sketch into
  the three concrete movements (a) d.1-bridge ⟹ `g_x` iso ⟹ `stalkLinearEquivOfIsIso`;
  (b) whiskered-stalk identification via the new naturality lemma;
  (c) flatness-free `LinearEquiv.lTensor` conclusion + converse d.1-bridge ⟹ `J.W` ⟹
  `GrothendieckTopology.W.isLocallyInjective`. Added the standing note that the lemma is stated
  over a general site but consumed only at `X.presheaf` (consumers `W_whiskerLeft_of_W` /
  `W_whiskerRight_of_W` → `tensorObj_assoc_iso`). The lemma statement block (and its existing
  `\leanok`) was left untouched.
- Added a one-paragraph lead-in before the three lemmas explaining the factoring.

## Cross-references introduced
- `\uses{lem:W_implies_stalkwise_iso, lem:stalk_tensor_commutation_naturality_right}` added to
  the proof of `lem:islocallyinjective_whiskerleft_via_stalk` — both labels are newly defined in
  this same chapter (immediately above), so they resolve.
- New lemmas `\uses{lem:stalk_linear_map}` and `\uses{lem:stalk_tensor_commutation}` — both exist
  in this chapter (lines ~1112 and ~1850).

## References consulted
- None opened this session. Per the directive, the two new lemmas and the rewritten proof are
  Archon-original assembly (no external source proof), so no `% SOURCE`/`% SOURCE QUOTE` blocks
  were written for them — the existing cited blocks (Kleiman, Stacks 01CR, Stacks
  lemma-stalk-tensor-product) were not modified.

## Macros needed (if any)
- None. Used only standard LaTeX (`array` environment inside `\[...\]`, `\triangleleft`,
  `\otimes`, `\xrightarrow`, `\big\downarrow`) already in use elsewhere in the chapter.

## Reference-retriever dispatches (if any)
- None.

## Notes for Plan Agent
- The two new lemma blocks are unmarked (no `\leanok`/`\mathlibok`) as expected — they are not yet
  formalized; `sync_leanok` will mark them once `isIso_stalkFunctor_map_of_W` and
  `stalkTensorIso_naturality_right` land in `Vestigial.lean` (or wherever the prover places them).
  The suggested Lean names in `\lean{...}` are the directive's; the prover may re-sign and the
  `\lean{...}` hint can be corrected by review if it diverges.
- `thm:rel_pic_addcommgroup_via_tensorobj` consumer-repoint to `thm:pic_commgroup` was left as-is
  per the directive (item 3 optional, standing note intact).
- The off-path duplicate `lem:islocallyinjective_whisker_of_W` was left untouched (out of scope).

## Strategy-modifying findings
(none)
