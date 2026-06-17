# Blueprint Review Report

## Slug
ts217fp

## Iteration
217

## Top-level summaries

### Lean difficulty quality

- `RigidityKbar.tex` / `lem:GrpObj_mulRight_globalises`, `lem:GrpObj_omega_basechange_proj`, `lem:GrpObj_omega_basechange_proj_inv_derivation`, `lem:GrpObj_omega_basechange_proj_inv`: these fallback piece-(i.b) declarations carry `% Iter-146 disposition: \lean{...name}` comments instead of formal `\lean{...}` tags — the intended Lean targets are named in comment form (e.g. `mulRight_globalises_cotangent`, `relativeDifferentialsPresheaf_basechange_along_proj_two`), giving provers the information but preventing blueprint-doctor / sync\_leanok tracking. Not on any active prover route.

### Citation discipline

No findings. All `% SOURCE:` blocks in the gate chapter and in other chapters read have the required `(read from references/<file>)` parenthetical, all named local files exist on disk, and visible `\textit{Source: ...}` lines match the `% SOURCE:` pointers.

## Per-chapter

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **[Gate chapter — CLEARED]** Both prior must-fix findings from iter-216 are genuinely resolved (see detailed analysis below).
  - `lem:tensorobj_unit_iso` lacks `\leanok` in the blueprint, but `tensorObj_left_unitor` and `tensorObj_right_unitor` exist without `sorry` in the Lean file (lines 919, 929). `sync_leanok` will add the markers on the next pass. Not a blueprint error.
  - `lem:restrictscalars_ringiso_strongmonoidal` (new block): all five `\lean{...}` names verified in the Lean file at root scope (lines 219, 237, 253, 266, 275); `\uses{lem:restrictscalars_ringiso_tensorequiv}` resolves within this chapter; `\leanok` present; no source citation needed (project-original formalization).
  - All cross-chapter `\uses` references verified: `lem:rel_pic_sharp_groupoid` → `Picard_RelPicFunctor.tex:76` ✓; `thm:relative_pic_quotient_well_defined` → `Picard_LineBundlePullback.tex:331` ✓; `def:IsLocallyTrivial` → `Picard_LineBundlePullback.tex:142` ✓; `def:pullback_along_projection` → `Picard_LineBundlePullback.tex:209` ✓.
  - The two occurrences of "free-cover" in the chapter body (lines 683, 1454) both appear in sentences explicitly REFUTING the free-cover approach ("no free-cover specialisation can stand in for it"); no "free-cover avoids H1" narrative remains.

#### Detailed gate analysis

**Prior finding 1 (assoc\_iso proof mismatch) — RESOLVED.**
`lem:tensorobj_assoc_iso` proof now has two clearly labelled sub-blocks:
- *Current realization*: route-(d) whiskering composite via `W_whiskerRight_of_W` / `W_whiskerLeft_of_W` / `isIso_sheafification_map_of_W`, explicitly noted as "transitively gated on the open, vestigial proof placeholder `isLocallyInjective_whiskerLeft_of_W`" (the sorry at Lean file line 632). Lean file confirmed: `tensorObj_assoc_iso` (line 989) uses `W_whiskerRight_of_W` (line 1020) and `W_whiskerLeft_of_W` (line 1023), both dependent on the sorry. Matches blueprint. ✓
- *Planned re-route*: direct gluing via two applications of `tensorobj_restrict_iso` + canonical presheaf associator + overlap-naturality + Hom-is-a-sheaf gluing. Clearly labelled "not yet realized". ✓
- The proof `\uses` correctly includes both routes' dependencies (`lem:tensorobj_restrict_iso`, `lem:whisker_of_W`, `lem:islocallyinjective_whisker_of_W`). ✓

**Prior finding 2 (free-cover avoids H1 narrative) — RESOLVED.**
Both the "free-cover" paragraphs and the stale `% NOTE` comments identified in iter-216 are gone. The H1 residual is now honestly named as the "sole remaining residual" and the "sole open substrate obligation" of the chapter:
- Step 3 of `lem:tensorobj_restrict_iso` proof explicitly labels the presheaf-level `pushforward β ≅ pullback φ` identification via `leftAdjointUniq` as "H1 alone", explains why `pushforwardNatTrans`/`pushforwardCongr` are Mathlib-absent at the presheaf level, and states the construction plan (de-sheafify the sheaf-level template app-for-app). ✓
- The Stacks `(f^*, f_*)` adjunction quote is present verbatim in the `% SOURCE QUOTE:` block (lines 607–625) with `(read from references/stacks-modules.tex, L252-273)`; `references/stacks-modules.tex` exists on disk. ✓
- `lem:tensorobj_restrict_iso` `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso}` verified at Lean file line 1090. ✓

**New block correctness — PASSED.**
`lem:restrictscalars_ringiso_strongmonoidal`: 5 Lean declarations verified in the Lean file:
- `restrictScalars_isIso_μ` — line 219 ✓
- `restrictScalars_isIso_ε` — line 237 ✓
- `restrictScalarsMonoidalOfRingEquiv` — line 253 ✓
- `restrictScalars_isIso_μ_of_bijective` — line 266 ✓
- `restrictScalars_isIso_ε_of_bijective` — line 275 ✓

All are in root scope (inside `section RestrictScalarsRingIsoTensor`, no namespace), matching the unqualified names in the blueprint's `\lean{...}` hint. The bijective variants correctly explained as consumed by the presheaf-level lift where the comparison map is bijective but not syntactically a `.toRingHom`. ✓

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/Jacobian.tex — complete + correct, no notes.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Fallback/off-path chapter; main theorem `thm:rigidity_over_kbar` carries `\leanok` and is `[CharZero]`-gated; explicitly documented as retained artifact, not the committed route.
  - Several piece-(i.b) declarations (`lem:GrpObj_mulRight_globalises`, `lem:GrpObj_omega_basechange_proj`, `lem:GrpObj_omega_basechange_proj_inv_derivation`, `lem:GrpObj_omega_basechange_proj_inv`) carry `% Iter-146 disposition: \lean{...name}` comments instead of formal `\lean{...}` tags — noted as **soon** Lean-difficulty-quality finding (see Top-level summaries). Proof sketches are present; the intended names are documented in comment form. Not on any active prover route.
  - Read partially (grep survey of 2621-line file); no indication of broken `\uses` or mathematically incorrect claims found.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelianVarietyRigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CodimOneExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CoheightBridge.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RRFormula.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OCofP.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OcOfD.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FlatteningStratification.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_IdentityComponent.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_QuotScheme.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelPicFunctor.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelativeSpec.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex — complete + correct, no notes.

## Cross-chapter notes

- STRATEGY.md `## Routes` section (A.1.c.SubT paragraph) retains the old "free-cover avoids H1" narrative ("must be proved on the free cover, NOT as the general presheaf-pushforward adjunction"), while the `## Phases & estimations` table in the same file correctly says "make-or-break RESOLVED (free-cover does NOT avoid H1; H1 on critical path)". The blueprint chapter `Picard_TensorObjSubstrate.tex` is consistent with the Phases table (correct narrative). The inconsistency is internal to STRATEGY.md; no blueprint chapter conflict.

## Severity summary

Severity summary: **HARD GATE CLEARS** for `Picard_TensorObjSubstrate.tex` — no must-fix finding touches it.

**soon** (2 items):
1. `RigidityKbar.tex` / piece-(i.b) fallback declarations: 4+ declaration blocks have `% Iter-146 disposition: \lean{...name}` in comment form instead of formal `\lean{...}` tags — blueprint-doctor and sync\_leanok cannot track them. Pre-existing since iter-146; none on any active prover route. Dispatch a blueprint-writer or editorial pass to promote the disposition-comment targets to formal `\lean{...}` tags when the fallback route is next touched.
2. STRATEGY.md `## Routes` section: stale "free-cover" paragraph (contradicts the `## Phases` table and the updated blueprint chapter). Plan agent should update the Routes section to match the Phases table narrative in the next iter.

**informational** (1 item):
1. `Picard_TensorObjSubstrate.tex` / `lem:tensorobj_unit_iso`: `\leanok` absent in blueprint but the Lean declarations (`tensorObj_left_unitor`, `tensorObj_right_unitor`) are closed without sorry. `sync_leanok` will add the marker on the next pass; no action needed.

**Overall verdict**: `Picard_TensorObjSubstrate.tex` is `complete: true`, `correct: true` with no must-fix finding — the HARD GATE CLEARS and `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` may enter this iter's prover objectives; the sole open substrate obligation (H1 presheaf `pushforwardPushforwardAdj`) is correctly documented and de-risked. All 33 chapters audited; 0 unstarted-phase proposals (every strategy phase has adequate blueprint coverage).
