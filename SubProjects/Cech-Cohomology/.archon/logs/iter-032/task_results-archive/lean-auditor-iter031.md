# Lean Audit Report

## Slug
iter031

## Iteration
031

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/CechBridge.lean

- **outdated comments**: 1 flagged (see notes)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none

**Notes:**

- **Line 65–67 (module docstring):** Forward-looking entry mentions `cech_eq_cohomology_of_basis` / `affine_serre_vanishing` as "(planned)". This is aspirational documentation in the module header, not an excuse-comment attached to a declaration. It doesn't admit that any *existing* code is wrong. Severity: minor (stale module-level doc if those names have moved or are now handled differently).

- **`homCechCosimplicialFam` through `injective_cech_acyclicFam` (lines 934–1113, `section FamilyParameterizedBridge`):** 11 `…Fam` declarations (the directive counts 10; the file has 11, including `homCechCosimplicial_δFam`). All are mechanical mirrors of the corresponding `X.OpenCover` variants. Every declaration compiles cleanly without sorry.

- **No covering hypothesis in FamilyParameterizedBridge:** The section variable (line 938) is `{ι : Type u} [Finite ι] (U : ι → TopologicalSpace.Opens ↥X)` with no `hU : ⨆ i, U i = ⊤` or equivalent. `injective_cech_acyclicFam` (line 1075) takes only `(I : X.Modules) [Injective I] (p : ℕ) (hp : 0 < p)` — no covering hypothesis. Confirmed correct.

- **`injective_cech_acyclicFam` is genuinely non-vacuous:** Statement is `IsZero ((sectionCechComplex U (…I)).homology p)` with `hp : 0 < p` required. The `0 < p` constraint is strictly necessary (degree 0 does not generally vanish). The proof constructs a genuine quasi-isomorphism `Θ` via `quasiIso_map_preadditiveYoneda_of_injective` applied to the opposite augmentation `cechFreeComplexAugFam U`, then transfers the source's vanishing across it. Not vacuous.

- **`maxHeartbeats 2000000` on `injective_cech_acyclicFam` (line 1062):** The comment "op-transport assembly elaborates several nested functor-on-homological-complex coercions whose defeq checks exceed the default heartbeat budget" mirrors verbatim the comment on the original `injective_cech_acyclic` (line 852), which has the same option. Both proofs have identical structure (same coercion chains, same `ComplexShape.down ℕ).symm` transport). This is a genuine performance need, not a masking device for a broken proof.

- **Existing `X.OpenCover` declarations (lines 136–909) are untouched:** All original declarations (`homCechCosimplicial`, `homCechComplex`, `homCechSectionIsoApp`, `homCechSectionCosimplicialIso`, `cechComplex_hom_identification`, `homCechComplexMapOpIso`, `sectionCechComplexMapOpIso`, `preadditiveYoneda_obj_preservesFiniteColimits_of_injective`, `quasiIso_map_preadditiveYoneda_of_injective`, `sectionCech_objD_exact_of_isZero_homology`, `sectionCech_one_coboundary_of_isZero_homology`, `ses_cech_h1`, `injective_cech_acyclic`) are present in the same line range with no modifications. `injective_cech_acyclic` ends at line 909; the new section begins at 934.

- **`set_option linter.unusedSectionVars false` (line 936):** Suppresses unused-section-variable lint in `FamilyParameterizedBridge`. Standard pattern when outer section variables (`X`) are used only transitively through `U`. Not a bad practice. (Minor note only.)

- **`rfl` proofs on `pi_mapIso_hom_eq` (line 176) and `homCechCosimplicial_δFam` (line 1016):** Both are definitionally trivial equalities. The use of `:= rfl` is correct here.

- **No sorry, no unauthorized axioms, no excuse-comments:** Grep confirms zero occurrences.

---

### AlgebraicJacobian/Cohomology/QcohTildeSections.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none

**Notes:**

- **`qcoh_iso_tilde_sections` (lines 62–64):** Takes `[IsIso F.fromTildeΓ]` as an instance hypothesis; proof body `(asIso F.fromTildeΓ).symm`. Clean, non-vacuous, correct. The `@[simp]` companion lemmas (lines 78–86) have `:= rfl` bodies that are definitionally correct for `asIso.symm`.

- **`qcoh_iso_tilde_sections_of_presentation` (lines 71–74):** Discharges the `IsIso` hypothesis via Mathlib's `isIso_fromTildeΓ_of_presentation`. Clean.

- **`free_isQuasicoherent` (lines 102–105):** Uses `prop_of_iso` and `tildeFinsupp`. No sorry. Correct approach.

- **`isIso_fromTildeΓ_of_genSections` (lines 116–120):** Constructs `F.Presentation` from two `GeneratingSections` and feeds it to Mathlib's `isIso_fromTildeΓ_of_presentation`. Clean.

- **`exists_finite_basicOpen_subcover` (lines 149–185):** Non-vacuous — requires `hU : ⨆ i, U i = ⊤` and produces `n`, `f : Fin n → R`, `φ : Fin n → ι` with (a) `∀ j, basicOpen (f j) ≤ U (φ j)` and (b) `Ideal.span (Set.range f) = ⊤`. The proof uses:
  - `TopologicalSpace.Opens.isBasis_iff_nbhd` + `PrimeSpectrum.isBasis_basic_opens` for the pointwise basic-open refinement (lines 161–165),
  - `isCompact_univ.elim_finite_subcover` for quasicompactness (lines 171–173),
  - `PrimeSpectrum.iSup_basicOpen_eq_top_iff` to translate the covering condition to the ideal-span condition (line 177).
  No hidden gaps. The `choose g φ' hxg hgU using hpt` step (line 166) correctly destructs the pointwise existence, and the finite subcover `t` with `Finset.equivFin` index is then mapped to `Fin t.card`.

- **P1 `qcoh_localized_sections` NOT stubbed:** The file ends at line 234 with no sorry-stub for the localization-of-sections lemma. The prover's claim that P1 was deliberately omitted rather than stubbed is confirmed.

- **Handoff section (lines 187–232):** Module-level planning documentation describing the remaining gap (`[IsQuasicoherent F] → IsIso F.fromTildeΓ`). Contains two pseudo-code declarations inside a docstring comment — not actual Lean code, no sorry. Not an excuse-comment on any existing declaration.

- **No sorry, no unauthorized axioms, no excuse-comments:** Grep confirms zero occurrences.

---

## Must-fix-this-iter

None.

---

## Major

None.

---

## Minor

- `CechBridge.lean:65–67` — Module docstring mentions `cech_eq_cohomology_of_basis` / `affine_serre_vanishing` as "(planned)". If these declarations are now handled under different names or in a different file, the module header is aspirationally stale. Not misleading for the declarations that *do* exist, and no code depends on this comment. Update when those names are settled.

---

## Excuse-comments (always called out separately)

None.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 1
- **excuse-comments**: 0

**Overall verdict:** Both files are axiom-clean, sorry-free, and structurally sound; the FamilyParameterizedBridge section is a correct cover-agnostic mirror of the OpenCover bridge with no covering hypothesis smuggled in, `injective_cech_acyclicFam` is a genuine positive-degree vanishing statement, and `exists_finite_basicOpen_subcover` has a complete quasicompactness-based proof with no hidden gaps.
