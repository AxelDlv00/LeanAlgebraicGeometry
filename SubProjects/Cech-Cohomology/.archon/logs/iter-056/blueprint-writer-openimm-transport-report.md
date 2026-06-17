# Blueprint Writer Report

## Slug
openimm-transport

## Status
COMPLETE — all five directive tasks executed; `leandag` clean (0 unknown_uses, 0 isolated
among new blocks); the single `unmatched_lean` is the intentional TODO build-target pin.

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made

### Task 1 — `lem:rightDerivedNatIso`
- **Added lemma** `\label{lem:rightDerivedNatIso}` / `\lean{AlgebraicGeometry.rightDerivedNatIso}` —
  a natural iso of additive functors `F ≅ G` induces `F.rightDerived n ≅ G.rightDerived n`.
  `\uses{}` empty (relies only on Mathlib `NatTrans.rightDerived` functoriality). Archon-original
  (no SOURCE lines). Proof: derive the iso's hom/inv, use `_comp`/`_id` for mutual inverses.

### Task 2 — Proof detail (2) made concrete (the must-fix)
- **Rewrote** Proof detail (2) of `lem:open_immersion_pushforward_comp` from one prose sentence into
  three named sub-steps **(2a)/(2b)/(2c)**:
  - (2a) `j` affine (via `isAffineHom_of_affine_separated`) ⇒ `j⁻¹(V)` (resp. `U ∩ f⁻¹V`) is an
    affine scheme.
  - (2b) presheaf description + `lem:sectionsFunctorCorepIso` + `lem:rightDerivedNatIso` reduce
    `H^q(j⁻¹V, H)` to `Ext^q(j_!O_{j⁻¹V}, H)`.
  - (2c) transport along the canonical scheme iso `j⁻¹V ≅ Spec Γ(j⁻¹V,O)`
    (`lem:isoSpec_mathlib`) carries `Ext^q(j_!O_{j⁻¹V},H)` to the pinned `⊤`-case
    `Ext^q(j_!O_⊤, H')` = `affine_serre_vanishing`, which vanishes for `q ≥ 1`. Packaged as
    `lem:sectionsFunctor_isoSpec_transport`.
- **Added the transport intermediate** `\label{lem:sectionsFunctor_isoSpec_transport}` with a TODO
  Lean pin `\lean{AlgebraicGeometry.sectionsFunctorIsoSpecTransport_TODO}` — this is the genuine
  gap: `affine_serre_vanishing`'s Lean signature is **pinned to `⊤` on a `Spec R`**
  (`jShriekOU (⊤ : (Spec R).Opens)`), so the general-affine-open case really does need a
  transport lemma that does not yet exist in Lean. Per directive, used a `…TODO…` pin (build
  target, not a fill-sorry target) rather than inventing a real name.
- **Added Mathlib anchor** `\label{lem:isoSpec_mathlib}` / `\lean{AlgebraicGeometry.IsAffineOpen.isoSpec}`
  `\mathlibok` — the canonical `V ≅ Spec Γ(V,O_U)` for an affine open. **Verified directly against
  Mathlib source** (`Mathlib/AlgebraicGeometry/AffineScheme.lean:377`, inside
  `namespace AlgebraicGeometry → namespace IsAffineOpen`), so the fully-qualified name and
  statement are faithful; no `% NOTE: confirm` flag needed (the analogist report had not landed,
  but direct source verification is stronger).
- **Extended `\uses`** on `lem:open_immersion_pushforward_comp` (both statement and inner proof) to
  add `lem:rightDerivedNatIso, lem:sectionsFunctorCorepIso, lem:sectionsFunctor_isoSpec_transport`.

### Task 3 — coverage-debt blocks for isolated `lean_aux` helpers
- **Added** `lem:toPresheafOfModules_additive` / `\lean{AlgebraicGeometry.toPresheafOfModules_additive}`
  — additivity of the presheaf-of-modules functor.
- **Added** `lem:sectionsFunctor_additive` / `\lean{AlgebraicGeometry.sectionsFunctor_additive}`,
  `\uses{lem:toPresheafOfModules_additive}` — additivity of `Γ(V,-)`.
- **Added** `lem:sectionsFunctorCorepIso` / `\lean{AlgebraicGeometry.sectionsFunctorCorepIso}`,
  `\uses{lem:jshriek_corepr, lem:sectionsFunctor_additive}` — `Γ(V,-) ≅ Hom(j_!O_V, -)`.
- **Added** `lem:isZero_homology_of_iso_homotopy_id_zero` /
  `\lean{AlgebraicGeometry.isZero_homology_of_iso_homotopy_id_zero}`,
  `\uses{lem:isZero_homology_of_homotopy_id_zero}`, placed immediately after
  `lem:isZero_homology_of_homotopy_id_zero` in the Sub-brick A region — the `(D ≅ D') → Homotopy
  (𝟙 D') 0 → IsZero (D.homology p)` consumer glue for Step 3(d).
- Skipped `jShriekOU_homEquiv_nat` (private) per directive.
- `rightDerivedNatIso` covered once under Task 1 (not duplicated).

### Task 4 — stale prose deleted
- **Removed** the stale trailing paragraph of `lem:affine_serre_vanishing` ("…not currently
  available in the ambient library… currently formalized in the reduced `_of_tildeVanishing` form
  pending the residual…"). Kept the genuinely-true fact that the formal statement carries
  `[EnoughInjectives X.Modules]`, reworded so it no longer claims the lemma is unfinished.
- **Removed** the now-redundant `% NOTE (iter-052)` block (it existed only to flag the stale text).

### Task 5 — misleading `\uses` prose clarified
- **Added parenthetical** in the proof of `lem:cechSection_contractible`: `lem:cech_acyclic_affine`
  is cited only as the Lean home of the `dep*` engine declarations — its standard-cover
  Čech-vanishing *conclusion* is not a mathematical dependency.

## Cross-references introduced
- `lem:rightDerivedNatIso`, `lem:sectionsFunctorCorepIso`, `lem:sectionsFunctor_isoSpec_transport`
  added to `lem:open_immersion_pushforward_comp` (statement + proof) — all exist in this chapter.
- `lem:sectionsFunctor_isoSpec_transport` `\uses{lem:isoSpec_mathlib, lem:sectionsFunctorCorepIso,
  lem:rightDerivedNatIso, lem:jshriek_corepr, lem:affine_serre_vanishing}` — all exist in this chapter.
- `lem:sectionsFunctorCorepIso` `\uses{lem:jshriek_corepr, lem:sectionsFunctor_additive}`.
- `lem:sectionsFunctor_additive` / `lem:isZero_homology_of_iso_homotopy_id_zero` wired to their
  single-step parents. `leandag build --json`: `unknown_uses = []`, isolated among new blocks = none.

## References consulted
- `references/summary.md` — confirmed the relative-affine-vanishing Stacks source is already
  present in the chapter (no new retrieval needed).
- (Lean source, not a `references/` citation) `AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean`,
  `AffineSerreVanishing.lean`, `CechAugmentedResolution.lean`, and
  `.lake/.../Mathlib/AlgebraicGeometry/AffineScheme.lean` — read to verify exact Lean names and the
  `⊤`-pinning of `affine_serre_vanishing`. No new `% SOURCE`/`% SOURCE QUOTE` blocks were written
  (the existing Stacks quotes were left untouched, per the citation-discipline constraint).

## Macros needed (if any)
None. All new prose uses existing macros / standard `\operatorname`.

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- **TODO build target surfaced.** `lem:sectionsFunctor_isoSpec_transport` carries a placeholder
  `\lean{AlgebraicGeometry.sectionsFunctorIsoSpecTransport_TODO}` (the single `unmatched_lean` in
  `leandag`). This is the *real* residual behind the `sorry` in
  `higherDirectImage_openImmersion_acyclic` (OpenImmersionPushforward.lean:306): a prover must build
  a Lean lemma identifying `Ext^q(jShriekOU (j⁻¹W), H)` over the affine open with the `⊤`-case on
  `Spec Γ` via `IsAffineOpen.isoSpec` + `rightDerivedNatIso`, then conclude by `affine_serre_vanishing`.
  Consider scaffolding this decl (planner/lean-scaffolder) next iter, then re-point the `\lean{}`.
- The `affine_serre_vanishing` blueprint statement reads "Let `U` be an affine scheme" while the Lean
  `affine_serre_vanishing` is pinned to `⊤` on `Spec R`. The blueprint statement is the intended
  mathematical content; the transport lemma is exactly what bridges the gap. No statement change made
  (out of scope), but flagging the prose/Lean mismatch for awareness.

## Strategy-modifying findings
None. The transport route is consistent with the chosen strategy; the only new obligation is the
TODO transport lemma, which is the concretization the directive requested.
