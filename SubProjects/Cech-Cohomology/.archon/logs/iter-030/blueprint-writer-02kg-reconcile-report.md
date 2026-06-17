# Blueprint Writer Report

## Slug
02kg-reconcile

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made

### A. `lem:cover_datum_bridge` — repinned to the landed open-level decl
- **Revised** `lem:cover_datum_bridge`: repinned `\lean{}` from the non-existent
  `AlgebraicGeometry.coverDatum_bridge` to the landed axiom-clean
  `AlgebraicGeometry.coverOpen_affineOpenCoverOfSpan`.
- Rewrote the statement to the open-level identity `coverOpen 𝒰 i = D(s_i)` (dropped the
  "full section-Čech-complex identification" claim) and rewrote the proof to match.
- Renamed the human title to "Standard-cover opens are the distinguished opens \(D(s_i)\)".
- Replaced the iter-029 `% NOTE` with a RESOLVED note: the fork is gone (family-form
  `injective_cech_acyclic` discharges the field directly); this lemma survives only as the
  open-level identity relating standard-cover opens to `D(s_i)`, off the `injective_acyclic`
  discharge path.
- **Rewired `\uses{}`**: `def:basis_cov_system` → `def:standard_affine_cover` (statement + proof).

### B. `lem:injective_cech_acyclic` — recorded the family-form generalization
- **Revised** statement prose: added a paragraph stating the positive-degree clause is
  established over an arbitrary finite family of opens (no covering hypothesis; stalkwise
  exactness of the augmented free Čech resolution; covering only fixes the augmentation
  target), so it discharges the cover-system `injective_acyclic` field directly.
- `\lean{}` pin name unchanged (`AlgebraicGeometry.injective_cech_acyclic`).
- I did **not** add the optional `CategoryTheory.cechComplexFunctor` `\mathlibok` anchor — I
  could not verify that exact Mathlib name (loogle was timing out). Flagged below.

### C. `lem:affine_injective_acyclic` — demoted to a special case
- Replaced the iter-029 SCOPE-GAP `% NOTE` with a RESOLVED note: the field is now discharged
  directly by family-form `lem:injective_cech_acyclic`; this ⊤-case decl
  (`Ideal.span (Set.range s) = ⊤`) is a valid special case, no longer required for the field.
- Softened the overclaiming statement prose to the ⊤-case (spanning family ⇒ the `D(s_i)`
  cover `Spec R`); rewrote the proof to go via the open-level identity (now
  `lem:cover_datum_bridge`) + family-form `lem:injective_cech_acyclic`.
- `\uses{}` unchanged (`lem:injective_cech_acyclic, lem:cover_datum_bridge`) — both are still
  genuinely used by the ⊤-case proof.

### D. `def:affine_cover_system` — rewrote the discharge + removed "NOT YET BUILDABLE"
- Replaced the iter-029 "NOT YET BUILDABLE / design fork" `% NOTE` with a RESOLVED note:
  `injective_acyclic` discharged directly by family-form `lem:injective_cech_acyclic`,
  `surj_of_vanishing` by `lem:affine_surj_of_vanishing`; the single remaining blocker is the
  `surj_of_vanishing` geometry, not the injective field.
- **Rewired `\uses{}`**: dropped `lem:affine_injective_acyclic`; added `lem:injective_cech_acyclic`.
  New set: `def:basis_cov_system, lem:affine_faces_mem, lem:affine_surj_of_vanishing,
  lem:injective_cech_acyclic`.
- Fixed the "five fields" prose → "Beyond the basis \(\mathcal{B}\) and the covering set
  \(\mathrm{Cov}\) … it carries three proof fields" (faces_mem, surj_of_vanishing,
  injective_acyclic), with the injective field credited to the family-form lemma.

### E. `lem:affine_surj_of_vanishing` — rewrote proof to the local-surjectivity route, + new blocks
- Rewrote the proof sketch into the 3-step route: (1) module epi ⇒ (gap-fill) abelian-sheaf
  epi ⇒ locally surjective presheaf map; (2) local lifts on a cover, refined via
  `Scheme.isBasis_affineOpens` + cofinality to a standard cover `𝒰 ∈ Cov`; (3) `Ȟ¹(𝒰,S₁)=0`
  + `ses_cech_h1` glue to a global lift.
- **Added lemma** `lem:to_sheaf_preserves_epi` / `\lean{AlgebraicGeometry.toSheaf_preservesEpimorphisms}`
  — project gap-fill (NO `\mathlibok`): underlying-abelian-sheaf functor preserves epis. Proof
  sketch via exactness/cokernel-zero. `\uses{def:basis_cov_system}`.
- **Added Mathlib anchor** `lem:presheaf_is_locally_surjective` /
  `\lean{CategoryTheory.Presheaf.IsLocallySurjective}` `\mathlibok` (confirmed: used in
  `HigherDirectImagePresheaf.lean:71`).
- **Added Mathlib anchor** `lem:sheaf_locally_surjective_iff_epi` /
  `\lean{CategoryTheory.Sheaf.isLocallySurjective_iff_epi'}` `\mathlibok`. `\uses` the presheaf
  anchor.
- **Added Mathlib anchor** `lem:scheme_isBasis_affineOpens` /
  `\lean{AlgebraicGeometry.Scheme.isBasis_affineOpens}` `\mathlibok`.
- **Rewired `\uses{}`** on the lemma + proof to include the four new blocks.

### F. `lem:standard_cover_cofinal` — reconciled to the refinement role
- Kept statement + `\lean{}` pin. Added prose making it explicitly the refinement step E
  invokes (via `lem:scheme_isBasis_affineOpens`), turning a local-surjectivity covering into a
  standard cover in `Cov`.
- **Rewired `\uses{}`**: added `lem:scheme_isBasis_affineOpens`.

### G. `lem:qcoh_iso_tilde_sections` — coverage debt + 01I8 decomposition
- **Revised** main block: bundled the two simp accessors
  `qcoh_iso_tilde_sections_hom` / `qcoh_iso_tilde_sections_inv` into the `\lean{}` list; kept
  the conditional-form `% NOTE` (updated to reference the bundled accessors and the new
  decomposition remark + presentation block). Added `lem:qcoh_iso_tilde_sections_of_presentation`
  to `\uses{}`.
- **Revised** proof: added a note that the formalized body is the one-line conditional
  `(asIso F.fromTildeΓ).symm`, with the unconditional upgrade gated on the 01I8 instance.
- **Added lemma** `lem:qcoh_iso_tilde_sections_of_presentation` /
  `\lean{AlgebraicGeometry.qcoh_iso_tilde_sections_of_presentation}` — discharges
  `[IsIso fromTildeΓ]` from a global `F.Presentation`. Cites Stacks Tag 01I8
  (`lemma-quasi-coherent-affine`, verbatim statement). `\uses` the main block + the Mathlib anchor.
- **Added Mathlib anchor** `lem:isIso_fromTildeGamma_of_presentation` /
  `\lean{AlgebraicGeometry.isIso_fromTildeΓ_of_presentation}` `\mathlibok` (the Mathlib counit
  criterion).
- **Added remark** `rem:o1i8_decomposition` documenting the 3-step 01I8 route (global
  generation → presentation → counit iso), with a verbatim `% SOURCE QUOTE PROOF:` from Tag
  01I8's proof (stacks-schemes.tex L1287–1387, ellipsis-joined verbatim fragments).

## Cross-references introduced
- `lem:affine_surj_of_vanishing` now `\uses{lem:to_sheaf_preserves_epi,
  lem:presheaf_is_locally_surjective, lem:sheaf_locally_surjective_iff_epi,
  lem:scheme_isBasis_affineOpens}` (all defined in this chapter).
- `lem:standard_cover_cofinal` now `\uses{lem:scheme_isBasis_affineOpens}` (this chapter).
- `def:affine_cover_system` now `\uses{lem:injective_cech_acyclic}` (this chapter), dropped
  `lem:affine_injective_acyclic`.
- `lem:qcoh_iso_tilde_sections` ↔ `lem:qcoh_iso_tilde_sections_of_presentation` (mutual, this
  chapter); both reference `lem:isIso_fromTildeGamma_of_presentation` (this chapter).
- `rem:o1i8_decomposition` `\uses` the three qcoh blocks above (this chapter).
- Verified with `leandag build --json`: **unknown_uses = 0**, **0 isolated nodes in this
  chapter** (the one project-wide isolated node is an unrelated `lean_aux` Lean node).

## References consulted
- `references/stacks-schemes.tex` — Tag 01I8 `lemma-quasi-coherent-affine` (L1279–1285 statement,
  L1287–1387 proof) for `lem:qcoh_iso_tilde_sections_of_presentation` and `rem:o1i8_decomposition`
  verbatim quotes; also confirmed `lemma-equivalence-quasi-coherent` (L1389–1407).
- `references/stacks-cohomology.tex` — re-read `lemma-injective-trivial-cech` and
  `lemma-ses-cech-h1` context already cited in the affected blocks (no new quotes added; existing
  verbatim quotes left intact).
- Project Lean files cross-checked for exact decl names: `AlgebraicJacobian/Cohomology/
  QcohTildeSections.lean` (confirmed `qcoh_iso_tilde_sections_of_presentation`,
  `qcoh_iso_tilde_sections_hom`/`_inv`, the `## Handoff` 3-step decomposition mirrored in the
  remark) and `HigherDirectImagePresheaf.lean:71` (confirmed `Presheaf.IsLocallySurjective`).

## Macros needed (if any)
- None. `remark` is already defined in `blueprint/src/macros/common.tex` (`\newtheorem{remark}`);
  `\mathlibok` is in use elsewhere in the chapter.

## Reference-retriever dispatches (if any)
- None. Tag 01I8 verbatim text was already on disk in `references/stacks-schemes.tex`; the
  optional Hartshorne II.5.16/II.5.17 fetch was not needed (Stacks source sufficed).

## Notes for Plan Agent
**`\lean{}` / `\mathlibok` pins to confirm against Lean (loogle was timing out, could not
independently re-verify the exact Mathlib namespaces):**
- `lem:to_sheaf_preserves_epi` → `AlgebraicGeometry.toSheaf_preservesEpimorphisms` — a *plausible*
  name for the prover's gap-fill instance (NOT `\mathlibok`); prover should confirm/rename. The
  underlying Mathlib mechanism may instead be `SheafOfModules.toSheaf.PreservesEpimorphisms` as an
  instance — if the prover registers it under a Mathlib name, this block may become a `\mathlibok`
  anchor instead.
- `lem:sheaf_locally_surjective_iff_epi` → `CategoryTheory.Sheaf.isLocallySurjective_iff_epi'` —
  `\mathlibok` pin not independently re-verified; confirm exact name (primed vs unprimed; there is
  also `TopCat.Presheaf.isLocallySurjective_iff` for the space-level restatement).
- `lem:scheme_isBasis_affineOpens` → `AlgebraicGeometry.Scheme.isBasis_affineOpens` — `\mathlibok`
  pin believed correct; confirm.
- `lem:isIso_fromTildeGamma_of_presentation` → `AlgebraicGeometry.isIso_fromTildeΓ_of_presentation`
  — used UNQUALIFIED in `QcohTildeSections.lean` under `namespace AlgebraicGeometry`; the true
  Mathlib namespace may be `AlgebraicGeometry.Scheme.Modules.isIso_fromTildeΓ_of_presentation`.
  Confirm the fully-qualified name so the `\mathlibok` node matches in leandag.
- `lem:presheaf_is_locally_surjective` → `CategoryTheory.Presheaf.IsLocallySurjective` — confirmed
  present in the toolchain (used by the project), `\mathlibok` safe.
- Optional `CategoryTheory.cechComplexFunctor` `\mathlibok` anchor (directive item B, optional):
  NOT added — could not verify the exact Mathlib name. If the planner can confirm it, it would be a
  nice dependency anchor for `lem:injective_cech_acyclic`'s raw-family parameterization.

**Sibling-chapter consistency:** `def:basis_cov_system` (still in this chapter) correctly lists 5
fields and was left untouched per directive. No cross-chapter edits were required.

## Strategy-modifying findings
None. The reconciliation matches the resolved design fork; no statement turned out unprovable or to
have a consequence that fails to follow.
