# Blueprint Writer Report

## Slug
subbrickA-decomp

## Status
COMPLETE — all four tasks delivered; no broken `\uses` (leandag `unknown_uses = 0`), no new isolated node, LaTeX environments balanced.

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made

### TASK 1 — Sub-brick A `\uses`-chain (7 new blocks) + Step-3 prose refinement
Added, as a new block group placed immediately after the `lem:cech_augmented_resolution`
proof:

- **Added lemma** `lem:cech_backbone_left_sigma` / `\lean{AlgebraicGeometry.cechBackbone_left_sigma}`
  — geometric bookkeeping: degree-`p` cover-nerve object `Y_p ≅ ∐_σ U_σ`, structure map
  `Sigma.desc (σ ↦ j_σ)`, `U_σ = coverInterOpen 𝒰 σ`. `\uses{def:cover_cech_nerve, def:cech_free_presheaf_complex}`. Proof: Y/N — Y (fibre-power-distributes-over-coproduct + fibre-product-of-open-immersions = intersection).
- **Added lemma** `lem:pushPull_sigma_iso` / `\lean{AlgebraicGeometry.pushPull_sigma_iso}`
  — **THE ONE NEW-INFRA LEAF**: `pushPullObj F Y_p ≅ ∏_σ pushPullObj F (Over.mk j_σ)`.
  `\uses{def:push_pull_obj, lem:cech_backbone_left_sigma, lem:coprodPresheafObjIso_mathlib, lem:isProductOfDisjoint_mathlib}`. Proof: Y — comparison map, check on `toPresheaf` (faithful/reflects-iso/preserves-limits), indexed disjoint-union decomposition iterating the binary Mathlib anchors.
- **Added lemma** `lem:pushPull_leg_sections` / `\lean{AlgebraicGeometry.pushPull_leg_sections}`
  — `Γ(V, pushPullObj F (Over.mk j_σ)) ≅ Γ(U_σ ∩ V, F)`.
  `\uses{def:push_pull_obj, def:cech_free_presheaf_complex, lem:pushforward_obj_obj_mathlib, lem:restrictFunctorIsoPullback_mathlib, lem:restrict_obj_mathlib}`. Proof: Y — three off-the-shelf identifications (two `rfl`-equalities + the restrict≅pullback iso).
- **Added lemma** `lem:pushPull_eval_prod_iso` / `\lean{AlgebraicGeometry.pushPull_eval_prod_iso}`
  — degreewise `Γ(V, pushPullObj F Y_p) ≅ ∏_σ Γ(coverInterOpen 𝒰 σ ⊓ V, F)`.
  `\uses{lem:pushPull_sigma_iso, lem:pushPull_leg_sections, lem:evaluation_preserves_products_mathlib}`. Proof: Y — assemble #2 + eval-preserves-products + #3.
- **Added lemma** `lem:cechSection_complex_iso` / `\lean{AlgebraicGeometry.cechSection_complex_iso}`
  — complex-level iso `D ≅ D'` (concrete section Čech complex over `coverInterOpen 𝒰 · ⊓ V`), differential match reuses `sectionCech_objD_apply`.
  `\uses{lem:pushPull_eval_prod_iso, lem:section_cech_objd_apply, lem:section_cech_product_equiv, def:cech_augmented_complex}`. Proof: Y.
- **Added lemma** `lem:cechSection_contractible` / `\lean{AlgebraicGeometry.cechSection_contractible}`
  — Sub-brick B: `Homotopy (𝟙 D') 0` because `V ≤ coverOpen 𝒰 i_fix` gives the family a maximum `U'_{i_fix}=V`; prepend = identity; dependent engine.
  `\uses{lem:cechSection_complex_iso, lem:cech_acyclic_affine, lem:cech_engine_complex, def:cech_free_presheaf_complex}`. Proof: Y. **See note on dependent-engine pin location below.**
- **Added lemma** `lem:cechSection_isZero_homology` / `\lean{AlgebraicGeometry.cechSection_isZero_homology}`
  — TOP consumed by `cechAugmented_exact`: `IsZero (D.homology p)` for `V ≤ coverOpen 𝒰 i`.
  `\uses{lem:cechSection_complex_iso, lem:cechSection_contractible, lem:isZero_homology_of_homotopy_id_zero}`. Proof: Y (transport #6 across #5, apply TASK-2 lemma).

- **Revised** `lem:cech_augmented_resolution` — added `lem:cechSection_isZero_homology` to both
  the lemma's `\uses{}` and the proof's `\uses{}`; refined Step 3 items (b), (c), (d) prose to
  cite the new chain (b → `lem:cechSection_complex_iso`/`lem:pushPull_eval_prod_iso`/`lem:pushPull_sigma_iso`/`lem:cech_backbone_left_sigma`/`lem:pushPull_leg_sections`; c → `lem:cechSection_contractible`; d → `lem:isZero_homology_of_homotopy_id_zero` + closing sentence naming `lem:cechSection_isZero_homology` as the single discharger). **Steps 1–2 untouched; SOURCE QUOTE blocks untouched.**

### TASK 2 — standalone homotopy-kills-homology lemma
- **Added lemma** `lem:isZero_homology_of_homotopy_id_zero` / `\lean{AlgebraicGeometry.isZero_homology_of_homotopy_id_zero}`
  — `Homotopy (𝟙 D) 0 ⟹ IsZero (D.homology p)` via homotopy-invariance of the induced map. Archon-original (no source). Proof: Y.

### TASK 3 — `\mathlibok` anchors (5 new; `restrict_obj` reused)
- `lem:pushforward_obj_obj_mathlib` / `\lean{AlgebraicGeometry.Scheme.Modules.pushforward_obj_obj}` (verified Sheaf.lean:155).
- `lem:restrictFunctorIsoPullback_mathlib` / `\lean{AlgebraicGeometry.Scheme.Modules.restrictFunctorIsoPullback}` (verified Sheaf.lean:371).
- `lem:evaluation_preserves_products_mathlib` / `\lean{SheafOfModules.evaluationPreservesLimitsOfShape}` (verified Limits.lean:85, namespace `SheafOfModules`).
- `lem:coprodPresheafObjIso_mathlib` / `\lean{AlgebraicGeometry.Scheme.coprodPresheafObjIso}` (verified Limits.lean:479).
- `lem:isProductOfDisjoint_mathlib` / `\lean{TopCat.Sheaf.isProductOfDisjoint}` (verified PairwiseIntersections.lean:430).
- **Reused existing** `lem:restrict_obj_mathlib` (`\lean{AlgebraicGeometry.Scheme.Modules.restrict_obj}`, already `\mathlibok` at chapter L4027) for `restrict_obj` — did NOT duplicate.

All five new anchors marked `\mathlibok` only (verified the real decl names exist in the local
Mathlib checkout before marking).

### TASK 4 — OpenImmersionPushforward coverage debt
- **Added lemma** `lem:pushforward_sections_functor` covering BOTH
  `\lean{AlgebraicGeometry.pushforwardSectionsFunctor}` and
  `\lean{AlgebraicGeometry.pushforwardSectionsFunctor_additive}` in one block. `\uses{lem:higher_direct_image_presheaf}`.
- **Added lemma** `lem:isZero_presheafToSheaf_of_sections_locally_zero` /
  `\lean{CategoryTheory.GrothendieckTopology.isZero_presheafToSheaf_of_sections_locally_zero}` — the
  sectionwise strengthening; prose explains why the objectwise `of_locally_isZero` form is
  insufficient (affine opens not downward-closed). `\uses{lem:sheafify_kills_locally_zero}`.
- **Revised** `lem:isZero_of_faithful_preservesZeroMorphisms` — added the import-isolation
  duplicate `\lean{CategoryTheory.Functor.isZero_of_faithful_preservesZeroMorphisms}` as a second
  `\lean{}` line on the existing block plus a `% NOTE:` explaining the duplication. `\leanok` left
  untouched.
- **Fixed dependencies** `lem:open_immersion_pushforward_comp` — added
  `lem:isZero_presheafToSheaf_of_sections_locally_zero` and `lem:pushforward_sections_functor`
  to both the lemma-level and proof-level `\uses{}` (wiring only — prose/Bridge (3) NOT rewritten,
  per out-of-scope constraint). This keeps the two new helper blocks non-isolated.

## Cross-references introduced
All resolved (leandag `unknown_uses = 0`). New edges reference these pre-existing labels, all
confirmed present in this chapter:
- `def:cover_cech_nerve` (L279), `def:cech_free_presheaf_complex` (L1374, pins `coverOpen`/`coverInterOpen`),
  `def:push_pull_obj` (L297), `def:cech_augmented_complex`.
- `lem:section_cech_objd_apply` (L858), `lem:section_cech_product_equiv` (L799).
- `lem:cech_acyclic_affine` (L1182, pins the dependent engine `depDiff`/`depHomotopy`/`depHomotopy_spec`/`depDiff_exact`),
  `lem:cech_engine_complex` (L1891, pins `le_coverInterOpen_iff`).
- `lem:restrict_obj_mathlib` (L4027), `lem:higher_direct_image_presheaf`, `lem:sheafify_kills_locally_zero`,
  `lem:isZero_presheafToSheaf_of_locally_isZero`.

## References consulted
None opened this round — the entire Sub-brick A chain is Archon-original project infrastructure
(directive: "no external source needed for the sub-lemmas"). `lem:cech_augmented_resolution` keeps
its existing Stacks `% SOURCE QUOTE PROOF:` (untouched). No `% SOURCE`/`% SOURCE QUOTE` lines were
written or fabricated.

## Macros needed
None — only standard macros (`\operatorname`, `\coprod`, `\amalg`, `\sqcup`, `\sqcap`, `\hookrightarrow`,
`\mathcal`, `\mathrm`) plus the chapter's existing `\v C` Čech convention.

## Reference-retriever dispatches
None.

## Notes for Plan Agent

1. **Dependent-engine pin location.** The Lean decls `CombinatorialCech.depDiff` /
   `depHomotopy` / `depHomotopy_spec` / `depDiff_exact` (which `cechSection_contractible` reuses)
   have NO standalone blueprint block — their only `\lean{}` pins live inside
   `lem:cech_acyclic_affine` (L1182). I therefore wired `lem:cechSection_contractible` with
   `\uses{lem:cech_acyclic_affine}`. This is the honest DAG edge given the current pin layout, but it
   creates a semantic edge to the *standard-cover affine-vanishing* lemma rather than to the
   bare combinatorial engine. If the engine is being de-privatized this iter, consider giving the
   `Dependent` engine its own small block so downstream consumers can `\uses` it directly without
   pulling in the affine-vanishing statement.

2. **Broken `\lean{}` pin in `lem:open_immersion_pushforward_comp` (out of my scope, flagged by
   the iter-054 OIP checker).** `\lean{AlgebraicGeometry.isAffineHom_of_affine_separated}` points at
   a `private lemma`, whose mangled environment name will not resolve. The directive did not list
   this for me to touch and de-privatization status is uncertain, so I left it. Either drop the pin
   or have the scaffolder make the declaration non-private.

3. **`unmatched_lean = 64` in leandag.** This is expected: the 8 new project `\lean{}` targets
   (`cechBackbone_left_sigma`, `pushPull_sigma_iso`, `pushPull_leg_sections`, `pushPull_eval_prod_iso`,
   `cechSection_complex_iso`, `cechSection_contractible`, `cechSection_isZero_homology`,
   `isZero_homology_of_homotopy_id_zero`) plus the 2 OIP helper names will not match Lean decls until
   the scaffolder creates the stubs this iter. The 5 new `\mathlibok` anchors point at real Mathlib
   decls (verified) and carry no Archon obligation.

## Strategy-modifying findings
None. The decomposition matches `analogies/subbrickA.md` exactly (one new-infra leaf
`pushPull_sigma_iso`; everything else off-the-shelf Mathlib or project reuse), and the route closes
`lem:cech_augmented_resolution`'s residual without altering any frozen signature
(`cech_computes_higherDirectImage` untouched).
