# Lean ↔ Blueprint Check Report

## Slug
gr-iter026

## Iteration
027

## Files audited
- Lean: `AlgebraicJacobian/Picard/GrassmannianCells.lean`
- Blueprint: `blueprint/src/chapters/Picard_GrassmannianCells.tex`

---

## Per-declaration (blueprint-referenced blocks)

All pre-existing blueprint blocks (`def:gr_affine_chart` through `lem:gr_cocycle`) have
correctly-named Lean targets, carry `\leanok`, and no sorrys. Signatures match the informal
prose. Only notable issues are flagged below; routine matches are summarised in the coverage
count.

### `\lean{AlgebraicGeometry.Grassmannian.mul_submatrix_col}` (chapter: `lem:gr_mul_submatrix_col`)
- **Lean target exists**: `mul_submatrix_col` is in the file — as `private lemma mul_submatrix_col`
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `private` in Lean 4 means the Lean name is mangled; the blueprint's `\lean{...}` hint references a name that does not exist in the public namespace. The `\leanok` marker appears to have been set anyway (probably by sync_leanok checking file-level compilation, not declaration-level lookup). Same issue applies to 8 other private helpers listed below.

### `\lean{AlgebraicGeometry.Grassmannian.map_nonsing_inv}` (chapter: `lem:gr_map_nonsing_inv`)
- **Lean target exists**: yes — as `private lemma map_nonsing_inv`
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: private-name mismatch (see above).

### `\lean{AlgebraicGeometry.Grassmannian.map_map_eq_of_comp}` (chapter: `lem:gr_map_map_eq_of_comp`)
- **Lean target exists**: yes — as `private lemma map_map_eq_of_comp`
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: private-name mismatch.

### `\lean{AlgebraicGeometry.Grassmannian.inv_mul_inv_mul_cancel}` (chapter: `lem:gr_inv_mul_inv_mul_cancel`)
- **Lean target exists**: yes — as `private lemma inv_mul_inv_mul_cancel`
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: private-name mismatch.

### `\lean{AlgebraicGeometry.Grassmannian.isUnit_incl_transitionPreMap_cross}` (chapter: `lem:gr_isUnit_incl_transitionPreMap_cross`)
- **Lean target exists**: yes — as `private lemma isUnit_incl_transitionPreMap_cross`
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: private-name mismatch.

### `\lean{AlgebraicGeometry.Grassmannian.isUnit_algebraMap_away_left}` (chapter: `lem:gr_isUnit_algebraMap_away_left`)
- **Lean target exists**: yes — as `private lemma isUnit_algebraMap_away_left`
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: private-name mismatch.

### `\lean{AlgebraicGeometry.Grassmannian.isUnit_algebraMap_away_right}` (chapter: `lem:gr_isUnit_algebraMap_away_right`)
- **Lean target exists**: yes — as `private lemma isUnit_algebraMap_away_right`
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: private-name mismatch.

### `\lean{AlgebraicGeometry.Grassmannian.imageMatrix_map_eq}` (chapter: `lem:gr_imageMatrix_map_eq`)
- **Lean target exists**: yes — as `private lemma imageMatrix_map_eq`
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: private-name mismatch.

### `\lean{AlgebraicGeometry.Grassmannian.cocycle_imageMatrix_eq}` (chapter: `lem:gr_cocycle_imageMatrix_eq`)
- **Lean target exists**: yes — as `private lemma cocycle_imageMatrix_eq`
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: private-name mismatch.

### `\lean{AlgebraicGeometry.Grassmannian.scheme}` (chapter: `def:gr_glued_scheme`)
- **Lean target exists**: **no** — not yet formalized. Correctly unmarked in blueprint (no `\leanok`).
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Still open. 11 iter-026 declarations build the scaffolding for this.

---

## Red flags

### Placeholder / suspect bodies
None. All 11 iter-026 declarations have genuine proof bodies; no `:= sorry`.

### Excuse-comments
None. The inline comments (`Project-local.`, `Blueprint reference:`) are documentation, not excuses.

### Axioms / Classical.choice on non-trivial claims
None.

---

## Unreferenced declarations (iter-026 additions — substantive, not helpers)

The following 11 declarations added in iter-026 have **no** corresponding `\lean{...}` block in
the blueprint. The module docstring of the containing `section` correctly attributes them to
`def:gr_glued_scheme`, but that coarse block does not break them out:

| Declaration | Lean type | Blueprint status |
|---|---|---|
| `minorDet_self` | `theorem` | uncovered — feeds `chartIncl_self_isIso` |
| `chartOverlap` | `noncomputable def` | uncovered — `V`-object of GlueData |
| `chartIncl` | `noncomputable def` | uncovered — `f`-field of GlueData |
| `chartIncl_isOpenImmersion` | `instance` | uncovered — **`\mathlibok` candidate** (body is `inferInstanceAs`) |
| `chartIncl_self_isIso` | `theorem` | uncovered — `f_id`-field of GlueData |
| `chartTransition` | `noncomputable def` | uncovered — `t`-field of GlueData |
| `chartTransition_self` | `theorem` | uncovered — `t_id`-field of GlueData |
| `awayPullbackIso` | `noncomputable def` | uncovered — **`\mathlibok` candidate** (pure `pullbackSpecIso` + `IsLocalization.algEquiv`) |
| `awayPullbackIso_inv_fst` | `theorem` | uncovered — **`\mathlibok` candidate** (uses `pullbackSpecIso_inv_fst`) |
| `awayPullbackIso_inv_snd` | `theorem` | uncovered — **`\mathlibok` candidate** (uses `pullbackSpecIso_inv_snd`) |
| `awayMulCommEquiv` | `noncomputable def` | uncovered — **`\mathlibok` candidate** (pure `IsLocalization.algEquiv` via `mul_comm`) |

**`\mathlibok` rationale for the five flagged entries:**

- `chartIncl_isOpenImmersion` — body is `inferInstanceAs (IsOpenImmersion (Spec.map ...))`. The
  instance is `instIsOpenImmersionMapOfHomAwayAlgebraMap` (or similar) from Mathlib. No Archon proof
  obligation; mark `\mathlibok`.
- `awayPullbackIso` — assembles `pullbackSpecIso` (Mathlib) and `IsLocalization.algEquiv`
  (Mathlib) using `IsLocalization.Away.mul'` (Mathlib). The proof is a one-liner over these three
  Mathlib facts; mark `\mathlibok`.
- `awayPullbackIso_inv_fst` — proof pivots on `pullbackSpecIso_inv_fst` (Mathlib) plus a
  `ringHom_ext` wrapped around Mathlib's `algEquiv.commutes`; mark `\mathlibok`.
- `awayPullbackIso_inv_snd` — symmetric to above; mark `\mathlibok`.
- `awayMulCommEquiv` — one `haveI : IsLocalization.Away (y * x) (Localization.Away (x * y))` via
  `mul_comm` then `IsLocalization.algEquiv`; entirely Mathlib; mark `\mathlibok`.

---

## Blueprint adequacy for this file

- **Coverage**: 38/49 Lean declarations have a corresponding `\lean{...}` block. 11 substantive
  iter-026 declarations are uncovered (not helpers); 9 covered declarations are private (see §2).
- **Proof-sketch depth**: **under-specified** for the GlueData section. The `def:gr_glued_scheme`
  block (the only block in §"The glued Grassmannian scheme") contains neither a proof body nor a
  breakdown of the five GlueData fields (`V`, `f`, `f_id`, `t`, `t_id`, `t_fac`, `cocycle`). It
  gives no indication of: (a) how the triple-overlap pullback factors through `awayPullbackIso`;
  (b) why `awayMulCommEquiv` is needed at all (the product-order mismatch between `cocycleΘIJ`'s
  domain `R[1/(P^J_I · P^J_K)]` and `awayPullbackIso`'s codomain `R[1/(P^J_K · P^J_I)]`); (c) in
  what order to assemble `t_fac` using `awayPullbackIso_inv_fst/_snd` and `awayMulCommEquiv`. A
  prover targeting `Scheme.GlueData` from the current prose alone would have no route to
  `awayMulCommEquiv`.
- **Hint precision**: **loose** for the 9 private declarations (blueprint uses public-looking names
  that are inaccessible outside the file in Lean 4). **Absent** for the 11 iter-026 declarations.
  Correct for the remaining 29 public declarations.
- **Generality**: matches need — the abstractions chosen (general `A : CommRing` in
  `awayPullbackIso`/`awayMulCommEquiv`) are correctly motivated and future-proofed against the
  heavy chart ring.
- **Recommended chapter-side actions**:
  1. **[must-fix-this-iter]** Add a GlueData subsection inside `sec:gr_glued` breaking out the five
     fields. For each of the 11 iter-026 declarations add either a `\lean{...}` block (if Archon
     should own the proof) or a `\mathlibok` block (for the five Mathlib-backed entries). Minimally,
     `awayMulCommEquiv` needs a block explaining the product-order mismatch and the `orderSwap`
     identity.
  2. **[major]** For the 9 private helpers with `\lean{...}` hints: either remove `private` so the
     names are exported, or remove the `\lean{...}` hints (replace with inline prose referencing the
     containing declaration). Leaving private declarations with public `\lean{...}` hints will cause
     any declaration-level name lookup to return "not found".
  3. Add `\lean{AlgebraicGeometry.Grassmannian.scheme}` to `def:gr_glued_scheme` (the target Lean
     name for the `.glued` field of the assembled `Scheme.GlueData`).

---

## Severity summary

| ID | Finding | Severity |
|---|---|---|
| B1 | `def:gr_glued_scheme` blueprint is under-specified (no GlueData field breakdown, no `awayMulCommEquiv` hint, no `t_fac` route) — prover cannot formalize `Scheme.GlueData` from prose alone | **must-fix-this-iter** |
| B2 | 11 iter-026 substantive declarations lack `\lean{...}` blocks; 5 are `\mathlibok` candidates ready to close | **major** |
| B3 | 9 private declarations referenced by blueprint's `\lean{...}` hints via unmangled public names (those names do not exist in Lean 4's exported namespace) | **major** |
| B4 | `def:gr_glued_scheme` missing `\lean{AlgebraicGeometry.Grassmannian.scheme}` hint | **minor** |

**Overall verdict**: the Lean side is axiom-clean and faithful for all completed declarations
(iter-026 additions carry no sorrys and correct signatures), but the blueprint chapter has a
must-fix adequacy gap for the next GlueData build: it does not document the 11 iter-026
intermediary declarations, does not explain the product-order subtlety that requires
`awayMulCommEquiv`, and gives no GlueData field breakdown to guide assembly of
`Scheme.GlueData`. — 49 declarations checked, 1 must-fix + 2 major + 1 minor finding.
