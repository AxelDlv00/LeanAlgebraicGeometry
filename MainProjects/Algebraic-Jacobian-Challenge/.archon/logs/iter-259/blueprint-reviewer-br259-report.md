# Blueprint Review Report

## Slug
br259

## Iteration
259

## Top-level summaries

### Incomplete parts

- `Albanese_AlbaneseUP.tex` / `lem:symmetric_product_to_jacobian`: proof body carries a NOTE that birationality is gated on Route C (RR) re-engagement; the `\leanok` on the statement block is consistent with the file having a sorry skeleton, but the RR dependency is unresolved. Non-blocking (file is gated, not in current objectives).

- `RiemannRoch_H1Vanishing.tex` / `lem:isFlasque_injective`: proof deferred ("formalisation is deferred to a future iteration after a Mathlib `j_!` construction is available"); `lem:isFlasque_constant_irreducible` non-empty branch also carries a typed sorry (Route A/B documented). Non-blocking — under the permanent USER RR pause.

- Multiple chapters (`AbelJacobi.tex`, `Jacobian.tex`, `CodimOneExtension.tex`, `RiemannRoch_RationalCurveIso.tex`, others): informal `Theorem~REF` / `lemma~REF` / `Section~REF` placeholders inside proof-body prose — these are established project-wide editorial placeholders for unresolved forward cross-references, not broken `\uses{}` labels. Non-blocking per directive.

### Proofs lacking detail

None that would impede prover dispatch on the current active routes.

### Multi-route coverage

**Route A primary (RR-free):** COVERED — TensorObjSubstrate, SheafOverEquivalence, LineBundleCoherence, LineBundlePullback, RelPicFunctor, FGAPicRepresentability, IdentityComponent, Pic0AbelianVariety, AuslanderBuchsbaum, CodimOneExtension, CoheightBridge, Thm32RationalMapExtension, AlbaneseUP, FlatteningStratification, QuotScheme, Cech/Higher direct images, FlatBaseChange.

**Route C (RR) — PAUSED (USER, permanent):** All four RR sub-chapters (WeilDivisor, RRFormula, OcOfD, OCofP, H1Vanishing, RationalCurveIso) are complete and correctly document the pause status and gating relationships. PASS.

**Genus-0 arm (AbelianVarietyRigidity / RigidityKbar):** COVERED — committed route (c) (Milne §I.3 Gm-scaling shortcut) fully blueprinted in AbelianVarietyRigidity.tex; fallback route (a) (cotangent-vanishing) documented in RigidityKbar.tex. PASS.

## Per-chapter

### HARD GATE chapters

### blueprint/src/chapters/Picard_SheafOverEquivalence.tex

- **complete**: true
- **correct**: true
- **notes**:
  - `def:sheafofmodules_over_equivalence` (`overEquivalence`): `\leanok`, proof sketch complete. The assembly of `pushforwardPushforwardEquivalence` + φ/ψ/H₁/H₂ is detailed and correct.
  - `lem:sheafofmodules_restrict_over_iso` (`restrictOverIso`): `\leanok`, proof sketch adequate (pushforwardComp + eqToIso route).
  - `lem:sheafofmodules_unit_over_iso` (`unitOverIso`): `\leanok`. **This iter's additive expansion is present and correct**: names `unitToPushforwardObjUnit`, describes the sectionwise-iso argument (`unitToPushforwardObjUnit_val_app_apply`), invokes `NatTrans.isIso_iff_isIso_app` for the iso-reflection lift, and identifies the final `(asIso (unitToPushforwardObjUnit φ))⁻¹` construction. No regression from br258-regate.
  - `lem:chart_over_iso` (`chartOverIso`): `\leanok`, three-iso composite correctly described.
  - All `\uses{}` labels resolve within the chapter.
  - Source provenance: Archon-original assembly (no verbatim SOURCE QUOTE required); source pointer to `SheafOfModules.pushforwardPushforwardEquivalence` and `Opens.overEquivalence` is present and correct.
  - **HARD GATE: PASSES.**

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex

- **complete**: true
- **correct**: true
- **notes**:
  - `lem:pullback_tensor_map_basechange` (`pullbackTensorMap_restrict`, D3′): `\leanok`. The proof sketch correctly identifies the four-square paste structure and explains why the unit-analog transpose-and-inject does not directly apply.
  - **Sq2 (δ-core)**: Correctly states the ring-map reconciliation is definitional (`toRingCatSheafHom_comp_hom_reconcile`, `rfl`), carrying no proof obligation. No pseudofunctor bookkeeping required.
  - **Sq2b (monoidality of `pullbackComp` — the genuinely new ingredient)**: The proof sketch is complete and sound. It correctly identifies that `δ` is itself an adjunction transpose (`homEquiv⁻¹` of `(η⊗η);μ`), so the `η→δ` mirror of `pullbackObjUnitToUnit_comp` is the correct route. The mate-calculus argument via `conjugateEquiv_pullbackComp_inv` + `unit_conjugateEquiv` + `Adjunction.comp_unit_app` is correctly described.
  - **Sq1 (sheafificationCompPullback coherence)**: Mathlib-absent, correctly noted as a standalone project sub-lemma.
  - **Sq3 (sheafifyTensorUnitIso transport)**: Correctly described as carried through the same `pullbackComp` identification as Sq2.
  - **Sq4 (pullbackValIso composition coherence)**: Mathlib-absent, correctly noted as the second standalone sub-lemma.
  - `\uses{}` labels for `lem:pullback_tensor_map`, `lem:pullback_tensor_map_natural`, `lem:presheaf_pullback_oplaxmonoidal`, `lem:tensorobj_restrict_iso` all resolve within the chapter.
  - Remark on the open-immersion base-change specialisation (`h := j'`) is present and correctly explains the D4′ consumption.
  - Broader chapter: all previously-closed declarations (`pullbackTensorMap`, `pullbackUnitIso`, `pullbackObjUnitToUnit_comp`, `sheafifyTensorUnitIso_hom_natural`, etc.) remain with `\leanok` and correct proof sketches. No regression.
  - Source provenance: Stacks lemma-tensor-product-pullback and lemma-pullback-locally-free cited verbatim for `lem:pullback_tensor_iso_loctriv`. D3′ itself is Archon-original (no external source claim).
  - **HARD GATE: PASSES.**

---

### Non-gate chapters (no findings — one-liner format)

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/Jacobian.tex — complete + correct, no notes.
(All four routes A/B/C/genus-0 documented with Mathlib gap assessments; per-sub-phase LOC budgets present; iter-172 A.4 re-estimate absorbed.)

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelianVarietyRigidity.tex — complete + correct, no notes.
(Committed Gm-scaling shortcut route (c) fully detailed; Rigidity Lemma chain closed iter-162; all sorries properly accounted for via sub-lemma decomposition.)

### blueprint/src/chapters/RigidityKbar.tex — complete + correct, no notes.
(Fallback route (a) documented with gap (i)+(ii); alg-closed pivot iter-152 correct; chart-algebra envelope correctly scoped to converse direction only.)

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.
(Carrier predicates `IsAffineHModuleVanishing`, `HasCechToHModuleIso` correctly documented as unproduced producers; conditional genus theorem correctly scoped.)

### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex — complete + correct, no notes.
(Covers `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean` not yet scaffolded — documented as the Rⁱf_* Čech blueprint; correct per directive guidance on deferred items.)

### blueprint/src/chapters/Cohomology_FlatBaseChange.tex — complete + correct, no notes.
(`lem:base_change_map_affine_local` and `lem:pushforward_base_change_mate_cancelBaseChange` are Mathlib-absent named obligations without `\leanok`, correctly documented. Both are sub-lemmas inside `lem:affine_base_change_pushforward` which has `\leanok`.)

### blueprint/src/chapters/Picard_RelativeSpec.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundleCoherence.tex — complete + correct, no notes.
(The stale-comment fix landed this iter is reflected; `chartOverIso` dependency via `Picard_SheafOverEquivalence` correctly noted in the `% NOTE` block.)

### blueprint/src/chapters/Picard_RelPicFunctor.tex — complete + correct, no notes.
(NOTE blocks correctly document that Lean bodies are placeholder-sorries pending monoidal gap; `PicSharp.addCommGroup` proof properly annotates the `pullback_tensor_iso_loctriv` concurrent-build dependency.)

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex — complete + correct, no notes.
(Seven sorries with closure recipes and rank assignments; Sorry 5/6/7 correctly flagged as Route C gated. `thm:quot_representable` and `def:rel_pic_etale_sheafification` cross-chapter labels verified present in sibling chapters.)

### blueprint/src/chapters/Picard_QuotScheme.tex — complete + correct, no notes.
(Extensive sub-lemma decomposition; iter-200/201/202 substrate landing notes present; `lem:pullback_tildeIso` and `lem:pushforward_isQuasicoherent` correctly typed as named project-side sorries with closure recipes.)

### blueprint/src/chapters/Picard_FlatteningStratification.tex — complete + correct, no notes.
(`thm:generic_flatness_algebraic` has no `\leanok` — correctly reflecting that it is a sub-lemma not yet formalized; geometric form `thm:generic_flatness` and main theorem `thm:flattening_stratification_exists` have `\leanok`.)

### blueprint/src/chapters/Picard_IdentityComponent.tex — complete + correct, no notes.
(Abstract identity-component substrate fully blueprinted; `lem:geometricallyConnected_of_connected_of_section` Stacks 037Q block added iter-194 correctly documented.)

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex — complete + correct, no notes.
(Five theorems tangentSpaceIso / smooth / proper / geomIrred / isAbelianVariety with adequate proof sketches citing Kleiman §5 and Milne III.)

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex — complete + correct, no notes.
(Path B RESOLVED iter-202 — `auslander_buchsbaum_formula_succ_pd` and main formula both closed axiom-clean; gap (3) OBVIATED. Status block `RESOLVED iter-202` correctly placed; remaining "gap (2)" recipe now historical-only.)

### blueprint/src/chapters/Albanese_CoheightBridge.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CodimOneExtension.tex — complete + correct, no notes.
(Stage 6 decomposition into 6.A/6.B/6.C present; iter-200/201/202/203 substrate landing status current; iter-203 Matsumura recipe detailed with full proof structure and target sorry-line. File is 1717 lines; chapter is fully self-consistent from the declarations audited.)

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex — complete + correct, no notes.
(Symmetric-power route (ii) committed; iter-199 birationality-gated-on-RR NOTE present; `lem:symmetric_product_to_jacobian` `\leanok` consistent with sorry skeleton existing. Non-blocking for current objectives.)

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RRFormula.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OcOfD.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OCofP.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex — complete + correct, no notes.
(Two typed sorries — `constant_of_irreducible` non-empty branch and `isFlasque_injective` j_! gap — are correctly documented with Route A/B closure recipes. Under permanent USER RR pause; non-blocking.)

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex — complete + correct, no notes.

---

## Severity summary

Severity summary: HARD GATE CLEARS — no findings.

Both `Picard_SheafOverEquivalence.tex` and `Picard_TensorObjSubstrate.tex` are `complete: true`, `correct: true`, with zero must-fix findings. All 38 chapters audited pass. No unstarted phases. No broken `\uses{}` labels. No citation-discipline failures on active prover routes. All non-blocking items are deferred/held per the established project pattern.

**Overall verdict**: All 38 chapters clean; both HARD GATE chapters confirmed complete + correct with zero findings — no regression from br258-regate verdict; both gated files (`Picard/SheafOverEquivalence.lean`, `Picard/TensorObjSubstrate.lean`) may proceed to prover objectives.
