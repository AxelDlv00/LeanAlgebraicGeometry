# Blueprint Writer Report

## Slug
iter054

## Status
COMPLETE — all five directive tasks executed; chapter is valid LaTeX, leandag clean (no
unknown_uses, no conflicts, my new nodes wired, the only remaining isolated node is a
pre-existing `lean_aux`, not mine).

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made

- **Task 1 — expanded Step 3 of `lem:cech_augmented_resolution` proof.** Appended a clearly
  delimited sub-paragraph "Step 3, formalization mechanism" (the existing math prose is
  preserved untouched) with an enumerated (a)–(e) route naming, in project notation, the Lean
  mechanism a prover instantiates:
  - (a) residual = `IsZero` of the homology of the section cochain complex `Γ(V, augmented Čech)`
    for `V ≤ U_{i_fix}`, as the evaluation-at-`V`-through-`toPresheaf` of the augmented complex;
  - (b) identification with the concrete `D^• = ∏_σ Γ(U_σ ∩ V, F)` cochain complex via
    map-of-homological-complexes naturality + per-degree product-of-sections iso (cross-ref
    `lem:cech_free_eval_sectionwise`, `lem:cech_free_eval_engine_iso`) — flagged as the project-side L1 work;
  - (c) prepend-`i_fix` is the identity on each section term (`U_{i_fix σ}∩V = U_σ∩V`), giving
    a homotopy `id ≃ 0` with components `combHomotopy i_fix`, relation `combHomotopy_spec`
    (cross-ref `lem:cech_free_eval_prepend_homotopy` + `_spec`);
  - (d) `id ≃ 0` ⟹ vanishing homology via the homotopy-invariance / identity-equals-zero
    characterization combo (cross-ref the new `lem:isZero_of_faithful_preservesZeroMorphisms`);
  - (e) DEAD END recorded: build the homotopy directly (mirror `lem:cech_free_eval_nonempty`); do
    NOT route via simplicial `ExtraDegeneracy` — it yields a *chain*-complex homotopy equivalence
    (face maps), wrong variance for the *cochain* (coface) Čech complex; no cosimplicial dual exists.
  Also added one sentence to Step 4 tying the augmentation/degree-0 term to the same identification (b)
  + homotopy (c), with the `i_fix`-component map `s ↦ s_{i_fix}` landing in `F(U_{i_fix}∩V)=F(V)`.

- **Task 2 — added two helper lemma blocks** (clears DAG coverage debt; both matched their project
  Lean decls — not in `unmatched_lean`):
  - **Added lemma** `\label{lem:isZero_of_faithful_preservesZeroMorphisms}` /
    `\lean{AlgebraicGeometry.isZero_of_faithful_preservesZeroMorphisms}` — a faithful zero-preserving
    functor reflects zero objects; one-line proof via the identity-equals-zero characterization +
    faithfulness (`map_injective`, `map_id`, `map_zero`). Archon-original; no `% SOURCE` lines.
  - **Added lemma** `\label{lem:isZero_presheafToSheaf_of_locally_isZero}` /
    `\lean{AlgebraicGeometry.isZero_presheafToSheaf_of_locally_isZero}` — a presheaf objectwise zero on
    a covering sieve has zero sheafification; proof wraps `lem:sheafify_kills_locally_zero` into the
    locally-zero / covering-sieve form (local injectivity from subsingleton fibres + free local
    surjectivity into the zero target). Archon-original; no `% SOURCE`. Placed adjacent to and
    `\uses`-linked from `lem:sheafify_kills_locally_zero`.
  Both wired into `lem:cech_augmented_resolution`'s **statement** `\uses` (and proof `\uses`).

- **Task 3 — expanded the proof of `lem:open_immersion_pushforward_comp`.** Appended a
  "Formalization route" paragraph naming the three bridges in project notation:
  - Bridge (1): objectwise homology of `f_*I^•` at `V` ↔ absolute cohomology presheaf
    `V ↦ Hⁿ(f⁻¹V,G)=Extⁿ(j_!O_{f⁻¹V},G)` via `extAddEquivCohomologyClass ∘ homologyAddEquiv`
    (→ `Extⁿ ≅ Hⁿ(Hom(X[0],I^•))`), then corepresentability `j_!O_U ⊣ Γ(U,-)` degreewise to turn the
    Hom-complex into the section/pushforward complex, `cochainComplexXIso` matching ℕ/ℤ indexing; the
    `rightDerived` side settled by the existing `isoRightDerivedObj` identification (cross-ref
    `lem:higher_direct_image_presheaf` and the new anchor `lem:ext_homcomplex_mathlib`). Recorded that
    no separate `rightDerived = Ext` comparison lemma is needed.
  - Bridge (2): Serre-vanishing transport to a general affine `V` — `j` affine so `j⁻¹V`/`U∩f⁻¹V`
    affine, transport along `isoSpec` + naturality of absolute cohomology.
  - Bridge (3): module-sheafification analogue of `lem:sheafify_kills_locally_zero` /
    `lem:isZero_presheafToSheaf_of_locally_isZero` via the `toSheaf∘sheafify ≅ presheafToSheaf∘forget`
    square, locally-zero hypothesis from (1)+(2).
  Updated **statement** + proof `\uses` to add `lem:acyclic_resolution_computes_derived`,
  `lem:sheafify_kills_locally_zero`, `lem:isZero_presheafToSheaf_of_locally_isZero`,
  `lem:ext_homcomplex_mathlib`.

- **Task 4 — bundled `isAffineHom_of_affine_separated`.** Added
  `AlgebraicGeometry.isAffineHom_of_affine_separated` as a third entry in the `\lean{...}` list of
  `lem:open_immersion_pushforward_comp` (matched in the DAG — no longer `unmatched`). Item (1) prose
  already justifies it.

- **Task 5 — Mathlib dependency anchor (done).** Added `\label{lem:ext_homcomplex_mathlib}` with
  `\mathlibok`, `\lean{}` naming `CategoryTheory.InjectiveResolution.extAddEquivCohomologyClass`,
  `CochainComplex.HomComplex.homologyAddEquiv`,
  `CategoryTheory.InjectiveResolution.cochainComplexXIso`. Dropped `isoRightDerivedObj` from this
  anchor because it already has a dedicated `\mathlibok` anchor `lem:right_derived_injective_resolution`
  (in Cohomology_AcyclicResolution.tex); the new anchor `\uses{lem:right_derived_injective_resolution}`
  and the prose points to it for the rightDerived side. `\mathlibok` is on this anchor only, never on a
  project to-be-proved decl.

## Cross-references introduced
- `lem:cech_augmented_resolution` (statement+proof `\uses`): added
  `lem:cech_free_eval_prepend_homotopy_spec`, `lem:isZero_of_faithful_preservesZeroMorphisms`,
  `lem:isZero_presheafToSheaf_of_locally_isZero` (proof `\uses` additionally lists
  `lem:cech_free_eval_sectionwise`, `lem:cech_free_eval_engine_iso`, `lem:cech_free_eval_nonempty`).
- `lem:isZero_presheafToSheaf_of_locally_isZero` `\uses{lem:sheafify_kills_locally_zero}` — exists in this chapter.
- `lem:open_immersion_pushforward_comp` (statement+proof `\uses`): added
  `lem:acyclic_resolution_computes_derived` (in Cohomology_AcyclicResolution.tex),
  `lem:sheafify_kills_locally_zero`, `lem:isZero_presheafToSheaf_of_locally_isZero`,
  `lem:ext_homcomplex_mathlib`.
- `lem:ext_homcomplex_mathlib` `\uses{lem:right_derived_injective_resolution}` — exists in
  Cohomology_AcyclicResolution.tex.

All verified with `leandag build --json`: 0 relevant `unknown_uses`, 0 conflicts. The `\lean{}` names
for `lem:ext_homcomplex_mathlib` appear under `unmatched_lean` — expected and correct for a Mathlib
anchor (they are Mathlib decls, not project decls; `\mathlibok` marks the node done). DAG note below.

## References consulted
- `analogies/deepbridge.md` — the iter-054 api-alignment analysis. Source of every named Mathlib decl
  used as formalization guidance: the `Homotopy.homologyMap_eq`/`homologyMap_id`/`homologyMap_zero`/
  `IsZero.iff_id_eq_zero` combo (Step-3 mechanism (d)); the `ExtraDegeneracy` variance dead-end (e);
  `extAddEquivCohomologyClass`, `homologyAddEquiv`, `cochainComplexXIso`, `isoRightDerivedObj`
  (Bridge (1) + anchor). All `% SOURCE`/`% SOURCE QUOTE` blocks in edited declarations were preserved
  verbatim — no new external-source citation blocks were authored this round, so no `references/`
  Stacks/textbook files were re-opened for quoting.

## Macros needed (if any)
- None. All new prose uses existing macros / standard math; no new `\foo` introduced.

## Reference-retriever dispatches (if any)
- None. The named Lean/Mathlib decls came from `analogies/deepbridge.md`; no external literature
  retrieval was required (the existing `% SOURCE QUOTE` blocks already cover the Stacks statements).

## Notes for Plan Agent
- **leandag reads only the STATEMENT-block `\uses` for edges, not the proof-block `\uses`.** This is
  why the directive's "update the proof `\uses`" instructions did not, by themselves, create DAG edges
  or clear the isolated `lem:isZero_of_faithful_preservesZeroMorphisms` node. I added the dependencies
  to the **statement** `\uses` of both `lem:cech_augmented_resolution` and
  `lem:open_immersion_pushforward_comp` (in addition to the proof blocks) so the DAG now reflects them.
  If other chapters rely on proof-block `\uses` for DAG edges, they may have silently-missing edges too.
- `lem:ext_homcomplex_mathlib`'s `\lean{}` targets show under `unmatched_lean` (expected for a Mathlib
  anchor). If the project later re-exports these under a project namespace, the anchor's `\lean{}` can be
  repointed; until then `\mathlibok` correctly marks it done. The decl existence is asserted by
  `analogies/deepbridge.md` ("CONFIRMED, real"), not independently re-verified against Mathlib by me.

## Strategy-modifying findings
None. The prose surfaced no strategy-level issue; both residuals are confirmed PROCEED-with-Mathlib-idiom
(per `analogies/deepbridge.md`), and the chapter now names the precise mechanisms for each.
