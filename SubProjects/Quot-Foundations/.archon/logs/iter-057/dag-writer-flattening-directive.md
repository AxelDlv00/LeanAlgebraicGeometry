# Blueprint Writer Directive

## Slug
flattening-gf-g3

## Target chapter
blueprint/src/chapters/Picard_FlatteningStratification.tex

## Strategy context
This chapter covers the generic-flatness lemma (Nitsure §4). The algebraic core is done; the
remaining work is the geometric G3 chain "per-patch freeness ⟹ flatness over the local base".
This directive does two small, surgical things to restore the blueprint's 1-to-1 Lean coverage and
wire four currently-isolated Mathlib anchors into the graph. It adds NO new mathematics — every
statement below already exists, proved sorry-free, in `FlatteningStratification.lean`.

## Required content

1. **New lemma block: G3.4 stalk flatness over the local base via transitivity.**
   - `\label{lem:gf_stalk_flat_localBase}`
   - `\lean{AlgebraicGeometry.gf_stalk_flat_localBase}`
   - `\uses{lem:mathlib_localization_flat, lem:mathlib_flat_trans}`
   - Place it immediately AFTER the existing block `lem:gf_flat_base_local_on_source`
     (around line 1904) and BEFORE `lem:gf_localizedModule_baseChange_tensor_comm`.
   - Statement (project notation): Let `R` be a commutative ring, `S ⊆ R` a submonoid, and `R'`
     the localization of `R` at `S` (so `R'` is flat over `R`). Let `N` be an `R'`-module,
     regarded as an `R`-module through the scalar tower `R → R' → N`. If `N` is flat over `R'`,
     then `N` is flat over `R`.
   - Geometric application (mention in one sentence, no Lean): with `R = 𝒪_{S,x}`,
     `R' = 𝒪_{S,p(y)}` a localization of `R` (because `p(y)` is a generization of `x`), and
     `N = F_y`, this upgrades "`F_y` flat over `𝒪_{S,p(y)}`" to "`F_y` flat over `𝒪_{S,x}`".
   - Proof sketch (two lines): `R'` is flat over `R` because it is a localization of `R`
     (\cref{lem:mathlib_localization_flat}); `N` is flat over `R'` by hypothesis; transitivity of
     flatness along `R → R' → N` (\cref{lem:mathlib_flat_trans}) gives `N` flat over `R`.
   - This is a project-bespoke (Archon-original) composition of two Mathlib results — NO external
     source citation block; the block stands on its proof sketch.

2. **Wire `lem:mathlib_flat_localization_preserves` into the graph.** The block
   `lem:gf_flat_localizedModule_sameBase` (B1, around line 1929) already `\cref`s
   `lem:mathlib_flat_localization_preserves` in its contrast note ("the existing Mathlib results
   localize over a submonoid of the base..."). Add `lem:mathlib_flat_localization_preserves` to
   that block's `\uses{}` (both the statement-level and proof-level `\uses{}` lines) so the anchor
   is no longer isolated. Do NOT change the prose.

3. **Wire `lem:mathlib_flat_of_localized_maximal` into the graph.** The block
   `lem:gf_flat_base_local_on_source` (G3.3, around line 1883) already `\cref`s
   `lem:mathlib_flat_of_localized_maximal` in its proof note. Add
   `lem:mathlib_flat_of_localized_maximal` to that block's proof `\uses{}` line (it currently
   lists only `lem:mathlib_flat_of_isLocalized_maximal`). Do NOT change the prose.

## Out of scope
- Do NOT touch the algebraic-core blocks, the G3.1/B1.0/B1/two-leg/comparison proof bodies, or any
  block other than the three named above.
- Do NOT add `\leanok` (managed by sync_leanok). The two contrast anchors are already `\mathlibok`.
- Do NOT invent new Mathlib anchors — `lem:mathlib_localization_flat`, `lem:mathlib_flat_trans`,
  `lem:mathlib_flat_localization_preserves`, `lem:mathlib_flat_of_localized_maximal` all already
  exist in this chapter.

## References
None needed — all content is project-bespoke and already present in the Lean file.

## Expected outcome
One new lemma block `lem:gf_stalk_flat_localBase` wired to two Mathlib flatness anchors, plus two
added `\uses{}` edges that pull the two contrast anchors into the dependency graph. After this,
`leandag show isolated` reports zero isolated blueprint nodes in this chapter and
`gf_stalk_flat_localBase` is no longer an uncovered Lean declaration.
