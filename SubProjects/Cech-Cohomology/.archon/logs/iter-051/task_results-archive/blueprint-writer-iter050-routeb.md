# Blueprint Writer Report

## Slug
iter050-routeb

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made
- **Removed** `lem:tilde_section_changeOfBase` (per-σ sheaf section iso, route A) — deleted statement
  + proof; directive-authorized. It needed the Mathlib-absent tilde base-change sheaf iso.
- **Removed** `lem:section_cech_changeOfBase_iso` (cochain iso through `Spec R_f`, route A) — deleted
  statement + proof; directive-authorized.
- **Added lemma** `lem:away_comparison_isLocalizedModule` —
  `\lean{AlgebraicGeometry.AwayComparison.comparison_isLocalizedModule}`. Project-local infrastructure
  anchor (NOT `\mathlibok` — project-owned) for the localisation-transitivity engine
  `M_a[1/b] = M_{ab}` that builds the degreewise `M_{gσ} ≅ (M_f)_{gσ}` iso. Inserted where the deleted
  route-A blocks stood.
- **Revised** `lem:affine_cech_vanishing_tilde_subcover` (the residual):
  - Added `\lean{AlgebraicGeometry.sectionCech_homology_exact_of_localizationAway}` (statement block
    previously had no `\lean{}`), pinning the new public theorem the prover builds in `CechAcyclic.lean`.
  - Statement `\uses{}` retargeted from the route-A labels to:
    `lem:section_cech_module_exact, lem:section_cech_homology_exact,
    lem:affine_cover_span_localizationAway, lem:away_comparison_isLocalizedModule,
    def:cech_cohomology_accessor`.
  - Updated the TODO/NOTE comment to describe the pinned `sectionCech_homology_exact_of_localizationAway`
    target (built in `CechAcyclic.lean`, where the polymorphic `SectionCechModule`/`SectionCechTilde`
    core is in scope).
  - **Rewrote the proof** to the change-of-RING argument: instantiate the polymorphic
    `SectionCechModule.dDiff_exact` (`lem:section_cech_module_exact`) over `R_f = Localization.Away f`
    with the `R_f`-spanning family `g/1` (`lem:affine_cover_span_localizationAway`); transfer
    positive-degree exactness back to the `R`-side via the degreewise `M_{gσ} ≅ (M_f)_{gσ}` AddEquiv
    ladder (`lem:away_comparison_isLocalizedModule`, with the `gσ ∈ √(f)` invertibility witness from
    `D(gσ) ⊆ D(f)`); wrap exactness as `IsZero` homology as in `lem:section_cech_homology_exact`.
    Carried over the existing `% SOURCE QUOTE PROOF` (the Stacks "Write U = Spec(A) … the Čech complex …
    is identified with ∏ M_{f_{i₀}} → …" step — identical for route B). Proof `\uses{}` set to
    `lem:section_cech_module_exact, lem:section_cech_homology_exact,
    lem:affine_cover_span_localizationAway, lem:away_comparison_isLocalizedModule`.
- **No change to** `lem:affine_cech_vanishing_qcoh` (Task 3): its statement and proof `\uses{}` never
  referenced the deleted route-A labels (verified by grep); Step 2 already cites
  `lem:affine_cech_vanishing_tilde_subcover` (unchanged).
- **Left intact** (still used): `lem:affine_cover_span_localizationAway`,
  `lem:cechCohomology_isZero_of_iso`, `lem:cech_acyclic_affine`, and the route-A helper lemmas
  `lem:modules_restrict_basicOpen` / `lem:tilde_section_isLocalizedModule` (heavily referenced
  elsewhere — deleting the two route-A blocks did NOT orphan them).

## Cross-references introduced
- `\uses{lem:away_comparison_isLocalizedModule}` added in `lem:affine_cech_vanishing_tilde_subcover`
  (statement + proof) — the new anchor block in the same chapter.
- `\uses{lem:section_cech_module_exact}` and `\uses{lem:section_cech_homology_exact}` added in the
  residual — both exist in this same chapter.
- Verified with `leandag build --json`: `unknown_uses` is **empty** (all edges resolve); the new
  anchor's `\lean{comparison_isLocalizedModule}` matched a real project Lean decl;
  `sectionCech_homology_exact_of_localizationAway` correctly shows as `unmatched_lean` (the not-yet-built
  prover target). The single isolated node is a pre-existing `lean_aux`, unrelated to these edits.

## References consulted
- `analogies/02kg-residual-changeofbase.md` — route-B (change-of-ring) recommendation: which
  polymorphic Lean nodes to reuse (`dDiff_exact`, `sectionCech_homology_exact`), the `AwayComparison`
  toolkit, the `gσ ∈ √(f)` invertibility witness, and the co-location of the new public theorem in
  `CechAcyclic.lean`.
- (No new `% SOURCE`/`% SOURCE QUOTE` blocks authored — the residual's existing Stacks
  `lemma-cech-cohomology-quasi-coherent-trivial` quotes were carried over verbatim, not regenerated;
  the new anchor is project-local with no external source.)

## Macros needed (if any)
- None. `\sqrt{(f)}`, `\operatorname{LocalizedModule}`, `\operatorname{Submonoid.powers}`,
  `\widetilde{}` all already in use elsewhere in the chapter.

## Notes for Plan Agent
- The residual's `\lean{}` now pins `AlgebraicGeometry.sectionCech_homology_exact_of_localizationAway`,
  a new PUBLIC theorem to be added directly in `CechAcyclic.lean` (per the analogist's Decision 2:
  co-locating it there keeps the `private SectionCechModule`/`SectionCechTilde` core in scope — zero
  refactor, no `private → public` flip). The prover objective should target that file/name.
- `lem:away_comparison_isLocalizedModule` is a project-local anchor (no `\mathlibok`) for an
  already-axiom-clean decl; it carries no `\uses{}` (foundational localisation primitive) and is
  non-isolated via the residual's incoming edge.

## Strategy-modifying findings
None.
