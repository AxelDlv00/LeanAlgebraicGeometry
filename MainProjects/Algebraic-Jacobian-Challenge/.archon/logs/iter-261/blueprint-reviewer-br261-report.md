# Blueprint Review Report

## Slug
br261

## Iteration
261

## Top-level summaries

### Proofs lacking detail

- `Picard_TensorObjSubstrate.tex` / `lem:dual_restrict_iso` (L5701): proof sketch (lines ~5786–5841) describes the route-(1) approach — consuming `overEquivalence`'s `restrictOverIso` / `unitOverIso` localised to V. An iter-260 review NOTE (line 5773) confirms this is **structurally insufficient**: those isos carry no internal-hom / dual content, and the goal's content is that the dual commutes with slice reindexing — which would require `pushforward (phiOver U)` to be strongly monoidal-closed. The genuine close is **route-(2)**: build the forward/inverse ≃ₗ directly — leg-A = eqToHom-conjugation across `f.opensFunctor` (poset-thin, `Subsingleton.elim`) ∘ leg-B = `restrictScalarsRingIsoDualEquiv` along `(f.appIso V).inv`. The NOTE tags this as a MUST-FIX for the plan/writer.

- `Picard_TensorObjSubstrate.tex` / `lem:pullback_tensor_map_basechange` "Second" paragraph (lines ~4035–4058): describes the proof of `pushforwardComp_lax_μ` as a ModuleCat extendScalarsComp / restrictScalarsComp / homEquiv_extendScalarsComp build. An iter-260 review NOTE (line 4023) records that this is **overstated**: the committed proof is a shorter sectionwise pure-tensor collapse (`pushforward_μ_eq` reducing to `restrictScalars_μ_tmul`, then `ModuleCat.restrictScalars_μ_tmul`). Separately, the sentence at line 4091 lists "Mathlib-absent monoidality Sq2b" as a missing ingredient — this is **stale**: Sq2b (`pullbackComp_δ` + `pushforwardComp_lax_μ`) is fully closed axiom-clean per the iter-260 review NOTE (line 4086). After iter-260 the only genuinely missing ingredients for `pullbackTensorMap_restrict` are Sq1 (`sheafificationCompPullback`) and Sq4 (`pullbackValIso`). Both NOTEs tag this as a MUST-FIX for the plan/writer.

### Lean difficulty quality

- `Picard_TensorObjSubstrate.tex` / `lem:dual_restrict_iso` (L5673): `\uses` edges in both statement and proof blocks include `lem:sheafofmodules_restrict_over_iso` and `lem:sheafofmodules_unit_over_iso`. Per the iter-260 review NOTE, these are stale: route-(2) does NOT consume `restrictOverIso` / `unitOverIso`. These edges should be removed when the writer rewrites to route-(2).

## Per-chapter

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex

- **complete**: true
- **correct**: false
- **notes**:
  - `lem:dual_restrict_iso` (L5701) proof sketch: route-(1) sketch is WRONG per iter-260 review NOTE (L5773). The correct route is route-(2) (leg-A eqToHom-conjugation + leg-B restrictScalarsRingIsoDualEquiv). Must be rewritten before DualInverse.lean prover dispatch.
  - `lem:dual_restrict_iso` statement / proof `\uses`: stale edges to `lem:sheafofmodules_restrict_over_iso` and `lem:sheafofmodules_unit_over_iso` — route-(2) does not consume them. Remove per the NOTE.
  - `lem:pullback_tensor_map_basechange` (D3' outer) "Second" paragraph (L4035): `pushforwardComp_lax_μ` proof description overstated; actual proof is sectionwise pure-tensor collapse, not extendScalarsComp build. NOTE at L4023 tags this as MUST-FIX for writer.
  - `lem:pullback_tensor_map_basechange` missing-ingredients sentence (L4091): "Sq2b missing" is stale — Sq2b is closed axiom-clean. Only Sq1 and Sq4 remain. NOTE at L4086 tags this as MUST-FIX for writer.

### blueprint/src/chapters/Picard_SheafOverEquivalence.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelPicFunctor.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundleCoherence.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelativeSpec.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_QuotScheme.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_IdentityComponent.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FlatteningStratification.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelianVarietyRigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CodimOneExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CoheightBridge.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_FlatBaseChange.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RRFormula.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OcOfD.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OCofP.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex — complete + correct, no notes.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/RigidityKbar.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Jacobian.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

## Severity summary

**must-fix-this-iter:**

1. `Picard_TensorObjSubstrate.tex` / `lem:dual_restrict_iso` proof sketch — **route-(1) sketch is WRONG** per iter-260 review NOTE. This is the proof the iter-261 prover for `DualInverse.lean` will read. Dispatching that prover without fixing this will cause another failed iter (iter-260 already failed for exactly this reason). Must-fix: dispatch blueprint-writer for `Picard_TensorObjSubstrate.tex` with directive: rewrite the leg-(A)/sliceDualTransport paragraph (L5786–5841) to route-(2) (eqToHom-conjugation across `f.opensFunctor` + `restrictScalarsRingIsoDualEquiv`), remove stale `\uses` edges to `lem:sheafofmodules_restrict_over_iso` / `lem:sheafofmodules_unit_over_iso` from both statement (L5673) and proof (L5702).

2. `Picard_TensorObjSubstrate.tex` / `lem:pullback_tensor_map_basechange` Sq2b description — **two stale claims** per iter-260 review NOTEs: (a) proof-method paragraph overstates `pushforwardComp_lax_μ` as an extendScalarsComp build (actual: pure-tensor collapse); (b) missing-ingredients sentence wrongly includes Sq2b. Must-fix: same writer dispatch as above — rewrite "Second" paragraph (L4035–4058) to the shorter sectionwise route; remove Sq2b from the missing list at L4091 (leave only Sq1 + Sq4).

Overall verdict: **HARD GATE FAILS** on `Picard_TensorObjSubstrate.tex` (`correct: false`); dispatch blueprint-writer for this chapter before dispatching any prover on `DualInverse.lean` or D3'. 37 of 38 chapters clean, 0 unstarted-phase proposals, 2 must-fix items both in the one active-prover chapter.
