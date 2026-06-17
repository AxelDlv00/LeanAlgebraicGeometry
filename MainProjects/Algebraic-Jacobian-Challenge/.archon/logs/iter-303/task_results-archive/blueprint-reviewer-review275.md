# Blueprint Review Report

## Slug
review275

## Iteration
275

## Top-level summaries

### Dependency & isolation findings

- `RiemannRoch_RationalCurveIso.tex` / `lem:phi_left_toNormalization_isIso_of_isIntegralHom`: leaf node (out-edges to `lem:phi_left_locallyQuasiFinite_of_finrank_one`; no statement-level in-edge from `lem:degree_one_morphism_iso`). The parent lemma's proof uses this helper but does not list it in its statement-level `\uses{}`. **wire-up** — add `lem:phi_left_toNormalization_isIso_of_isIntegralHom` to `lem:degree_one_morphism_iso`'s statement `\uses{}`. Low dispatch-risk (same file), hence "soon".
- `RiemannRoch_RationalCurveIso.tex` / `lem:phi_left_fromNormalization_isIso_of_smoothProper_finrank_one`: same situation — leaf node with out-edges but no statement-level in-edge from `lem:degree_one_morphism_iso`. **wire-up** — add to `lem:degree_one_morphism_iso` statement `\uses{}`. "soon".
- All other isolated nodes (126 total, 3 blueprint): the three blueprint-isolated nodes are `lem:S3_sep_2_*`, `lem:S3_pi_2_*`, `lem:isiso_sheafification_map_of_W` — all reviewer-certified exempt. No new blueprint isolated nodes introduced this iteration. **keep** for all three.

### Rendering integrity (pre-existing findings, "soon" tier)

All findings below were present before iteration 275 — none were introduced by the new coverage blocks.

- `AbelianVarietyRigidity.tex`: `math-delim` — lines 25, 41 (interleaved `\( … \)` inside `$ … $`).
- `Albanese_AlbaneseUP.tex`: `bare-label` (`lem:agps` in prose); `math-delim` — lines 79, 84, 369, 435.
- `Albanese_AuslanderBuchsbaum.tex`: `bare-label` (`lem:depth_drops_by_one`); `math-delim` — lines 158, 401.
- `Albanese_CodimOneExtension.tex`: `math-delim` — lines 187, 1686, 1732.
- `Albanese_CoheightBridge.tex`: `math-delim` — lines 111, 134, 144.
- `AlgebraicJacobian_Cotangent_GrpObj.tex`: `literal-ref` (bare `REF` in line 7 — should be `\cref{chap:RigidityKbar}`); `undefined-macro` (`\obj` in `lem:isIso_of_app_iso_module`, `\toUnit` in `lem:section_snd_eq_identity_struct`).
- `AbelJacobi.tex`: `literal-ref` — 2× `Theorem~REF` in prose.
- `Cohomology_MayerVietoris.tex`: `literal-ref` — 29 occurrences (Chapter~REF, Definition~REF, Lemma~REF).
- `Cohomology_SheafCompose.tex`: `literal-ref` — `Definition~REF`, `Theorem~REF`.
- `Cohomology_StructureSheafAb.tex`: `literal-ref` — Chapter~REF, Definition~REF, Theorem~REF.
- `Cohomology_StructureSheafModuleK.tex`: `literal-ref` — 38 occurrences.
- `Differentials.tex`: `literal-ref` — 16 occurrences.
- `Jacobian.tex`: `literal-ref` — 9 occurrences.
- `Picard_FGAPicRepresentability.tex`: `bare-label` (`cor:algsch`, `lm:ctn`, `lm:qt`, etc.); `math-delim` — lines 129, 135.
- `Picard_FlatteningStratification.tex`: `literal-ref` — 23 occurrences; `math-delim` — line 742.
- `Picard_IdentityComponent.tex`: `bare-label` (`cor:sm`, `lem:agps`, `th:qpp`) — 17 occurrences.
- `Picard_Pic0AbelianVariety.tex`: `bare-label` (`cor:ch0`, `cor:sm`, `rmk:Jac`, etc.); `undefined-macro` (`\tu`).
- `Picard_QuotScheme.tex`: `math-delim` — lines 243, 332.
- `Picard_RelPicFunctor.tex`: `bare-label` (`th:cmp`, `th:main`); `literal-ref` — 3× `REF`.
- `Picard_RelativeSpec.tex`: `math-delim` — line 686.
- `RiemannRoch_OCofP.tex`: `math-delim` — lines 27, 424.
- `RiemannRoch_OcOfD.tex`: `literal-ref` — 43× `REF`; `math-delim` — lines 231, 411.
- `RiemannRoch_RRFormula.tex`: `literal-ref` — 35× `REF` in prose; `math-delim` — lines 121, 726.
- `RiemannRoch_RationalCurveIso.tex`: `math-delim` — lines 36, 51.
- `RiemannRoch_WeilDivisor.tex`: `math-delim` — lines 142, 1370.
- `Rigidity.tex`: `literal-ref` — `REF`, `Theorem~REF`.

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Pre-existing `literal-ref`: 2× `Theorem~REF` placeholders in prose — soon.

### blueprint/src/chapters/AbelianVarietyRigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Pre-existing `math-delim`: lines 25, 41 — soon.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Pre-existing `bare-label` (`lem:agps`) and `math-delim` (lines 79, 84, 369, 435) — soon.

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Pre-existing `bare-label` (`lem:depth_drops_by_one`) and `math-delim` (lines 158, 401) — soon.

### blueprint/src/chapters/Albanese_CodimOneExtension.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Pre-existing `math-delim` (lines 187, 1686, 1732) — soon.

### blueprint/src/chapters/Albanese_CoheightBridge.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Pre-existing `math-delim` (lines 111, 134, 144) — soon.

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Pre-existing `literal-ref` (bare `REF` at line 7, should be `\cref{chap:RigidityKbar}`) — soon.
  - Pre-existing `undefined-macro`: `\obj` in `lem:isIso_of_app_iso_module`, `\toUnit` in `lem:section_snd_eq_identity_struct`. Likely shorthands for `\mathrm{obj}` / group-object unit map — writer should add `\providecommand` definitions or replace with `\mathrm{...}`. Soon.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_FlatBaseChange.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Pre-existing `literal-ref`: 29 occurrences of Chapter~REF, Definition~REF, Lemma~REF — soon.

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Pre-existing `literal-ref`: `Definition~REF`, `Theorem~REF` in prose — soon.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Pre-existing `literal-ref` (Chapter~REF, Definition~REF, Theorem~REF) — soon.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Pre-existing `literal-ref` — 38 occurrences — soon.

### blueprint/src/chapters/Differentials.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Pre-existing `literal-ref` — 16 occurrences — soon.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex — complete + correct, no notes.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Pre-existing `literal-ref` — 9 occurrences (Chapter~REF, Theorem~REF, REF) — soon.

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Pre-existing `bare-label` (7 occurrences: `cor:algsch`, `lm:ctn`, `lm:qt`, etc.) and `math-delim` (lines 129, 135) — soon.

### blueprint/src/chapters/Picard_FlatteningStratification.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Pre-existing `literal-ref` (23 occurrences) and `math-delim` (line 742) — soon.

### blueprint/src/chapters/Picard_IdentityComponent.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Pre-existing `bare-label` (17 occurrences: `cor:sm`, `lem:agps`, `th:qpp`) — soon.

### blueprint/src/chapters/Picard_LineBundleCoherence.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundlePullback.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Iter-275 new blocks `def:OnProduct_carrier` and `lem:OnProduct_isLocallyTrivial`: both correctly carry statement-level `\uses{def:line_bundle_on_product, def:IsLocallyTrivial}` / `\uses{def:line_bundle_on_product, def:OnProduct_carrier, def:IsLocallyTrivial}`; both lean pins matched; no duplicate; not isolated. Clean.

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Pre-existing `bare-label` (15 occurrences: `cor:ch0`, `cor:sm`, `rmk:Jac`, etc.) and `undefined-macro` (`\tu`) — soon.

### blueprint/src/chapters/Picard_QuotScheme.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Pre-existing `math-delim` (lines 243, 332) — soon.

### blueprint/src/chapters/Picard_RelPicFunctor.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Iter-275 new blocks (`def:rel_tensor_obj`, `lem:rel_pic_sharp_unit_loctriv`, `lem:rel_pic_sharp_inverse_unique`, `def:rel_add`, `def:rel_neg`): all correctly carry statement-level `\uses{}`; all lean pins (`PicSharp.relTensorObj`, `PicSharp.isLocallyTrivial_unit`, `PicSharp.pInverseUnique`, `PicSharp.relAdd`, `PicSharp.relNeg`) matched; no duplicates; none isolated. Clean.
  - Pre-existing `bare-label` (`th:cmp`, `th:main`) and `literal-ref` (3× `REF`) — soon.

### blueprint/src/chapters/Picard_RelativeSpec.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Iter-275 new block `def:relspec_qcoh_pullback`: correctly carries `\uses{def:qc_sheaf_of_algebras, lem:relspec_pullback_fst_isaffinehom, lem:relspec_pullback_coequifibered}`; lean pin `AlgebraicGeometry.Scheme.QcohAlgebra.pullback` matched; no duplicate; not isolated. Clean.
  - Pre-existing `math-delim` (line 686) — soon.

### blueprint/src/chapters/Picard_SheafOverEquivalence.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OCofP.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Pre-existing `math-delim` (lines 27, 424) — soon.

### blueprint/src/chapters/RiemannRoch_OcOfD.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Pre-existing `literal-ref` (43× `REF`) and `math-delim` (lines 231, 411) — soon.

### blueprint/src/chapters/RiemannRoch_RRFormula.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Iter-275 new blocks (`lem:euler_char_sheafOf_zero`, `lem:euler_char_sheafOf_succ`, `lem:euler_char_sheafOf_single_add`, `lem:euler_char_of_shortExact_skyscraper`, `lem:finrank_H0_toModuleKSheaf_eq_one`): all correctly carry statement-level `\uses{}`; all five lean pins matched; no duplicates; none isolated. Clean.
  - Pre-existing `literal-ref` (35× `REF` in proof prose) and `math-delim` (lines 121, 726) — soon.

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Iter-275 new blocks: all 9 new declarations (`def:localParameterAtInfty`, `lem:localParameterAtInfty_uniformiser_witness`, `def:hom_poleDivisor`, `thm:poleDivisor_degree_eq_finrank`, `lem:algebraMap_bijective_of_finrank_one`, `def:phi_left_functionField_algEquiv_of_finrank_one`, `lem:phi_left_locallyQuasiFinite_of_finrank_one`, `lem:phi_left_toNormalization_isIso_of_isIntegralHom`, `lem:phi_left_fromNormalization_isIso_of_smoothProper_finrank_one`) have statement-level `\uses{}`, matched lean pins, no duplicates, none isolated. Clean.
  - Three sorry-bodied helpers (`lem:localParameterAtInfty_uniformiser_witness`, `lem:phi_left_locallyQuasiFinite_of_finrank_one`, `lem:phi_left_fromNormalization_isIso_of_smoothProper_finrank_one`) carry honest "Honest sketch (the Lean body is an open hole)" proof notes as required. Verified.
  - Missing wire-up (soon): `lem:phi_left_toNormalization_isIso_of_isIntegralHom` and `lem:phi_left_fromNormalization_isIso_of_smoothProper_finrank_one` are substrate helpers for `lem:degree_one_morphism_iso` (`iso_of_degree_one`) but not listed in its statement-level `\uses{}`. They are leaf nodes at the statement-DAG level. Since all reside in the same `RationalCurveIso.lean` file, dispatch ordering is not at risk; wire-up improves DAG fidelity. Soon.
  - Pre-existing `math-delim` (lines 36, 51) — soon.

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Iter-275 new block `lem:primeDivisor_ext`: correctly carries `\uses{def:prime_divisor}`; lean pin `AlgebraicGeometry.Scheme.PrimeDivisor.ext` matched; no duplicate; not isolated (used by `lem:primeDivisor_equivOpen` via references). Clean.
  - Pre-existing `math-delim` (lines 142, 1370) — soon.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Pre-existing `literal-ref` (`REF`, `Theorem~REF`) — soon.

### blueprint/src/chapters/RigidityKbar.tex — complete + correct, no notes.

## Severity summary

- **must-fix-this-iter**: none.
- **soon**:
  - `RiemannRoch_RationalCurveIso.tex`: wire-up `lem:phi_left_toNormalization_isIso_of_isIntegralHom` and `lem:phi_left_fromNormalization_isIso_of_smoothProper_finrank_one` into `lem:degree_one_morphism_iso` statement `\uses{}`.
  - Rendering: ~20 chapters have pre-existing `math-delim`, `bare-label`, `literal-ref`, or `undefined-macro` findings (see "Rendering integrity" section above). None are new this iteration. Writer cleanup pass recommended but not blocking prover dispatch.

**Overall verdict**: The 23 iter-275 additive coverage blocks are all correctly wired (statement-level `\uses{}`), use matched Lean pins, introduce no duplicates and no new isolated blueprint nodes; the 3 sorry-bodied RCI helpers carry honest open-hole sketches. The HARD GATE CLEARS for all 38 chapters — no must-fix-this-iter findings. Pre-existing rendering and DAG wire-up issues are "soon" tier.
