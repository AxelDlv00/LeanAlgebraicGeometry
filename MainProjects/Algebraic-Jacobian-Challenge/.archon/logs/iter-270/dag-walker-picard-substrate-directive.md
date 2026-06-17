# DAG Walker Directive

## Slug
picard-substrate

## Seed
lem:isinvertible_implies_locallytrivial

## Strategy context
Phase A.1.c.sub — the comparison iso of pullback with tensor on line bundles
(loc-triv), the active critical-path lane. Chapter
`Picard_TensorObjSubstrate.tex` (consolidated, covers the TensorObjSubstrate/*
files) plus `Picard_RelPicFunctor.tex` (the relative Picard sheaf this substrate
feeds, phase A.1.c.fun).

## Depth / scope
Walk the cone of the seed across `Picard_TensorObjSubstrate.tex` and
`Picard_RelPicFunctor.tex`. PRIMARY job: dependency transcription + `\lean{}`
pinning. Do NOT rewrite proven statements/proofs.

### Isolated leaves to wire (their proofs are already cited by `\cref{}` in the
chapter but the edge was never put in `\uses{}` — convert those into real
`\uses{}` edges on the consuming blocks):
- lem:isiso_sheafification_map_of_W (referenced near line 5120)
- lem:pullback_val_iso_natural (referenced at lines 3324, 3362)
- def:scheme_modules_homMk (referenced at line 6545)
Find each block that `\cref{}`s these in its statement/proof and add the label to
that block's `\uses{}`.

### Gap nodes needing a `\lean{}` pin (and wiring into the cone):
In `Picard_TensorObjSubstrate.tex`:
- lem:flat_whisker_localizer
- lem:stalk_linear_map
- lem:islocallyinjective_whisker_of_W
- lem:whisker_of_W
- lem:jw_ismonoidal
- lem:stalk_tensor_commutation_naturality_right
In `Picard_RelPicFunctor.tex`:
- thm:rel_pic_etale_sheaf_unit_canonical

For each, inspect the covered Lean file for the real declaration name and pin
`\lean{<real.name>}` if it exists; otherwise pin `\lean{AlgebraicGeometry.TODO.<label>}`
per DAG integrity rule 1. Then verify each one's `\uses{}` matches the
dependencies its mathematics uses, adding missing edges. Note `lem:stalk_linear_map`
is an umbrella lemma whose prose names several Lean decls — pin it to the most
representative one (or the TODO placeholder) and wire it to its consumers.

## Out of scope
Remarks (`rem:`/`rmk:`) are exempt — do not wire them. Do not add `\leanok`. Do
not alter the substrate's proven `pullback_tensor_*` proof bodies beyond `\uses{}`.

## References
- `references/kleiman-picard.md` (§4 existence, relative Picard sheaf) and
  `references/nitsure-hilbert-quot.md` — only if a block here lacks a citation
  line; do not rewrite existing cited prose.
