# Blueprint Writer Report

## Slug
coverage-debt

## Status
COMPLETE — all five iter-045 helper declarations now carry blueprint blocks (three new
blocks; two private wrappers bundled into one of them), each with `\label`, `\lean`,
accurate `\uses`, and an informal proof sketch. `leandag` confirms all five are matched,
zero unknown_uses, zero conflicts, none of the new blocks isolated.

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made
- **Added lemma** `lem:modulesRestrictBasicOpen_smul_eq_genV` /
  `\lean{AlgebraicGeometry.modulesRestrictBasicOpen_smul_eq'}` — general-open-`V` companion of
  `lem:modulesRestrictBasicOpen_smul_eq`; tile action over arbitrary `V` transports (rfl/defeq) to
  the `F.val` structure-sheaf action over the iterated-image open `ι ''ᵁ V`.
  - `\uses{lem:tile_image_opens_identities}` (same as sibling, per directive). Proof sketch: Y.
  - Anchored immediately after its `V=⊤` sibling.
- **Added lemma** `lem:tile_section_ring_identity_genV` /
  `\lean{AlgebraicGeometry.tile_section_ring_identity', AlgebraicGeometry.appIso_inv_res,
  AlgebraicGeometry.appIso_inv_res_assoc}` — general-open-`V` companion of
  `lem:tile_section_ring_identity`. **The two private wrappers `appIso_inv_res` /
  `appIso_inv_res_assoc` are bundled into this block's `\lean{}`** (they get no separate block, per
  directive). Proof sketch: Y — derive from `V=⊤` by post-composing with the restriction
  `ι ''ᵁ V ≤ ι ''ᵁ ⊤`, pushing it through the two section isos (the two wrappers), residual
  `res(⊤≤⊤)=id` by thin-category Subsingleton.
  - `\uses{lem:tile_section_ring_identity}`. Anchored after its sibling.
- **Added lemma** `lem:tile_scalar_compat_genV` / `\lean{AlgebraicGeometry.tile_scalar_compat'}` —
  general-open-`V` companion of `lem:tile_scalar_compat`; `r • x` (R-action) `=` `(algebraMap R R_g r) • x`
  (R_g-action) at arbitrary `V`; the `V = D(f̄)` instance is the keystone scalar-tower sub-need.
  - `\uses{lem:modulesSpecToSheaf_smul_eq, lem:modulesRestrictBasicOpen_smul_eq_genV,
    lem:tile_section_ring_identity_genV}`. Proof sketch: Y — same shape as the `V=⊤` proof.
  - Anchored after its sibling.

### Label-naming note
The Lean decls carry a prime (`'`). Blueprint labels use a `_genV` suffix instead of `'`
(`lem:..._genV`) to avoid an apostrophe inside `\label`/`\ref` keys — no existing label in the
chapter uses a prime, and `_genV` ("general `V`") is unambiguous and tooling-safe. The `\lean{}`
pins keep the exact primed Lean names, so the DAG match is correct.

## Cross-references introduced
- `\uses{lem:tile_image_opens_identities}` in `lem:modulesRestrictBasicOpen_smul_eq_genV` — target exists (this chapter).
- `\uses{lem:tile_section_ring_identity}` in `lem:tile_section_ring_identity_genV` — exists (this chapter).
- `\uses{lem:modulesSpecToSheaf_smul_eq, lem:modulesRestrictBasicOpen_smul_eq_genV,
  lem:tile_section_ring_identity_genV}` in `lem:tile_scalar_compat_genV` — all exist (this chapter; latter two are the new blocks above).
- Prose `\ref{lem:tile_section_localization}`, `\ref{lem:tile_scalar_compat}`,
  `\ref{lem:modulesRestrictBasicOpen_smul_eq}`, `\ref{lem:tile_section_ring_identity}` — all pre-existing labels.
- `leandag build --json`: unknown_uses = ∅ (none mention `genV`), conflicts = ∅, all five Lean names matched,
  isolated = 1 (a pre-existing `lean_aux` node, chapter "—", not one of mine).

## References consulted
None — all three blocks are Archon-original / project-bespoke general-`V` companions. Their
`V=⊤` siblings carry no `% SOURCE:`/`% SOURCE QUOTE:` citation lines (they stand on the proof
sketch alone), so per citation discipline these companions likewise omit source lines. No
`reference-retriever` was needed; no `references/` file was opened.

## Macros needed (if any)
None. All commands used (`\Spec`, `\Gamma`, `\rho`, `\theta`, `\beta`, `\alpha`, `\lambda`,
`\iota`, `\hookrightarrow`, `\texttt`, `\emph`, …) already appear in the sibling blocks.
Removed a transient `\(\hom\)` I had typed in the second block's proof, replacing it with the
prose "explicit order-restriction maps and image opens" to avoid relying on an undefined macro.

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- `lem:tile_section_localization` (line ~4738) and its Step-4 sketch were left untouched per
  directive. Its surrounding prose at lines ~4802–4813 already contains a `% NOTE (review iter-045)`
  asking the planner to author this `tile_scalar_compat'` block and "refresh this paragraph to cite
  it as done" — that paragraph still says the V=D(f̄) compat is a pending generalisation. With
  `lem:tile_scalar_compat_genV` now in place, a follow-up writer pass on the `tile_section_localization`
  block could cite `\ref{lem:tile_scalar_compat_genV}` there and drop the stale NOTE. Out of scope this round.
- `lem:tile_scalar_compat_genV` is a leaf (outgoing `\uses` only); it becomes an incoming edge target
  for `lem:tile_section_localization` once that block's `\uses` is updated in the deferred pass. Not
  isolated (it has outgoing edges), so no DAG action needed now.
- No `\leanok` added (owned by `sync_leanok`); no `\mathlibok` added (these are project-bespoke, not Mathlib anchors).

## Strategy-modifying findings
None.
