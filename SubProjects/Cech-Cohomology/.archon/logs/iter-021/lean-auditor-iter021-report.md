# Lean Audit Report

## Slug
iter021

## Iteration
021

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/CechAcyclic.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none (see notes on pre-existing `sorry`)
- **bad practices**: 1 flagged (unnecessary `classical`)
- **excuse-comments**: none
- **notes**:
  - **Line 110** — pre-existing `sorry` in `CechAcyclic.affine`. The surrounding comment block (lines 80–110) accurately describes exactly what is missing (the L1 categorical→module bridge: identifying abstract `CechComplex` terms with away-localisation modules and the abstract differential with `combDifferential`). There is no minimisation, no "will fix later" language, and no claim that the sorry is temporary or inconsequential. Honestly flagged. Per directive, not treated as a new defect.
  - **Lines 1200–1209** — module-level doc for `section SectionCechBridge` claims that the lemmas "(c1)–(c3) move that abstract complex to the concrete localised-module complex `SectionCechModule.dDiff` … and read off homology vanishing." This overstates what the section currently achieves. Step (c1) = `sectionCechProductEquiv` / `sectionCechProductEquiv_apply` ✓; step (c2, abstract) = `sectionCechFaceRestr` / `sectionCech_objD_apply` ✓ (cosimplicial differential expressed as alternating presheaf restrictions); step (c3) and "read off homology vanishing" = `sectionCech_isZero_homology_of_objD_exact` is a *conditional* result requiring `Function.Exact` of `objD` as a hypothesis. The actual identification of the presheaf restriction maps `sectionCechFaceRestr` with `SectionCechModule.dCoface` (via `qcohSectionsAwayLocalized` + `qcohRestriction_eq_comparison`) is **not assembled** in this section; that assembly step is the active gap between (c2) and closing `sectionCech_isZero_homology_of_objD_exact` unconditionally. The comment implies the assembly is present when it is not. (MAJOR)
  - **Line 1273** — `classical` in the body of `private lemma ab_hom_finsetSum_apply`. The proof uses `Finset.induction` and `Finset.sum_insert`, neither of which requires classical reasoning in Lean 4. The `classical` is dead here. Harmless but slightly noisy. (MINOR)
  - **Lines 1255–1256** — `(by simp)` used twice for the `exactAt_iff'` side conditions (`q + 1 = q + 1` and `q + 2 = q + 1 + 1` style obligations) inside `sectionCech_isZero_homology_of_objD_exact`. These should be `omega` or `rfl`-provable and are harmless, but `simp` carries a larger proof-search footprint than necessary. (MINOR)
  - **Lines 1210–1327** — `SectionCechBridge` as a whole: all 6 new declarations (`sectionCechProductEquiv`, `sectionCechProductEquiv_apply`, `sectionCechFaceRestr`, `sectionCech_objD_apply`, `sectionCech_isZero_homology_of_objD_exact`, `ab_hom_finsetSum_apply`) are sorry-free, introduce no new `axiom`s, and are individually mathematically correct. The proof strategies are standard (product-equiv API, finset induction, `rfl`-based definitional reasoning). No suspect bodies.

### AlgebraicJacobian/Cohomology/PresheafCech.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All 6 declarations (`injective_toPresheafOfModules`, `freeYonedaHomEquiv`, `freeYonedaHomEquiv_apply`, `freeYonedaHomAddEquiv`, `sectionCechCosimplicial`, `sectionCechComplex`) are sorry-free, axiom-free, and use correct proof strategies.
  - The long strategy comment block (lines 33–196) accurately describes the overall plan and correctly notes which declarations have moved to sibling files (`CechBridge.lean`, `FreePresheafComplex.lean`). No stale references.
  - `freeYonedaHomEquiv_apply` uses `: rfl` as the body, appropriate since the equivalence is definitionally the composition. Not a suspect body — the definition of `freeYonedaHomEquiv` makes this definitionally true.
  - `sectionCechCosimplicial`: the `map_id` proof uses `Subsingleton.elim (homOfLE _).op (𝟙 _)`, which is valid since morphisms in `Opens` (a preorder category) are unique. The `map_comp` proof uses `congr 1` closing with `rfl`. Both are correct applications of preorder-category uniqueness.

---

## Must-fix-this-iter

*(none)*

---

## Major

- `CechAcyclic.lean:1200–1209` — Module-level doc for `section SectionCechBridge` claims the lemmas "move that abstract complex to `SectionCechModule.dDiff` … and read off homology vanishing." The identification of `sectionCechFaceRestr` with `dCoface` (the assembly of `qcohSectionsAwayLocalized` + `qcohRestriction_eq_comparison` into a single "restriction = `dDiff`" lemma) is absent from this section. `sectionCech_isZero_homology_of_objD_exact` is conditional on `Function.Exact` of `objD` as a hypothesis, not an unconditional vanishing. The comment should say something like "steps (c1)–(c2, abstract) done here; (c3 assembly) is the remaining gap in this section" to avoid giving a false impression of completeness.

---

## Minor

- `CechAcyclic.lean:1273` — `classical` in `ab_hom_finsetSum_apply` is unused; `Finset.induction` and `Finset.sum_insert` do not require classical reasoning.
- `CechAcyclic.lean:1255–1256` — `(by simp)` for `exactAt_iff'` shape side-conditions would be more robust as `(by omega)` or `(by norm_num)`.

---

## Excuse-comments (always called out separately)

*(none)*

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 1
- **minor**: 2
- **excuse-comments**: 0

**Overall verdict**: The new `SectionCechBridge` section (6 declarations) is sorry-free, axiom-free, and individually sound; the only meaningful finding is that the module-level doc slightly overstates what the section currently achieves — the final assembly connecting `objD` to `dDiff` is the active gap, and the comment should reflect this rather than implying completion of the full bridge.
