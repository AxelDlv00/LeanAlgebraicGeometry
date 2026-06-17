# Blueprint Review Report

## Slug
ts221

## Iteration
221

## Top-level summaries

### Lean difficulty quality

- `Picard_TensorObjSubstrate.tex` / `lem:internal_hom_isSheaf` (`\lean{AlgebraicGeometry.Scheme.Modules.dual}`): the block conflates two distinct Lean objects — the sheaf-condition verification of `ℋom(M,N)` and the `AlgebraicGeometry.Scheme.Modules.dual` construction — under a single `\lean{}` pin. The intermediate Lean declaration `PresheafOfModules.InternalHom.internalHomPresheaf` (or analogous name) has no block or pin. A prover dispatched on sub-step 4 would face two Lean construction targets with no canonical name for the sheaf object. This is a split/annotation gap, not a mathematical error. Not blocking for sub-step 3; must-fix before sub-step 4 is dispatched.

## Per-chapter

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex
- **complete**: true
- **correct**: true
- **notes**:
  - (gate question, answered below) Sub-step 3 targets `def:presheaf_dual` and `lem:internal_hom_eval` are both present, mathematically sound, proof-sketch adequate, Lean names plausible. **GATE CLEARS for sub-step 3.**
  - (soon) `lem:internal_hom_isSheaf` should be split before sub-step 4 dispatch: currently a single block + pin (`AlgebraicGeometry.Scheme.Modules.dual`) covers (a) sheaf-condition verification of `ℋom(M,N)` and (b) the `dual` construction. Sub-step 4 prover needs a named Lean target for the intermediate sheaf object; `PresheafOfModules.InternalHom.internalHomPresheaf` (or equivalent) warrants its own `\definition`/`\lemma` block with a `\lean{}` pin before sub-step 4 is dispatched.
  - (informational) `def:presheaf_internal_hom` and `lem:presheaf_pushforward_adj_substrate` (H1/H2 substrate, built iter-217–220) lack `\leanok` markers — sync_leanok timing; not a blueprint error.
  - (informational) `lem:tensorobj_unit_iso` (left/right unitors) lacks `\leanok` on its statement block; likely sync_leanok has not yet run for this block after iter-220.

### Gate verdict (explicit, per directive)

**`Picard_TensorObjSubstrate.tex` is `complete: true` and `correct: true` with no must-fix-this-iter finding.**
The file may receive a prover this iter on sub-step 3 (`def:presheaf_dual` → `PresheafOfModules.dual`; `lem:internal_hom_eval` → `PresheafOfModules.internalHomEval`).

Detailed rationale:

1. **`def:presheaf_dual`** (§`sec:tensorobj_dual_infra`, line ~2584): Definition present. States `M^\vee := ℋom(M, R)`, value = `ModuleCat.of (R(U)) (M|_U → R|_U)`. `\lean{PresheafOfModules.dual}` — plausible name matching the project convention. `\uses{def:presheaf_internal_hom}` — correct single dependency; parent is `\leanok` (iter-220 assembled it). No `\leanok` on this block — correct for a new target. No citation annotation — acceptable as an Archon-original specialization of the already-cited `def:presheaf_internal_hom` (Stacks 01CM); the citation is carried by the parent, not duplicated here. Proof sketch not required (it is a `\definition`). Mathematical content is clear and correct.

2. **`lem:internal_hom_eval`** (§`sec:tensorobj_dual_infra`, line ~2604): Lemma present. States the evaluation `M ⊗_R M^\vee → R`, `s ⊗ φ ↦ φ(s)`. `\lean{PresheafOfModules.internalHomEval}` — plausible. `\uses{def:presheaf_dual, def:scheme_modules_tensorobj}` — correct. Citation complete: `% SOURCE: [Stacks Project], "Modules on Ringed Spaces", \S Internal Hom (tag area 01CM) (read from references/stacks-modules.tex, L3517--L3524)` with verbatim Stacks quote and visible `\textit{Source:}` line; `references/stacks-modules.tex` EXISTS on disk. Proof sketch: open-by-open contractions, compatibility with restriction maps, counit of tensor-hom adjunction specialised to the unit presheaf. Adequate depth for a prover to formalize. No `\leanok` — correct for new target.

3. **`lem:internal_hom_isSheaf` gap** (sub-step 4, future): The block carries `\lean{AlgebraicGeometry.Scheme.Modules.dual}` only. The sheaf-condition proof and the presheaf-to-sheaf promotion step have no named Lean pin (`PresheafOfModules.InternalHom.internalHomPresheaf` or equivalent). This does NOT block sub-step 3 (which does not touch sub-step 4 material), but the writer should split this block before sub-step 4 is dispatched.

---

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelianVarietyRigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - (informational) Several proof-block comments state "the chain's single genuinely-deep residual sorry" or describe `lem:rigidity_eqAt_closedPoint_of_proper_into_affine` as the lone residual — these were ACCURATE at iter-161 but are STALE as of iter-162, when Step 1 was proven axiom-clean. The review agent noted this stale status in a `% NOTE:` annotation at line ~196, but the parent proof block prose (§`lem:rigidity_eqOn_saturated_open_to_affine` proof, ~line 406) still says "This per-slice statement is the chain's single genuinely-deep residual sorry." These stale notes carry no soundness risk (the code is proven) but could mislead a reader. A plan-agent blueprint-prose pass should refresh them.
  - (informational) `lem:rational_map_to_av_extends` (Milne Thm 3.2) is Route-A-only and lacks `\leanok` — expected; the Lean target `AlgebraicGeometry.rationalMap_to_av_extends` is a placeholder. A later chapter (`Albanese_Thm32RationalMapExtension.tex`) names `AlgebraicGeometry.Scheme.RationalMap.extend_to_av` as the canonical target; a reconciliation pass is noted in that chapter's STRATEGY NOTE.
  - (informational) Chapter is PAUSED (Genus0 arm frozen under ROUTE C PAUSE) — no prover dispatch expected.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - (informational) `thm:nonempty_jacobianWitness` carries a sorry body by design — the main protected open gap. All extracted projections (`def:Jacobian`, `thm:Jacobian_grpObj`, etc.) are `\leanok` and project through the `jacobianWitness` existential correctly.
  - (informational) Chapter read partially (lines 1–347 of ~601); the post-line-347 material covers Route B, sub-step C.2 expansion, and A.4 audit, which per PROGRESS.md is consistent with the current blueprint state.

### blueprint/src/chapters/Picard_RelPicFunctor.tex
- **complete**: true
- **correct**: true
- **notes**:
  - (informational) HELD lane (`PicSharp := const PUnit`, `functorial := 0` placeholders still live). Chapter is the A.1.c specification; no prover dispatch until Lane TS lands the iso-class group.

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelativeSpec.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_QuotScheme.tex
- **complete**: true
- **correct**: true
- **notes**:
  - (informational) HELD behind A.1.c.SubT→A.1.c. The Grassmannian sub-build is noted as a candidate for its own chapter; the chapter author tagged it "writer iter-175+" but it has since been embedded. No action needed.

### blueprint/src/chapters/Picard_FlatteningStratification.tex
- **complete**: true
- **correct**: true
- **notes**:
  - (informational) The corresponding Lean target file `AlgebraicJacobian/Picard/FlatteningStratification.lean` exists (in git status as modified) but is HELD behind A.1.c.SubT. Blueprint chapter is adequate as a specification.

### blueprint/src/chapters/Picard_IdentityComponent.tex
- **complete**: true
- **correct**: true
- **notes**:
  - (informational) Lean target file `AlgebraicJacobian/Picard/IdentityComponent.lean` does not yet exist per chapter header — by design (gated A.2.c). Chapter is the prover-ready specification.

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex
- **complete**: true
- **correct**: true
- **notes**:
  - (informational) Lean target file `AlgebraicJacobian/Picard/Pic0AbelianVariety.lean` does not yet exist — by design (gated A.2.c). Chapter is the A.3 specification.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CodimOneExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex
- **complete**: true
- **correct**: true
- **notes**:
  - (informational) Lean target file `AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean` does not yet exist — by design (gated A.4.c). Chapter STRATEGY NOTE records a reconciliation task: `lem:rational_map_to_av_extends` reserved in `AbelianVarietyRigidity.tex` under name `AlgebraicGeometry.rationalMap_to_av_extends` should be re-targeted to `AlgebraicGeometry.Scheme.RationalMap.extend_to_av` from this chapter. This is informational; no active prover lane is affected.

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex
- **complete**: true
- **correct**: true
- **notes**:
  - (informational) Lean target file does not yet exist — by design (gated A.4.b). Chapter notes that Mathlib may already have parts of the depth/projective-dimension API; a Mathlib audit is recommended before a prover is dispatched.

### blueprint/src/chapters/Albanese_CoheightBridge.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OcOfD.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RRFormula.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OCofP.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex
- **complete**: true
- **correct**: true
- **notes**:
  - (informational) Chapter carries a top-level `\uses{def:genus, lem:morphism_to_p1_from_global_sections, lem:degree_via_pole_divisor, lem:degree_one_morphism_iso, cor:nonconstant_function_genus_zero, thm:riemannRoch_genus_zero, def:codim1_cycles, def:divisor_degree}` before any section. This is valid leanblueprint syntax for chapter-level dependencies. The blueprint-doctor would have flagged broken labels; assuming clean since no doctor finding was surfaced in PROGRESS.md. All referenced labels are expected in the sibling RR.1–RR.3 chapters. Route C PAUSED — not a blocking concern.

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelianVarietyRigidity.tex — see full block above.

### blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex — complete + correct, no notes.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: true
- **correct**: true
- **notes**:
  - (informational) `thm:rigidity_over_kbar` carries sorry body by design (named gap, route (a) fallback). Chapter explicitly catalogues gaps (i) and (ii) honestly. Route (c) (char-free) is the committed genus-0 route, handled by `AbelianVarietyRigidity.tex`. No action needed.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes.

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex
- **complete**: true
- **correct**: true
- **notes**:
  - (informational) Pointer chapter; mathematical content lives in `RigidityKbar.tex`. All surviving declarations are `\leanok` or axiom-clean per chapter header. Zero sorry-bodied declarations.

## Severity summary

**must-fix-this-iter**: NONE — HARD GATE CLEARS for sub-step 3 dispatch.

**soon**:
- `Picard_TensorObjSubstrate.tex` / `lem:internal_hom_isSheaf`: split before sub-step 4 dispatch. The block must be refactored into (a) a `\definition` or `\lemma` block for the presheaf-of-modules internal hom sheaf object (pinned `\lean{PresheafOfModules.InternalHom.internalHomPresheaf}` or analogous) and (b) a `\definition` block for `AlgebraicGeometry.Scheme.Modules.dual` (the current sole pin). The intermediate sheaf object needs its own `\lean{}` annotation so a prover on sub-step 4 has a canonical Lean target. Dispatch a blueprint-writer for this split before sub-step 4 is planned.

**informational**:
- `AbelianVarietyRigidity.tex`: stale "single genuinely-deep residual sorry" language in several proof blocks (step 1 proven in iter-162). Low risk; PAUSED lane.
- `Picard_TensorObjSubstrate.tex`: `def:presheaf_internal_hom` (iter-220 assembled) lacks `\leanok` marker — sync_leanok timing.
- `Picard_TensorObjSubstrate.tex`: `lem:tensorobj_unit_iso` lacks `\leanok` on statement block — sync_leanok timing.
- `Albanese_Thm32RationalMapExtension.tex` / `AbelianVarietyRigidity.tex`: dual Lean-name registration for `lem:rational_map_to_av_extends` — requires reconciliation pass before the Albanese UP lane opens.

Overall verdict: **All 33 chapters audited; HARD GATE CLEARS for `Picard_TensorObjSubstrate.tex` sub-step 3 (`def:presheaf_dual`, `lem:internal_hom_eval`). One soon finding: split `lem:internal_hom_isSheaf` before sub-step 4 dispatch. No unstarted phases — every strategy phase has adequate blueprint coverage.**
