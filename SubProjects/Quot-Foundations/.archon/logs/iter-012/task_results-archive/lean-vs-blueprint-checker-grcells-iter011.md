# Lean ↔ Blueprint Check Report

## Slug
grcells-iter011

## Iteration
011

## Files audited
- Lean: `AlgebraicJacobian/Picard/GrassmannianCells.lean`
- Blueprint: `blueprint/src/chapters/Picard_GrassmannianCells.tex`

---

## Per-declaration

The blueprint chapter has 17 `\lean{...}` references: 5 pointing to Mathlib lemmas (marked `\mathlibok`, not expected in this file) and 12 pointing to declarations in the Lean file. All 12 file-local targets are present, carry correct signatures, and have no red-flag bodies.

---

### `\lean{AlgebraicGeometry.Grassmannian.affineChart}` (chapter: `def:gr_affine_chart`)
- **Lean target exists**: yes (line 56)
- **Signature matches**: yes — `(d r : ℕ) (I : Finset (Fin r)) : Scheme := AlgebraicGeometry.Spec (CommRingCat.of (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ))`. Blueprint: `U^I = Spec ℤ[X^I]`. Correct; `hI : I.card = d` is not needed for the chart ring itself.
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` present and correct.

---

### `\lean{AlgebraicGeometry.Grassmannian.universalMatrix}` (chapter: `def:gr_universal_matrix`)
- **Lean target exists**: yes (line 78)
- **Signature matches**: yes — `(d r : ℕ) (I : Finset (Fin r)) (hI : I.card = d) : Matrix (Fin d) (Fin r) (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)`. Exactly matches the blueprint's scaffold hint, including the `hI` cardinality hypothesis.
- **Proof follows sketch**: N/A (definition)
- **notes**: Body encodes the identity block (`q ∈ I`, using `I.orderIsoOfFin hI`) and free indeterminates (`q ∉ I`, using `MvPolynomial.X`), matching the blueprint prose exactly. `\leanok` present.

---

### `\lean{AlgebraicGeometry.Grassmannian.minorDet}` (chapter: `def:gr_minor_det`)
- **Lean target exists**: yes (line 88)
- **Signature matches**: yes — `(d r : ℕ) (I J : Finset (Fin r)) (hI : I.card = d) (hJ : J.card = d) : MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ`. Blueprint: `P^I_J = det(X^I_J) ∈ ℤ[X^I]`. Correct.
- **Proof follows sketch**: N/A (definition)
- **notes**: Body `((universalMatrix d r I hI).submatrix id (fun j => (J.orderIsoOfFin hJ j : Fin r))).det` matches scaffold hint verbatim. `\leanok` present.

---

### `\lean{AlgebraicGeometry.Grassmannian.universalMinor}` (chapter: `def:gr_universal_minor`)
- **Lean target exists**: yes (line 96)
- **Signature matches**: yes — `... : Matrix (Fin d) (Fin d) (Localization.Away (minorDet d r I J hI hJ))`. Blueprint: `X^I_J ∈ Mat_{d×d}(R^I_J)`. Correct.
- **Proof follows sketch**: N/A (definition)
- **notes**: Body applies `algebraMap _ _` via `.map`, matching scaffold hint. `\leanok` present.

---

### `\lean{AlgebraicGeometry.Grassmannian.isUnit_det_universalMinor}` (chapter: `lem:gr_minorDet_unit`)
- **Lean target exists**: yes (line 104)
- **Signature matches**: yes — `IsUnit (universalMinor d r I J hI hJ).det`. Blueprint: `det(X^I_J) ∈ (R^I_J)^×`.
- **Proof follows sketch**: yes — proof rewrites `det(X^I_J)` as `algebraMap _ _ (minorDet ...)` via `RingHom.map_det`, then applies `IsLocalization.Away.algebraMap_isUnit`. This is exactly the one-step argument sketched in the blueprint's proof block.
- **notes**: `\leanok` present on both statement and proof blocks.

---

### `\lean{AlgebraicGeometry.Grassmannian.universalMinorInv}` (chapter: `def:gr_universalMinorInv`)
- **Lean target exists**: yes (line 115)
- **Signature matches**: yes — `Matrix (Fin d) (Fin d) (Localization.Away (minorDet d r I J hI hJ))`. Blueprint: `(X^I_J)^{-1} ∈ Mat_{d×d}(R^I_J)`.
- **Proof follows sketch**: N/A (definition)
- **notes**: Body `:= (universalMinor d r I J hI hJ)⁻¹` matches scaffold hint. `\leanok` present.

---

### `\lean{AlgebraicGeometry.Grassmannian.universalMinorInv_mul_cancel}` (chapter: `lem:gr_universalMinorInv_identities`)
- **Lean target exists**: yes (line 123)
- **Signature matches**: yes — conjunction `(X^I_J)⁻¹ * X^I_J = 1 ∧ X^I_J * (X^I_J)⁻¹ = 1`, matching blueprint's "two-sided inverse" claim.
- **Proof follows sketch**: yes — applies `Matrix.nonsing_inv_mul` and `Matrix.mul_nonsing_inv` once `isUnit_det_universalMinor` is established, as the blueprint's proof block says.
- **notes**: Pair packaged as conjunction rather than two separate lemmas — acceptable and the blueprint's hint explicitly says "A conjunction (or pair of lemmas)". `\leanok` present on both blocks.

---

### `\lean{AlgebraicGeometry.Grassmannian.imageMatrix}` (chapter: `def:gr_image_matrix`)
- **Lean target exists**: yes (line 133)
- **Signature matches**: yes — `Matrix (Fin d) (Fin r) (Localization.Away (minorDet d r I J hI hJ))`, defined as `universalMinorInv d r I J hI hJ * (universalMatrix d r I hI).map (algebraMap _ _)`. Blueprint: `M = (X^I_J)^{-1} X^I`. Matches scaffold hint verbatim.
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` present.

---

### `\lean{AlgebraicGeometry.Grassmannian.transitionPreMap}` (chapter: `def:gr_transition_pre`)
- **Lean target exists**: yes (line 141)
- **Signature matches**: yes — `MvPolynomial (Fin d × {q : Fin r // q ∉ J}) ℤ →ₐ[ℤ] Localization.Away (minorDet d r I J hI hJ)`. Blueprint: `ℤ`-algebra hom `ℤ[X^J] → R^I_J`.
- **Proof follows sketch**: N/A (definition)
- **notes**: Body `:= MvPolynomial.aeval (fun e => imageMatrix d r I J hI hJ e.1 e.2.1)` matches scaffold hint exactly (the free indeterminate `x^J_{p,q}` maps to the `(p,q)`-entry of the image matrix). `\leanok` present.

---

### `\lean{AlgebraicGeometry.Grassmannian.isUnit_transitionPreMap_minorDet}` (chapter: `lem:gr_transition_pre_unit`)
- **Lean target exists**: yes (line 229)
- **Signature matches**: yes — `IsUnit (transitionPreMap d r I J hI hJ (minorDet d r J I hJ hI))`. Blueprint: `θ̃_{I,J}(P^J_I)` is a unit.
- **Proof follows sketch**: yes — the proof chain traces `θ̃_{I,J}(P^J_I)` → `det(image of X^J_I)` → `det((X^I_J)^{-1})` → unit, matching the blueprint's sketch. Intermediate steps require three helper lemmas not individually pinned by the blueprint (`universalMatrix_map_transitionPreMap`, `imageMatrix_submatrix_I`, and `universalMinorInv_mul_cancel`'s first component), which the Lean file provides internally.
- **notes**: `\leanok` present on both blocks. Blueprint proof sketch mentions the key chain but does not name the intermediate lemmas; see Blueprint adequacy section.

---

### `\lean{AlgebraicGeometry.Grassmannian.transitionMap}` (chapter: `def:gr_transition`)
- **Lean target exists**: yes (line 245)
- **Signature matches**: yes — `Localization.Away (minorDet d r J I hJ hI) →+* Localization.Away (minorDet d r I J hI hJ)`. Blueprint: `θ_{I,J} : ℤ[X^J, 1/P^J_I] → ℤ[X^I, 1/P^I_J]`.
- **Proof follows sketch**: N/A (definition)
- **notes**: Body `:= IsLocalization.Away.lift (minorDet d r J I hJ hI) (g := ...) (isUnit_transitionPreMap_minorDet ...)` matches scaffold hint. `\leanok` present.

---

### `\lean{AlgebraicGeometry.Grassmannian.transitionMap_self}` (chapter: `lem:gr_transition_self`)
- **Lean target exists**: yes (line 255)
- **Signature matches**: yes — `transitionMap d r I I hI hI = RingHom.id (Localization.Away (minorDet d r I I hI hI))`. Blueprint scaffold hint: "transitionMap_self d r I : transitionMap d r I I = RingHom.id _". The concrete type in Lean (`Localization.Away (minorDet d r I I hI hI)`) is correct since `P^I_I ≠ 1` as a ring element (it is 1 as a value, but `minorDet d r I I hI hI` has that type), consistent with the blueprint's parenthetical "(up to the identification R^I_I = R^I from P^I_I = 1)".
- **Proof follows sketch**: yes — shows `universalMinor ... I I = 1` (from `universalMatrix_submatrix_self`), hence `universalMinorInv = 1`, hence the image matrix is `X^I` lifted, hence the pre-hom is the structure map, then uses `IsLocalization.ringHom_ext` to conclude the transition map equals the identity. This is exactly the chain described in the blueprint proof block.
- **notes**: `\leanok` present on both blocks. Proof is the most elaborate in the file but faithfully executes the blueprint's argument.

---

### Mathlib anchor blocks (not in this file — expected)

The following 5 blueprint blocks are marked `\mathlibok` and point to Mathlib declarations, correctly absent from this Lean file:

| Blueprint label | `\lean{...}` target |
|---|---|
| `lem:mathlib_away_algebraMap_isUnit` | `IsLocalization.Away.algebraMap_isUnit` |
| `lem:mathlib_isUnit_iff_isUnit_det` | `Matrix.isUnit_iff_isUnit_det` |
| `lem:mathlib_nonsing_inv_mul` | `Matrix.nonsing_inv_mul` |
| `lem:mathlib_mul_nonsing_inv` | `Matrix.mul_nonsing_inv` |
| `lem:mathlib_away_lift` | `IsLocalization.Away.lift` |

All are genuine Mathlib lemmas; `\mathlibok` is correct. Note that `Matrix.isUnit_iff_isUnit_det` is listed in the blueprint as a dependency anchor (`lem:mathlib_isUnit_iff_isUnit_det`) but is not actually used by `isUnit_transitionPreMap_minorDet`'s Lean proof (which uses `IsUnit.of_mul_eq_one` instead). This is a minor blueprint adequacy note — the anchor is harmless but slightly misleading.

---

### Blueprint targets absent from Lean file (future work)

The following four blocks have `\lean{...}` pins but no `\leanok` and no corresponding Lean declaration; these are correctly flagged as future scope.

| Blueprint label | `\lean{...}` target | Status |
|---|---|---|
| `lem:gr_cocycle` | `AlgebraicGeometry.Grassmannian.cocycleCondition` | not yet formalized |
| `def:gr_glued_scheme` | `AlgebraicGeometry.Grassmannian.scheme` | not yet formalized |
| `lem:gr_separated` | `AlgebraicGeometry.Grassmannian.isSeparated` | not yet formalized |
| `lem:gr_proper` | `AlgebraicGeometry.Grassmannian.isProper` | not yet formalized |

These are **not errors** for this iteration; they are correctly left unmarked in the blueprint.

---

## Red flags

*None.*

LSP axiom check on `transitionMap_self` (the most complex theorem in the file) and `isUnit_transitionPreMap_minorDet` both return `["propext", "Classical.choice", "Quot.sound"]` — the standard Lean/Mathlib kernel axioms. No project-specific axioms, no `sorry`, no `axiom` declarations in the file.

Source scan: no `:= sorry`, no suspect bodies (`:= True`, `:= rfl` on non-trivial claims), no excuse-comments (`-- TODO replace`, `-- temporary`, `-- placeholder`), no `Classical.choice _` on substantive claims. The only private lemma (`mul_submatrix_col`) is a genuine matrix-multiplication-submatrix helper.

---

## Unreferenced declarations (informational)

Five declarations in the Lean file have no corresponding `\lean{...}` blueprint reference:

| Declaration | Line | Nature | Blueprint relevance |
|---|---|---|---|
| `universalMatrix_submatrix_self` | 150 | substantive | Used by `transitionMap_self` proof; blueprint's `lem:gr_transition_self` proof sketch implicitly relies on "X^I_I = 1" but does not pin this as a named lemma. |
| `mul_submatrix_col` | 165 | private helper | Pure technical lemma (submatrix-mul commutativity); acceptable to leave unpinned. |
| `imageMatrix_submatrix_self` | 173 | substantive | Used by `isUnit_transitionPreMap_minorDet`; blueprint's `def:gr_image_matrix` mentions "J-minor of M is identity" in prose but does not pin this as a named declaration. |
| `imageMatrix_submatrix_I` | 187 | substantive | Used by `isUnit_transitionPreMap_minorDet`; blueprint's `def:gr_image_matrix` mentions "I-minor of M is (X^I_J)^{-1}" in prose but does not pin it. |
| `universalMatrix_map_transitionPreMap` | 202 | substantive | The matrix formula `θ̃_{I,J}(X^J) = M`; blueprint's `def:gr_transition_pre` states this as part of the definition's prose but does not pin a separate lemma. |

The four substantive helpers are not suspicious — they are mathematically correct intermediate facts used in the proofs of the blueprinted lemmas. Their absence from the blueprint represents minor coverage debt.

---

## Blueprint adequacy for this file

- **Coverage**: 12/17 Lean declarations have a corresponding `\lean{...}` blueprint block (excluding the private lemma: 12/16). The 4 substantive unreferenced lemmas are legitimate helpers whose content is mentioned in the prose of adjacent blueprint blocks.

- **Proof-sketch depth**: **under-specified** for two blocks:
  1. `lem:gr_transition_pre_unit` (`isUnit_transitionPreMap_minorDet`): The blueprint's proof sketch gives the right chain (`θ̃_{I,J}(P^J_I) = det((X^I_J)^{-1}) = unit`) but does not mention that proving this requires three intermediate named lemmas (`universalMatrix_map_transitionPreMap`, `imageMatrix_submatrix_I`, `universalMinorInv_mul_cancel` component). A prover who took the sketch at face value would need to discover these helpers from scratch.
  2. `lem:gr_transition_self` (`transitionMap_self`): Proof sketch is accurate but the step "hence the pre-hom is the structure map" requires a non-trivial `MvPolynomial.ringHom_ext` argument that the blueprint does not preview.
  - These are the only two places where the Lean clearly needed reasoning the chapter does not spell out. The mismatch is **tolerable** given the detailed scaffold comments embedded as `% LEAN SIGNATURE` source comments in the blueprint, which effectively extend the sketch.

- **Hint precision**: **precise** — all 12 `\lean{...}` pins name the correct Lean identifier. The detailed `% LEAN SIGNATURE (intended scaffold target)` comments in the blueprint supply concrete type expressions that exactly match the landed Lean signatures.

- **Generality**: **matches need** — the level of generality (over `MvPolynomial ... ℤ`, `Localization.Away`, `IsLocalization.Away.lift`) is exactly what the project needs.

- **Minor accuracy issue**: `lem:mathlib_isUnit_iff_isUnit_det` (`Matrix.isUnit_iff_isUnit_det`) is listed as a dependency anchor but is not actually used in the corresponding Lean proof, which takes a direct `IsUnit.of_mul_eq_one` route. The anchor is harmless but slightly inaccurate.

- **Recommended chapter-side actions** (low priority, not blocking):
  1. Add `\lean{AlgebraicGeometry.Grassmannian.universalMatrix_submatrix_self}` as a named lemma block (perhaps as a sub-lemma of `def:gr_universal_matrix`) pinning "the I-minor of X^I is 1_{d×d}".
  2. Add `\lean{AlgebraicGeometry.Grassmannian.imageMatrix_submatrix_self}` and `\lean{AlgebraicGeometry.Grassmannian.imageMatrix_submatrix_I}` as named blocks within `def:gr_image_matrix`'s section, capturing "M_J = 1" and "M_I = (X^I_J)^{-1}".
  3. Add `\lean{AlgebraicGeometry.Grassmannian.universalMatrix_map_transitionPreMap}` as a corollary of `def:gr_transition_pre`.
  4. Remove or correct the `lem:mathlib_isUnit_iff_isUnit_det` anchor if it is not genuinely used in the proof chain.

---

## Severity summary

### must-fix-this-iter
*None.*

### major
*None.*

### minor
- **4 unreferenced substantive Lean lemmas**: `universalMatrix_submatrix_self`, `imageMatrix_submatrix_self`, `imageMatrix_submatrix_I`, `universalMatrix_map_transitionPreMap`. Their content appears implicitly in adjacent blueprint prose but they have no `\lean{...}` pins. Coverage debt; does not affect correctness.
- **Blueprint proof sketches under-specified** for `lem:gr_transition_pre_unit` and `lem:gr_transition_self`: the intermediate steps are not named in the chapter, requiring provers to discover them. Mitigated by the detailed `% LEAN SIGNATURE` scaffold comments embedded in the `.tex` source.
- **Stale Mathlib anchor**: `lem:mathlib_isUnit_iff_isUnit_det` is listed as a dependency but not used in the actual Lean proof.

---

**Overall verdict**: All 12 blueprint-pinned declarations are present in the Lean file with correct signatures and standard-only axioms (no sorry, no project axioms, no red flags); the file is fully axiom-clean and the proofs faithfully execute the blueprint's mathematical arguments. Minor coverage debt from 4 unpinned helper lemmas and a slightly thin proof sketch for one lemma — nothing blocking.
