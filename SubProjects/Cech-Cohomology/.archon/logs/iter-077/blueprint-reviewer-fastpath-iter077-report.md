# Blueprint Review: fastpath-iter077
**Iter:** 077

## Top-level summaries

- **Directive items**: All 6 items from prior `capstone-iter077` review resolved (see per-chapter notes).
- **DAG**: `unknown_uses: []`, `isolated: 0`. Clean.
- **Rendering**: `malformed_refs: []`, `broken_refs: []`, `orphan_chapters: []`.
- **covers_problems**: `CechTermAcyclic.lean` flagged as missing file — **expected/known**, file being added this iter. Not a blocker.
- **Advisory (non-blocking)**: `lem:rightAcyclic_finite_prod` proof sketch says "additive right-derived functor preserves finite biproducts" — correct informally, but Lean path is via biproduct-of-injective-resolutions, not functor-additivity directly. Adequate for a prover; not must-fix.

## Unstarted-phase proposals

None. Only active phase P5b has full blueprint coverage in `Cohomology_CechHigherDirectImage.tex`. All other phases are Completed.

## Per-chapter

### `Cohomology_CechHigherDirectImage.tex`
- **Complete**: true
- **Correct**: true
- **Notes**:
  1. **Item 1 (Seam a)** ✓ — `lem:pushforward_mapHC_cechComplexOnX` (L11846): statement present, `\lean{AlgebraicGeometry.pushforward_mapHomologicalComplex_cechComplexOnX}`, `\uses{def:cech_complex_on_X, def:cech_complex}` (both defined at L7048, L119). Proof explicitly invokes additivity of f_* and `map_sum` identity for the alternating coface sum. Adequate.
  2. **Item 2 (Seam b)** ✓ — `lem:cechAugmented_to_acyclicResolutionInput` (L11886): index-shift spelled out ("augmentation shifts homological degree by one"); `e:F≅cycles 0` extraction complete (injectivity from vanishing at degree 0, surjectivity onto ker d⁰ from vanishing at degree 1). `\uses{lem:cech_augmented_resolution, def:cech_complex_on_X, def:cech_augmented_complex}` all defined.
  3. **Item 3 (`lem:rightAcyclic_finite_prod`)** ✓ — L11820, `\lean{AlgebraicGeometry.rightAcyclic_finite_prod}`. No `\uses` — CORRECT (leaf, no project blueprint deps, pure Mathlib facts). Proof: finite product = finite biproduct → additive RD functor distributes. Advisory: Lean path likely via biproduct of injective resolutions; blueprint is adequate.
  4. **Item 4 (`lem:cech_computes_cohomology_affineCover`)** ✓ — L11927, `\lean{AlgebraicGeometry.cech_computes_higherDirectImage_of_affineCover}`. Explicit hypotheses: f separated QC, X separated (`[X.IsSeparated]` context), `h𝒰 : ∀ i, IsAffine (𝒰.X i)`. Assembly proof has 4 steps: (a) `lem:cechAugmented_to_acyclicResolutionInput` extracts `e:F≅cycles 0` + exactness; (b) `lem:cech_term_pushforward_acyclic` gives termwise acyclicity; (c) `lem:acyclic_resolution_computes_derived` applied; (d) `lem:pushforward_mapHC_cechComplexOnX` rewrites `f_*C•` as `Č•(U,F)`. `\uses` (statement and proof) agree: `lem:cech_augmented_resolution, lem:cech_term_pushforward_acyclic, lem:acyclic_resolution_computes_derived, lem:pushforward_mapHC_cechComplexOnX, lem:cechAugmented_to_acyclicResolutionInput, def:cech_complex, def:higher_direct_image`. Counterexample remark ("single-element cover with X non-affine breaks termwise acyclicity") is mathematically correct.
  5. **Item 5 (covers)** ✓ — L19: `CechToHigherDirectImage.lean`; L20: `CechTermAcyclic.lean`. Both present. `missing_file` warning for `CechTermAcyclic.lean` from blueprint-doctor is expected (file added this iter).
  6. **Item 6 (`lem:cech_term_pushforward_acyclic` \uses)** ✓ — L11638: `\uses{..., lem:pushPull_sigma_iso, lem:rightAcyclic_finite_prod}`. Both present (L8563, L11820). Proof \uses at L11672 matches.

### `Cohomology_HigherDirectImage.tex`
- **Complete**: true
- **Correct**: true
- **Notes**: Single def `def:higher_direct_image` (L26). Clean.

### `Cohomology_AcyclicResolution.tex`
- **Complete**: true
- **Correct**: true
- **Notes**: Pre-existing P4 chapter, no new issues.

## Severity summary

- **must-fix this iter**: none
- **advisory (non-blocking)**: `lem:rightAcyclic_finite_prod` proof sketch slightly informal re: Lean biproduct path — prover should look for `biproduct.lift/desc` + `IsZero.of_iso` path, not `map_sum`.

## HARD GATE verdict

`Cohomology_CechHigherDirectImage.tex`: **complete: true / correct: true**. No must-fix findings. Gate is **satisfied** for both `CechToHigherDirectImage.lean` and `CechTermAcyclic.lean`. Provers may be dispatched.
