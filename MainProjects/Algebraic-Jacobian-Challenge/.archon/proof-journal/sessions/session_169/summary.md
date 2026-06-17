# Session 169 (iter-169 review)

## Session metadata
- **Session number**: 169 (= iter-169)
- **Sorry count**: 14 → **13** (net −1; from `ga_grpObj` deletion).
- **Files edited**: `AlgebraicJacobian/Genus0BaseObjects.lean` (only).
- **Targets attempted**: `gmScalingP1` body (PRIMARY); `gmScalingP1_collapse_at_zero` body (PRIMARY, gated); 4 SECONDARY hygiene items (`aux_left` docstring, `projectiveLineBar_isReduced` docstring, section-(E) header, drop `ga_grpObj`).
- **Outcome**: **PARTIAL (armed-trigger escalation).** Both PRIMARY bodies stayed `sorry`. All 4 SECONDARY items landed axiom-clean. Build green; no new axioms. The iter-168/iter-169 plan's "5th-consecutive-deferral → user escalation" trigger is now **ARMED for iter-170**.

## Targets — per-target detail

### `gmScalingP1` body (Genus0BaseObjects.lean L685)

**Three independent routes tried — each hit a Mathlib infrastructure gap.**

#### Attempt 1: Direct `Proj.fromOfGlobalSections` from the whole pullback
- Code: build φ : MvPolynomial (Fin 2) kbar →+* Γ((ProjectiveLineBar ⊗ Gm).left, ⊤) sending `X 0 ↦ t`, `X 1 ↦ 1`; apply `Proj.fromOfGlobalSections`.
- Lean error: none — semantic dead-end recognised pre-edit. Γ(ℙ¹ × 𝔾_m, ⊤) = k̄[t, t⁻¹] (Γ(ℙ¹, ⊤) = k̄ by properness; tensored with `GmRing`). Any morphism produced via this route factors through Spec(GmRing) = 𝔾_m — i.e. the embedding 𝔾_m ↪ ℙ¹, NOT the scaling action `(x, λ) ↦ λ·x`.
- Insight: A single `fromOfGlobalSections` from a non-affine source CANNOT encode a non-trivially-bivariate morphism. Global sections of a non-affine source LOSE the ℙ¹ factor.

#### Attempt 2: Chart-glue (Option B per iter-169 plan)
- Code: two chart-side ring maps
  `φ_i : MvPolynomial (Fin 2) kbar →+* TensorProduct kbar (HomogeneousLocalization.Away 𝒜 (X i)) (GmRing kbar)` for `i ∈ Fin 2`; `Proj.fromOfGlobalSections` per chart; glue via `Scheme.Cover.glueMorphisms` over the pullback cover `(projectiveLineBarAffineCover kbar).openCover.pullback₁ pullback.fst`.
- Lean error: none reached — bailout on LOC budget. ~200 LOC of `TensorProduct` + `HomogeneousLocalization.Away` ring-instance plumbing with no in-tree precedent + ~50 LOC cocycle. **Specific blockers identified:**
  - `TensorProduct kbar (HomogeneousLocalization.Away 𝒜 _) (GmRing kbar)` has NO `CommRing` / `Algebra` instance shipped by Mathlib under `inferInstance`.
  - Cocycle on `D₊(X 0 · X 1)` requires `Proj.basicOpen`-cover-restriction lemmas not specialised to `affineOpenCoverOfIrrelevantLESpan`.
- Insight: The plan's "<200 LOC" estimate was optimistic. The decisive Mathlib gap is the missing CommRing/Algebra instance on `TensorProduct (HomogeneousLocalization.Away _ _) _`.

#### Attempt 3: Functoriality-of-Proj route (not in iter-169 plan)
- Code: `Proj.map : (𝒜 →+*ᵍ ℬ) → (Proj ℬ ⟶ Proj 𝒜)` from `ProjectiveSpectrum/Functor.lean:144`. With 𝒜 = `MvPolynomial (Fin 2) kbar` (std ℕ-grading), ℬ = `MvPolynomial (Fin 2) (GmRing kbar)`, graded φ : 𝒜 →+*ᵍ ℬ sending `X 0 ↦ t · X 0, X 1 ↦ X 1` gives `Proj.map φ : Proj ℬ → Proj 𝒜 = ℙ¹`.
- Lean error: none — Mathlib gap. The remaining step (identify `Proj ℬ ≅ ProjectiveLineBar ⊗ Gm`) requires the **relative-Proj base-change iso** `Proj(MvPoly (Fin n) R) ≅ Proj(MvPoly (Fin n) k) ×_{Spec k} Spec R`. VERIFIED ABSENT (Glob+Grep across all `Mathlib/AlgebraicGeometry/`): no `Proj.iso_pullback_Spec`, `ProjPolynomial`, `relativeProj`, or comparable declaration anywhere.
- Insight: The CLEANEST route mathematically; would close if/when Mathlib gains the relative-Proj formalism (multi-iter Mathlib PR).

### `gmScalingP1_collapse_at_zero` body (L709)
- Status: gated on `gmScalingP1` body; no attempt this iter. Docstring refreshed to make the dependency explicit.

### SECONDARY-1 `homogeneousLocalizationAwayIso_aux_left` docstring (L350-367) — RESOLVED
- Replaced "iter-168 partial: structural setup via `ext`, `Away.mk_surjective`, `val_injective` gets us to the underlying `Localization.Away (X i)` comparison…" with an honest "TODO — no body landed; deferred infrastructure not on the genus-0 critical path (iter-169 pivoted to Option B for `gmScalingP1`, sidestepping the iso)."

### SECONDARY-2 `projectiveLineBar_isReduced` docstring (L708-718) — RESOLVED
- Replaced "Project-side scaffold sorry (Mathlib does not ship `IsReduced (Proj 𝒜)` …)" with the iter-168-aware "Closed axiom-clean iter-168 via `IsReduced.of_openCover` over `projectiveLineBarAffineCover`; each chart `Spec (HomogeneousLocalization.Away 𝒜 (X_i))` is a domain because `algebraMap = .val` factors through `Function.Injective.isDomain`." Body unchanged.

### SECONDARY-3 Section-(E) header (L680-696) — RESOLVED
- Dropped the "`ℙ¹` is reduced — scaffold (Mathlib gap…)" bullet; replaced with the axiom-clean iter-168 description.

### SECONDARY-4 Drop `ga_grpObj` (L526-540) — RESOLVED
- Deleted the `ga_grpObj` instance + the dependent `ga_smooth` instance. `grep -rn "ga_grpObj" AlgebraicJacobian/` post-edit returns empty. Net `−1` on the file's sorry count. **Blueprint pin `\lean{AlgebraicGeometry.ga_grpObj}` at `AbelianVarietyRigidity.tex:1023` is now ORPHANED** — flagged in `recommendations.md` for iter-170 plan-writer cleanup.

### SECONDARY-5 (optional re-audit) — deferred
- The 4 remaining "Mathlib gap"-framed scaffold sorries (`projectiveLineBar_geomIrred` L175, `projectiveLineBar_smoothOfRelDim` L182, `gm_geomIrred` L789, `projGm_isReduced` L819) were NOT re-audited this iter. Per the prover's task_result, each "appears genuinely blocked on scheme-level alg-closed-base / smooth-to-reduced bridges that are multi-iter upstream items, not <20 LOC inline fixes" — but this is a stated impression, not a verified investigation. Worth a future hygiene iter dedicated to it.

## Key findings / patterns discovered

1. **The genus-0 base-case headline body is GENUINELY blocked on missing Mathlib infrastructure** — not on prover tactic skill or planner steering. Three structurally distinct routes (single-`fromOfGlobalSections` from total space; chart-glue Option B; functoriality `Proj.map`) each terminate at a different missing Mathlib piece (loss of ℙ¹-factor via global sections; `TensorProduct (HomogeneousLocalization.Away _ _) _` CommRing instance; relative-Proj base-change iso). This concentrates the iter-170 user-escalation choice on a single observable: which Mathlib gap to commit to (or whether to bypass via `[CharZero]`).
2. **`Proj.map` is functorial in graded ring maps in Mathlib** (`ProjectiveSpectrum/Functor.lean:144` for `Proj.map`, L99 for `sheafedSpaceMap`). This was not previously cited in the project's KB; it is the cleanest morphism-construction shape for the genus-0 `σ_×` IF Mathlib later supplies the relative-Proj base-change iso.
3. **Relative-Proj base-change is GENUINELY absent from Mathlib** (verified iter-169 — no `Proj.iso_pullback_Spec`/`ProjPolynomial`/`relativeProj`/`Proj.base_change_iso` declarations exist). This is informative for the strategy critic on iter-170+: a major Mathlib-side push would be needed for the cleanest route.
4. **`Mathlib/AlgebraicGeometry/GroupAction/*` does NOT exist** (verified `Glob` returned no matches). Mathlib has no precedent for "scheme action by a group scheme." A project-side construction of `σ_×` cannot lean on a Mathlib group-action API.

## Blueprint markers updated (manual)

- **`AbelianVarietyRigidity.tex`, `def:ga_grpObj` (L1020-L1032)**: added `% NOTE (iter-169): ORPHANED PIN — the Lean instance has been deleted; iter-170 plan-writer should DELETE the entire block.` (review-agent semantic-marker scope).
- **`AbelianVarietyRigidity.tex`, `def:gaTranslationP1` (L1156+)**: added `% NOTE (iter-169): ESCALATION ARMED — body ships as typed sorry; three attempted routes each hit Mathlib gaps; iter-170 picks escalation option (a/b/c).` Mirrors the iter-169 NOTE already in place at `def:proj_chart_ring_iso`.
- **`AbelianVarietyRigidity.tex`, `lem:gmScaling_fixes_zero` (L1207+)**: added `% NOTE (iter-169): GATED SORRY — strictly downstream of `gmScalingP1`'s body; tracks parent escalation.`
- No `\mathlibok` additions / removals required (no new Mathlib-aliased declarations landed this iter). No `\lean{...}` renames flagged (the `ga_grpObj` orphan is left as `\lean{...}` for now — the iter-170 plan-writer will DELETE the whole block per the lean-vs-blueprint-checker's recommendation, which is plan-agent informal-prose scope, not review-agent marker scope). No stale `\notready` to strip on this chapter (the surviving `\notready`s are in `RigidityKbar.tex`, all on the off-path fallback artifact).

## Recommendations
See `recommendations.md`.
