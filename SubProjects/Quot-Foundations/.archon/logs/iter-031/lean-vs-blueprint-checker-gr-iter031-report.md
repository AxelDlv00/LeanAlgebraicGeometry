# Lean ↔ Blueprint Check Report

## Slug
gr-iter031

## Iteration
031

## Files audited
- Lean: `AlgebraicJacobian/Picard/GrassmannianCells.lean`
- Blueprint: `blueprint/src/chapters/Picard_GrassmannianCells.tex`

---

## Per-declaration (iter-031 additions and pinned blocks)

### `\lean{AlgebraicGeometry.Grassmannian.cocyclePhiId}` (chapter: `lem:gr_cocycle_phi_id`)
- **Lean target exists**: yes — `theorem cocyclePhiId` at line 1066
- **Signature matches**: yes
  - Blueprint: "composite Φ := Θ_{I,J,K} ∘ swap_J ∘ Θ_{J,K,I} ∘ swap_K ∘ Θ_{K,I,J} ∘ swap_I = RingHom.id on Localization.Away(P^I_J · P^I_K)"
  - Lean: `(cocycleΘIJ ...).comp (awayMulCommEquiv.toRingHom.comp (cocycleΘIJ ...).comp (...))) = RingHom.id (Localization.Away (minorDet * minorDet))`
  - The 6-fold chain of Θ / swap homs and the `= RingHom.id` conclusion match exactly.
- **Proof follows sketch**: partial — blueprint sketch describes a generator-level check (`IsLocalization.ringHom_ext` → chart-ring generators → reuse `cocycle_imageMatrix_eq`). The Lean proof instead telescopes algebraically in three modular steps:
  1. `rotMid`: absorbs `swap_J ∘ Θ_{J,K,I} ∘ swap_K` into `Θ_{J,K}`;
  2. `cocycleCondition`: collapses `Θ_{I,J} ∘ Θ_{J,K}` to `Θ_{I,K}`;
  3. `transitionInvPair`: proves the residual `Θ_{I,K} ∘ Θ_{K,I} ∘ swap_I = id`.
  Mathematical content is the same (both reduce to the `(Y_K)⁻¹ Y` matrix collapse), but the modular structure is cleaner than the prose sketch implies.
- **Notes**: no sorry; no red flags; proof term correct.

### `\lean{AlgebraicGeometry.Grassmannian.scheme}` (chapter: `def:gr_glued_scheme`)
- **Lean target exists**: yes — `noncomputable def scheme` at line 1157
- **Signature matches**: yes
  - Blueprint: "Gluing the affine charts {U^I} along the transition isomorphisms θ_{I,J} yields a scheme Gr(r,d) → Spec ℤ"
  - Lean: `noncomputable def scheme (d r : ℕ) : Scheme := (theGlueData d r).glued`
  - Type is `Scheme`, constructed as the `.glued` of the GlueData. Correct.
- **Proof follows sketch**: N/A (definition)
- **Notes**: no sorry; the NOTE at `def:gr_glued_scheme` (iter-031) correctly reads "FULLY FORMALIZED and axiom-clean"; `#print axioms` would return only `{propext, Classical.choice, Quot.sound}` per the NOTE.

### `\lean{AlgebraicGeometry.Grassmannian.chartTransition'_cocycle}` (no blueprint block)
- **Lean target exists**: yes — `theorem chartTransition'_cocycle` at line 1106
- **Blueprint block**: **MISSING** — this public theorem is only mentioned in prose/NOTE inside `def:gr_glued_scheme` but has no dedicated `\lean{...}` block.
- **Signature matches**: N/A (no block to compare against)
- **Notes**: declaration is substantive (the `cocycle` field of the GlueData), not a private helper; needs a blueprint block.

### `\lean{AlgebraicGeometry.Grassmannian.theGlueData}` (no blueprint block)
- **Lean target exists**: yes — `noncomputable def theGlueData` at line 1141
- **Blueprint block**: **MISSING** — referenced only in prose inside `def:gr_glued_scheme`; no `\lean{...}` block.
- **Notes**: the GlueData bundle is the key intermediate structure between the raw chart-ring data and `scheme`; its absence from the blueprint's `\lean{}` index means `sync_leanok` cannot track it independently.

### `\lean{AlgebraicGeometry.Grassmannian.awayMulCommEquiv_comp_awayInclLeft}` (no blueprint block)
- **Lean target exists**: yes — `lemma awayMulCommEquiv_comp_awayInclLeft` at line 935 (public, not private)
- **Blueprint block**: **MISSING** — directive notes this as coverage debt. Conceptually it is the key identity `swap_{x,y} ∘ ι^L_{x,y} = ι^R_{y,x}` used inside `rotMid`.
- **Notes**: minor coverage gap.

### Private iter-031 helpers (coverage-debt, per directive)
`rotMid` (line 944), `transitionInvImageMatrix` (line 961), `transitionInvPair` (line 1026) are all `private lemma` — no blueprint blocks expected, but each implements a non-trivial step:
- `rotMid`: collapses the middle rotation of Φ to `cocycleΘJK`
- `transitionInvImageMatrix`: the matrix collapse `(X^K_I)⁻¹ X^K → X^I` under `θ_{I,K}`
- `transitionInvPair`: the ring identity `Θ_{I,K} ∘ Θ_{K,I} ∘ swap_I = id`

All are sorry-free, mathematically sound, and serve as modular sub-lemmas for `cocyclePhiId`.

---

## Red flags

### Placeholder / suspect bodies
None. All iter-031 additions (`cocyclePhiId`, `chartTransition'`, `chartTransition'_cocycle`, `theGlueData`, `scheme`, helpers) have non-sorry bodies.

### Excuse-comments
The raised `maxHeartbeats` comments at lines 876 and 1098 are legitimate performance annotations (the `erw` through `HasPullback` instance diamonds on heavy MvPolynomial objects is genuinely defeq-expensive). Not excuse-comments.

### Pre-existing private vs. public name mismatch (major, pre-iter-031)
Nine declarations in the chapter are marked `private` in Lean but have `\lean{AlgebraicGeometry.Grassmannian.Name}` pins in the blueprint using the public-namespace form:

| Blueprint `\lean{...}` | Lean declaration | Line |
|---|---|---|
| `mul_submatrix_col` | `private lemma mul_submatrix_col` | 165 |
| `map_nonsing_inv` | `private lemma map_nonsing_inv` | 300 |
| `isUnit_incl_transitionPreMap_cross` | `private lemma isUnit_incl_transitionPreMap_cross` | 366 |
| `isUnit_algebraMap_away_left` | `private lemma isUnit_algebraMap_away_left` | 402 |
| `isUnit_algebraMap_away_right` | `private lemma isUnit_algebraMap_away_right` | 410 |
| `map_map_eq_of_comp` | `private lemma map_map_eq_of_comp` | 479 |
| `imageMatrix_map_eq` | `private lemma imageMatrix_map_eq` | 487 |
| `inv_mul_inv_mul_cancel` | `private lemma inv_mul_inv_mul_cancel` | 514 |
| `cocycle_imageMatrix_eq` | `private lemma cocycle_imageMatrix_eq` | 524 |

In Lean 4, `private` declarations receive a mangled internal name `_private.<hash>.Name`; the public-namespace form `AlgebraicGeometry.Grassmannian.Name` does not exist as a resolvable name in `lake env lean`. This breaks `sync_leanok` (which calls `#print axioms Ns.Name`) for each of these nine blocks. The `\leanok` markers on these blocks are therefore stale/unreliable. This is a **pre-existing** issue (the `\leanok` markers were set before iter-031) but it must be fixed: either make the declarations non-private, or update the `\lean{...}` pins to use the underscore-prefixed private names (or remove the pins and mark the blocks `\mathlibok`-adjacent as internal helpers).

### Axioms / Classical.choice
None introduced; the NOTE at `def:gr_glued_scheme` confirms axiom-clean.

---

## Unreferenced declarations (informational)

The following public declarations have no `\lean{...}` pin:

| Declaration | Type | Significance |
|---|---|---|
| `chartTransition'_cocycle` (line 1106) | theorem | Substantive: scheme-level cocycle field of GlueData |
| `theGlueData` (line 1141) | def | Substantive: the `Scheme.GlueData` bundle |
| `awayMulCommEquiv_comp_awayInclLeft` (line 935) | lemma | Helper, used in `rotMid` |
| `chartTransition'_ringIdentity` (line 861) | theorem | Has a blueprint block at `lem:gr_chartTransition'_ringIdentity` — already covered |
| `chartTransition'_fac` (line 884) | theorem | Has a blueprint block at `lem:gr_chartTransition'_fac` — already covered |

Note: `chartTransition'_ringIdentity` and `chartTransition'_fac` do have blueprint blocks (checked above); they are not missing.

The three `private` iter-031 helpers (`rotMid`, `transitionInvImageMatrix`, `transitionInvPair`) are intentionally unblocked per the directive.

---

## Blueprint adequacy for this file

- **Coverage**: 40+ of ~50 substantive Lean declarations have `\lean{...}` blocks. Missing blocks: `chartTransition'_cocycle`, `theGlueData`, `awayMulCommEquiv_comp_awayInclLeft` (public); and the 4 private iter-031 helpers (acceptable to omit). The nine pre-existing private declarations with mismatched pins inflate the nominal coverage number but are functionally broken (see Red flags above).
- **Proof-sketch depth**: adequate overall. The `def:gr_glued_scheme` block is an exceptionally detailed construction narrative (~300 words), enumerating every GlueData field and how the cocycle reduces to the ring identity. The `lem:gr_cocycle_phi_id` sketch correctly identifies the key strategy. Minor gap: the sketch describes generator-level expansion while the Lean proof uses the cleaner 3-step telescoping (rotMid → cocycleCondition → transitionInvPair); the prose could note this structure explicitly.
- **Hint precision**: precise for all pinned declarations. The `\lean{...}` hints name the correct Lean declarations throughout.
- **Generality**: matches need. The blueprint correctly anticipates the triple-overlap ring structure, the product-order mismatch (awayMulCommEquiv), and the pullback-iso leg lemmas.
- **Recommended chapter-side actions**:
  1. Add a `\begin{definition}...\end{definition}` block with `\lean{AlgebraicGeometry.Grassmannian.theGlueData}` immediately before `def:gr_glued_scheme`.
  2. Add a `\begin{lemma}...\end{lemma}` block with `\lean{AlgebraicGeometry.Grassmannian.chartTransition'_cocycle}` (the scheme-level cocycle theorem) between `lem:gr_chartTransition'_fac` and `lem:gr_cocycle_phi_id`.
  3. Add a `\begin{lemma}...\end{lemma}` block with `\lean{AlgebraicGeometry.Grassmannian.awayMulCommEquiv_comp_awayInclLeft}` in the order-swap subsection.
  4. Fix the nine pre-existing private `\lean{...}` pins (items in the Red flags table above). Options: (a) remove `private` from each declaration so the public name is valid, or (b) wrap each in a separate public `alias` or `lemma` stub that the `\lean{...}` pin points at, or (c) replace each `\lean{Name}` pin with `\mathlibok` and a note that the result is an internal lemma.
  5. Expand the proof sketch in `lem:gr_cocycle_phi_id` to name the three modular steps (`rotMid` → `cocycleCondition` → `transitionInvPair`) so the proof structure is documented at the right granularity.

---

## Severity summary

| Finding | Severity |
|---|---|
| `chartTransition'_cocycle` — no `\lean{...}` block for a substantive public theorem | **major** |
| `theGlueData` — no `\lean{...}` block for a substantive public def | **major** |
| Nine pre-existing private declarations with broken public-namespace `\lean{...}` pins (breaks `sync_leanok`) | **major** (pre-existing, not iter-031 introduced) |
| `awayMulCommEquiv_comp_awayInclLeft` — no block (public helper) | **minor** |
| `rotMid`, `transitionInvImageMatrix`, `transitionInvPair` — no blocks (private, acknowledged coverage debt) | **minor** |
| `lem:gr_cocycle_phi_id` proof sketch coarser than 3-step telescoping Lean proof | **minor** |

**Overall verdict**: The iter-031 GR-glue formalization is mathematically correct, sorry-free, and axiom-clean; all `\lean{...}`-pinned iter-031 declarations (`cocyclePhiId`, `scheme`) match the blueprint statements precisely. Two substantive public declarations (`theGlueData`, `chartTransition'_cocycle`) need blueprint blocks, and nine pre-existing private declarations have broken `\lean{...}` pins that impair `sync_leanok` — these are the outstanding chapter-side obligations before the GR-glue chapter can be declared fully synchronized.
