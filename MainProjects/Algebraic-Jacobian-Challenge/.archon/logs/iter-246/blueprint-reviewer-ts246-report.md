# Blueprint Review Report

## Slug
ts246

## Iteration
246

## Top-level summaries

### Incomplete parts

- `Picard_FlatteningStratification.tex`: four helper lemmas (`lem:flat_locus_open`, `lem:nonflat_locus_proper`, `lem:noetherian_induction_strata`, `cor:flattening_stratification_curve`) have no `\lean{...}` pins; multiple internal proof references use bare `Theorem~REF` / `Lemma~REF` placeholders instead of `\cref{}`. Chapter is A.2.a (deferred — no active prover); deferral rationale required in plan.md.
- `Jacobian.tex`: main existence theorem proof block consists entirely of strategy-routing notes pointing to Routes A/B/C rather than a proof sketch. Adequate as a routing document; not adequate as a formalization blueprint. Gated behind all routes — deferral rationale required.
- `Albanese_CodimOneExtension.tex`: Stage 2 (depth-≥2 extension, Stacks 00TT regularity gap) is documented as a typed sorry in the Lean body; the blueprint proof sketch for Stage 2 explicitly defers to a Mathlib-absent substrate. Chapter is HELD (gated A.2.c); deferral rationale required.

### Proofs lacking detail
*(none — all proof blocks in active-lane chapters are adequate for provers)*

### Lean difficulty quality
*(none — all `\lean{...}` hints in active-lane chapters name correctly-typed targets)*

### Citation discipline
*(no hard failures — all `% SOURCE:` lines in newly edited blocks carry `(read from references/...)` parentheticals and `\textit{Source:}` visible lines)*

---

## Hard-Gate Clearance Verdicts — Focus Chapters

### Chapter 1 — `Picard_TensorObjSubstrate.tex` (feeds `Picard/TensorObjSubstrate.lean`)

**Verdict: HARD GATE CLEARS — complete + correct, no must-fix.**

**What changed this iter:** The writer added one new lemma block:

```
\label{lem:isiso_pullbacktensormap_of_sheafifydelta}
\lean{AlgebraicGeometry.Scheme.Modules.isIso_pullbackTensorMap_of_isIso_sheafifyDelta}
\uses{lem:pullback_tensor_map}
```

This brick reduces iso-ness of `pullbackTensorMap` to iso-ness of the sheafified presheaf-level δ: `IsIso (a_Y.map (δ (pullback φ') M.val N.val))`. The `\uses{lem:pullback_tensor_map}` reference is valid (that label exists in the chapter). No `\leanok` on the new block is correct — it was added in the blueprint-writer pass this iter, before this prover cycle's `sync_leanok` run.

**D2' (`lem:pullback_tensor_iso_unit`) revised proof sketch** now reads: apply `lem:isiso_pullbacktensormap_of_sheafifydelta` first (reducing to the sheafified presheaf δ on the unit pair), then invoke `Functor.OplaxMonoidal.left_unitality_hom` to express δ(1,1) through unitors + `η(pullback φ')`, show the unitors are isos, and invoke `pullbackUnitIso` (an iso for all f, proven) to get `IsIso(a_Y.map(η))`. All three `\uses{lem:pullback_tensor_map, lem:pullback_unit_iso, lem:isiso_pullbacktensormap_of_sheafifydelta}` references are valid.

**Prover target this iter** is D2' (`IsIso (a_Y.map (η (pullback φ')))`) — the η-bridge — then D3'/D4'/`IsInvertible.pullback` as far as reachable. The proof route is fully specified.

**Cross-references verified (D1'–D4' chain):**
- `lem:pullback_tensor_map_natural` (D1') — exists in chapter ✓
- `lem:pullback_tensor_iso_unit` (D2') — exists in chapter ✓
- `lem:pullback_tensor_map_basechange` (D3') — exists in chapter ✓
- `lem:pullback_tensor_iso_loctriv` (D4') — exists in chapter (the prover target) ✓
- `lem:isiso_of_isiso_restrict` — exists in chapter ✓
- `lem:tensorobj_preserves_locally_trivial`, `lem:IsLocallyTrivial_pullback`, `lem:pullback_unit_iso` — all exist ✓

The demotion of the abandoned general build (`lem:pullback0_tensor_iso`, `lem:pullback_tensor_iso` general, `lem:pullback_lan_decomposition`) remains coherent: no live `\uses{}` edge points at those demoted blocks from the D1'–D4' chain.

---

### Chapter 2 — `Picard_RelPicFunctor.tex` (feeds `Picard/RelPicFunctor.lean`)

**Verdict: HARD GATE CLEARS — complete + correct, no must-fix. RPF prover dispatch approved.**

**Four-step `addCommGroup` proof sketch assessment:**

*Step 1 (AddCommGroup on carrier):* Constructs the group on isomorphism classes of `OnProduct` via tensor product. Uses `lem:tensorobj_lift_onproduct` (closure under ⊗), `lem:tensorobj_preserves_locally_trivial` (product stays loc-triv), `lem:tensorobj_assoc_iso`/`lem:tensorobj_comm_iso`/`lem:tensorobj_unit_iso` (axioms from TensorObjSubstrate), `lem:tensorobj_isoclass_commgroup` (`picCommGroup`), `lem:tensorobj_inverse_invertible` (`exists_tensorObj_inverse`, returns a loc-triv witness keeping the group closed). All labels verified in `Picard_TensorObjSubstrate.tex`. **Sound and detailed enough.** ✓

*Step 2 (π_T* as group homomorphism):* Uses `lem:pullback_unit_iso` for map_zero (proven), and `lem:pullback_tensor_iso_loctriv` (D4', currently `exact sorry` in Lean, the concurrently-built A.1.c.sub target) for map_add. The proof block explicitly labels these as "deferred targets authored in parallel" — the typed-sorry bridge strategy is correctly documented. **Sound and adequately detailed for bridge-authoring.** ✓

*Step 3 (setoid reconciliation):* States that the set-valued quotient relation of `thm:relative_pic_quotient_well_defined` coincides with the left-coset relation of `im(π_T*)`: both encode `L ~ L' ↔ [L^inv ⊗ L'] ∈ H_T`. The characterization is concrete and uses only the tensor inverse (Step 1) and group law — does NOT need the comparison iso. **Mathematically sound; the equivalence of the two presentations of the quotient is a correct and standard argument.** ✓

*Step 4 (transport via `Equiv.addCommGroup`):* Standard — quotient set is in canonical bijection with the group quotient, transport the group structure. **Correct and standard.** ✓

**All `\uses{}` cross-references in the proof block verified:**
- `def:line_bundle_on_product`, `def:pullback_along_projection`, `thm:relative_pic_quotient_well_defined` — in `Picard_LineBundlePullback.tex` ✓
- `lem:tensorobj_lift_onproduct`, `lem:tensorobj_preserves_locally_trivial`, `lem:tensorobj_assoc_iso`, `lem:tensorobj_comm_iso`, `lem:tensorobj_unit_iso`, `lem:tensorobj_isoclass_commgroup`, `lem:tensorobj_inverse_invertible`, `lem:pullback_unit_iso`, `lem:pullback_tensor_iso_loctriv` — all in `Picard_TensorObjSubstrate.tex` ✓

**Stale-gate contradiction check:** The iter-198 "Gate annotation" paragraph was correctly stripped (not present in the chapter). The residual iter-199 `% NOTE` comments (in proof blocks of `def:rel_pic_sharp`, `lem:rel_pic_sharp_functorial`, `thm:rel_pic_sharp_presheaf`, `def:rel_pic_etale_sheafification`, `thm:rel_pic_etale_sheaf_group_structure`) reference the monoidal-structure gap and say "DO NOT promote to `\leanok`... until the body is replaced with the mathematically correct construction." These are `%`-comment documentation artifacts; they describe the historical Lean body state (placeholder bodies at pinned commit b80f227), not the mathematical content. They **do not contradict** the current four-step proof sketch. They are informational stale notes, not mathematical errors. The mathematical content of the proof sketch is sound.

**Gate decision summary:** The `addCommGroup` construction is complete, correct, and detailed enough. The typed-sorry bridges for `lem:pullback_tensor_iso_loctriv` and `lem:tensorobj_inverse_invertible` are correctly documented. The setoid reconciliation (Step 3) is sound. No must-fix. **Dispatch the RPF prover this iter.**

---

## Per-chapter

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex
- **complete**: true
- **correct**: true
- **notes**:
  - New `lem:isiso_pullbacktensormap_of_sheafifydelta` properly integrated; no `\leanok` expected pre-`sync_leanok` *(informational)*
  - Stale Route-C aside prose (prior "soon" finding, ts245) — non-blocking structural cleanup *(informational, carry-forward)*

### blueprint/src/chapters/Picard_RelPicFunctor.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Residual iter-199 `% NOTE` comments in proof blocks reference now-addressed monoidal-structure gap; these are `%`-comment artifacts, not mathematical errors — should be cleaned in a future blueprint-writer pass *(informational)*
  - `def:rel_pic_sharp`, `lem:rel_pic_sharp_functorial`, `thm:rel_pic_sharp_presheaf`, `def:rel_pic_etale_sheafification`, `thm:rel_pic_etale_sheaf_group_structure` all carry `\leanok` on statement blocks with NOTE warnings about incorrect Lean bodies — this is the correct pre-formalization state (statement formalized, proof body is sorry/placeholder) *(informational)*

### blueprint/src/chapters/Picard_FlatteningStratification.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Missing `\lean{...}` pins on `lem:flat_locus_open`, `lem:nonflat_locus_proper`, `lem:noetherian_induction_strata`, `cor:flattening_stratification_curve`
  - Several internal proof references use `Theorem~REF` / `Lemma~REF` placeholders instead of `\cref{}`
  - Chapter is A.2.a (deferred, HELD behind A.1.c) — plan agent should record deferral rationale rather than dispatching a writer now

### blueprint/src/chapters/Jacobian.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Main existence theorem proof block defers to Routes A/B/C with routing notes and LOC estimates rather than a proof sketch; adequate as a routing document, insufficient as a formalization blueprint
  - Gated behind all active routes — plan agent should record deferral rationale

### blueprint/src/chapters/Albanese_CodimOneExtension.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Stage 2 (depth-≥2 extension, Stacks 00TT regularity) documented as typed sorry; blueprint proof references a Mathlib-absent substrate but correctly characterizes the gap
  - Chapter is HELD (gated A.2.c) — plan agent should record deferral rationale

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - Five declaration blocks carry `\leanok` on statement entries, but per iter-192 plan notes the Lean file (`IdentityComponent.lean`) did not yet exist at blueprint-writing time. The `\leanok` markers indicate types are formalized, but if no corresponding Lean declarations exist the markers are incorrect.
  - A.3 is gated on A.2.c (HELD) — plan agent should record deferral rationale and note this for the lean-auditor when A.3 activates

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelativeSpec.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_QuotScheme.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_IdentityComponent.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_FlatBaseChange.tex — complete + correct, no notes. (Two named Mathlib gaps — `lem:base_change_map_affine_local` and `lem:pushforward_base_change_mate_cancelBaseChange` — are correctly documented as the sole remaining obligations; lane is HELD.)

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes. (Two producer instances documented as conditional — correct for deferred cohomology lane.)

### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes. (Genus delivery conditional on producer instances from StructureSheafModuleK — correct.)

### blueprint/src/chapters/AbelianVarietyRigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/RigidityKbar.tex — complete + correct, no notes.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes. (M5–M8 milestones deferred — correct, not needed for current objective.)

### blueprint/src/chapters/Albanese_AlbaneseUP.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CoheightBridge.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex — complete + correct, no notes. (Single-theorem bridge chapter; thin by design.)

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex — complete + correct, no notes. (ROUTE C PAUSE — content is adequate for the paused state.)

### blueprint/src/chapters/RiemannRoch_RRFormula.tex — complete + correct, no notes. (ROUTE C PAUSE.)

### blueprint/src/chapters/RiemannRoch_OCofP.tex — complete + correct, no notes. (ROUTE C PAUSE.)

### blueprint/src/chapters/RiemannRoch_OcOfD.tex — complete + correct, no notes. (ROUTE C PAUSE — four typed sorries expected for paused prover lane.)

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex — complete + correct, no notes. (ROUTE C PAUSE.)

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex — complete + correct, no notes. (ROUTE C PAUSE — one typed sorry for `lem:isFlasque_injective` awaiting Mathlib j_! functor, correctly documented.)

---

## Cross-chapter notes

- `Picard_RelPicFunctor.tex` proof of `lem:rel_pic_sharp_groupoid` now `\uses{lem:pullback_tensor_iso_loctriv}` (the D4' target being built in `Picard_TensorObjSubstrate.tex`). The PROGRESS.md standing deferral note "add the `\uses{lem:pullback_tensor_iso_loctriv}` edge to `lem:rel_pic_sharp_groupoid`" is now resolved — the edge exists in the chapter.

- `Picard_Pic0AbelianVariety.tex` has declarations with `\leanok` that overlap with those in `Picard_IdentityComponent.tex`. Both chapters address Pic0/identity-component material. Once the Lean file lands, the two chapters should be reconciled to avoid pin conflicts (informational).

---

## Severity summary

**Must-fix-this-iter** (4 findings — all in DEFERRED/HELD lanes; plan agent should record deferral rationale in plan.md for each, not dispatch writers):

1. `unstarted-completeness`: `Picard_FlatteningStratification.tex` — missing `\lean{}` pins and `Theorem~REF` placeholders on sub-lemmas. A.2.a deferred — record deferral rationale.
2. `unstarted-completeness`: `Jacobian.tex` — main existence theorem proof block lacks a proof sketch (routing notes only). Gated behind all routes — record deferral rationale.
3. `unstarted-completeness`: `Albanese_CodimOneExtension.tex` — Stage 2 Stacks 00TT gap leaves the depth-≥2 extension proof incomplete in the blueprint. HELD (gated A.2.c) — record deferral rationale.
4. `correctness`: `Picard_Pic0AbelianVariety.tex` — `\leanok` markers on statements without a Lean file. A.3 gated on A.2.c (HELD) — record deferral rationale and flag for lean-auditor when A.3 activates.

**Soon:**

- `Picard_RelPicFunctor.tex`: Residual iter-199 `% NOTE` comments referencing the now-superseded monoidal-structure gate should be cleaned in the next RPF blueprint-writer pass after `addCommGroup` is authored.
- `Picard_Pic0AbelianVariety.tex`: Lean skeleton owed once A.3 de-gates.

**Informational:**

- `Picard_TensorObjSubstrate.tex`: new `lem:isiso_pullbacktensormap_of_sheafifydelta` lacks `\leanok` (pre-sync_leanok — expected). Stale Route-C aside prose (carry-forward from ts245).
- Strategy-level: `exists_tensorObj_inverse` (`lem:tensorobj_inverse_invertible`) is consumed by both the TensorObjSubstrate group law and the RPF `addCommGroup` — the chapter-cross interaction is correctly documented in both chapters.

**Overall verdict:** HARD GATE CLEARS for both prover-bound chapters — `Picard_TensorObjSubstrate.tex` remains complete+correct (new brick cleanly integrated, D2' proof route actionable) and `Picard_RelPicFunctor.tex` is now complete+correct with a sound four-step `addCommGroup` sketch (gates clear, RPF prover dispatch approved this iter); 4 must-fix findings from partial chapters in DEFERRED/HELD lanes (plan agent should record deferral rationale for each, not dispatch blueprint writers); 0 unstarted-phase proposals (all 35 strategy-phase chapters have adequate blueprint coverage at current scope); 35 chapters audited.
