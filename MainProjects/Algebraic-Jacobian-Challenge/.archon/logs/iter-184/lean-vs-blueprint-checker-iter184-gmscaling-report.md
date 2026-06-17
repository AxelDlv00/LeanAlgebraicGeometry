# Lean ↔ Blueprint Check Report

## Slug
iter184-gmscaling

## Iteration
184

## Files audited
- Lean: `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean`
- Blueprint: `blueprint/src/chapters/Genus0BaseObjects_GmScaling.tex` — **ABSENT**
  - All GmScaling content lives in `blueprint/src/chapters/AbelianVarietyRigidity.tex`
    (declared via `% archon:covers ... AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean`
    at line 4 of that chapter). Sections audited: lines ~1140–1480 of `AbelianVarietyRigidity.tex`.

---

## Per-declaration

### `\lean{AlgebraicGeometry.gmScalingP1_cover}` (chapter: `\label{def:gmscaling_cover}`)
- **Lean target exists**: yes (line 136)
- **Signature matches**: yes — `(kbar : Type u) [Field kbar] : ((ProjectiveLineBar kbar) ⊗ Gm kbar).left.OpenCover`
- **Proof follows sketch**: N/A (definition, axiom-clean)
- **notes**: `\leanok` on statement block consistent with sorry-free body.

### `\lean{AlgebraicGeometry.gmScalingP1_chart}` (chapter: `\label{def:gmscaling_chart}`)
- **Lean target exists**: yes (line 186)
- **Signature matches**: yes — chart-i scheme morphism to `ProjectiveLineBarScheme`
- **Proof follows sketch**: yes — body uses `gmScalingP1_cover_X_iso`, `Spec.map`, `Proj.awayι`, matching the recipe in the blueprint
- **notes**: `\leanok` on statement block consistent with sorry-free body.

### `\lean{AlgebraicGeometry.gmScalingP1_chart_agreement}` (chapter: `\label{lem:gmscaling_chart_agreement}`)
- **Lean target exists**: yes (line 442)
- **Signature matches**: yes — `∀ x y : Fin 2, pullback.fst (f x) (f y) ≫ chart x = pullback.snd (f x) (f y) ≫ chart y`
- **Proof follows sketch**: partial — diagonal cases and (1,0)-from-(0,1) symmetry match the blueprint. The (0,1) cross case delegates to `gmScalingP1_chart_agreement_cross01` (private lemma, still `sorry`).
- **notes**: `\leanok` on statement block is consistent (the declaration exists with a body, `sorry` propagates from the sub-lemma). The substantive sorry is correctly isolated.

### `\lean{AlgebraicGeometry.gmScalingP1_chart_PLB_eq}` (chapter: `\label{lem:gmscaling_chart_PLB_eq}`)
- **Lean target exists**: yes (line 221, `private lemma`)
- **Signature matches**: yes — per-chart bridge equation matching blueprint prose
- **Proof follows sketch**: yes — 5-stage proof follows the blueprint's three-step reduction (A, B, C) via `awayι_comp_PLB_hom`, `pullbackSpecIso_hom_base`, `pullbackRightPullbackFstIso`, `pullbackSymmetry`. Axiom-clean.
- **notes**: The `private` modifier does not affect correctness. Blueprint's `\lean{...}` pin may cause `sync_leanok` resolution issues (private decls are not externally accessible), but this is a pre-existing condition, not iter-184 drift.

### `\lean{AlgebraicGeometry.gmScalingP1_over_coherence}` (chapter: `\label{lem:gmscaling_over_coherence}`)
- **Lean target exists**: yes (line 490)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `Scheme.Cover.hom_ext` + `ι_glueMorphisms_assoc` + `gmScalingP1_chart_PLB_eq` chain matches blueprint prose
- **notes**: Axiom-clean (no direct sorry; sorry propagation is only through `gmScalingP1_chart_agreement_cross01`).

### `\lean{AlgebraicGeometry.gmScalingP1}` (chapter: `\label{def:gaTranslationP1}`)
- **Lean target exists**: yes (line 514)
- **Signature matches**: yes — `ProjectiveLineBar kbar ⊗ Gm kbar ⟶ ProjectiveLineBar kbar`
- **Proof follows sketch**: yes — `Over.homMk (glueMorphisms ...) over_coherence` exactly as blueprint notes
- **notes**: Body is axiom-clean structurally; sorry taint flows via `gmScalingP1_chart_agreement_cross01`.

### `\lean{AlgebraicGeometry.gmScalingP1_collapse_at_zero}` (chapter: `\label{lem:gmScaling_fixes_zero}`)
- **Lean target exists**: yes (line 539)
- **Signature matches**: yes — `lift (toUnit ≫ zeroPt) (𝟙 Gm) ≫ gmScalingP1 = toUnit ≫ zeroPt`
- **Proof follows sketch**: no (body is `sorry`); blueprint has a proof sketch (chart-1 ring map, restrict to x=0, get constant 0 map)
- **notes**: Single honest `sorry`. Blueprint sketch is adequate; the route via `Cover.hom_ext` + `pointOfVec` factorization of `zeroPt` is described. This is a known open sorry, not a new drift.

### `\lean{AlgebraicGeometry.projectiveLineBar_isReduced}` (chapter: `\label{lem:projlinebar_isReduced}`)
- **Lean target exists**: yes (line 579)
- **Signature matches**: yes — `IsReduced (ProjectiveLineBar kbar).left`
- **Proof follows sketch**: yes — `IsReduced.of_openCover` + `val_injective` + domain chain matches blueprint exactly
- **notes**: Axiom-clean. No drift.

---

## Red flags

### Placeholder / suspect bodies

- `gmScalingP1_chart_agreement_cross01` at line 412–427: body is `:= ... sorry` — substantive claim (the (0,1) cocycle cross case). Blueprint claims a non-trivial ring-level identity; the `cancel_epi` structural lift is in place but the substantive proof is `sorry`. This is the iter-184 target; the sorry is **named and honest**, not buried.
- `gmScalingP1_collapse_at_zero` at line 539–545: body is `sorry`. Blueprint has a proof sketch.
- `gm_geomIrred` at line 621–623: body is `sorry`. Blueprint has no corresponding `\lean{}` block (Mathlib gap scaffold; see below).
- `projGm_isReduced` at line 651–655: body is `sorry`. Blueprint has no `\lean{}` block.

All four are pre-existing and not new in iter-184.

---

## Unreferenced declarations (informational)

These Lean declarations have no `\lean{...}` blueprint pin:

| Declaration | Type | Blueprint mention? | Note |
|---|---|---|---|
| `pullback_map_fst_proj` | `@[reassoc (attr:=simp)] lemma` | None | **Correct.** Pure Lean infrastructure helper (iter-184 Recipe 1). No chapter entry needed. |
| `pullback_map_snd_proj` | `@[reassoc (attr:=simp)] lemma` | None | **Correct.** Same as above. |
| `awayι_comp_PLB_hom` | `private lemma` | Mentioned in prose | Iter-173 chart-bridge helper. No pin needed. |
| `gmScalingP1_cover_X_iso` | `private def` | Mentioned in prose | Internal to chart construction. |
| `gmScalingP1_chart_agreement_cross01` | `private lemma` | None | **Flagged.** The active sorry lives here. Blueprint should reference this sub-lemma as the locus of the remaining obligation. See Blueprint adequacy below. |
| `gmScalingP1_cover_intersection_X_iso` | `private def` | None | Iter-182 intersection iso. Blueprint should at least mention the approach if Recipe 2+3 are to use it. |
| `gmScalingP1_chart0_ringMap` | `noncomputable def` | Mentioned in prose (line 1284) | Substantive; prose names it but no `\lean{}` pin. Minor gap. |
| `gmScalingP1_chart1_ringMap` | `noncomputable def` | Mentioned in prose | Same. |
| `projGm_locallyOfFiniteType` | `instance` | Comment mention only (line 1764) | |
| `gm_geomIrred` | `instance` | Comment mention only | Mathlib-gap scaffold sorry. |
| `projGm_geomIrred` | `instance` | Comment mention only | |
| `projGm_isReduced` | `instance` | Comment mention only | Mathlib-gap scaffold sorry. |

---

## Blueprint adequacy for this file

- **Coverage**: 7/7 `\lean{...}`-pinned declarations exist in the Lean file and match their prose signatures. The 5 product-stability instances and 2 ring-map defs are unreferenced by `\lean{}` pins (mentioned in prose only).
- **Proof-sketch depth for `gmScalingP1_chart_agreement_cross01`**: **under-specified**.
  - The blueprint (`lem:gmscaling_chart_agreement`, lines 1325-1338) correctly states the ring-level identity `λ·u = (1/t)·λ` and its reduction to `t·u = 1`. This is sufficient for the *mathematical content* of Recipe 3.
  - However, the blueprint gives no structural guidance for Recipe 2 (named projection lemmas) or the iter-182/183 structural approach (`gmScalingP1_cover_intersection_X_iso`, `cancel_epi`, iso-chain projection). The prose says only "the proof routes through the chart-ring iso and the `pullbackSpecIso` bridge" — which is the pre-iter-182 description and does not describe the actual chosen strategy.
  - The `analogies/gmscaling-projection-idiom.md` report (iter-184 Recipe plan) provides the missing structural guidance, so the prover is not blocked. But the blueprint chapter is stale relative to the actual Lean approach.
- **Hint precision**: **loose** for the cross01 sorry — the blueprint does not name `gmScalingP1_chart_agreement_cross01` as the locus, nor describe the intersection iso approach.
- **Generality**: matches need.
- **Recommended chapter-side actions** (for a blueprint-writing subagent post-Recipe-2+3 closure):
  1. Add a paragraph to `lem:gmscaling_chart_agreement` noting that the (0,1) cross case is isolated as `gmScalingP1_chart_agreement_cross01` (private lemma), with the structural lift via `cancel_epi (gmScalingP1_cover_intersection_X_iso.inv)`.
  2. Add a brief note on `gmScalingP1_cover_intersection_X_iso` as the intersection-iso helper (iter-182), either inline in `lem:gmscaling_chart_agreement` or as a new scaffold block.
  3. Once Recipe 2 projection lemmas are named, add `\lean{...}` hints for them (or at minimum name them in prose).
  4. Add `\lean{...}` pins for `gmScalingP1_chart0_ringMap` and `gmScalingP1_chart1_ringMap` (currently prose-only; these are substantive axiom-clean definitions).

---

## Severity summary

- **must-fix-this-iter**: none. All four sorries are pre-existing, named, and honest. No new signature mismatches or axiom introductions in iter-184.
- **major**:
  - Blueprint under-specification for `gmScalingP1_chart_agreement_cross01`: the chapter does not describe the intersection-iso structural approach that iter-182/183/184 Recipes 2+3 require. A blueprint-writing subagent should expand `lem:gmscaling_chart_agreement` after Recipe 2+3 land.
  - No `\lean{}` pins for `gmScalingP1_chart0_ringMap` / `gmScalingP1_chart1_ringMap` (substantive axiom-clean defs named in prose but not formally pinned).
- **minor**:
  - `gmScalingP1_chart_PLB_eq` is `private` but has a blueprint `\lean{}` pin — pre-existing; may silently break `sync_leanok` resolution.
  - No blueprint chapter file for GmScaling; content buried in `AbelianVarietyRigidity.tex` via `% archon:covers`.
  - Five product-stability instances (`projGm_locallyOfFiniteType`, `gm_geomIrred`, `projGm_geomIrred`, `projGm_isReduced`, `projectiveLineBar_isReduced`) are in the Lean file with no `\lean{}` pins (only comment mentions). Blueprint expansion warranted when these sorries close.

**Overall verdict**: The iter-184 Recipe 1 additions (`pullback_map_fst_proj` / `pullback_map_snd_proj`) are correctly Lean-only infrastructure with no blueprint change needed; no `\lean{...}` drift was introduced. The chapter prose for `gmScalingP1_chart_agreement_cross01` states the mathematical content of the cocycle but is under-specified for the structural (intersection iso + cancel_epi) approach that Recipe 2+3 require — a blueprint expansion is recommended post-closure but is not blocking.
