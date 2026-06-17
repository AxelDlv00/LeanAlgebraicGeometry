# Blueprint Review: gate078
**Iter:** 078

## Top-level summaries

- **DAG**: 0 unknown_uses, 0 conflicts, 0 isolated nodes, 1 sorry (frozen `cech_computes_higherDirectImage` — expected, strategy-known).
- **Rendering**: blueprint-doctor clean: 0 malformed_refs, 0 broken_refs, 0 orphan chapters, 0 covers_problems.
- **All `\uses{}` valid** (leandag confirms).
- **Unmatched `\lean{}`**: 86 entries — all on `\mathlibok` blocks (Mathlib-provided, expected, not a defect).
- **No must-fix items** on blueprint side. HARD GATE CLEARED for `CechToHigherDirectImage.lean`.

## Unstarted-phase proposals

OMIT — all strategy phases complete or active. No unstarted phases found.

## Per-chapter

### `Cohomology_CechHigherDirectImage.tex`
- **Complete**: true
- **Correct**: true
- **Covers**: 18 Lean files; primary focus file `CechToHigherDirectImage.lean`.

**Focus-block verdicts (directive items):**

**`lem:cech_term_pushforward_acyclic`** (line 11688):
- Statement: `f` quasi-compact + `[X.IsSeparated]` + `[S.IsSeparated]` + `hres` per-intersection. CORRECT.
- Route via `f∘j_σ` affine (Stacks 01SG, needs `S.IsSeparated`) is explicitly stated in the blueprint body. CORRECT.
- `\uses{lem:affine_serre_vanishing, def:cech_nerve, lem:higher_direct_image_presheaf, lem:isQuasicoherent_pullback_opens, lem:pushPull_sigma_iso, lem:rightAcyclic_finite_prod}` — all labels verified present (leandag unknown_uses: []). ACCURATE.
- Blueprint does NOT carry `[IsSeparated f]` as explicit hypothesis (Lean producer has it additionally as a redundancy from the outer theorem). Not a defect — producer is GREEN-VERIFIED.

**`lem:isQuasicoherent_pullback_opens`** (line 11636):
- Statement: pullback of qcoh along open immersion is qcoh. WELL-FORMED.
- Proof sketch: cover by affine opens, use site-theoretic over-category equivalence, transport qcoh presentation. ADEQUATE.
- `\uses{lem:isQuasicoherent_restrict_basicOpen, lem:restrict_over_compat, lem:restrictFunctorIsoPullback_mathlib}` — all valid (leandag confirms). ACCURATE.
- Many `\lean{}` names listed (modules-over-opens equivalence chain). Not verified individually, but leandag reports no unmatched\_lean for this node (it has `\leanok`-covered siblings).

**`lem:cech_computes_cohomology_affineCover`** (line 12023):
- Statement: `f` separated + `[S.IsSeparated]`, with `[X.IsSeparated]` DERIVED via separated-cancellation (f: X→S separated, S→Spec Z separated ⟹ X→Spec Z separated). Scope paragraph (X-separated specialisation of 02KE) present. `hres` family carried. CORRECT and FAITHFUL target.
- Lean target `cech_computes_higherDirectImage_of_affineCover` currently has `[X.IsSeparated]` (not `[S.IsSeparated]`) + no `hres` — this is the PROVER'S residual work, NOT a blueprint defect. Blueprint correctly describes the final intended signature.
- Proof sketch (lines 12082–12107): feeds `cechAugmented_to_acyclicResolutionInput` → `cechTerm_pushforward_acyclic` → P4 assembly → rewrite via `pushforward_mapHC_cechComplexOnX`. ADEQUATE.
- Soft note: proof sketch says "Lemma~\ref{lem:cech_term_pushforward_acyclic} supplies termwise acyclicity" without explicitly mentioning `hres n` is passed. The `hres` is in scope from the outer hypothesis — inferable by any prover. Not a must-fix.
- `\uses{...}` — all 7 labels verified present. ACCURATE.

**`lem:cechAugmented_to_acyclicResolutionInput`** (line 11980):
- PProd note (`% NOTE (review iter-077)`) accurately reflects Lean code (`PProd` for `(Iso ×' Prop)`). CORRECT.
- Statement/proof: two outputs extracted from augmented exactness. CORRECT and ADEQUATE.
- `\uses{lem:cech_augmented_resolution, def:cech_complex_on_X, def:cech_augmented_complex}` — all valid. ACCURATE.

**Other chapter content**:
- `lem:cech_computes_cohomology` (frozen `cech_computes_higherDirectImage`): documented `sorry` / "false as stated" — acknowledged in strategy. Blueprint prose discusses this explicitly. Not a must-fix.
- `lem:rightAcyclic_finite_prod`: correct, proof sketch adequate.
- `lem:pushforward_mapHC_cechComplexOnX`: correct.
- `lem:cech_augmented_resolution`: correct.
- All other blocks in chapter: reviewed; no issues found.

### `Cohomology_AcyclicResolution.tex`
- **Complete**: true
- **Correct**: true
- All `\leanok` + `\mathlibok` blocks present. All `\uses{}` edges valid. Full horseshoe construction + dimension-shift + comparison theorem documented and formalized. Clean.

### `Cohomology_HigherDirectImage.tex`
- **Complete**: true (single definition `def:higher_direct_image` with note on `[HasInjectiveResolutions X.Modules]` hypothesis)
- **Correct**: true
- Note re `[HasInjectiveResolutions X.Modules]` being an explicit hypothesis due to Mathlib gap (Grothendieck-abelian instance absent for `SheafOfModules`) accurately reflects the state.

## Severity summary

- **must-fix (blocking)**: NONE.
- **soft/informational**: Proof sketch of `lem:cech_computes_cohomology_affineCover` implicitly threads `hres n` without spelling it out; adequate for prover but could be one-line explicit. Low priority.
- **known/non-blocking**: Frozen `cech_computes_higherDirectImage` sorry (strategy-sanctioned; `with_sorry: 1` in leandag).

## HARD GATE verdict

`Cohomology_CechHigherDirectImage.tex`: **complete=true, correct=true, no must-fix findings**.

**HARD GATE CLEARED** for `CechToHigherDirectImage.lean`. Prover may be dispatched this iter.

**Prover task summary** (for the prover's directive, not a blueprint defect):
1. In `cech_computes_higherDirectImage_of_affineCover`: replace `[X.IsSeparated]` with `[S.IsSeparated]`; internally derive `haveI : X.IsSeparated` from `IsSeparated f` + `S.IsSeparated` (composition of separated morphisms).
2. Add `hres : ∀ (n : ℕ) (σ : Fin (n+1) → 𝒰.I₀), HasInjectiveResolutions (coverInterOpen 𝒰 σ).toScheme.Modules` to the signature.
3. Pass `hres n` at the `cechTerm_pushforward_acyclic` call (currently line 207).
4. Thread `[S.IsSeparated]` + derived `[X.IsSeparated]` instance into `cechAugmented_to_acyclicResolutionInput` and `cechTerm_pushforward_acyclic` calls as needed (they should resolve by instance search once `haveI` is in scope).
