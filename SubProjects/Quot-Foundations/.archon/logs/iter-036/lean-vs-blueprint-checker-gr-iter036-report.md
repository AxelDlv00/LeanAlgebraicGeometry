# Lean ↔ Blueprint Check Report

## Slug
gr-iter036

## Iteration
036

## Files audited
- Lean: `AlgebraicJacobian/Picard/GrassmannianCells.lean` (1632 lines)
- Blueprint: `blueprint/src/chapters/Picard_GrassmannianCells.tex` (2564 lines)

---

## Per-declaration

### E1 — `\lean{AlgebraicGeometry.Grassmannian.existence_chart_factorization}` (chapter: `lem:gr_existence_chart_factorization`)

- **Lean target exists**: yes — `theorem existence_chart_factorization` at line 1559
- **Signature matches**: yes
  - Blueprint: "there exist a size-d subset I and a ring hom f : R^I → K with i₁ = Spec(f) ∘ ι_I"
  - Lean: `∃ (I : (theGlueData d r).J) (f : MvPolynomial (...) ℤ →+* K), i₁ = Spec.map (CommRingCat.ofHom f) ≫ (theGlueData d r).ι I`
  - Matches: field argument is a field K, output is the exact factorisation claimed.
- **Proof follows sketch**: yes — uses `ι_jointly_surjective` + `IsOpenImmersion.lift` + `Spec.preimage` exactly as the blueprint describes.
- **`\leanok`**: present on blueprint block — consistent with axiom-clean Lean proof.
- **notes**: E1 had no `% LEAN SIGNATURE` comment; the prover designed a signature that faithfully captures the prose. No issues.

---

### E2 — `\lean{AlgebraicGeometry.Grassmannian.existence_minimal_valuation}` (chapter: `lem:gr_existence_minimal_valuation`)

- **Lean target exists**: yes — `theorem existence_minimal_valuation` at line 1583
- **Signature matches**: yes
  - Blueprint: choose J maximising v(f(P^I_J)); conclude f(P^I_J) ≠ 0.
  - Lean: `∃ J : (theGlueData d r).J, (∀ J', valuation R K (f (minorDet ... J' ...)) ≤ valuation R K (f (minorDet ... J ...))) ∧ f (minorDet ... J ...) ≠ 0`
  - Matches. Uses `Finite.exists_max` to find the maximum (multiplicative valuation = minimum additive), `minorDet_self` to bound from below by 1, then concludes non-zero.
- **Proof follows sketch**: yes — matches blueprint exactly.
- **`\leanok`**: present on blueprint block.
- **notes**: Blueprint has a `% LEAN SIGNATURE` hint. Lean matches the hint's intent. The direction of ≤ (max via `∀ J', v(J') ≤ v(J)`) correctly corresponds to Nitsure's minimum-additive / maximum-multiplicative setup.

---

### E3 ratio core helper — `existence_lift_transitionPreMap_minorDet_mul` (NO blueprint block)

- **Lean target exists**: yes — `theorem existence_lift_transitionPreMap_minorDet_mul` at line 1619
- **Blueprint `\lean{...}` pin**: **ABSENT** — no blueprint block, no `\lean{...}` reference anywhere in the chapter
- **Signature**: The Lean statement captures the displayed equation in the E3 proof body:
  ```
  (IsLocalization.Away.lift (minorDet d r I J hI hJ) hf)
      (transitionPreMap d r I J hI hJ (minorDet d r J K hJ hK))
      * f (minorDet d r I J hI hJ)
    = f (minorDet d r I K hI hK)
  ```
  i.e. `f'(θ̃_{I,J}(P^J_K)) · f(P^I_J) = f(P^I_K)`, the pulled-back minor-ratio identity.
- **Proof quality**: clean (applies `transitionPreMap_minorDet_mul` via `congrArg` through the localisation lift). No sorry.
- **notes**: This is a substantive, self-contained lemma (the algebraic core of E3) currently buried in the E3 proof text rather than having its own blueprint block. **Coverage debt — see Blueprint Adequacy below.**

---

### E3-full — `\lean{AlgebraicGeometry.Grassmannian.existence_factor_through_valuationRing}` (chapter: `lem:gr_existence_factor_through_valuation_ring`)

- **Lean target exists**: **no** — no declaration with this name exists in the file
- **Blueprint `\leanok`**: **absent** — block is correctly unmarked, acknowledging the open obligation
- **Chapter acknowledges gap**: yes — the proof body of `lem:gr_existence_factor_through_valuation_ring` explicitly states:
  > "(This entry-as-minor sign bookkeeping is the one sub-step with no pre-existing matrix-algebra scaffold; it requires expanding the determinant of a column-substituted identity matrix.)"
- **notes**: E3-full is correctly shown as an open obligation. The chapter is not claiming it done. The cofactor-expansion gap (expressing x^J_{p,q} as ±P^J_{K'} via column-substitution of the identity) is honestly acknowledged.

---

### E4 — `\lean{AlgebraicGeometry.Grassmannian.existence_lift}` (chapter: `lem:gr_existence_lift`)

- **Lean target exists**: **no** — absent from the file
- **Blueprint `\leanok`**: **absent** — open obligation correctly marked
- **notes**: E4 and subsequent declarations (`valuativeExistence_toSpecZ`, `isProper`) are all absent from Lean and correctly have no `\leanok` in the chapter. Not blocking anything in the current iter.

---

### Declarations with `\lean{...}` pins that exist and are formalized (spot-check)

All 74 previously-completed `\lean{...}`-pinned blocks checked. All declarations exist with matching names and signatures. Below are a few spot-checks of interest:

| Blueprint label | Lean decl | Status |
|---|---|---|
| `def:gr_affine_chart` | `affineChart` (line 56) | ✓ |
| `lem:gr_cocycle` | `cocycleCondition` (line 604) | ✓ |
| `lem:gr_cocycle_phi_id` | `cocyclePhiId` (line 1066) | ✓ |
| `def:gr_glued_scheme` | `scheme` (line 1157) | ✓ |
| `lem:gr_separated` | `isSeparated` (line 1413) | ✓ |
| `lem:gr_isProper_of_valuativeExistence` | `isProper_of_valuativeExistence` (line 1531) | ✓ |
| `lem:gr_transitionPreMap_minorDet_mul` | `transitionPreMap_minorDet_mul` (line 1495) | ✓ |

---

## Red flags

No red flags found:
- **No `:= sorry`** anywhere in the file for any formalized declaration
- **No suspect bodies** (`:= True`, `:= rfl` on non-trivial claims)
- **No excuse-comments** (`-- TODO replace`, `-- temporary`, `-- placeholder`, `-- wrong but works`)
- **No `axiom` declarations** in the file

The scaffold section header at line 1422 (`/-! ## Project-local Mathlib supplement — properness scaffold ...`) is a section comment, not an excuse-comment; the declarations in that section all have real proofs.

---

## Unreferenced declarations (informational)

The following Lean declarations have no `\lean{...}` reference in the blueprint:

| Declaration | Line | Assessment |
|---|---|---|
| `private lemma rotMid` | 944 | Private helper for `cocyclePhiId`; acceptable as implementation detail |
| `private lemma transitionInvImageMatrix` | 961 | Private helper for `cocyclePhiId`; acceptable |
| `private lemma transitionInvPair` | 1026 | Private helper for `cocyclePhiId`; acceptable |
| `theorem existence_lift_transitionPreMap_minorDet_mul` | 1619 | **Substantive — should have a blueprint block** (see Coverage Debt) |

---

## Blueprint adequacy for this file

### Coverage
- **74 / 78 Lean declarations** have a corresponding `\lean{...}` block in the chapter.
- 4 are open forward-declarations with no Lean target yet (E3-full, E4, `valuativeExistence_toSpecZ`, `isProper`).
- 4 unreferenced declarations: 3 private cocycle helpers (acceptable) + 1 substantive helper needing a block.

### Private-lemma `\lean{...}` pin mismatch
Nine `private lemma` declarations are `\lean{...}`-pinned with their public qualified names in the blueprint:
`mul_submatrix_col` (165), `map_nonsing_inv` (301), `isUnit_incl_transitionPreMap_cross` (366), `isUnit_algebraMap_away_left` (401), `isUnit_algebraMap_away_right` (411), `map_map_eq_of_comp` (479), `imageMatrix_map_eq` (487), `inv_mul_inv_mul_cancel` (514), `cocycle_imageMatrix_eq` (524).

In Lean 4, `private` gives declarations a mangled internal name, not `AlgebraicGeometry.Grassmannian.X`. The `\lean{...}` pin as written cannot resolve externally. However, `\leanok` is already present on all these blocks (presumably accepted by `sync_leanok`), so the project tooling has accepted this pattern. Flagged as **minor** — the convention is cosmetic documentation within this project.

### Proof-sketch depth
- **E1, E2**: adequate — the blueprint proof sketches are detailed enough and the Lean proofs follow them.
- **E3 ratio core**: **under-specified** — the equation `f'(θ̃_{I,J}(P^J_K)) · f(P^I_J) = f(P^I_K)` appears only as a mid-proof displayed equation in `lem:gr_existence_factor_through_valuation_ring`, not as a named lemma block. The prover produced a clean standalone theorem for it.
- **E3-full proof**: The proof body is partially complete — it covers the minor-ratio step but openly states the cofactor-expansion gap. This is honest.

### Blueprint adequacy verdict
- **Proof-sketch depth**: adequate for formalized parts; under-specified for E3 ratio core (needs its own block)
- **Hint precision**: precise for all existing pins
- **Generality**: matches need
- **Recommended chapter-side actions**:
  1. Add a named lemma block for the E3 ratio core, pinned to `\lean{AlgebraicGeometry.Grassmannian.existence_lift_transitionPreMap_minorDet_mul}`:
     ```
     \begin{lemma}\label{lem:gr_existence_lift_transitionPreMap_minorDet_mul}
     \lean{AlgebraicGeometry.Grassmannian.existence_lift_transitionPreMap_minorDet_mul}
     \uses{lem:gr_transitionPreMap_minorDet_mul, lem:mathlib_away_lift}
     Let f' : R^I_J → F be the away-localisation lift of f. Then for every K,
       f'(θ̃_{I,J}(P^J_K)) · f(P^I_J) = f(P^I_K).
     \end{lemma}
     ```
  2. Reference this new block from the proof of `lem:gr_existence_factor_through_valuation_ring`.

---

## Severity summary

### must-fix-this-iter
None.

### major
- **Missing blueprint block for `existence_lift_transitionPreMap_minorDet_mul`** (the E3 ratio core helper, line 1619). This is a substantive formalized lemma with no `\lean{...}` pin in the chapter. A blueprint block should be added so the prover for E3-full can reference it directly, and so the blueprint's coverage graph includes it. The missing block does not block *existing* formalized declarations, but leaves the most important new helper of this iter undocumented in the blueprint.

### minor
- Nine `private lemma` declarations have `\lean{...}` pins with their would-be public qualified names. The project's `sync_leanok` machinery has accepted these. The cosmetic mismatch between Lean's private-name mangling and the blueprint's name should eventually be resolved (make them non-private, or annotate them with `@[private]` + a public alias), but is not blocking.
- `\lean{...}` pins for E3-full, E4, `valuativeExistence_toSpecZ`, `isProper` point to non-existent declarations. These are forward-declarations; the absence of `\leanok` correctly marks them open. Not errors.

---

## Overall verdict

**Clean for all formalized declarations — 1 major coverage debt (missing E3 ratio core blueprint block).** 74 declarations checked; 0 red flags; 1 substantive unreferenced helper (`existence_lift_transitionPreMap_minorDet_mul`, the E3 ratio core) needs a blueprint block; E3-full correctly shown open; E1/E2 pins valid and signatures faithful.
