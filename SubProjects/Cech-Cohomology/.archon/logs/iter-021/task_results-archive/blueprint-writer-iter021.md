# Blueprint Writer Report

## Slug
iter021

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Summary
All of TASK A (A1–A5), TASK B (B1–B2), and TASK C (C1–C2) are done. After the pass:
- `archon dag-query unmatched` = **0 of 0** (was 24) — every previously-unmatched Lean
  decl now has a blueprint home, including the 24th (`iInf_fin_succ`, the private lattice
  helper behind `basicOpen_sprod`, not in the directive's explicit list — bundled into
  `def:qcoh_sections_localized`).
- `leandag build --json` → `unknown_uses: []` (no broken `\uses`); none of the new nodes
  isolated.
- The FreeCechEngine + differential-match nodes exist with accurate `\uses{}`.
- Every private-`CombinatorialCech.*` reference in the free-eval proof sketches is gone,
  replaced by the public `FreeCechEngine.*` names.
- `lem:section_cech_homology_exact` now references `ShortComplex.ab_exact_iff` (NOT
  `moduleCat_exact_iff`) with its 3-sub-lemma chain.

The 4 new `\lean{}` names that intentionally do NOT yet exist in Lean (prover targets,
appear only in the reverse "blueprint→no-lean" list): `cechFreeEvalEngineIso`,
`sectionCechProductEquiv`, `sectionCechCofaceMatch`, `sectionCechAbExact`. No `\leanok`
added anywhere.

## Changes Made

### TASK A — Free-complex route (FreePresheafComplex.lean)
- **Added lemma** `\label{lem:free_cech_engine}` / `\lean{...9 FreeCechEngine.* +
  isZero_sigma_of_forall_isZero}` (A2 + part of A5) — the constant-coefficient
  combinatorial Čech contracting-homotopy engine (`combDifferential`(`_comp`/`_exact`/
  `_eq_of_cocycle`), `combHomotopy`(`_spec`/`_zero`), `combSign_flip`,
  `cons_comp_succAbove_succ`), plus the generic coproduct-of-zeros helper
  `isZero_sigma_of_forall_isZero`. Carries the `% NOTE:` that `FreeCechEngine.*` is a
  deliberate public free-side copy of the private `CombinatorialCech.*` engine. Source
  reused from the `lemma-homology-complex` proof region (verbatim differential + `h`
  quote, references/stacks-cohomology.tex L1245–1268).
- **Added lemma** `\label{lem:cech_free_eval_engine_iso}` /
  `\lean{AlgebraicGeometry.cechFreeEvalEngineIso}` (A1, the CHURNING corrective,
  to-be-built) — degreewise iso `((eval V).mapHomologicalComplex).obj
  (cechFreePresheafComplex 𝒰) ≅ C•` with `C•_p = ∐_{σ:Fin(p+1)→I₁(V)} O_X(V)` and
  differential `FreeCechEngine.combDifferential`; proof sketch covers the index split
  (`freeYonedaEval_iso_of_le`/`_isZero_of_not_le`) and the differential match via
  `cechFreeSimplicial.map` reindexing + `Limits.Sigma.hom_ext`. `\uses{lem:cech_free_eval_sectionwise,
  lem:free_cech_engine}`. Placed between sectionwise and empty.
- **Revised** `lem:cech_free_eval_sectionwise` (A4) — `\lean{}` now also lists
  `freeYonedaEval_iso_of_le`, `freeYonedaEval_isZero_of_not_le`; prose sentence added
  describing the 3-piece full identification.
- **Revised** `lem:cech_free_eval_empty` (A5) — `\lean{}` now lists
  `cechFreeEval_isZero_of_isEmpty`, `coverStructurePresheaf_eval_isZero_of_isEmpty`,
  `isZero_homology_of_isZero_X`; `\uses{lem:free_cech_engine}` added; prose note naming
  the bricks.
- **Revised** `lem:cech_free_eval_prepend_homotopy` + `..._spec` (A3 + A1) — private
  `CombinatorialCech.combHomotopy`/`_spec`/`cons_comp_succAbove_succ`/`combSign_flip`
  references replaced by public `FreeCechEngine.*`; `\uses` extended with
  `lem:cech_free_eval_engine_iso`, `lem:free_cech_engine`.
- **Revised** `lem:cech_free_eval_nonempty` and `lem:cech_free_complex_quasi_iso` (A1) —
  `\uses{lem:cech_free_eval_engine_iso}` added; the stray private-name reference in the
  `quasi_iso` proof prose also fixed to `FreeCechEngine.*`.

### TASK B — Section route (CechAcyclic.lean)
- **Revised** `def:qcoh_sections_localized` (B1) — `\lean{}` now also lists
  `basicOpen_sprod`, `qcohRestriction_eq_comparison`, and `iInf_fin_succ` (the 24th
  decl); two-paragraph prose addition describing the multi-index intersection identity
  and the item-(5) restriction-is-comparison brick.
- **Revised** `lem:section_cech_homology_exact` (B2) — replaced the wrong
  `ShortComplex.moduleCat_exact_iff` route with `ShortComplex.ab_exact_iff` +
  product-equivalence route; statement now notes the degree-`p` object is the
  *categorical product `∏ᶜ` in Ab*, and states the directed top-level form
  `1 ≤ p ⇒ IsZero(homology p)` (the form `sectionCech_affine_vanishing` consumes).
  `\uses` extended with the 3 sub-lemma labels; proof body rewritten to the 3-step chain.
- **Added 3 sub-lemmas** (B2, to-be-built):
  - `\label{lem:section_cech_product_equiv}` / `\lean{AlgebraicGeometry.sectionCechProductEquiv}`
    — `ToType(∏ᶜ Fσ) ≃ ∀σ, ToType(Fσ)` via `Concrete.productEquiv`, per-σ identified with
    `dCoeff` by `IsLocalizedModule` uniqueness.
  - `\label{lem:section_cech_coface_match}` / `\lean{AlgebraicGeometry.sectionCechCofaceMatch}`
    — `alternatingCofaceMapComplex` degree-`p` differential = `∑ⱼ(-1)ʲ Pi.lift(...)`, each
    restriction matched to `AwayComparison.comparison` via `qcohRestriction_eq_comparison`
    + `basicOpen_sprod`, identifying with `dDiff`.
  - `\label{lem:section_cech_ab_exact}` / `\lean{AlgebraicGeometry.sectionCechAbExact}` —
    `IsZero(homology p)` for `1 ≤ p` via `exactAt_iff_isZero_homology` +
    `ShortComplex.ab_exact_iff`, transporting `dDiff_exact` across the product equivalence.

### TASK C — Bridge route (CechBridge.lean)
- **Added lemma** `\label{lem:cech_complex_op_identification}` /
  `\lean{homCechComplexMapOpIso, homCechComplex_d_eq, homCechCosimplicial_δ}` (C1) — the
  opposite-transport iso `homCechComplex ≅ (preadditiveYoneda.obj F).mapHomologicalComplex
  ∘ HomologicalComplex.op (cechFreePresheafComplex)`; bundles the two private drivers.
  `\uses{lem:cech_complex_hom_identification, def:cech_free_presheaf_complex}`.
- **Added lemma** `\label{lem:section_cech_complex_mapop_iso}` /
  `\lean{sectionCechComplexMapOpIso}` (C1) — the composite
  `homCechComplexMapOpIso⁻¹ ≫ cechComplex_hom_identification`.
  `\uses{lem:cech_complex_op_identification, lem:cech_complex_hom_identification}`.
- **Added lemma** `\label{lem:hom_into_injective_exact}` /
  `\lean{preadditiveYoneda_obj_preservesFiniteColimits_of_injective,
  quasiIso_map_preadditiveYoneda_of_injective}` (C1) — `Hom(-,I)` exact ⇒ preserves
  homology ⇒ carries quasi-isos to quasi-isos, for general abelian category; project-bespoke
  (mechanism pointer to `lem:injective_of_adjoint`).
- **Revised** `lem:injective_cech_acyclic` (C2) — `\uses` (statement + proof) extended with
  `lem:cech_complex_op_identification`, `lem:section_cech_complex_mapop_iso`,
  `lem:hom_into_injective_exact`; added a "Categorical assembly" paragraph describing the
  op / map-through-`preadditiveYoneda.obj I` / transport-across-`sectionCechComplexMapOpIso`
  route.

## Cross-references introduced (all resolve — `unknown_uses: []`)
- `lem:section_cech_homology_exact` → `lem:section_cech_product_equiv`,
  `lem:section_cech_coface_match`, `lem:section_cech_ab_exact` (all in this chapter).
- `lem:cech_free_eval_engine_iso`, `lem:free_cech_engine` consumed by the prepend/nonempty/
  quasi-iso free-eval lemmas (this chapter).
- `lem:cech_complex_op_identification`, `lem:section_cech_complex_mapop_iso`,
  `lem:hom_into_injective_exact` consumed by `lem:injective_cech_acyclic` (this chapter).

## References consulted
- `references/summary.md` — source index.
- `references/stacks-cohomology.tex` (L1227–1285) — verbatim differential + contracting-map
  `h` quotes for `lem:free_cech_engine` and `lem:cech_free_eval_engine_iso` (the
  `lemma-homology-complex` proof region, same region already cited by the sectionwise lemma).
- (Existing `% SOURCE QUOTE` blocks for `lem:section_cech_homology_exact`,
  `def:qcoh_sections_localized`, the free-eval lemmas, and `lem:injective_cech_acyclic`
  were reused as-is; no new external citations fabricated. The three new section sub-lemmas
  and the three new bridge blocks are project-bespoke decomposition/categorical-machinery
  steps and carry no external `% SOURCE` per citation discipline.)

## Macros needed
- None. Used only base/amsmath macros (`\prod^{c}` for `∏ᶜ`, `\bigcap`, `\coprod`,
  `\operatorname`). Replaced a draft `\bigsqcap`/`\ggg`/`\operatorname{Pi.\pi}` with
  base-LaTeX-safe forms (`\bigcap`, "followed by", `\pi`).

## Reference-retriever dispatches
- None (all needed sources already in `references/`).

## Notes for Plan Agent
- `def:qcoh_sections_localized` now bundles `iInf_fin_succ` (a `private` lemma in
  CechAcyclic.lean). It was the only unmatched decl outside the directive's explicit list;
  bundling it into the basic-open-intersection prose was the natural home and clears the
  coverage debt to 0. Flagging in case you'd prefer it elsewhere.
- The directive's `lem:cech_free_eval_engine_iso` `\lean{}` is pinned to the to-be-built
  `cechFreeEvalEngineIso`; this plus the 3 section sub-lemmas (`sectionCechProductEquiv`,
  `sectionCechCofaceMatch`, `sectionCechAbExact`) are the new prover targets this round.
  They show up in `leandag build --json`'s `unmatched_lean` (blueprint→no-lean) list, which
  is expected — `archon dag-query unmatched` (lean→no-blueprint) is the acceptance metric
  and is 0.
- `lem:cech_acyclic_affine` still legitimately lists the private `CombinatorialCech.*`
  names in its `\lean{}` (those ARE the real names in CechAcyclic.lean); I left them
  untouched — A3 scoped the rename to the FreePresheafComplex-side free-eval proofs only.

## Strategy-modifying findings
- None. The corrected `ab_exact_iff` route and the differential-match decomposition are
  internal proof-structure fixes consistent with the existing strategy; nothing surfaced
  that changes STRATEGY.md.
