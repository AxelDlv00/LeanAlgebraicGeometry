# Lean ↔ Blueprint Check Report

## Slug
gr-iter012

## Iteration
012

## Files audited
- Lean: `AlgebraicJacobian/Picard/GrassmannianCells.lean`
- Blueprint: `blueprint/src/chapters/Picard_GrassmannianCells.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Grassmannian.affineChart}` (chapter: def:gr_affine_chart)
- **Lean target exists**: yes
- **Signature matches**: partial — the blueprint requires `I` with `#I = d` but the Lean signature omits `hI : I.card = d`; the definition is valid for all `I` (more general than blueprinted, not wrong).
- **Proof follows sketch**: N/A (definition, no proof body to compare)
- **notes**: Blueprint says "for I with #I = d"; Lean drops that guard. Mathematically harmless (the scheme is well-defined for any I), but creates a slight contract mismatch. `\leanok` present on statement block.

### `\lean{AlgebraicGeometry.Grassmannian.universalMatrix}` (chapter: def:gr_universal_matrix)
- **Lean target exists**: yes
- **Signature matches**: yes — `Matrix (Fin d) (Fin r) (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)`, carries `hI : I.card = d`. Entry formula (identity block via `orderIsoOfFin`, free indeterminate otherwise) matches blueprint exactly.
- **Proof follows sketch**: N/A
- **notes**: `\leanok` present.

### `\lean{AlgebraicGeometry.Grassmannian.minorDet}` (chapter: def:gr_minor_det)
- **Lean target exists**: yes
- **Signature matches**: yes — `det` of the J-submatrix reindexed via `J.orderIsoOfFin hJ`.
- **Proof follows sketch**: N/A
- **notes**: `\leanok` present.

### `\lean{AlgebraicGeometry.Grassmannian.universalMinor}` (chapter: def:gr_universal_minor)
- **Lean target exists**: yes
- **Signature matches**: yes — `Matrix (Fin d) (Fin d) (Localization.Away (minorDet d r I J hI hJ))`, J-minor base-changed along `algebraMap`.
- **Proof follows sketch**: N/A
- **notes**: `\leanok` present.

### `\lean{AlgebraicGeometry.Grassmannian.isUnit_det_universalMinor}` (chapter: lem:gr_minorDet_unit)
- **Lean target exists**: yes
- **Signature matches**: yes — `IsUnit (universalMinor d r I J hI hJ).det`
- **Proof follows sketch**: yes — uses `RingHom.map_det` to equate det with the image of `minorDet`, then applies `IsLocalization.Away.algebraMap_isUnit`, exactly as the blueprint sketch describes.
- **notes**: `\leanok` on both statement and proof blocks.

### `\lean{AlgebraicGeometry.Grassmannian.universalMinorInv}` (chapter: def:gr_universalMinorInv)
- **Lean target exists**: yes
- **Signature matches**: yes — `:= (universalMinor d r I J hI hJ)⁻¹`
- **Proof follows sketch**: N/A
- **notes**: `\leanok` present.

### `\lean{AlgebraicGeometry.Grassmannian.universalMinorInv_mul_cancel}` (chapter: lem:gr_universalMinorInv_identities)
- **Lean target exists**: yes
- **Signature matches**: yes — a conjunction `(inv * minor = 1) ∧ (minor * inv = 1)`, exactly as blueprinted.
- **Proof follows sketch**: yes — one-liner applying `Matrix.nonsing_inv_mul` and `Matrix.mul_nonsing_inv` given `isUnit_det_universalMinor`, matching the blueprint sketch.
- **notes**: `\leanok` on both statement and proof blocks.

### `\lean{AlgebraicGeometry.Grassmannian.imageMatrix}` (chapter: def:gr_image_matrix)
- **Lean target exists**: yes
- **Signature matches**: yes — `universalMinorInv * (universalMatrix.map algebraMap)` in `Mat(d×r)(R^I_J)`.
- **Proof follows sketch**: N/A
- **notes**: `\leanok` present.

### `\lean{AlgebraicGeometry.Grassmannian.transitionPreMap}` (chapter: def:gr_transition_pre)
- **Lean target exists**: yes
- **Signature matches**: yes — `MvPolynomial (Fin d × {q // q ∉ J}) ℤ →ₐ[ℤ] Localization.Away (minorDet d r I J hI hJ)` via `MvPolynomial.aeval (fun e => imageMatrix … e.1 e.2.1)`.
- **Proof follows sketch**: N/A
- **notes**: `\leanok` present.

### `\lean{AlgebraicGeometry.Grassmannian.isUnit_transitionPreMap_minorDet}` (chapter: lem:gr_transition_pre_unit)
- **Lean target exists**: yes
- **Signature matches**: yes — `IsUnit (transitionPreMap d r I J hI hJ (minorDet d r J I hJ hI))`
- **Proof follows sketch**: yes — proves `θ̃(P^J_I) = det(X^I_J)⁻¹` via `imageMatrix_submatrix_I` and then `IsUnit.of_mul_eq_one`, matching the blueprint's chain `det(θ̃(X^J_I)) = det((X^I_J)⁻¹) = unit`.
- **notes**: `\leanok` on both statement and proof blocks.

### `\lean{AlgebraicGeometry.Grassmannian.transitionMap}` (chapter: def:gr_transition)
- **Lean target exists**: yes
- **Signature matches**: yes — `Localization.Away (minorDet d r J I hJ hI) →+* Localization.Away (minorDet d r I J hI hJ)` via `IsLocalization.Away.lift`.
- **Proof follows sketch**: N/A
- **notes**: `\leanok` present.

### `\lean{AlgebraicGeometry.Grassmannian.transitionMap_self}` (chapter: lem:gr_transition_self)
- **Lean target exists**: yes
- **Signature matches**: yes — `transitionMap d r I I hI hI = RingHom.id (Localization.Away (minorDet d r I I hI hI))`
- **Proof follows sketch**: yes — proves `universalMinor = 1`, hence `universalMinorInv = 1`, hence `imageMatrix = X^I map algebraMap`, hence `transitionPreMap = algebraMap`, then uses `IsLocalization.ringHom_ext` to conclude. Each step matches the blueprint's sketch.
- **notes**: `\leanok` on both statement and proof blocks. The proof is substantially more detailed than the blueprint sketch (the sketch is two sentences; the Lean is ~20 lines), which is expected for formal work.

### `\lean{AlgebraicGeometry.Grassmannian.cocycleCondition}` (chapter: lem:gr_cocycle)
- **Lean target exists**: yes
- **Signature matches**: yes — `cocycleΘIK d r I J K hI hJ hK = (cocycleΘIJ …).comp (cocycleΘJK …)`, the propositional ring-hom equality over the triple-overlap rings `S_K →+* S_I`. Exactly as specified in the blueprint comment.
- **Proof follows sketch**: yes — the blueprint sketch describes a matrix computation reducing both sides to `(Y_K)⁻¹ Y` with `Y = X^I`. The Lean proof uses `IsLocalization.ringHom_ext` and `MvPolynomial.ringHom_ext`, delegating the matrix identity to `cocycle_imageMatrix_eq`, which in turn uses `imageMatrix_map_eq` to establish exactly this reduction. The mathematical content matches.
- **notes**: `\leanok` on both statement and proof blocks. `lean_verify` confirms the theorem uses only `propext`, `Classical.choice`, `Quot.sound` — the standard Lean 4 foundational axioms; no extra axioms introduced.

### `\lean{AlgebraicGeometry.Grassmannian.scheme}` (chapter: def:gr_glued_scheme)
- **Lean target exists**: no — no `scheme` declaration in the Lean file.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint statement block has NO `\leanok`; this is unformalized planned work. Not a red flag for this iteration.

### `\lean{AlgebraicGeometry.Grassmannian.isSeparated}` (chapter: lem:gr_separated)
- **Lean target exists**: no
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint block has no `\leanok`. Unformalized future work.

### `\lean{AlgebraicGeometry.Grassmannian.isProper}` (chapter: lem:gr_proper)
- **Lean target exists**: no
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint block has no `\leanok`. Unformalized future work.

### Mathlib-backed references (informational)
- `\lean{IsLocalization.Away.algebraMap_isUnit}` — `\mathlibok`, not a project obligation.
- `\lean{Matrix.nonsing_inv_mul}` — `\mathlibok`.
- `\lean{Matrix.mul_nonsing_inv}` — `\mathlibok`.
- `\lean{IsLocalization.Away.lift}` — `\mathlibok`.

---

## Red flags

*No red flags found.*

### Placeholder / suspect bodies
None. `grep -c sorry` returns 0. All 13 project-local declarations with `\leanok` have concrete, closed proof bodies.

### Excuse-comments
None. No TODO/placeholder/temporary/wrong-but-works comments anywhere in the file.

### Axioms / Classical.choice on non-trivial claims
None. The file contains zero `axiom` declarations. `lean_verify` on `cocycleCondition` (the most complex theorem) confirms the only axioms are the three standard Lean 4 foundations (`propext`, `Classical.choice`, `Quot.sound`). `Classical.choice` enters through Mathlib's noncomputable infrastructure (localisation, nonsingular inverses), which the blueprint implicitly authorises by directing use of `Localization.Away` and `Matrix.nonsing_inv`.

---

## Unreferenced declarations (informational)

21 declarations in the Lean file have no `\lean{...}` blueprint reference. The file correctly marks many as `private`. Public declarations worth noting:

| Declaration | Line | Status |
|---|---|---|
| `universalMatrix_submatrix_self` | 150 | Public theorem. Proves the I-minor of X^I is the identity. The blueprint mentions this fact inline in the proof sketches of `lem:gr_transition_self` but assigns no separate `\lean{}` tag. **Borderline: should have a blueprint entry.** |
| `mul_submatrix_col` | 165 | `private lemma`. Pure matrix helper; acceptable as private. |
| `imageMatrix_submatrix_self` | 173 | Public theorem. Proves M_J = 1. Blueprint mentions this inline in `def:gr_image_matrix` ("Its J-minor is 1") but gives no tag. |
| `imageMatrix_submatrix_I` | 187 | Public theorem. Proves M_I = (X^I_J)^{-1}. Blueprint mentions inline but untouched. |
| `universalMatrix_map_transitionPreMap` | 202 | Public theorem. The key lemma "θ̃_{I,J}(X^J) = imageMatrix". Blueprint's prose for `def:gr_transition_pre` asserts this but doesn't tag a Lean theorem for it. |
| `awayInclLeft` / `awayInclRight` | 310, 322 | Public defs. Infrastructure for triple-overlap rings. Described only in the blueprint comment block on `lem:gr_cocycle`; no `\lean{}` tags. |
| `awayInclLeft/Right_comp_algebraMap` | 334, 341 | Public lemmas. Same. |
| `transitionPreMap_minorDet` | 349 | Public theorem. Maps `minorDet d r J K` through `transitionPreMap` to the det of a submatrix of `imageMatrix`. Essential sub-step of `isUnit_transitionPreMap_minorDet` and the cocycle. No blueprint entry. |
| `cocycleΘIJ`, `cocycleΘJK`, `cocycleΘIK` | 422, 441, 460 | Public defs. The triple-overlap transition maps that appear in the statement of `cocycleCondition`. Blueprint comment describes them structurally but gives no `\lean{}` tags. |
| `cocycle_imageMatrix_eq` | 524 | `private lemma`. Central matrix identity of the cocycle proof; acceptable as private. |
| `map_nonsing_inv`, `map_map_eq_of_comp`, `imageMatrix_map_eq`, `isUnit_incl_transitionPreMap_cross`, `inv_mul_inv_mul_cancel`, `isUnit_algebraMap_away_{left,right}` | various | `private` helpers; acceptable. |

---

## Blueprint adequacy for this file

- **Coverage**: 13/16 project-local `\lean{}`-tagged declarations are formalized in this file (the remaining 3 — `scheme`, `isSeparated`, `isProper` — are correctly unformalized and absent `\leanok`). 21 Lean declarations have no blueprint tag: 14 are `private` helpers (acceptable), 7 are public declarations representing substantial infrastructure.

- **Proof-sketch depth**: **adequate** for the 13 formalized declarations. Every formalized theorem has a proof body that matches the corresponding blueprint sketch (or, for the simple ones, is more detailed than the sketch requires). The blueprint comment on `lem:gr_cocycle` is notably thorough — it resolves the triple-overlap ring type-checking issue and describes the matrix-reduction strategy in detail. This guidance was clearly used by the prover.

- **Hint precision**: **precise** for all 13 formalized items. The `\lean{...}` hints match the Lean declaration names and the signature comments in the blueprint match the Lean signatures.

- **Generality**: **matches need** for the formalized content. One minor exception: `affineChart` in Lean omits `hI : I.card = d`, making it slightly more general than the blueprint specifies (no downstream harm identified).

- **Recommended chapter-side actions**:
  1. **(major)** Add `\lean{}` entries for `cocycleΘIJ`, `cocycleΘJK`, `cocycleΘIK` — they appear in the statement of the blueprinted `cocycleCondition` and a future prover/reader needs to know they exist. The blueprint comment describes them; promoting to proper definition blocks with `\lean{}` tags would close the gap.
  2. **(major)** Add `\lean{AlgebraicGeometry.Grassmannian.universalMatrix_map_transitionPreMap}` as a named lemma block (the matrix identity θ̃_{I,J}(X^J) = M, currently referenced only in prose).
  3. **(minor)** Add `\lean{}` stubs for `awayInclLeft`, `awayInclRight` (and their comp-algebraMap lemmas) so the triple-overlap infrastructure is discoverable.
  4. **(minor)** Add `\lean{}` stubs for `universalMatrix_submatrix_self`, `imageMatrix_submatrix_self`, `imageMatrix_submatrix_I`, `transitionPreMap_minorDet` — all are key sub-lemmas referenced in blueprint proof sketches but unnamed.
  5. **(future iteration)** Formalize `scheme` (def:gr_glued_scheme), `isSeparated` (lem:gr_separated), `isProper` (lem:gr_proper). The blueprint proofs are detailed and self-contained; the missing piece is the scheme-gluing machinery (likely requires `AlgebraicGeometry.GluingData` or a Mathlib gluing API).

---

## Severity summary

**must-fix-this-iter**: 0 — no sorries, no wrong bodies, no excuse-comments, no rogue axioms, no signature mismatches on formalized declarations.

**major**: 2
1. `affineChart` (line 56) omits `hI : I.card = d` compared to the blueprint's stated domain. Signature is more general, not wrong, but deviates from the blueprinted contract; downstream uses all pass `hI` to downstream declarations so in practice the chart is only used in the `hI = d` context, but the definition itself is unguarded.
2. Blueprint adequacy gap: `cocycleΘIJ/JK/IK` and `universalMatrix_map_transitionPreMap` are public, substantive declarations central to the stated `cocycleCondition` but have no `\lean{}` blueprint entries. A blueprint-writing subagent should address items 1–2 of recommended actions.

**minor**: 4 — naming drift on the `affineChart` guard; four further public helpers (`universalMatrix_submatrix_self`, `imageMatrix_submatrix_{self,I}`, `transitionPreMap_minorDet`) lack blueprint stubs; the three future declarations (`scheme`, `isSeparated`, `isProper`) are unformalized but correctly unmarked.

**Overall verdict**: The Lean file is clean and faithful — all 13 formalized declarations match their blueprint blocks in signature and proof content, with no sorries, no wrong definitions, and no red flags; the two major findings are a minor generality gap in `affineChart`'s signature and a blueprint coverage gap for the triple-overlap infrastructure that the prover built to prove `cocycleCondition`.
