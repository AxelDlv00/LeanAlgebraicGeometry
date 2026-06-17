# Lean ↔ Blueprint Check Report

## Slug
grcells-iter033

## Iteration
033

## Files audited
- Lean: `AlgebraicJacobian/Picard/GrassmannianCells.lean` (1292 lines)
- Blueprint: `blueprint/src/chapters/Picard_GrassmannianCells.tex` (1928 lines)

---

## Per-declaration

The file has ~54 `\lean{...}`-pinned declarations. Below, only entries requiring comment are listed; all remaining checked declarations are noted in aggregate at the end.

### `\lean{AlgebraicGeometry.Grassmannian.isSeparated}` (chapter: `lem:gr_separated`)
- **Lean target exists**: **no** — no declaration named `isSeparated` appears in the file. The file ends (lines 1273–1289) with a `/-! ... -/` comment describing the remaining geometric assembly needed for the next iteration.
- **Signature matches**: N/A (target absent)
- **Proof follows sketch**: N/A
- **notes**: The statement block `lem:gr_separated` correctly carries no `\leanok` (so `sync_leanok` behaves correctly). However the `\lean{...}` pin is a dangling forward reference that the blueprint tool will fail to resolve. A `% NOTE:` annotation is needed to record it as planned future work. See **Major findings**.

### `\lean{AlgebraicGeometry.Grassmannian.isProper}` (chapter: `lem:gr_proper`)
- **Lean target exists**: **no** — pre-existing dangling forward reference; unchanged this iter.
- **notes**: Same situation as `isSeparated`; pre-existing; no `\leanok` (correct). Out of scope for this iter's diff but noted for completeness.

### Bulk check: all other `\lean{...}`-pinned declarations (52 entries)

All 52 remaining `\lean{...}`-pinned declarations exist, their signatures match the blueprint prose, and their proof strategies follow the stated sketches. Specifically verified for this iter's additions:

| Blueprint block | Lean declaration | Exists | Sig | Proof |
|---|---|---|---|---|
| — | `transitionPreMap_minorDet_swap_mul` (L1179) | ✓ | — | see below |
| — | `diagonalRingMap` (L1202) | ✓ | — | see below |
| — | `diagonalRingMap_left` (L1212) | ✓ | — | see below |
| — | `diagonalRingMap_right` (L1221) | ✓ | — | see below |
| — | `diagonalRingMap_surjective` (L1231) | ✓ | — | see below |
| — | `pullbackιIso` (L1267) | ✓ | — | see below |

(The "—" in the blueprint column means no dedicated `\lean{...}` block exists for these declarations — see **Unreferenced declarations** below.)

---

## Red flags

### Placeholder / suspect bodies
None. Every declaration in the file has a substantive body. No `:= sorry` appears anywhere. The three `private lemma` entries for `cocyclePhiId`'s helper lemmas (`rotMid`, `transitionInvImageMatrix`, `transitionInvPair`) all have genuine proofs.

### Excuse-comments
The `/-! ... -/` section at lines 1273–1289 explains what remains for `isSeparated` in the next iteration. This is informational narration in a doc-comment, not an excuse-comment attached to a placeholder declaration — the section contains no sorry'd or stub declaration, only helper lemmas with real proofs. Acceptable.

The module docstring (lines 8–21) says "This file contains the single blueprint-pinned declaration for the affine charts… `affineChart`." This is stale: the file now contains ~1300 lines of proved content. Minor documentation rot but not a correctness issue.

### Axioms / Classical.choice on non-trivial claims
None. No `axiom` declarations.

---

## Unreferenced declarations (informational)

The following declarations in the Lean file have **no** `\lean{...}` block in the blueprint:

### Substantive (flagged — should have blueprint blocks)

1. **`transitionPreMap_minorDet_swap_mul`** (L1179, `theorem`) — proves
   `θ̃_{I,J}(P^J_I) · P^I_J = 1` in `R^I_J`, the explicit inverse relation refining
   `isUnit_transitionPreMap_minorDet`. This is a non-trivial ring identity used directly
   by `diagonalRingMap_surjective`. The blueprint's `lem:gr_separated` proof sketch
   references this identity informally ("image contains `1/P^I_J = δ_{I,J}(1 ⊗ P^J_I)`")
   but there is no dedicated `\lean{...}` block.

2. **`diagonalRingMap`** (L1202, `noncomputable def`) — the tensor-product ring map
   `δ_{I,J} : ℤ[X^I] ⊗_ℤ ℤ[X^J] → R^I_J`. Explicitly described in the blueprint's
   `lem:gr_separated` proof and the Lean module's `/-! ... -/` section. No dedicated block.

3. **`diagonalRingMap_left`** (L1212, `theorem`) — `δ(a ⊗ 1) = algebraMap a`. One-line
   proof but part of the API needed for `pullback.hom_ext` coherence in the next iter.
   No dedicated block.

4. **`diagonalRingMap_right`** (L1221, `theorem`) — `δ(1 ⊗ b) = θ̃_{I,J}(b)`. Same
   status as `diagonalRingMap_left`. No dedicated block.

5. **`diagonalRingMap_surjective`** (L1231, `theorem`) — **the key substantive result**:
   surjectivity of `δ_{I,J}`, which is the mathematically essential ingredient for
   `isSeparated`. The blueprint proof of `lem:gr_separated` argues this explicitly.
   No dedicated `\lean{...}` block exists; the block for `lem:gr_separated` pins only
   the final `isSeparated` declaration.

6. **`pullbackιIso`** (L1267, `noncomputable def`) — the source iso
   `pullback (ι i) (ι j) ≅ chartOverlap d r i.1 j.1 i.2 j.2`. Needed as the `e₂`
   source identification in the closed-immersion argument for `isSeparated`. No dedicated
   block; implicitly referred to in the comment section and in the blueprint's
   `lem:gr_separated` proof ("By `def:gr_glued_scheme` the diagonal preimage is the
   overlap `U^I_J`").

### Helper-only private declarations (acceptable — no blueprint coverage needed)

7. `rotMid` (private, L944) — used internally by `cocyclePhiId`.
8. `transitionInvImageMatrix` (private, L961) — used internally by `transitionInvPair`.
9. `transitionInvPair` (private, L1026) — used internally by `cocyclePhiId`.
10. `awayMulCommEquiv_comp_algebraMap` (L847) — IS pinned in the blueprint (`lem:gr_awayMulCommEquiv_comp_algebraMap`, line 1325). ✓ OK.

### Pre-existing issue: blueprint pins private declarations (minor)

The blueprint uses `\lean{...}` to pin 8 declarations that are marked `private` in Lean:
`mul_submatrix_col`, `map_nonsing_inv`, `map_map_eq_of_comp`, `inv_mul_inv_mul_cancel`,
`isUnit_incl_transitionPreMap_cross`, `isUnit_algebraMap_away_left`,
`isUnit_algebraMap_away_right`, `imageMatrix_map_eq`, `cocycle_imageMatrix_eq`.
In Lean 4 the public name `AlgebraicGeometry.Grassmannian.X` does not exist for a
`private lemma X`; the blueprint tool's declaration lookup will fail. The `\leanok`
markers on these blocks were set (presumably by `sync_leanok` scanning unqualified
names), so the markers are correct, but the `\lean{...}` hints are technically wrong.
This is a pre-existing issue, not introduced this iter.

---

## Faithfulness audit of iter-033's new helpers

The directive asks specifically whether `diagonalRingMap`, `_left`, `_right`,
`diagonalRingMap_surjective`, `transitionPreMap_minorDet_swap_mul`, and `pullbackιIso`
are faithful to the blueprint's separatedness argument (`lem:gr_separated`).

**Blueprint argument** (`lem:gr_separated`, lines 1738–1780):
1. The restricted diagonal comorphism is `δ_{I,J} : R^I ⊗_ℤ R^J → R^I_J`, first
   factor = structure map, second factor = `θ_{I,J}`.
2. The image contains `X^I` (left factor) and `1/P^I_J` (via `δ(1 ⊗ P^J_I) = det((X^I_J)⁻¹)
   = 1/P^I_J`), hence all of `R^I_J`.

**Lean faithfulness check:**

- `transitionPreMap_minorDet_swap_mul` (L1179): proves
  `θ̃_{I,J}(P^J_I) · P^I_J = 1`. The proof reduces via
  `universalMatrix_map_transitionPreMap` and `imageMatrix_submatrix_I` to
  `det(universalMinorInv) · det(universalMinor) = 1`, matching the blueprint's
  `det((X^I_J)⁻¹) · P^I_J = 1` identity. **Faithful. ✓**

- `diagonalRingMap` (L1202): defined as `Algebra.TensorProduct.lift` of the structure
  map on the left and `transitionPreMap` on the right. Matches blueprint's
  `δ_{I,J}(X^I ⊗ 1 ↦ X^I, 1 ⊗ X^J ↦ (X^I_J)⁻¹ X^I)`. **Faithful. ✓**

- `diagonalRingMap_left` (L1212): `δ(a ⊗ 1) = algebraMap a`. **Faithful. ✓**

- `diagonalRingMap_right` (L1221): `δ(1 ⊗ b) = θ̃_{I,J}(b)`. **Faithful. ✓**

- `diagonalRingMap_surjective` (L1231): uses `IsLocalization.surj` to write any
  `z ∈ R^I_J` as `z = algebraMap(a) / P^I_J^n`, then provides witness
  `a ⊗ (P^J_I)^n` and closes using `transitionPreMap_minorDet_swap_mul` to cancel
  `(P^I_J · P^J_I)^n = 1`. This corresponds exactly to the blueprint's argument
  ("image contains all of `X^I`" via the left factor, and "`1/P^I_J`" via the right
  factor, generating all of `R^I_J`). **Faithful. ✓**

- `pullbackιIso` (L1267): constructs `pullback (ι i) (ι j) ≅ chartOverlap d r i.1 j.1`
  from `theGlueData.vPullbackConeIsLimit`. The blueprint says
  "`Δ^{-1}(U^I × U^J) = U^I ∩ U^J = U^I_J = Spec R^I[1/P^I_J]`". This matches. **Faithful. ✓**

No mathematical divergence found.

---

## Blueprint adequacy for this file

- **Coverage**: Of ~1292-line Lean file, approximately 52 declarations have `\lean{...}` blocks.
  The 6 new substantive declarations from this iter are uncovered (see above). This
  brings the blueprint-uncovered count to 6 substantive + 3 private helpers + stale docstring.
  **52/58 substantive declarations covered.**

- **Proof-sketch depth**: **adequate** for all existing covered blocks. The `lem:gr_separated`
  sketch (lines 1738–1780) gives enough mathematical content to reconstruct all 6 new helper
  declarations: the tensor-product `δ`, the left/right factor computations, and the
  surjectivity argument via `P^J_I` inverse. However, without dedicated `\lean{...}` blocks
  the helpers are invisible to the blueprint tool and cannot have their `\leanok` status
  tracked.

- **Hint precision**: **loose** for `lem:gr_separated` — the only `\lean{...}` is the final
  `isSeparated`, but five helpers (`diagonalRingMap`, `transitionPreMap_minorDet_swap_mul`,
  etc.) and the source iso (`pullbackιIso`) are not pinned. A prover reading the chapter would
  not know these intermediate targets need independent declaration.

- **Generality**: matches need (no parallel API gap).

- **Recommended chapter-side actions**:
  1. Add `% NOTE: AlgebraicGeometry.Grassmannian.isSeparated not yet formalized; helpers
     diagonalRingMap / diagonalRingMap_surjective / pullbackιIso proved this iter; geometric
     assembly (pullbackDiagonalMapIdIso, hom_ext coherence, Spec ℤ reconciliation) deferred
     to next iter.` to `lem:gr_separated`.
  2. Add dedicated definition block `def:gr_diagonal_ring_map` pinning
     `AlgebraicGeometry.Grassmannian.diagonalRingMap` with uses `def:gr_transition_pre`.
  3. Add a lemma block pinning `AlgebraicGeometry.Grassmannian.transitionPreMap_minorDet_swap_mul`
     (the explicit inverse `θ̃(P^J_I) · P^I_J = 1`), uses `lem:gr_transition_pre_unit`.
  4. Add a lemma block pinning `AlgebraicGeometry.Grassmannian.diagonalRingMap_surjective`,
     uses `def:gr_diagonal_ring_map` (new) and the explicit inverse lemma above.
  5. Add a definition block pinning `AlgebraicGeometry.Grassmannian.pullbackιIso` (source iso
     for the closed-immersion argument), uses `def:gr_glued_scheme`.
  6. (Cosmetic) Update the stale module docstring (L8–21) to reflect the file's current scope.
  7. (Pre-existing/low-priority) Promote the 8 blueprint-pinned `private` declarations to
     non-private, or correct the `\lean{...}` hints to reflect that their public names don't
     exist; the current `\leanok` markers are correctly set by `sync_leanok` but the name
     resolution in the blueprint tool will fail.

---

## Severity summary

- **must-fix-this-iter**: **None.** No placeholder sorries, no signature mismatches with
  blueprint prose, no axioms, no excuse-comments on substantive declarations. The dangling
  `isSeparated` pin is a known forward reference (no `\leanok`, consistent), not a
  placeholder. All 6 new helpers are sorry-free and faithful.

- **major** (2 findings):
  1. **Dangling `\lean{...}` in `lem:gr_separated`**: `AlgebraicGeometry.Grassmannian.isSeparated`
     does not exist. Needs `% NOTE:` annotation so the blueprint tool does not attempt resolution.
  2. **Blueprint coverage gap**: 5 new substantive declarations (`diagonalRingMap`,
     `diagonalRingMap_surjective`, `transitionPreMap_minorDet_swap_mul`,
     `diagonalRingMap_left`/`_right`, `pullbackιIso`) have no `\lean{...}` blocks. They
     will be invisible to `sync_leanok` and untrackable in the proof dashboard until
     dedicated blocks are added.

- **minor** (2 findings):
  1. Pre-existing: 8 private declarations are pinned with `\lean{...}` hints naming
     non-existent public names. `sync_leanok` works around this but the blueprint tool
     cannot resolve the names.
  2. Stale module docstring at L8–21.

**Overall verdict:** The iter-033 ring-theoretic and source-iso contributions are sorry-free, axiom-clean, and mathematically faithful to the blueprint's separatedness argument; the main gap is that 5 new substantive helpers and the source iso need dedicated blueprint blocks before `isSeparated` itself can land, and the dangling `isSeparated` pin needs a `% NOTE:` to signal its forward-reference status — 6 declarations checked this iter, 0 red flags on bodies, 2 major blueprint gaps.
