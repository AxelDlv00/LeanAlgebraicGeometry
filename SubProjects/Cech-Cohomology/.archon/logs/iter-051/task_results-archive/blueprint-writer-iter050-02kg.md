# Blueprint Writer Report

## Slug
iter050-02kg

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made

### Task 1 — fixed the (mathematically incorrect) proof of `lem:affine_cech_vanishing_qcoh`
- **Revised** `lem:affine_cech_vanishing_qcoh` (statement block): replaced the old `% NOTE` (which
  flagged the sketch as incomplete) with a clean note documenting the reduced
  `_of_tildeVanishing` formalization; updated `\lean{}` to bundle both
  `AlgebraicGeometry.affine_cech_vanishing_qcoh` (aspirational) and the live reduced form
  `AlgebraicGeometry.affine_cech_vanishing_qcoh_of_tildeVanishing`; rewrote `\uses{}` to the real
  deps (`lem:cech_acyclic_affine, lem:qcoh_iso_tilde_sections,
  lem:affine_cech_vanishing_tilde_subcover, lem:cechCohomology_isZero_of_iso,
  def:affine_cover_system, def:has_vanishing_higher_cech`). Dropped the stale
  `lem:qcoh_isIso_fromTildeGamma` dep. Added the "currently formalized in the reduced
  `_of_tildeVanishing` form" sentence to the body.
- **Rewrote the proof** to the change-of-base-to-`R_f` argument (Stacks 02KG "Write `U = Spec(A)`",
  invoking `lemma-cech-cohomology-quasi-coherent-trivial`):
  - Step 1: transport `F ≅ ~M` reduction via `lem:cechCohomology_isZero_of_iso`.
  - Step 2: explicitly notes that for a proper `D(f)` the family `{gᵢ}` does NOT span the unit ideal
    of `R`, so `lem:cech_acyclic_affine` (span `= ⊤`) does not apply directly; the required vanishing
    is the new residual `lem:affine_cech_vanishing_tilde_subcover`, proved by change of base to `R_f`.
  - Added the verbatim `% SOURCE QUOTE PROOF:` ("Write U = Spec(A) … Clearly the Čech complex … is
    identified with the complex ∏ M_{f_{i_0}} → …") before the proof env.

### Task 2 — change-of-base sub-lemma chain
- **Added** `lem:iSup_basicOpen_eq_top_iff_span` — Mathlib dependency anchor
  (`\lean{PrimeSpectrum.iSup_basicOpen_eq_top_iff}`, `\mathlibok`). Verified faithful via
  `lean_hover_info`: `⨆ i, basicOpen (f i) = ⊤ ↔ Ideal.span (Set.range f) = ⊤`. Created to give the
  span lemma's `\uses{}` a real node (the original `\uses` target did not exist as a label).
- **Added** `lem:affine_cover_span_localizationAway` —
  `\lean{AlgebraicGeometry.affine_cover_span_localizationAway}` (DONE in Lean), `\uses{}` the anchor.
  Statement + informal proof (pullback along `Spec R_f ≅ D(f)`, `f` a unit in `R_f`).
- **Added** `lem:tilde_section_changeOfBase` — infra (a): per-σ section iso
  `Γ(D_R(g_σ),~M) ≅ Γ(D_{R_f}(g_σ/1),~M_f)`, both `= M_{g_σ}`. NOT yet a Lean decl (`% TODO`
  placeholder, names QcohRestrictBasicOpen as the intended engine). `\uses{lem:modules_restrict_basicOpen,
  lem:tilde_section_isLocalizedModule}`.
- **Added** `lem:section_cech_changeOfBase_iso` — infra (b): degreewise cochain-complex iso assembling
  (a). NOT yet a Lean decl (`% TODO`). `\uses{lem:tilde_section_changeOfBase, def:section_cech_complex,
  def:section_cech_functoriality}`.
- **Added** `lem:affine_cech_vanishing_tilde_subcover` — the residual (`htilde` form): for `D(f) = ⨆ D(gᵢ)`
  and `p>0`, `Ȟᵖ({D(gᵢ)},~M)=0`. Proof = the change-of-base argument. NOT yet a Lean decl (`% TODO`:
  it is the `htilde` hypothesis the two reduced forms take). Carries `% SOURCE`/`% SOURCE QUOTE`
  (statement) + `% SOURCE QUOTE PROOF` (the "Write U = Spec A" step), from
  `lemma-cech-cohomology-quasi-coherent-trivial`. `\uses{lem:cech_acyclic_affine,
  lem:affine_cover_span_localizationAway, lem:tilde_section_changeOfBase,
  lem:section_cech_changeOfBase_iso}`.

### Task 3 — coverage-debt blocks
- **Added** `lem:cechCohomology_isZero_of_iso` —
  `\lean{AlgebraicGeometry.cechCohomology_isZero_of_iso}`, reusable transport lemma (iso of
  coefficient presheaves transports Čech-vanishing). One-paragraph proof via
  `def:section_cech_functoriality`. Cited from Step 1 of `lem:affine_cech_vanishing_qcoh`.
- **Revised** `lem:affine_cech_vanishing_qcoh` — bundled `affine_cech_vanishing_qcoh_of_tildeVanishing`
  into `\lean{}` and added the reduced-form sentence (see Task 1).
- **Revised** `lem:affine_serre_vanishing` — bundled
  `AlgebraicGeometry.affine_serre_vanishing_of_tildeVanishing` into `\lean{}`; added
  `lem:affine_cech_vanishing_tilde_subcover` to `\uses{}`; added the "currently formalized in the
  reduced `_of_tildeVanishing` form pending the residual" sentence.

## Cross-references introduced
- All new `\uses{}` resolve: `leandag build --json` reports **`unknown_uses: 0`**.
- New real-Lean targets all **matched** in the DAG: `affine_cech_vanishing_qcoh_of_tildeVanishing`,
  `affine_serre_vanishing_of_tildeVanishing`, `cechCohomology_isZero_of_iso`,
  `affine_cover_span_localizationAway`.
- Still `unmatched_lean` (expected/intended): the aspirational unconditional pins
  `affine_cech_vanishing_qcoh` and `affine_serre_vanishing` (documented in `% NOTE`s), and the Mathlib
  anchor `PrimeSpectrum.iSup_basicOpen_eq_top_iff` (Mathlib names are not in the project's compiled
  lean-aux, normal for `\mathlibok` anchors).
- The single isolated node reported by leandag is a pre-existing `lean_aux` node (no chapter), not one
  of my blocks.

## References consulted
- `references/stacks-coherent.tex` (L44–135, L145–174) — verbatim `% SOURCE QUOTE`/`% SOURCE QUOTE
  PROOF` for `lem:affine_cech_vanishing_tilde_subcover` (statement of
  `lemma-cech-cohomology-quasi-coherent-trivial` and its "Write U = Spec(A) … Čech complex identified
  with ∏ M_{f_{i_0}} → …" change-of-base step), and the `% SOURCE QUOTE PROOF` added to
  `lem:affine_cech_vanishing_qcoh`. Also confirmed the 02KG proof "condition (3) follows from
  lemma-cech-cohomology-quasi-coherent-trivial".
- `references/summary.md` — source index (confirmed `stacks-coherent` carries 02KG and the trivial
  Čech-vanishing lemma).
- Lean source `AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean` (read-only) — confirmed the real
  signatures of `affine_cover_span_localizationAway`, `cechCohomology_isZero_of_iso`,
  `affine_cech_vanishing_qcoh_of_tildeVanishing`, `affine_serre_vanishing_of_tildeVanishing`, and the
  Mathlib name `PrimeSpectrum.iSup_basicOpen_eq_top_iff` (verified its exact statement via
  `lean_hover_info`).

## Macros needed (if any)
- None. All notation used (`\operatorname`, `\widetilde`, `\bigsqcup`, etc.) is already standard in the
  chapter.

## Reference-retriever dispatches (if any)
- None — the required source (`references/stacks-coherent.tex`) was already on disk.

## Notes for Plan Agent
- The two infra lemmas `lem:tilde_section_changeOfBase` and `lem:section_cech_changeOfBase_iso`, and
  the residual `lem:affine_cech_vanishing_tilde_subcover`, are blueprinted with `% TODO` markers and
  **no `\lean{}` pin** — they are the next Lean targets for the prover. The intended engine is named in
  prose: `QcohRestrictBasicOpen` (`modulesRestrictBasicOpen`, `modulesRestrictBasicOpenIso`,
  `presentationModulesRestrictBasicOpen`) plus `tilde_section_isLocalizedModule`. Once
  `affine_cech_vanishing_tilde_subcover` is a closed Lean decl it can be passed as the `htilde`
  hypothesis to both `_of_tildeVanishing` forms to discharge the unconditional targets.
- The aspirational pins `affine_cech_vanishing_qcoh` / `affine_serre_vanishing` remain `unmatched_lean`
  by design (no Lean decl yet); they become matched once the residual closes. No action needed now.

## Strategy-modifying findings
None. The change-of-base argument is exactly the Stacks 02KG route the strategy already assumes; this
round only corrected the prose to match it and exposed the decomposition the prover will formalize.
