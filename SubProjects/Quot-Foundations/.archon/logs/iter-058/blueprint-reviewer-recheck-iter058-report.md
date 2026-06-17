# Blueprint Review: recheck-iter058
**Iter:** 058
**Scope:** Picard_SectionGradedRing.tex — two new spec blocks only

## Per-chapter

### `Picard_SectionGradedRing.tex`
- **Complete**: true
- **Correct**: true
- **must-fix-this-iter**: no

### Findings

#### `def:relTensorTriplePresheaf` (lines 443–470)
- Object formula given: `U ↦ P(U) ⊗_ℤ (O_X(U) ⊗_ℤ Q(U))`, restriction maps = ℤ-tensor of the three underlying restriction maps. ✓
- Functoriality: explicitly names `map_id` and `map_comp` (checked on elementary tensors by ⊗-induction). ✓ — answers query (a).
- Role in coequalizer stated (domain row of `lem:relativeTensor_as_coequalizer`). ✓
- **DAG edge concern (non-blocking):** `\uses{lem:relativeTensor_as_coequalizer}` points in the WRONG direction — the triple presheaf is an *input* to the coequalizer, not derived from it; the correct `\uses` would be `\uses{lem:presheafModule_monoidal_mathlib}` (matching `def:relTensorDomainPresheaf`). No cycle arises because `lem:relativeTensor_as_coequalizer` does NOT list `def:relTensorTriplePresheaf` in its own `\uses`. Also, Lean-side `relTensorTriplePresheaf` is already axiom-clean (iter-056), so this does not block dispatch of `relTensorActL`. Recommend writer correction for DAG hygiene, but not must-fix-this-iter.
- Missing `\uses` on `lem:relativeTensor_as_coequalizer` side: the proof of that lemma implicitly uses `def:relTensorTriplePresheaf` and `def:relTensorDomainPresheaf` (step 2 "three objectwise families assemble…") but neither is listed. This is a pre-existing missing edge, not introduced by this write; note for future writer pass.

#### `def:relTensorActL` (lines 472–507)
- Source/target presheaves named (`def:relTensorTriplePresheaf` → `def:relTensorDomainPresheaf`). ✓
- Component formula: `m ⊗ (s ⊗ n) ↦ (s · m) ⊗ n` (left-action form). Lean name `RelativeTensorCoequalizer.actLmap` cited explicitly. ✓ — answers query (b), component side.
- Naturality: "restriction of s · m equals (s|_V) · (m|_V), checked on elementary tensors by ⊗-induction" — corresponds to `map_smul` compatibility. ✓ — answers query (b), naturality side.
- `\uses{def:relTensorTriplePresheaf, def:relTensorDomainPresheaf, lem:relativeTensor_as_coequalizer}` — all appropriate. ✓
- No `\leanok` (unformalized) — expected; this is the prover target.

## Summary
Both new spec blocks pass. (a) `relTensorDomainPresheaf`/`relTensorTriplePresheaf` functoriality (`map_id`/`map_comp`): adequately specified. (b) `relTensorActL` component (`actLmap`, formula `(s·m)⊗n`) and naturality (`map_smul`): adequately specified. HARD GATE cleared for `Picard_SectionGradedRing.tex`.

The one non-blocking finding (backwards `\uses` edge in `def:relTensorTriplePresheaf`) is correctness-category but does not affect prover dispatch given that `relTensorTriplePresheaf` is already axiom-clean on the Lean side.
