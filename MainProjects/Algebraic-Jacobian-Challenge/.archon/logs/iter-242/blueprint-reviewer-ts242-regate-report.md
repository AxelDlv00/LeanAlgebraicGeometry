# Blueprint Review Report

## Slug
ts242-regate

## Iteration
242

## Top-level summaries

### Proofs lacking detail

- `RigidityKbar.tex` / `thm:rigidity_over_kbar`: proof body is an explicit `sorry`; the chapter documents this as an intentional named gap (gaps (i) and (ii) — global cotangent-triviality of `A` and `H^0(C, Ω) = 0` — are absent from Mathlib and the tree). No proof sketch is provided because no formalizable route exists yet.  This is pre-existing and the plan agent has accepted it as a named gap.

### Citation discipline

No new citation-discipline findings. All `% SOURCE:` blocks in both gate-critical chapters name existing local reference files with `(read from references/...)` parentheticals and carry matching visible `\textit{Source: ...}` lines.

## Per-chapter

### Gate-critical chapters

#### blueprint/src/chapters/Picard_TensorObjSubstrate.tex
- **complete**: true
- **correct**: true
- **notes**:
  - GATE CHECK (per directive): `sec:tensorobj_pullback_monoidality` verified in full.
    - `lem:pullback_unit_iso`: proof is the one-line representable-flatness argument (`final_of_representablyFlat` ⇒ `(Opens.map f.base).Final` unconditionally ⇒ `instIsIsoPullbackObjUnitToUnitOfFinal`). Stale `\uses{lem:pullbackObjUnitToUnit_comp, lem:unitToPushforwardObjUnit_comp}` removed; current `\uses` is correctly `\uses{def:scheme_modules_tensorobj}` only. `\lean{AlgebraicGeometry.Scheme.Modules.pullbackUnitIso}` pin is correct. `\leanok` present (already proved). No chart-chase, no false "Final need not hold globally". ✓
    - `lem:pullback_tensor_iso`: proof is the three-step concrete-strong-monoidal route — build `P = sheafification ∘ (sectionwise extendScalars)` with tensorator `TensorProduct.AlgebraTensorModule.distribBaseChange` and unit comparison `sheafifyTensorUnitIso` (Step 1), exhibit `P ⊣ pushforward` (Step 2), obtain `pullback f ≅ P` via `leftAdjointUniq` and transport the monoidal structure (Step 3). The `pullbackTensorIso` is explicitly described as the three-iso composite. Stacks `lemma-tensor-product-pullback` source quote intact (verbatim, with `% SOURCE:` and visible `\textit{Source: ...}` lines). No `\leanok` (expected — prover target). `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorIso}` pin correct. This is a coherent, formalizable proof sketch. ✓
    - `lem:isinvertible_pullback`: statement unchanged; `\uses{def:scheme_modules_isinvertible, lem:pullback_tensor_iso, lem:pullback_unit_iso}` correct; Stacks `lemma-pullback-invertible` source quote present. ✓
  - `lem:pullbackObjUnitToUnit_comp` and `lem:unitToPushforwardObjUnit_comp` are correctly retained as standalone lemmas (they are real provable composition coherences, `\leanok` on both); they are no longer cross-referenced from `lem:pullback_unit_iso`, only from `lem:pullbackObjUnitToUnit_comp`'s own proof. No stale reference survives. ✓

#### blueprint/src/chapters/Cohomology_FlatBaseChange.tex
- **complete**: true
- **correct**: true
- **notes**:
  - GATE CHECK (per directive):
    - `lem:pullback_spec_tilde_iso`: new lemma present. Statement: `(Spec φ)^* M̃ ≅ (R' ⊗_R M)~` for `φ : R → R'`. `\lean{AlgebraicGeometry.pullback_spec_tilde_iso}` pin present with no `\leanok` (expected — prover target). Stacks 01I9 source quote is the verbatim two-statement excerpt from `lemma-widetilde-pullback` ("We have ψ^* M̃ = (S ⊗_R M)~ functorially..."), with `(read from references/stacks-schemes.tex, L1241--1256)` and visible `\textit{Source:}` line. `% SOURCE QUOTE PROOF:` present for the proof body. Proof sketch uses the `pushforward ⊣ pullback` adjunction and the already-proved `lem:pushforward_spec_tilde_iso` as the right-adjoint identification; the argument is coherent. ✓
    - `lem:affine_base_change_pushforward`: `\uses` now includes `lem:pullback_spec_tilde_iso`. Proof names the pullback-of-tilde dictionary (Lemma `lem:pullback_spec_tilde_iso`) and the pushforward dictionary (Lemma `lem:pushforward_spec_tilde_iso`) as the two affine dictionaries, and explicitly identifies the sole nontrivial remaining obligation as matching `pushforwardBaseChangeMap` with `TensorProduct.AlgebraTensorModule.cancelBaseChange` (lines 936–952). Both previously under-specified obligations are now named. ✓
    - `lem:gammaPushforwardIsoAt_naturality`: no such label exists anywhere in `Cohomology_FlatBaseChange.tex` or any other chapter. The naturality appears only as a prose remark (`\emph{Naturality of the family \{e_U\}_U in the open (remark)}`) inside the proof of `lem:gammaPushforwardIsoAt`. No dangling `\ref{...}` or `\uses{...}` pointing at a non-existent label. ✓

### Other chapters (compact format where clean)

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelianVarietyRigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex — complete + correct, no notes.
(Declaration blocks for `def:depth`, `lem:depth_via_ext`, `def:projective_dimension`, `lem:depth_short_exact_sequence`, `thm:auslander_buchsbaum`, and multiple supporting lemmas are all present with `\leanok` marks; chapter is a prover-ready specification.)

### blueprint/src/chapters/Albanese_CodimOneExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CoheightBridge.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.
(Pointer chapter with no new content; documents its declarations accurately.)

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes.
(Several "REF" placeholders in narrative text, not in `\uses{}`/`\lean{}` structural arguments; declaration blocks are properly pinned.)

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex — complete + correct, no notes.

### blueprint/src/chapters/Jacobian.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex — complete + correct, no notes.
(Sorry-scaffolded by design; the sorry constructors are intentional placeholders for the A.2.c engine work. The blueprint declaration blocks are complete and correctly cited.)

### blueprint/src/chapters/Picard_FlatteningStratification.tex — complete + correct, no notes.
(Several lemma blocks without `\leanok` — `lem:flat_locus_open`, `lem:nonflat_locus_proper`, `lem:noetherian_induction_strata` — but these are prover targets with complete proof sketches, not blueprint gaps.)

### blueprint/src/chapters/Picard_IdentityComponent.tex — complete + correct, no notes.
(Multiple blocks with `\leanok` for the abstract identity-component substrate and the `Pic0Scheme` declarations; the specification is complete.)

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex — complete + correct, no notes.
(`thm:pic0_tangent_space_iso` has `\leanok`; the chapter contains the full A.3.iii–vii specification.)

### blueprint/src/chapters/Picard_QuotScheme.tex — complete + correct, no notes.
(Some lemma blocks lack `\leanok` — the engine lemmas are prover targets, not blueprint gaps. The proof sketches that are present are adequate.)

### blueprint/src/chapters/Picard_RelPicFunctor.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelativeSpec.tex — complete + correct, no notes.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OCofP.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OcOfD.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RRFormula.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex — complete + correct, no notes.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `thm:rigidity_over_kbar` carries an explicit `sorry` body; no proof sketch is provided. The chapter explicitly and honestly documents this as an intentional named gap blocked on two Mathlib-absent gaps: (i) global cotangent-triviality `Ω_{A/k̄} ≅ 𝒪_A^⊕g` and (ii) `H^0(C, Ω_{C/k̄}) = 0`. The "route (a) vs route (b)" decision is open. This is pre-existing across many iterations and the plan agent has accepted it as a documented deferral.
  - The characteristic-free route via `chap:AbelianVarietyRigidity` is NOT affected: `prop:rigidity_genus0_curve_to_AV` there is the committed critical-path declaration and is `\leanok`. This chapter is the fallback route (a) artifact.
  - Severity: `must-fix-this-iter` per the strict severity rule (chapter is `partial`), but plan agent should record a one-line deferral in `iter/iter-242/plan.md` (as done in prior iterations): the named sorry is intentional and the blocking gaps (i)/(ii) are multi-hundred-LOC Mathlib builds with no current prover assignment.

## Severity summary

**HARD GATE STATUS: CLEARS** for both gate-critical chapters and their active prover lanes.

- `Picard_TensorObjSubstrate.tex`: `complete: true, correct: true` → prover dispatch for Phase 2 `pullbackTensorIso` may proceed.
- `Cohomology_FlatBaseChange.tex`: `complete: true, correct: true` → prover dispatch for `lem:pullback_spec_tilde_iso` may proceed.

**must-fix-this-iter** (1 item):
1. `RigidityKbar.tex` / `thm:rigidity_over_kbar` — named sorry, `partial` status. Pre-existing documented deferral; plan agent should record one-line deferral rationale in `iter/iter-242/plan.md`. No blueprint-writer dispatch needed (the chapter's narrative is complete; the gap is in Lean/Mathlib, not in the blueprint specification).

No `soon` or `informational` findings beyond the above. No unstarted-phase blueprint proposals (all strategy phases have adequate blueprint coverage).

**Overall verdict**: HARD GATE CLEARS — both gate-critical chapters (`Picard_TensorObjSubstrate.tex` and `Cohomology_FlatBaseChange.tex`) are `complete: true, correct: true` with no must-fix findings; prover dispatch for `pullbackTensorIso` (Phase 2) and `pullback_spec_tilde_iso` is unblocked. Single pre-existing `RigidityKbar.tex` named-sorry item requires plan-agent deferral record only.
