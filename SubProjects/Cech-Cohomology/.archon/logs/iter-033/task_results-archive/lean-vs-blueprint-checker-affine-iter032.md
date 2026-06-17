# Lean ↔ Blueprint Check Report

## Slug
affine-iter032

## Iteration
032

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (blocks: `lem:affine_faces_mem`, `lem:standard_cover_cofinal`, `lem:to_sheaf_preserves_epi`,
  `lem:affine_surj_of_vanishing`, `lem:cover_datum_bridge`, `lem:affine_injective_acyclic`,
  `def:affine_cover_system`)

---

## Per-declaration

### `\lean{AlgebraicGeometry.affine_faces_mem}` (chapter: `lem:affine_faces_mem`)
- **Lean target exists**: yes (line 37)
- **Signature matches**: yes — blueprint says "every finite intersection D(g_{i₀}) ∩ ⋯ ∩ D(g_{iₚ}) is again a distinguished open"; Lean states `⨅ k, PrimeSpectrum.basicOpen (s (σ k)) ∈ Set.range (fun f => PrimeSpectrum.basicOpen f)`, which is the correct typed formulation.
- **Proof follows sketch**: yes — blueprint proof: "D(f) ∩ D(g) = D(fg), iterate over the face"; Lean proof: `⟨∏ k, s (σ k), (basicOpen_sprod ...).symm⟩`, a one-liner using `basicOpen_sprod`. Mathematical content matches.
- **notes**: `\leanok` present on both statement and proof blocks. No discrepancies.

---

### `\lean{AlgebraicGeometry.standard_cover_cofinal}` (chapter: `lem:standard_cover_cofinal`)
- **Lean target exists**: yes (line 131)
- **Signature matches**: yes (faithful) — blueprint: "every open covering of D(f) admits a refinement that is a standard open cover"; Lean: `∃ (n : ℕ) (g : Fin n → R) (φ : Fin n → α), (... = ⨆ i, PrimeSpectrum.basicOpen (g i)) ∧ ∀ i, PrimeSpectrum.basicOpen (g i) ≤ W (φ i)`. The explicit ∃-witnesses (n, g, φ) are the correct Lean encoding of "admits a refinement with explicit mapping back to the original cover". The abstract cofinal-system prose maps directly to this indexed-refinement form.
- **Proof follows sketch**: yes (mathematically) — blueprint: "quasi-compactness of D(f) + basic-open basis → finite subcover"; Lean: uses `PrimeSpectrum.isCompact_basicOpen f`, `PrimeSpectrum.isTopologicalBasis_basic_opens`, and `IsCompact.elim_finite_subcover`. Mathematical content matches.
- **notes**: **Two inaccurate `\uses` annotations** (see Red Flags below). `\leanok` present on statement and proof blocks.

---

### `\lean{AlgebraicGeometry.toSheaf_preservesEpimorphisms}` (chapter: `lem:to_sheaf_preserves_epi`)
- **Lean target exists**: no — no declaration with this name appears in `AffineSerreVanishing.lean` or any imported file. The module-level comment (lines 87–121) explicitly defers this. No `\leanok` on the blueprint block (correctly absent).
- **Signature matches**: N/A (not formalized)
- **Proof follows sketch**: N/A (not formalized); **blueprint proof sketch is inaccurate** — see Blueprint Adequacy below.
- **notes**: `% NOTE (iter-032)` comment in the blueprint already flags non-formalization. The `\lean{...}` hint pins the target name correctly for a future prover.

---

### `\lean{AlgebraicGeometry.affine_surj_of_vanishing}` (chapter: `lem:affine_surj_of_vanishing`)
- **Lean target exists**: no — gated on `toSheaf_preservesEpimorphisms`; no `\leanok` (correctly absent).
- **Signature matches**: N/A (not formalized)
- **Proof follows sketch**: N/A
- **notes**: Expected absent. Blueprint proof sketch is detailed (3 steps: local surjectivity → refine to standard cover → glue via Ȟ¹=0). Adequacy of the step-2 detail depends on resolving `lem:to_sheaf_preserves_epi` first.

---

### `\lean{AlgebraicGeometry.coverOpen_affineOpenCoverOfSpan}` (chapter: `lem:cover_datum_bridge`)
- **Lean target exists**: yes (line 53)
- **Signature matches**: yes — blueprint: "coverOpen 𝒰 i = D(s_i) in Opens(Spec R)"; Lean: `coverOpen (...).openCover i = PrimeSpectrum.basicOpen (s i)`. Exact match.
- **Proof follows sketch**: yes — blueprint: "by construction the i-th member of the standard affine cover is D(s_i)"; Lean unfolds `coverOpen`, applies `Spec.map_base` and `PrimeSpectrum.localization_away_comap_range`. Mathematical content: open range of the localization map = D(s_i). Matches.
- **notes**: `\leanok` on statement and proof. No discrepancies.

---

### `\lean{AlgebraicGeometry.affine_injective_acyclic}` (chapter: `lem:affine_injective_acyclic`)
- **Lean target exists**: yes (line 74)
- **Signature matches**: yes — blueprint: "Ȟ^p(𝒰, I) = 0 for p > 0, where 𝒰 is a standard cover of the whole affine (spanning hypothesis)"; Lean: `IsZero (cechCohomology (fun i => PrimeSpectrum.basicOpen (s i)) ((Scheme.Modules.toPresheafOfModules (Spec R)).obj I) q)` with hypotheses `Ideal.span (Set.range s) = ⊤` and `0 < q`. Matches.
- **Proof follows sketch**: yes — blueprint: "the opens of 𝒰 are D(s_i) (lem:cover_datum_bridge), apply family-form injective Čech-acyclicity"; Lean: rewrites via `coverOpen_affineOpenCoverOfSpan`, then applies `injective_cech_acyclic`. Matches.
- **notes**: `\leanok` on statement and proof. No discrepancies.

---

### `\lean{AlgebraicGeometry.affineCoverSystem}` (chapter: `def:affine_cover_system`)
- **Lean target exists**: no — gated on `affine_surj_of_vanishing` (which is gated on `toSheaf_preservesEpimorphisms`); no `\leanok` (correctly absent).
- **Signature matches**: N/A (not formalized)
- **Proof follows sketch**: N/A
- **notes**: Expected absent.

---

## Red Flags

### Inaccurate `\uses` annotations on `lem:standard_cover_cofinal`

**Statement-level `\uses{def:standard_affine_cover, lem:scheme_isBasis_affineOpens}`**:

The `lem:scheme_isBasis_affineOpens` annotation claims the proof depends on `Scheme.isBasis_affineOpens` (the Mathlib lemma for general schemes, `AlgebraicGeometry.Scheme.isBasis_affineOpens`). The actual Lean proof (line 140) uses `PrimeSpectrum.isTopologicalBasis_basic_opens`, a different Mathlib lemma specific to `Spec R`. While mathematically equivalent for affine schemes, the dependency graph in the blueprint is misleading: `standard_cover_cofinal` formally depends on the PrimeSpectrum-specific result, not the general scheme result.

**Proof-level `\uses{def:standard_affine_cover, lem:affine_faces_mem}`**:

The `lem:affine_faces_mem` claim is wrong. The Lean proof of `standard_cover_cofinal` does not call `affine_faces_mem` anywhere; it goes directly to `PrimeSpectrum.isTopologicalBasis_basic_opens` (basis membership) and `IsCompact.elim_finite_subcover`. The blueprint correctly uses `affine_faces_mem` in the informal sketch of *cofinality as a system* (Tag 009L), but the Lean proof for the refinement step does not invoke it.

Severity: **major** — stale `\uses` annotations misdirect the dependency graph.

---

## Unreferenced declarations (informational)

All four Lean declarations in the file (`affine_faces_mem`, `coverOpen_affineOpenCoverOfSpan`, `affine_injective_acyclic`, `standard_cover_cofinal`) are referenced by `\lean{...}` blocks in the blueprint. No unreferenced declarations.

---

## Blueprint adequacy for this file

- **Coverage**: 4/7 `\lean{...}`-tagged declarations are formalized; 3 correctly absent (no `\leanok`). The 4 formalized ones all have matching Lean targets.
- **Proof-sketch depth**: **under-specified** for `lem:to_sheaf_preserves_epi`; adequate for all formalized declarations.
- **Hint precision**: **loose** for `lem:standard_cover_cofinal` (wrong Mathlib lemma named in `\uses`); **precise** for all other formalized declarations.
- **Generality**: matches need.

### `lem:to_sheaf_preserves_epi` — proof sketch is inaccurate

The blueprint proof block (lines 3487–3493) states:

> "The underlying abelian-sheaf functor on sheaves of O_X-modules is additive and exact (it preserves finite colimits, **being a left adjoint composed with the exact sheafification–forgetful comparison**), so it sends the cokernel of g to the cokernel of the image of g..."

This is **wrong in two ways**:

1. **Wrong adjointness direction.** `SheafOfModules.toSheaf R : SheafOfModules R ⥤ Sheaf (Opens X)^{op} Ab` is NOT a left adjoint in the direction that would imply right-exactness. The sheafification functor is a *left* adjoint to the inclusion of sheaves into presheaves, but `toSheaf` here goes from `SheafOfModules` to `Sheaf Ab` — it is not a left adjoint in any direction that would give `PreservesFiniteColimits`. The blueprint's claim "being a left adjoint" gives a false path for a prover.

2. **Mathlib gap not acknowledged in the proof block.** Mathlib ships `PreservesFiniteLimits (toSheaf R)` (`Mathlib.Algebra.Category.ModuleCat.Sheaf.Limits:118`) but does NOT ship `PreservesFiniteColimits`. The proof sketch implies this is available or trivially derivable, which is false — it is the exact missing instance blocking formalization.

The `% NOTE (iter-032)` comment accurately diagnoses the problem, but it appears only as a LaTeX comment (invisible to a reader of the rendered blueprint PDF). The proof block as written will mislead any prover who encounters it without the comment.

**Recommended chapter-side actions**:
- Replace the proof block for `lem:to_sheaf_preserves_epi` with accurate content: (a) state that Mathlib only has left-exactness (`PreservesFiniteLimits`), not right-exactness; (b) identify the real path as building `PreservesFiniteColimits` via the sheafification adjunction at the level of `PresheafOfModules`; (c) remove the incorrect "left adjoint" claim.
- Promote the `% NOTE` content into the main proof block or a `\begin{remark}...\end{remark}` so it is visible in the rendered output and guides future provers.
- Correct the `\uses` annotations on `lem:standard_cover_cofinal` (statement: replace `lem:scheme_isBasis_affineOpens` with a note that the proof uses `PrimeSpectrum.isTopologicalBasis_basic_opens` directly; proof: remove `lem:affine_faces_mem`).

---

## Severity summary

| Finding | Severity |
|---------|----------|
| `lem:to_sheaf_preserves_epi` proof sketch wrong (left adjoint claim) and understates real difficulty (Mathlib has only `PreservesFiniteLimits`) | **must-fix-this-iter** |
| `lem:standard_cover_cofinal` statement `\uses` names wrong Mathlib basis lemma (`Scheme.isBasis_affineOpens` vs. `PrimeSpectrum.isTopologicalBasis_basic_opens`) | **major** |
| `lem:standard_cover_cofinal` proof `\uses` incorrectly lists `lem:affine_faces_mem` (not called) | **major** |

**Overall verdict**: The four formalized declarations are correct and faithful to their blueprint statements; the must-fix finding is entirely on the blueprint side — the proof sketch for `lem:to_sheaf_preserves_epi` contains a wrong adjointness claim and a gap-acknowledgment that lives only in a LaTeX comment, leaving the rendered blueprint misleading for any prover who attempts this gap-fill.
