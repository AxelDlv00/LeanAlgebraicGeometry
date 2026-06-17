# Blueprint Writer Report

## Slug
cofacematch

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made
- **Added lemma** `\lemma`/`\label{lem:section_cech_objd_apply}`/`\lean{AlgebraicGeometry.sectionCech_objD_apply, AlgebraicGeometry.sectionCechFaceRestr}` — the abstract cosimplicial unfold: read through `sectionCechProductEquiv`, the underlying group action of `objD q` is `∑ᵢ (-1)ⁱ • sectionCechFaceRestr(σ,i)(x(σ∘δᵢ))`. Inserted BEFORE `lem:section_cech_coface_match`. Purely cosimplicial, no sheaf/localisation content; Archon-original (no external source). `\uses{def:section_cech_complex, lem:section_cech_product_equiv}`.
  - Proof sketch added: Y — unfold `alternatingCofaceMapComplex.objD` as alternating sum of `Pi.lift` cofaces; push projection through with `sectionCechProductEquiv_apply` + `ab_hom_finsetSum_apply` + `Pi.lift_π`.
- **Rewrote** `lem:section_cech_coface_match` — kept `\lean{AlgebraicGeometry.sectionCechCofaceMatch}` (still aspirational). Changed `\uses` to `{lem:section_cech_objd_apply, def:qcoh_sections_localized, def:section_cech_module_complex}`. Restated for the active **tilde case** `F = tilde M`. Proof now explicitly layers (i) abstract unfold (`lem:section_cech_objd_apply`) and (ii) the tilde F-bridge: the per-coordinate `AddEquiv` φ_σ (the `IsLocalizedModule` comparison, unique by `AwayComparison.comparison_unique`, via `qcohSectionsAwayLocalized`+`basicOpen_sprod`), the naturality square = `qcohRestriction_eq_comparison`, and the accessor reconciliation (`toPresheafOfModules…presheaf.obj` vs `modulesSpecToSheaf`/`tilde.toOpen` ModuleCat sections). Added a `% NOTE:` flagging the general-`F` 01I8 globalisation as separately deferred.
- **Rewrote** `lem:section_cech_ab_exact` — added `AlgebraicGeometry.sectionCech_isZero_homology_of_objD_exact` and `AlgebraicGeometry.ab_hom_finsetSum_apply` to `\lean{}` (alongside aspirational `AlgebraicGeometry.sectionCechAbExact`). `\uses` now includes `lem:section_cech_objd_apply`. Proof recast to two layers: the DONE precursor `sectionCech_isZero_homology_of_objD_exact` (IsZero homology given `Function.Exact` of consecutive `objD`, via `exactAt_iff_isZero_homology` + `HomologicalComplex.exactAt_iff'` + `ShortComplex.ab_exact_iff_function_exact`), and the ladder transport `Function.Exact.of_ladder_addEquiv_of_exact` discharging the hypothesis (vertical maps `e_p = ∏φ_σ ∘ sectionCechProductEquiv`, squares from `sectionCech_objD_apply` + coface match, `H = dDiff_exact`).
- **Revised** `lem:section_cech_product_equiv` — added `AlgebraicGeometry.sectionCechProductEquiv_apply` to `\lean{}`; added a sentence describing the coordinate-projection restatement.
- **Revised** `lem:section_cech_homology_exact` — added `lem:section_cech_objd_apply` to statement `\uses`; prose now names the abstract-unfold→tilde-bridge split and states the tilde case is the active target (general `F` deferred to 01I8).
- **Revised** `lem:cech_acyclic_affine` (proof) — added `lem:section_cech_objd_apply`, `lem:section_cech_coface_match` to proof `\uses`; reduction paragraph now states the tilde case is the gap-free active target and general `F` reduces via 01I8.

## Coverage outcome (verified via leandag)
All five previously-unmatched decls are now matched to blueprint nodes:
- `ab_hom_finsetSum_apply` → `lem:section_cech_ab_exact`
- `sectionCechFaceRestr` → `lem:section_cech_objd_apply`
- `sectionCechProductEquiv_apply` → `lem:section_cech_product_equiv`
- `sectionCech_isZero_homology_of_objD_exact` → `lem:section_cech_ab_exact`
- `sectionCech_objD_apply` → `lem:section_cech_objd_apply`

`leandag build`: `unknown_uses: []`, `isolated: 0`. The remaining unmatched_lean entries (`sectionCech_homology_exact`, `sectionCechCofaceMatch`, `sectionCechAbExact`, `sectionCech_affine_vanishing`) are the aspirational to-be-built top-level decls, unchanged by this round. Env begin/end balance: 82/82.

## Cross-references introduced
- `\uses{lem:section_cech_objd_apply}` in `lem:section_cech_coface_match`, `lem:section_cech_ab_exact`, `lem:section_cech_homology_exact`, and proof of `lem:cech_acyclic_affine` — target is the new block in this same chapter (verified present).

## References consulted
- None opened this round for new verbatim quotes. The tilde-bridge facts (Tag 01HV items (4)–(5) and the 01I8 globalisation note) are already cited verbatim in `def:qcoh_sections_localized`; the new `lem:section_cech_objd_apply` is Archon-original (purely cosimplicial), so carries no external source block.

## Macros needed (if any)
- None. All commands used (`\widetilde`, `\operatorname`, `\check`, etc.) are standard / already in use in the chapter.

## Notes for Plan Agent
- `ab_hom_finsetSum_apply` is `private` in `CechAcyclic.lean` but the directive requested coverage under `AlgebraicGeometry.ab_hom_finsetSum_apply`; leandag matched it fine. If the prover later needs it cross-file it would have to be de-privatised, but for blueprint coverage it is now anchored.
- The coface-match proof sketch names `IsLocalizedModule.iso` / `AwayComparison.comparison_unique` for φ_σ and `qcohRestriction_eq_comparison` for the naturality square. The prover building `sectionCechCofaceMatch` owns the accessor-reconciliation infrastructure (`toPresheafOfModules…presheaf.obj` ↔ ModuleCat `tilde.toOpen` sections); this is flagged in the rewritten prose and the `% NOTE:`.

## Strategy-modifying findings
None. The decomposition encodes the iter-021 decision (tilde-first, 01I8 deferred) without re-opening it.
