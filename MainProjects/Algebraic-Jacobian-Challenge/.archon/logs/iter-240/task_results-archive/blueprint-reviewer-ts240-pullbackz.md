# Blueprint Review Report

## Slug
ts240-pullbackz

## Iteration
240

## Top-level summaries

### Incomplete parts

- `Picard_RelPicFunctor.tex`: declaration bodies for `def:rel_pic_sharp`, `lem:rel_pic_sharp_groupoid`, and `lem:rel_pic_sharp_functorial` are documented stubs (Lean body = constant at `PUnit`, not implementing the carrier-pivot). The chapter still describes the old `IsLocallyTrivial` / `LineBundle.OnProduct` carrier; the `IsInvertible`-carrier rewrite is gated on `IsInvertible.pullback` landing. The chapter's `sec:relpic_lean_encoding` gate-annotation acknowledges this but the chapter is not yet updated.

### Proofs lacking detail

- `Picard_TensorObjSubstrate.tex` / `lem:pullback_tensor_iso` proof part (a): the "already-established sheafification-monoidality brick (cf. lem:tensorobj_restrict_iso)" is referenced without a `\lean{}` pin identifying it by name (`sheafifyTensorUnitIso`). The prover can locate it from context, but the reference is informal. Non-blocking for the gate (the brick is axiom-clean from iter-239 per project records).

### Citation discipline

- `Picard_RelPicFunctor.tex` / `def:rel_pic_sharp`: `\leanok` is present on this statement block, but the chapter's own `% NOTE:` (line 190–205) explicitly warns "DO NOT promote this block to \\leanok via the deterministic sync\_leanok phase, and DO NOT mark it formalised in review, until the body is replaced." The marker is inconsistent with the known stub state. Same finding applies to `lem:rel_pic_sharp_groupoid` (line 74) and `lem:rel_pic_sharp_functorial` (line 207). This is not a citation-discipline issue in the Stacks-quote sense, but it is a correctness-axis violation: `\leanok` signals formalization where none exists.

## Per-chapter

### `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` — focus chapter

- **complete**: true
- **correct**: true
- **notes**:
  - `sec:tensorobj_pullback_monoidality` GATE VERDICT: **CLEARS**. Full checklist:
  - Dead sectionwise-`extendScalars` route is absent. The section intro correctly identifies that `f^*` is an abstract left adjoint with no sectionwise/stalkwise formula, and that Mathlib ships only `Adjunction.rightAdjointLaxMonoidal` (the wrong direction), so the oplax comparison on `f^*` is not free.
  - Route Z (local-chart finality) is correctly described: exhibits comparison maps and proves them isomorphisms by restricting to affine charts where `Opens.map g.base` is `Final` (via `final_of_representablyFlat`), then globalizes via `isIso_of_isIso_restrict`.
  - `lem:pullback_unit_iso` (Phase 1): proof is `pullbackObjUnitToUnit f` → `instIsIsoPullbackObjUnitToUnitOfFinal` on each `resLE` chart → globalize. Cheap and correct.
  - `lem:pullback_tensor_iso` (Phase 2): proof is (a) construct `pullbackObjTensorToTensor` from presheaf-level monoidal structure of `PresheafOfModules.pullback` moved across `SheafOfModules.sheafificationCompPullback`; (b) show it iso by the same finality chart-chase (local comparison = `extendScalars` tensorator, strong monoidal in `ModuleCat`); (c) the full `CoreMonoidal.ofOplaxMonoidal` packaging is explicitly off the critical path (requires hand-built `OplaxMonoidal f^*`; `leftAdjointOplaxMonoidal` absent from Mathlib). The statement is the pointwise iso, which is all the invertibility consumer needs.
  - `lem:isinvertible_pullback`: consumes only the pointwise comparison isos via composite `pullbackTensorIso⁻¹ ≫ f*e ≫ pullbackUnitIso`. No strong-monoidal packaging invoked. SOURCE/SOURCE QUOTE/SOURCE QUOTE PROOF blocks for `lemma-tensor-product-pullback` (L2392–2400) and `lemma-pullback-invertible` (L4142–4157) are byte-accurate (confirmed by blueprint-clean ts240).
  - `\uses{}` graph: acyclic. `lem:pullback_unit_iso` → `def:scheme_modules_tensorobj`; `lem:pullback_tensor_iso` → `{def:scheme_modules_tensorobj, lem:pullback_unit_iso}`; `lem:isinvertible_pullback` → `{def:scheme_modules_isinvertible, lem:pullback_tensor_iso, lem:pullback_unit_iso}`. Confirmed by blueprint-clean ts240.
  - Mathlib facts cited (`instIsIsoPullbackObjUnitToUnitOfFinal`, `final_of_representablyFlat`, `sheafificationCompPullback`, `isIso_of_isIso_restrict`) are the correct tools for the stated proof route.
  - Informational: proof part (a) references "sheafification-monoidality brick (cf. lem:tensorobj_restrict_iso)" without naming `sheafifyTensorUnitIso`. Non-blocking.

### `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

- **complete**: true
- **correct**: true
- **notes**:
  - Additive edits from this iter confirmed non-regressing.
  - `lem:gammaPushforwardIsoAt`: present, `\lean{AlgebraicGeometry.gammaPushforwardIsoAt}` pinned, `\uses{lem:globalSectionsIso_hom_comp_specMap_appTop}` correct and acyclic. Proof sketch (copies `gammaPushforwardIso` with `⊤` replaced by arbitrary open `U`) is sound. Identified as `e_{D(a)}` for `U=D(a)` — correct connection to movement (1) in `lem:pushforward_spec_tilde_iso` proof.
  - `lem:tildeRestriction_isLocalizedModule`: present, pinned, no `\uses{}` (standalone tilde-localization fact). Proof sketch (trivial-submonoid bijection + triangle identity) is sound.
  - `lem:pushforward_spec_tilde_iso` proof: new "Naturality in the open drives the transport" paragraph correctly identifies the open-naturality of `{e_U}` as the uniform driver for `hloc(a)`, referencing `lem:gammaPushforwardIsoAt` + `lem:tildeRestriction_isLocalizedModule` by name. The `\uses{}` in the proof now includes both new blocks. Acyclic.
  - Blueprint-clean ts240 confirmed no Lean leakage and all `\lean{}` pins present.

### `blueprint/src/chapters/Picard_RelPicFunctor.tex`

- **complete**: partial
- **correct**: partial
- **notes**:
  - `\leanok` is present on `lem:rel_pic_sharp_groupoid` (line 74), `def:rel_pic_sharp` (line 156), and `lem:rel_pic_sharp_functorial` (line 207). The chapter's own `% NOTE:` at lines 190–205 explicitly warns these are stubs: `def:rel_pic_sharp` carries a constant-functor placeholder `((CategoryTheory.Functor.const _).obj (AddCommGrpCat.of PUnit))` that is NOT the relative Picard presheaf. The `\leanok` markers incorrectly signal formalization.
  - The chapter describes the OLD `IsLocallyTrivial`/`LineBundle.OnProduct` carrier. The carrier-pivot rewrite (to `IsInvertible`) is gated on `IsInvertible.pullback` landing (the current iter-240 prover objective). The chapter cannot be dispatched for RPF prover work until the rewrite lands.
  - Action: AFTER `IsInvertible.pullback` closes, dispatch a blueprint-writer for the carrier-pivot rewrite. Until then, record deferral citing the IsInvertible.pullback gate.

### `blueprint/src/chapters/Cohomology_HigherDirectImage.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_RelativeSpec.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_LineBundlePullback.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_FGAPicRepresentability.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_FlatteningStratification.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_IdentityComponent.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_Pic0AbelianVariety.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_QuotScheme.tex`

- **complete**: partial
- **correct**: partial
- **notes**:
  - Several `\lean{}` pins name declarations that are Mathlib-absent and not yet in-tree: e.g., `AlgebraicGeometry.flatBaseChangeCohomology` (line 745), `AlgebraicGeometry.pullback_tildeIso` (line 958), `AlgebraicGeometry.pushforward_isQuasicoherent` (line 994). These are speculative pins for held engine work. Non-blocking for the current prover lanes (engine is held behind A.1.c). Flagged as "soon" in prior iter; status unchanged.
  - Section setup prose (line 43) has a dangling open paren: "Hilbert polynomial `Φ(λ)=…` (constant on connected `T` by flatness; see~\)". Minor prose error. Informational.

### `blueprint/src/chapters/AbelianVarietyRigidity.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Albanese_AlbaneseUP.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Albanese_CodimOneExtension.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Albanese_CoheightBridge.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Cohomology_MayerVietoris.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Cohomology_SheafCompose.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Cohomology_StructureSheafAb.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex` — complete + correct, no notes.

### `blueprint/src/chapters/AbelJacobi.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Jacobian.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Rigidity.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RigidityKbar.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Genus.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Differentials.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex` — complete + correct, no notes.

### `blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RiemannRoch_OCofP.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RiemannRoch_OcOfD.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RiemannRoch_RRFormula.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RiemannRoch_H1Vanishing.tex` — complete + correct, no notes.

## Severity summary

**must-fix-this-iter:**

1. `Picard_RelPicFunctor.tex` — `correct: partial`. `\leanok` present on `def:rel_pic_sharp`, `lem:rel_pic_sharp_groupoid`, `lem:rel_pic_sharp_functorial` whose Lean bodies are documented stubs (not implementing the `IsInvertible` carrier functor); chapter's own NOTE warns against the markers. Carrier-pivot rewrite is gated on `IsInvertible.pullback` (current iter-240 prover objective): **record deferral citing the gate** (carrier-pivot dispatch pending IsInvertible.pullback close); do NOT dispatch the RPF prover while this chapter is partial.

2. `Picard_QuotScheme.tex` — `complete: partial`, `correct: partial`. Speculative `\lean{}` pins for Mathlib-absent held-engine declarations. Non-blocking for current objectives (engine held). **Record deferral** citing engine-held status; update pins when engine work begins.

**soon:**

- `Picard_TensorObjSubstrate.tex` / `lem:pullback_tensor_iso` part (a): "sheafification-monoidality brick" referenced without naming `sheafifyTensorUnitIso`. Harmless for current prover (brick is axiom-clean); pin the name before dispatching the next tier of prover work that consumes this path.

**informational:**

- `Picard_QuotScheme.tex` line 43: dangling open paren in setup prose. Minor.

**Focus chapter gate decision:**

`sec:tensorobj_pullback_monoidality` in `Picard_TensorObjSubstrate.tex`: **HARD GATE CLEARS**. `lem:pullback_tensor_iso`, `lem:pullback_unit_iso`, and `lem:isinvertible_pullback` are complete and correct. Route Z (local-chart finality) is correctly formalized, the descope of `CoreMonoidal.ofOplaxMonoidal` is coherent, Stacks SOURCE QUOTEs are byte-accurate, `\uses{}` is acyclic, and the Mathlib facts cited are the right tools. The prover (`mathlib-build`) for Phase 1 (`pullbackUnitIso`) and Phase 2 (`pullbackTensorIso`) may be dispatched this iter.

**FlatBaseChange confirmed non-regressed:**

`Cohomology_FlatBaseChange.tex` additive edits (`lem:gammaPushforwardIsoAt`, `lem:tildeRestriction_isLocalizedModule`, natural-in-open notes to `lem:pushforward_spec_tilde_iso` proof) did not regress the chapter. Complete + correct, gate confirmed.

Overall verdict: `sec:tensorobj_pullback_monoidality` HARD GATE CLEARS for the pullback-monoidality prover; `Cohomology_FlatBaseChange.tex` remains clean; 2 chapters (`Picard_RelPicFunctor.tex`, `Picard_QuotScheme.tex`) have must-fix findings with recorded deferral rationales available; 0 unstarted-phase proposals (all strategy phases have adequate blueprint coverage).
