# Blueprint Review Report

## Slug
loctriv-regate

## Iteration
245

---

## GATE VERDICT (priority output)

### `Picard_TensorObjSubstrate.tex` — `sec:tensorobj_pullback_monoidality`

**HARD GATE CLEARS.**

- `complete: true`
- `correct: true`
- 0 must-fix findings touching this section

All three gate criteria are satisfied:

1. **D1'–D4' + re-routed `lem:isinvertible_pullback` are mathematically correct and actionable.**
2. **Demotion is coherent: no live `\uses{}` edge reaches the abandoned blocks.**
3. **No must-fix finding touches this section.**

Detail per sub-lemma:

| Label | Role | Correct? | Actionable? | Notes |
|---|---|---|---|---|
| `lem:pullback_tensor_map_natural` (D1') | Naturality of δ_sheaf in (M,N) | ✓ | ✓ | Flows from Mathlib `OplaxMonoidal.δ_natural` + naturality of sheafification reconciliation. Archon-original. |
| `lem:pullback_tensor_iso_unit` (D2') | δ is iso on the unit pair (𝒪,𝒪) | ✓ | ✓ | Uses `pullbackUnitIso` (unconditional iso, ✓ proven) + Mathlib `δ_comp_η_tensorHom` / `δ_comp_tensorHom_η`. Proof: conjugation makes δ_{(𝒪,𝒪)} an iso. Sound. |
| `lem:pullback_tensor_map_basechange` (D3') | δ commutes with open-immersion base-change square | ✓ | ✓ | **Sole genuinely-new step.** Mate calculus via `OplaxMonoidal.comp_δ` + `conjugateEquiv_pullbackComp_inv`, same tools that proved the axiom-clean unit analog `pullbackObjUnitToUnit_comp`. Feasibility confirmed by that precedent. Proof sketch is specific and cites the exact Mathlib API. |
| `lem:pullback_tensor_iso_loctriv` (D4') | Full chart-chase: δ iso on loc-triv pairs | ✓ | ✓ | Chart-chase structure complete: D3' localises δ^f to δ^{g_i}; D1' (naturality) transports to unit pair; D2' gives iso; `isiso_of_isiso_restrict` globalises. Mirrors `lem:IsLocallyTrivial_pullback` pattern. Two Stacks source quotes present, verbatim, with correct `(read from references/stacks-modules.tex)` parenthetical. |
| `lem:isinvertible_pullback` (re-routed) | Pullback preserves ⊗-invertibility | ✓ | ✓ | Now carries explicit `IsLocallyTrivial M, N` hypotheses. Three-step composite `(pullbackTensorIsoOfLocallyTrivial)⁻¹ ≫ (pullback f).mapIso e ≫ pullbackUnitIso` is spelled out. Stacks source verbatim. No dependence on abandoned blocks. |

**Demotion check:**

Grep on `\uses{` across all chapters confirms: the only `\uses{lem:pullback_lan_decomposition}` occurrences are at lines 2977 and 2993 of `Picard_TensorObjSubstrate.tex`, both within `lem:pullback0_tensor_iso`'s own statement/proof — itself an off-path demoted block. No `\uses{}` in any live block (including `lem:isinvertible_pullback`) references `lem:pullback_tensor_iso` (general), `lem:pullback0_tensor_iso`, or `lem:pullback_lan_decomposition`. Both abandoned blocks carry `% NOTE: ABANDONED ... OFF the critical path.` markers. Demotion is self-consistent.

**Lean targets:** `pullbackTensorMap_natural`, `pullbackTensorMap_unit_isIso`, `pullbackTensorMap_restrict`, `pullbackTensorIsoOfLocallyTrivial`, `IsInvertible.pullback` — none has `\leanok` (all are the prover's targets). Names are descriptive and consistent with project naming convention.

---

## Top-level summaries

### Proofs lacking detail

- `AbelianVarietyRigidity.tex` / proof blocks of `lem:rigidity_eqOn_dense_open`, `lem:rigidity_eqOn_saturated_open_to_affine`, `lem:rigidity_eqAt_closedPoint_of_proper_into_affine`: the proof prose still contains the phrase "single genuinely-deep residual sorry" and similar wording about the chain's open residual. A `% NOTE (iter-162 review) STALE as of iter-162` note at line 201 correctly flags this — the chain was proven axiom-clean in iter-162 — but the stale prose remains in the proof blocks of the sub-lemmas. The `\leanok` markers are correct. This is a documentation mismatch only; the mathematics is sound and the blocks are proven.

### Citation discipline

All new live lemmas (D1'–D4' + re-routed `lem:isinvertible_pullback`) follow citation rules correctly:
- D1'–D3': Archon-original (no external source). Correctly omit `% SOURCE:` lines.
- D4' (`lem:pullback_tensor_iso_loctriv`) and `lem:isinvertible_pullback`: Two Stacks quotes each, verbatim English (correct — Stacks is in English), with `(read from references/stacks-modules.tex)` parentheticals. Visible `\textit{Source:...}` lines present and matching.

---

## Per-chapter

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `lem:pullback_tensor_map_basechange` (D3') statement `\uses` includes `lem:pullback_tensor_map_natural` but the proof `\uses` omits it. D3's proof does not invoke D1' (naturality) — only the mate calculus. This is a harmless over-inclusion in the statement \uses; creates one ghost edge in the dependency graph. Informational.
  - `lem:isinvertible_implies_locallytrivial`: carries `% NOTE: OFF the critical path AND unnecessary.` — correct annotation; retained for future A.2.c use. Not a finding.
  - The chapter still carries dead duplicate whisker lemma + off-path full-monoidal route-(e) apparatus (noted in PROGRESS.md as "future structural/refactor pass, non-blocking"). Not a current finding.

### blueprint/src/chapters/AbelianVarietyRigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Proof blocks of `lem:rigidity_eqOn_dense_open`, `lem:rigidity_eqOn_saturated_open_to_affine`, `lem:rigidity_eqAt_closedPoint_of_proper_into_affine` contain stale "single genuinely-deep residual sorry" wording — the chain has been proven axiom-clean since iter-162 (flagged by the `% NOTE (iter-162 review) STALE` annotation at line 201 of the first block, but subsequent proof blocks were not updated). Soon-severity documentation cleanup; `\leanok` markers are correct.

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelPicFunctor.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `PicSharp.addCommGroup` sorry (RelPicFunctor.lean:269) is the chapter's documented open obligation, explicitly gated on `lem:pullback_tensor_iso_loctriv` (A.1.c.sub). The blueprint content correctly describes the dependency: map_add via the loc-triv comparison iso, map_zero via pullbackUnitIso, inverse via exists_tensorObj_inverse. Not a correctness issue — status is expected and consistent with the gate clearing this iter.
  - `def:rel_pic_sharp` has `\leanok` on a placeholder Lean body (constant functor at PUnit). Documented by the % NOTE at line 189. Semantically consistent with `\leanok` meaning "at least a sorry present."

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Assembly chapter gated on A.2.c (QuotScheme + RelPicFunctor). Main declarations have `\leanok` on scaffolding bodies, explicitly documented. Blueprint content is mathematically sound.

### blueprint/src/chapters/Picard_RelativeSpec.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_IdentityComponent.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Gated A.2.c; sorries are documented scaffolding. Blueprint content sound.

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Gated A.2.c; same pattern as IdentityComponent.

### blueprint/src/chapters/Picard_QuotScheme.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - A.2.c-engine chapter. Large (1435 lines); well-documented with appropriate sorries for Mathlib-absent infrastructure (R^i f_*, Relative Proj). Not a correctness issue.

### blueprint/src/chapters/Picard_FlatteningStratification.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - A.2.c-engine chapter; gated; appropriate sorries documented.

### blueprint/src/chapters/Cohomology_FlatBaseChange.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - A.2.c-engine side-lane; HELD per PROGRESS.md (defeq wall, re-engagement condition documented). Blueprint content is sound; infrastructure lemmas (stalk-local/basis-local/affine-open isomorphism criteria) have `\leanok`. The two affine-close obligations remain open sorries.

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `def:higher_direct_image` has `[HasInjectiveResolutions X.Modules]` as a conditional hypothesis (Mathlib doesn't yet have `EnoughInjectives` for `SheafOfModules`). Documented by % NOTE. Mathematically correct; Lean target is conditional on the instance, which is the honest state.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/Jacobian.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Top-level assembly chapter; positive-genus arm gated A.2.c, genus-0 arm proven (AbelianVarietyRigidity complete). Blueprint content correct; gated sorries are documented and expected.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Gated A.2.c + A.3; symmetric-power route documented (Route ii, cube-free). Blueprint content sound. Main theorem has `\leanok` on scaffolding.

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Route-1 Albanese fallback; retained reversibly, gated A.2.c.

### blueprint/src/chapters/Albanese_CodimOneExtension.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Route-1 Albanese fallback; retained reversibly.

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Route-A + Route-1 input. Gated A.2.c.

### blueprint/src/chapters/Albanese_CoheightBridge.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Route C PAUSE. Under user directive freeze; content is present.

### blueprint/src/chapters/RiemannRoch_OCofP.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Route C PAUSE.

### blueprint/src/chapters/RiemannRoch_OcOfD.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Route C PAUSE.

### blueprint/src/chapters/RiemannRoch_RRFormula.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Route C PAUSE.

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Route C PAUSE.

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Route C PAUSE.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Route C PAUSE (CharZero fallback, retained reversibly). Large chapter (2621 lines); not on the critical path.

---

## Cross-chapter notes

- `Picard_RelPicFunctor.tex` references `lem:pullback_tensor_iso_loctriv` (now in `Picard_TensorObjSubstrate.tex`) in its prose description of addCommGroup dependency, but no formal `\uses{}` edge yet from `lem:rel_pic_sharp_groupoid` to the new loctriv lemma. This will need a `\uses{}` update when the prover closes `lem:rel_pic_sharp_groupoid`. Informational now (the addCommGroup block is an open sorry); not a must-fix for the current dispatch.

---

## Severity summary

**must-fix-this-iter**: 0

**soon**:
- `AbelianVarietyRigidity.tex` proof-block prose: stale "single genuinely-deep residual sorry" wording in `lem:rigidity_eqOn_dense_open`, `lem:rigidity_eqOn_saturated_open_to_affine`, `lem:rigidity_eqAt_closedPoint_of_proper_into_affine` proof blocks — iter-162 closed the chain, `% NOTE (iter-162 review) STALE` at line 201 flags the root but the sub-lemma prose was not cleaned. Blueprint writer cleanup; `\leanok` markers are correct.

**informational**:
- `Picard_TensorObjSubstrate.tex`: `lem:pullback_tensor_map_basechange` statement `\uses` over-includes `lem:pullback_tensor_map_natural` (not consumed by D3' proof; D1' naturality is a separate lemma invoked only in D4'). Harmless extra dependency edge.
- `Picard_RelPicFunctor.tex`: future `\uses{lem:pullback_tensor_iso_loctriv}` edge missing from `lem:rel_pic_sharp_groupoid` (not yet a gate issue since the block is an open sorry; will be needed when the prover closes that block).

Overall verdict: **HARD GATE CLEARS** for `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` — `sec:tensorobj_pullback_monoidality` is complete+correct with D1'–D4' and re-routed `lem:isinvertible_pullback` all mathematically sound, proof sketches actionable, demotion coherent; 0 must-fix findings; 35 chapters audited, 0 unstarted-phase proposals.
