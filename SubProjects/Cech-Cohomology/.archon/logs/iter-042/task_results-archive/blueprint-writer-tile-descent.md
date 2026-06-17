# Blueprint Writer Report

## Slug
tile-descent

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made
- **Added lemma** `\lemma`/`\label{lem:isLocalizedModule_powers_restrictScalars_of_algebraMap}`/`\lean{AlgebraicGeometry.isLocalizedModule_powers_restrictScalars_of_algebraMap}` — base-ring descent: an `A`-linear localisation at `powers(algebraMap R A f)` restricts to an `R`-linear localisation at `powers f` under a scalar tower. Placed just before `lem:tile_section_localization` (after `lem:localized_module_map_exact_mathlib`). One-line informal proof records the scalar-tower identity `f^k·x = f_A^k·x` and the `Module.End.isUnit_iff` reduction. No `\leanok`/`\mathlibok` added (sync owns it; it is a project lemma, not a Mathlib re-export — it is the *converse* of `IsLocalizedModule.of_restrictScalars`, which Mathlib lacks).
- **Added sub-lemma A** `\label{lem:tile_image_opens_identities}` (no `\lean{}` pin yet; `% NOTE` flags deferred reconciliation) — the two image opens of the affine tile identification `ι : Spec R_g ≅ D(g) ↪ X`: `ι(Spec R_g) = D(g)` and `ι(D(f̄)) = D(gf) = D(g)∩D(f)`, via `PrimeSpectrum.basicOpen_mul`. Includes the exact `''ᵁ`-form opens from the directive. Proof notes these are set-level, not definitional, equalities.
- **Added sub-lemma B** `\label{lem:tile_section_comparison}` (no `\lean{}` pin yet; `% NOTE` flags deferred reconciliation) — the load-bearing natural `R_g`-linear isomorphism `Γ_{R_g}(V, F_(g)) ≅ Γ_R(ι(V), F)` intertwining restrictions. Proof spells out the local-ring `Γ(M,-)` (where `restrict_obj` is rfl) vs global-ring `modulesSpecToSheaf.obj` mismatch, the `globalSectionsIso` restrict-scalars bookkeeping, and states explicitly the two carriers are not even defeq (base ring + opens).
- **Revised** `lem:tile_section_localization` — rewrote the proof to the honest 5-step descent (global presentation → `R_g`-localisation → opens identities → non-rfl section comparison → base-ring descent to `R`). Added a `% NOTE` recording that the old `bridge.md` B6 "section comparison is restrict_obj-rfl" recipe is UNSOUND. Updated BOTH `\uses{}` (statement + proof) to add `lem:isLocalizedModule_powers_restrictScalars_of_algebraMap`, `lem:tile_image_opens_identities`, `lem:tile_section_comparison`, keeping the existing deps. Non-circularity paragraph preserved.
- **Revised** `lem:qcoh_section_equalizer` — added `AlgebraicGeometry.res_trans_apply` to its `\lean{...}` list so the private restriction-functoriality helper gets a real DAG coverage edge (statement/proof prose untouched, as directed).

## Cross-references introduced
- `\uses{lem:isLocalizedModule_powers_restrictScalars_of_algebraMap}` in `lem:tile_section_localization` (statement + proof) — target added in this same chapter.
- `\uses{lem:tile_image_opens_identities, lem:tile_section_comparison}` in `lem:tile_section_localization` (statement + proof) — targets added in this same chapter.
- Sub-lemma B `\uses{lem:tile_image_opens_identities, lem:restrict_obj_mathlib, lem:presentation_modulesRestrictBasicOpen}`; sub-lemma A `\uses{lem:presentation_modulesRestrictBasicOpen}` — all in-chapter.
- Verified with `leandag build --json`: `unknown_uses = []` (no broken refs); my chapter has 0 isolated nodes (the single project-wide isolated node is an unrelated `lean_aux`). `res_trans_apply` is NOT in `unmatched_lean` → it matched a live Lean decl. `isLocalizedModule_powers_restrictScalars_of_algebraMap` also matched a live Lean decl (already proved, as the directive stated).

## References consulted
None — this content is project-bespoke categorical/algebraic plumbing (Stacks 01HV(4)/01I8 already cited elsewhere in the chapter; the directive confirmed no new retrieval needed). No new `% SOURCE`/`% SOURCE QUOTE` blocks were authored.

## Macros needed (if any)
- None new. Only `\Spec` (already in `macros/common.tex`) plus standard `\operatorname`/`\mathcal`/`\mathrm`. The `''ᵁ`-image notation is rendered as `''^{\mathrm U}` inline (chapter-local, no macro).

## Reference-retriever dispatches (if any)
- None.

## Notes for Plan Agent
- Sub-lemmas A (`lem:tile_image_opens_identities`) and B (`lem:tile_section_comparison`) carry no `\lean{}` pin yet — their Lean decls are to-build. Each has a `% NOTE` to reconcile the pin once built. When the prover lands the section-comparison construction, name the new decls and the review agent (or next writer) should add the `\lean{}` pins so leandag matches them.
- Sub-lemma B's proof estimates the construction at ~100–150 LOC (per the iter-041 diagnosis) — this is the genuine remaining cost on the keystone route, not wiring.

## Strategy-modifying findings
None. The decomposition fix is internal to the chapter; the non-circularity hinge (localisation on the tile, never the global `F`) is unchanged and the keystone-at-`g` statement is still not invoked.
