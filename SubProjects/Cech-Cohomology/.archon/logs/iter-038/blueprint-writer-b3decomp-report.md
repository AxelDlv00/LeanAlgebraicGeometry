# Blueprint Writer Report

## Slug
b3decomp

## Status
COMPLETE — all four directed edits made; `leandag` shows no broken `\uses`, no conflicts.

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made

### Task 1 — `overEquivalence` Mathlib anchor + continuity infra block (inserted after `lem:pushforwardPushforwardEquivalence_mathlib`)
Two new blocks added (file region formerly ~line 3962, immediately before `lem:quasicoherentData_mathlib`):

- **Added Mathlib anchor** `lemma`/`\label{lem:overEquivalence_mathlib}`/`\lean{TopologicalSpace.Opens.overEquivalence}` — `\mathlibok`. States the over-category of opens contained in `U` is equivalent to the subspace site `Opens U`. No `\uses`, no proof (Mathlib-supplied).
- **Added project lemma** `lemma`/`\label{lem:overEquivalence_isContinuous}` with
  `\lean{AlgebraicGeometry.Opens.overEquivalence_functor_coverPreserving, AlgebraicGeometry.Opens.overEquivalence_inverse_coverPreserving, AlgebraicGeometry.Opens.overEquivalence_functor_isContinuous, AlgebraicGeometry.Opens.overEquivalence_inverse_isContinuous}`
  — all four continuity declarations pinned in one node. Statement `\uses{lem:overEquivalence_mathlib}`; proof block added (`\uses{lem:overEquivalence_mathlib}`), no `\mathlibok` (project-proved, closes a Mathlib TODO). Proof prose describes cover-preservation via the over-topology membership criterion + point bookkeeping, and continuity from cover-density/local-fullness/local-faithfulness of an equivalence's functors. (Lean tactic strings / `mem_over_iff` / `Subtype.val` were paraphrased into mathematical prose per the no-Lean-syntax rule.)

### Task 2 — B3 proof sketch expanded with B3a/B3b/B3c (`lem:restrict_over_compat`)
- **Statement block** unchanged (`\lean{AlgebraicGeometry.overBasicOpenIsoRestrict}` untouched).
- **Proof block** `\uses` changed to
  `\uses{lem:modules_restrict_basicOpen, lem:pushforwardPushforwardEquivalence_mathlib, lem:restrict_obj_mathlib, lem:overEquivalence_isContinuous}`.
- Proof prose rewritten into three named sub-steps:
  - **B3a** — structure-sheaf compatibility datum: over-side `S = (Spec R).ringCatSheaf.over D(g)` (sections `Γ(Spec R, V)`) vs subscheme `(↥D(g)).ringCatSheaf` (sections `Γ(Spec R, ι(W))`); agreement via open immersion; comparison `φ/ψ` with coherence `H₁/H₂` built from `Hom.appIso` of `(specBasicOpen g).ι` — same `appIso` used by `Scheme.Modules.restrictFunctor`. Emphasized this is genuine geometric content, NOT a `map_id`-triviality (contrast B2).
  - **B3b** — module equivalence: feed `φ/ψ/H₁/H₂` + continuous site equivalence into `pushforwardPushforwardEquivalence`, get `(↥D(g)).Modules ≃ SheafOfModules ((Spec R).ringCatSheaf.over D(g))`, object map sends `F.restrict (specBasicOpen g).ι ↦ F.over D(g)`, sections agree by `restrict_obj`.
  - **B3c** — transport to `Spec R_g` along `basicOpenIsoSpecAway g` (restriction-along-iso equivalence) landing on `modulesRestrictBasicOpen g F` (definitionally the double restrict); compose to get `F.over D(g) ≅ modulesRestrictBasicOpen g F`.
- Closing paragraph kept: B3 distinct from `lem:tilde_restrict_basicOpen`, NOT discharged by `lem:modules_restrict_basicOpen`.

### Task 3 — B2 proof `\uses` tightened (`lem:presentation_over_basicOpen`)
- **Statement block** `\uses` unchanged.
- **Proof block** `\uses` changed to
  `\uses{lem:presentation_map_mathlib, lem:pushforwardPushforwardEquivalence_mathlib, lem:presentation_ofIsIso_mathlib}`.
- Added one sentence: transport realized by building the site equivalence via `pushforwardPushforwardEquivalence`, transporting through its inverse with `Presentation.map`, closing along the residual iso with `Presentation.ofIsIso`.

### Task 4 — B1 `\lean{}` bundles the private helper (`lem:qcoh_finite_presentation_cover`)
- `\lean{AlgebraicGeometry.qcoh_finite_presentation_cover, AlgebraicGeometry.coversTop_iSup_eq_top}` — helper appended. Statement, proof prose, `\uses` all unchanged.

## Cross-references introduced
- `\uses{lem:overEquivalence_mathlib}` in `lem:overEquivalence_isContinuous` (statement + proof) — target is the new sibling Mathlib anchor in this same chapter. ✓ resolves.
- `\uses{lem:overEquivalence_isContinuous}` added to the `lem:restrict_over_compat` proof — target is the new project block in this same chapter. ✓ resolves.
- `\uses{lem:pushforwardPushforwardEquivalence_mathlib, lem:presentation_ofIsIso_mathlib}` added to `lem:presentation_over_basicOpen` proof — both pre-existing Mathlib anchors in this chapter. ✓ resolve.

## leandag verification
`leandag build --json`: `unknown_uses => []`, `conflicts => []`. None of my edited/added nodes appear under `unknown_uses`. `lem:overEquivalence_isContinuous` does NOT appear in `unmatched_lean` — its four Lean names matched the project source scan (the prover's declarations exist). `lem:overEquivalence_mathlib` appears in `unmatched_lean`, as expected for a `\mathlibok` Mathlib re-export not present in project Lean source. The single project-wide `isolated` node is pre-existing and unrelated to these edits (all four new/edited blocks are wired: overEquivalence_mathlib ← overEquivalence_isContinuous ← restrict_over_compat).

## Coverage-debt confirmation (for the planner)
The four `overEquivalence` continuity declarations are now pinned in one blueprint node (`lem:overEquivalence_isContinuous`); the site-equivalence itself has a `\mathlibok` anchor (`lem:overEquivalence_mathlib`); and `coversTop_iSup_eq_top` is now bundled into B1's `\lean{}`. All five previously-unanchored Lean declarations are matched. B3's sketch now carries the B3a/B3b/B3c decomposition the prover identified.

## References consulted
None — all four edits concern Mathlib re-export anchors and project-bespoke (Archon-original) lemmas. No external textbook source citations were added, so no `references/` files were opened (per the citation-discipline carve-out for Mathlib anchors and project-original blocks).

## Macros needed
None. All notation used (`\operatorname`, `\widetilde`, `\mathcal`, `\cong`, `\simeq`, `\widehat`) is standard and already in use elsewhere in the chapter.

## Notes for Plan Agent
- The B3a prose names `φ/ψ` and coherence `H₁/H₂` descriptively (as "comparison ring-sheaf morphisms" / "coherence witnesses") rather than as literal Lean identifiers, per the no-Lean-syntax rule. The next prover should read these as the `pushforwardPushforwardEquivalence` comparison-data arguments.
- `\widehat{D(g)}` is used to denote the open `D(g)` viewed as a subspace `↥D(g)` (distinguishing it from the over-object). If the planner prefers different notation for the subspace, that is a chapter-wide cosmetic choice; I kept it local and consistent within the B3 proof.

## Strategy-modifying findings
None.
