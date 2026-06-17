# Blueprint Writer Report

## Slug
iter062

## Status
COMPLETE — all four coordinated edits applied; LaTeX balanced, `leandag` shows `unknown_uses: []` and no newly-isolated nodes.

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made

### EDIT 1 — CSI `lem:pushPull_binary_coprod_prod`
- **Revised `\lean{...}`** — appended the two axiom-clean private helpers
  `AlgebraicGeometry.isIso_prodLift_of_isLimit` and `AlgebraicGeometry.coprodDecompMap` to the
  existing `\lean{AlgebraicGeometry.pushPull_binary_coprod_prod}` list. Both matched live Lean decls in
  `leandag` (no longer `unmatched_lean`), so their dependency edges are now carried (no separate
  lemma blocks created, per directive).
- **Added `% NOTE:` block inside the proof** documenting the two Lean-level blockers handed off by the
  iter-061 prover: (a) the `toPresheaf … ⋙ evaluation` composite-instance trap and its fix via
  `SheafOfModules.evaluation V` + `Scheme.Modules.Hom.isIso_iff_isIso_app`; (b) the Ab→ModuleCat
  bridge via `isLimitOfReflects` through `forget₂`, the `⊥`/sup open identities as
  `Scheme.coprodPresheafObjIso` `h₂`/`h₁`, and cone-leg matching via `restrictAdjunction_unit_app_app`
  (rfl). LaTeX comment only; does not render.

### EDIT 2 — OpenImm: new node `lem:pushforward_iso_qcoh_of_slice_qcoh`
- **Added lemma** `\label{lem:pushforward_iso_qcoh_of_slice_qcoh}` immediately before
  `lem:pushforward_iso_preserves_qcoh`, with
  `\lean{AlgebraicGeometry.pushforward_iso_qcoh_of_slice_qcoh,
  AlgebraicGeometry.coversTop_preimage_of_iso}` (bundling the private cover-transport helper, which
  matched a live Lean decl) and `\uses{lem:isQuasicoherent_of_coversTop_mathlib,
  lem:nonempty_quasicoherentData_mathlib}`. Statement: qcoh of an iso-pushforward reduces to qcoh of
  its preimage-transported slices; proof = cover-transport (`Sieve.ofObjects` /
  `Opens.grothendieckTopology`) + the cover criterion.

### EDIT 3 — OpenImm: retarget `lem:pushforward_iso_preserves_qcoh` to the `pullback ψ_r` route
- **Added build-target sub-lemma** `\label{lem:slice_structureSheaf_hom}`
  (`\lean{AlgebraicGeometry.sliceStructureSheafHom}`, marked `% NOTE: build target …`): the slice
  structure-sheaf ring map `ψ_r` over `V`, restricting the structure-sheaf morphism `φ.hom` induces to
  the over-category via the Beck–Chevalley `Over.post ⋙ Over.forget = Over.forget ⋙ F` (rfl) modulo the
  unit-iso `Over.map` adjustment. Archon-original; no source line (per directive).
- **Added build-target sub-lemma** `\label{lem:pushforward_slice_pullback_iso}`
  (`\lean{AlgebraicGeometry.pushforwardSlicePullbackIso}`, `% NOTE: build target …`,
  `\uses{lem:slice_structureSheaf_hom}`): the comparison iso `(pullback ψ_r).obj(H.over W transported)
  ≅ (Φ H).over V`, from the pullback-unit iso + the opens-equivalence `rfl`. (3rd optional node folded
  into the main proof body rather than split out.)
- **Revised `lem:pushforward_iso_preserves_qcoh`** `\uses` (statement + proof, both occurrences):
  now `{lem:slice_structureSheaf_hom, lem:pushforward_slice_pullback_iso,
  lem:pushforward_iso_qcoh_of_slice_qcoh, lem:presentation_map_mathlib,
  lem:presentation_ofIsIso_mathlib, lem:nonempty_quasicoherentData_mathlib,
  lem:isAffineOpen_image_of_iso_mathlib}`. **Removed** `lem:pushforward_commutes_restriction` and
  `lem:pushforwardPushforwardEquivalence_mathlib` (and the now-redundant
  `lem:isQuasicoherent_of_coversTop_mathlib`, which is carried by the slice lemma). Rewrote the
  per-member transport paragraph to route the presentation transport through the left-adjoint
  `pullback ψ_r` (`Presentation.map` → comparison iso `Presentation.ofIsIso` → per-slice qcoh →
  `pushforward_iso_qcoh_of_slice_qcoh`). Statement block + Stacks `% SOURCE`/`% SOURCE QUOTE` left
  intact.

### EDIT 4 — Demote `lem:pushforward_commutes_restriction`; delete dead coyoneda anchors
- **Annotated `lem:pushforward_commutes_restriction`** with `% NOTE: superseded …` near its label.
  Block retained; nothing on the live `pushforward_iso_preserves_qcoh` chain `\uses` it any more.
- **Removed** `lem:compCoyonedaIso_mathlib` and `lem:coyoneda_fullyFaithful_mathlib` (the two dead
  `\mathlibok` coyoneda anchors). **Reworded** the `lem:jshriek_transport_along_iso` proof: the
  three-step chain now reads as a corepresentability-uniqueness transport (no `coyoneda` full-faithful
  reflection, no `compCoyonedaIso`), matching the iter-060 `CorepresentableBy.uniqueUpToIso` closure.
  No dangling `\ref` to either deleted label remains (verified by grep).

## Cross-references introduced
- `lem:pushforward_iso_qcoh_of_slice_qcoh` `\uses{lem:isQuasicoherent_of_coversTop_mathlib,
  lem:nonempty_quasicoherentData_mathlib}` — both exist in this chapter.
- `lem:pushforward_slice_pullback_iso` `\uses{lem:slice_structureSheaf_hom}` — exists (new, same
  chapter).
- `lem:pushforward_iso_preserves_qcoh` now `\uses` the three new nodes + `lem:presentation_map_mathlib`,
  `lem:presentation_ofIsIso_mathlib`, `lem:nonempty_quasicoherentData_mathlib`,
  `lem:isAffineOpen_image_of_iso_mathlib` — all exist in this chapter.

## References consulted
- None opened this session. All four edits are `% NOTE:` annotations, `\lean{}`/`\uses{}` rewiring,
  deletion of two `\mathlibok` Mathlib anchors, and Archon-original build-target prose (the `ψ_r`
  construction is project-bespoke Mathlib-gap infrastructure — no external source line per directive).
  The retained Stacks `% SOURCE QUOTE` on `lem:pushforward_iso_preserves_qcoh` was left untouched.

## Verification
- `leandag build --json`: `unknown_uses: []`, `conflicts: []`. `unmatched_lean` = the three intended
  build targets (`sliceStructureSheafHom`, `pushforwardSlicePullbackIso`,
  `pushforward_iso_preserves_qcoh`), each carrying a `% NOTE: build target` marker. The bundled
  helpers (`isIso_prodLift_of_isLimit`, `coprodDecompMap`, `pushforward_iso_qcoh_of_slice_qcoh`,
  `coversTop_preimage_of_iso`) all matched live Lean decls.
- Project-wide isolated count = 1 (a pre-existing `lean_aux` node, unrelated); none of the touched
  nodes are isolated. The two deleted coyoneda anchors are gone.
- LaTeX environment balance: lemma/proof/definition/enumerate all begin==end.

## Macros needed (if any)
- None.

## Reference-retriever dispatches (if any)
- None.

## Notes for Plan Agent
- `lem:pushforward_commutes_restriction` and `lem:pushforwardPushforwardEquivalence_mathlib` remain
  used by the *other* per-slice presentation route elsewhere in the chapter (around the B-series
  decomposition, lines ~4129–4290); only the `pushforward_iso_preserves_qcoh` edge was removed, so
  those blocks are not orphaned.
- The three new build targets (`sliceStructureSheafHom`, `pushforwardSlicePullbackIso`, and the
  retargeted `pushforward_iso_preserves_qcoh` body) are the prover's next OpenImm work-items; the
  `ψ_r` construction (`lem:slice_structureSheaf_hom`) is the genuine ~100–150 LOC Mathlib gap.

## Strategy-modifying findings
None.
