# Lean ↔ Blueprint Check Report

## Slug
differentials-iter126

## Iteration
126

## Files audited
- Lean: `AlgebraicJacobian/Differentials.lean` (144 lines, post-iter-126 M1 excise)
- Blueprint: `blueprint/src/chapters/Differentials.tex` (210 lines, post-iter-126 rewrite)

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf}` (chapter: `def:relative_kaehler_presheaf`, line 15)
- **Lean target exists**: yes (Differentials.lean:51, `noncomputable def`)
- **Signature matches**: yes — `(f : X ⟶ S) → X.PresheafOfModules`; blueprint prose says "presheaf of $\struct{X}$-modules on $X$" which is exactly `X.PresheafOfModules`.
- **Proof follows sketch**: yes — Lean unfolds the adjunction-transpose of `f.c` and feeds it to `PresheafOfModules.DifferentialsConstruction.relativeDifferentials'`, matching the prose construction step-for-step.
- **notes**: The blueprint's colimit description of `f⁻¹_psh O_S(V)` is the Mathlib semantics of `TopCat.Presheaf.pullback`; consistent with the Lean.

### `\lean{AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_obj_kaehler}` (chapter: `lem:relative_kaehler_presheaf_obj`, line 24)
- **Lean target exists**: yes (Differentials.lean:60, `theorem`)
- **Signature matches**: yes — sections over `V` equal `CommRingCat.KaehlerDifferential` of the adjunction-transposed ring map at `V`, matching the displayed formula.
- **Proof follows sketch**: yes — chapter says "identification is by `rfl` after unfolding"; Lean body is literally `:= rfl`.
- **notes**: None.

### `\lean{AlgebraicGeometry.Scheme.smooth_locally_free_omega}` (chapter: `thm:smooth_locally_free_omega`, line 51)
- **Lean target exists**: yes (Differentials.lean:124, `theorem`)
- **Signature matches**: yes — uses `SmoothOfRelativeDimension n f` (non-deprecated class per Remark `rem:smooth_class_naming`); produces affine `U`, `V`, `e`, `IsAffineOpen U`, `IsAffineOpen V`, `Module.Free` and `Module.rank = n` on the appLE algebra K\"ahler module. Exact match with the displayed conclusion.
- **Proof follows sketch**: yes — Step 1 uses `SmoothOfRelativeDimension.exists_isStandardSmoothOfRelativeDimension` (the lemma the chapter labels "mk_iff bridge"); Steps 2/3/4 use the named Mathlib lemmas (`isStandardSmooth`, `free_kaehlerDifferential`, `rank_kaehlerDifferential`); Step 4.5 discharges `Nontrivial B` via `Nonempty V := ⟨⟨x, hxV⟩⟩` rather than naming `component_nontrivial`. Mathematical content is identical (`x ∈ V` ⇒ V nonempty ⇒ section ring nontrivial); the chapter's named witness is slightly different from the actual Lean tactic but resolves the same instance.
- **notes**: Minor — the chapter's "Mathlib name summary" lists `component_nontrivial` as a closure piece, while the Lean code uses `Nonempty V` and `algebraize` to get `Nontrivial B` via instance synthesis. Not wrong, just a naming-precision drift on one of the five cited lemmas.

### `\lean{AlgebraicGeometry.Scheme.kaehler_localization_subsingleton}` (chapter: `lem:kaehler_localization_subsingleton`, line 118)
- **Lean target exists**: yes (Differentials.lean:70, `theorem`)
- **Signature matches**: yes — `(M : Submonoid A) [IsLocalization M L] : Subsingleton (Ω[L⁄A])`, matching the prose ("A → L localization at M ⊆ A ⇒ Ω_{L/A} subsingleton").
- **Proof follows sketch**: yes — 2-line re-export `FormallyUnramified.of_isLocalization` + `subsingleton_kaehlerDifferential`, exactly as the chapter sketch states.
- **notes**: Cleanly described as a thin re-export; no Mathlib gap remaining.

### `\lean{AlgebraicGeometry.Scheme.kaehler_quotient_localization_iso}` (chapter: `lem:kaehler_quotient_localization_iso`, line 131)
- **Lean target exists**: yes (Differentials.lean:86, `noncomputable def`)
- **Signature matches**: yes — `[IsLocalization M L] [IsScalarTower A L B] : Ω[B⁄A] ≃ₗ[B] Ω[B⁄L]`, matching prose ("the canonical $B$-linear map $\Omega_{B/A} \to \Omega_{B/L}$ ... is a $B$-linear equivalence").
- **Proof follows sketch**: yes — Lean opens `LinearEquiv.ofBijective (KaehlerDifferential.map A L B B)`, proves injectivity by reducing to `Subsingleton (B ⊗[L] Ω[L⁄A])` via `exact_mapBaseChange_map`, surjectivity by `KaehlerDifferential.map_surjective`. Matches the second fundamental exact sequence argument in the chapter.
- **notes**: Properly framed as the M1.d extractable Mathlib-PR candidate (`KaehlerDifferential.equivOfFormallyUnramified`) in both the Lean docstring and the chapter `rem:bridge_mathlib_pr`.

## Red flags

None. No `sorry`, no `axiom`, no placeholder body, no excuse-comment in the post-excise Lean file. The two retained docstring references to "M1" framing both correctly point at the standalone Mathlib-PR candidate, not at a deleted bridge.

## Unreferenced declarations (informational)

None substantive. All 5 file declarations are `\lean{...}`-tagged in the blueprint. Coverage is 5/5 = 100%.

## Blueprint adequacy for this file

- **Coverage**: 5/5 Lean declarations have a corresponding `\lean{...}` block. Unreferenced: 0 helpers + 0 substantive.
- **Proof-sketch depth**: adequate. Every retained theorem's proof block names the Mathlib closure pieces the Lean uses (e.g. `exists_isStandardSmoothOfRelativeDimension`, `FormallyUnramified.of_isLocalization`, `exact_mapBaseChange_map`, `map_surjective`). The chapter even labels each cited lemma `[verified]` and lists its Mathlib file.
- **Hint precision**: precise. The `\lean{...}` macros all use fully-qualified names that match the Lean file's declarations exactly. The `SmoothOfRelativeDimension` vs deprecated `IsSmoothOfRelativeDimension` distinction is explicitly called out in Remark `rem:smooth_class_naming`.
- **Generality**: matches need. The Lean exports nothing the blueprint omits, and the blueprint claims nothing the Lean fails to deliver. The chapter's explicit excise narrative (Section `sec:bridge`, line 111) correctly documents that the bridge `relativeDifferentialsPresheaf_equiv_kaehler_appLE` and its `appLE_isLocalization` sub-lemma have been excised, with their off-loop Mathlib-PR work redirected to `analogies/relative-differentials-presheaf-bridge.md`.
- **`\uses{...}` graph hygiene**: clean. All `\uses{...}` references in the chapter resolve to existing labels (`def:relative_kaehler_presheaf`, `lem:kaehler_localization_subsingleton`). No dangling references to deleted labels (`thm:relativeDifferentialsPresheaf_equiv_kaehler_appLE`, `lem:appLE_isLocalization`).
- **Deleted-decl name check**: the seven excised declaration names (`appLE_unitSubmonoid`, `appLE_colimRingHom`, `appLE_colimAlgebra`, `appLE_colimRingHom_comp_φV`, `isUnit_appLE_unitSubmonoid_in_colim`, `appLE_isLocalization`, `relativeDifferentialsPresheaf_equiv_kaehler_appLE`) do not appear inside any `\lean{...}` macro. Two names (`relativeDifferentialsPresheaf_equiv_kaehler_appLE`, `appLE_isLocalization`) appear in narrative prose at line 111 inside `\texttt{...}` purely as historical-context callouts to what was excised; this is correct documentation, not a stale claim.
- **"Parked from iter-125" framing check**: no surviving "parked" framing for `appLE_isLocalization`. The chapter explicitly says it was "excised iter-126" (lines 6, 113, 148) and routes the off-loop PR work via `analogies/relative-differentials-presheaf-bridge.md`. No stale parked prose.
- **Recommended chapter-side actions**: none required. The chapter is in a clean post-excise state.

## Severity summary

- **must-fix-this-iter**: none.
- **major**: none.
- **minor**: the chapter's "Mathlib name summary" at `thm:smooth_locally_free_omega` lists `AlgebraicGeometry.Scheme.component_nontrivial` as the Step 4.5 closure piece, while the Lean code discharges `Nontrivial B` via `Nonempty V := ⟨⟨x, hxV⟩⟩` plus `algebraize`. The mathematical step is the same and instance synthesis closes the gap; if a future blueprint-writer wants exact name-precision, the prose could be reworded to "via instance synthesis from `Nonempty V`". Low-impact prose-vs-Lean drift only.

Overall verdict: post-excise `Differentials.lean` and `Differentials.tex` are in a fully consistent state; all 5 retained declarations are `\lean{...}`-tagged with precise signatures and faithful proof sketches, no deleted declaration names leak into `\lean{...}` macros or `\uses{}` graph, and the M1 excise narrative is documented correctly.
