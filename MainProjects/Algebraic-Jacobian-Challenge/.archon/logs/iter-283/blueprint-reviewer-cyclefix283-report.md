# Blueprint Review Report

## Slug
cyclefix283

## Iteration
283

## Top-level summaries

### Dependency & isolation findings

**Isolated nodes — all `lean_aux`, all pre-known:**
- All 54 isolated nodes are `lean_aux` type (no chapter, no blueprint entry). They are internal prover-lane helpers in `TensorObjSubstrate.lean` (18), `DualInverse.lean` (13), and sibling files, below blueprint granularity. Deferred per standing policy. **Disposition: keep** (all are intentionally uncovered Lean helpers; 2 carry ∞-effort sorry targets `sheafificationCompPullback_comp_tail` and `sliceDualTransportInv`).

**`unmatched_lean` (44 entries) — all pre-existing:**
- `AlgebraicGeometry.TODO.*` stubs (24 entries): intentional future-work stubs. **Disposition: keep / soon.**
- `lem:push_pull_functor` → `AlgebraicGeometry.pushPullMap_comp` (`Cohomology_CechHigherDirectImage.tex` L338–352): The block carries two `\lean{}` pins (`pushPullMap_id` + `pushPullMap_comp`); leandag resolves to the second, which doesn't yet exist (documented iter-264 NOTE inside the chapter). Pre-existing; no action required this iter.
- `lem:hom_Ga_to_av_trivial` / `lem:hom_from_Ga_trivial`: name-drift stubs in `AbelianVarietyRigidity.tex`. Pre-existing.
- Remaining stubs with non-TODO real names (e.g. `lem:pullback_tensor_iso`, `lem:isinvertible_implies_locallytrivial`, etc.): pre-existing declarations with sorries in Lean; not introduced this iter.

All 0 `unknown_uses` (broken `\uses{}` edges). The DAG is acyclic: `leanblueprint web` exits 0, `leandag build` reports 878 blueprint nodes, 1484 edges, 0 conflicts, 0 unknown_uses.

### Rendering integrity (blueprint-doctor)

127 `malformed_refs` found, distribution:
- `AbelJacobi.tex`: 2 (`literal-ref`) — **mathematician-protected; not in scope**
- `Jacobian.tex`: 9 (`literal-ref`) — **mathematician-protected; not in scope**
- `RiemannRoch_OcOfD.tex`: 51 (`literal-ref`) — **Route-C permanently paused; not in scope**
- `RiemannRoch_RRFormula.tex`: 43 (`literal-ref`) — **Route-C permanently paused; not in scope**
- `RiemannRoch_OCofP.tex`: 8 (`math-delim`) — **Route-C permanently paused; not in scope**
- `RiemannRoch_RationalCurveIso.tex`: 8 (`math-delim`) — **Route-C permanently paused; not in scope**
- `RiemannRoch_WeilDivisor.tex`: 6 (`math-delim`) — **Route-C permanently paused; not in scope**

Zero malformed_refs in any active or non-protected chapter. Zero broken_refs, zero orphan chapters, zero covers_problems, zero new axiom_decls.

## Focus-area verdict: six iter-283 `\uses` corrections

All six corrections are **accurate and complete**: no genuine edge was wrongly removed, and no missing edge was overlooked. Evidence per correction:

**1. `Albanese_AuslanderBuchsbaum.tex` — `lem:auslander_buchsbaum_formula_succ_pd` statement `\uses`.**
- Before: `{lem:depth_drops_by_one, lem:enat_ab_inductive_combine, thm:auslander_buchsbaum}`.
- After: `{lem:depth_drops_by_one, lem:enat_ab_inductive_combine}`.
- Correct: `thm:auslander_buchsbaum`'s proof block already contains `\uses{..., lem:auslander_buchsbaum_formula_succ_pd, ...}` (thm → lem). The inductive-step lemma takes the AB formula for pd ≤ k as a hypothesis in the statement, not as a downstream consumer. The removed edge was the back-edge of a 2-cycle.
- Remaining edges accurate: `lem:depth_drops_by_one` is explicitly named as a structural ingredient; `lem:enat_ab_inductive_combine` packages the arithmetic step.

**2. `Picard_FGAPicRepresentability.tex` — `def:pic_scheme` statement `\uses` reduced to `{def:has_pic_scheme}`.**
- Before: `{def:has_pic_scheme, thm:pic_is_group_scheme, thm:fga_pic_representability}`.
- After: `{def:has_pic_scheme}`.
- Correct: Lean implementation is `PicScheme := (HasPicScheme.has_pic_scheme C).choose` (L223); it depends only on `HasPicScheme`. The group structure and representability are built ON TOP of `PicScheme`, not prior to it. Both removed edges were back-edges of cycles.
- The `Lean encoding` section prose correctly states the same: "so `def:pic_scheme` depends only on `def:has_pic_scheme`, not on `thm:fga_pic_representability` or `thm:pic_is_group_scheme`."

**3. `Picard_RelativeSpec.tex` — `thm:relative_spec_univ` statement `\uses` removed `thm:relative_spec_base_change`.**
- Before: `{thm:relative_spec_exists, thm:relative_spec_affine_base, def:relspec_structure_morphism, thm:relative_spec_base_change}`.
- After: `{thm:relative_spec_exists, thm:relative_spec_affine_base, def:relspec_structure_morphism}`.
- Correct: `thm:relative_spec_base_change` has `\uses{thm:relative_spec_univ, ...}` (base_change → univ). The universal property is proved by affine-gluing (`relativeGluingData`), never invoking base change. The removed edge was a cycle-closing back-edge.

**4. `Picard_QuotScheme.tex` — `def:pullback_app_isoTensor_sigma` `\uses` replaced `def:quot_pullback_app_isoTensor` with `def:quot_pullback_app_isoTensor_baseMap`.**
- Before: `{def:quot_pullback_app_isoTensor, def:quot_canonical_basechange_map, lem:pullback_tildeIso, lem:tildeIso_of_isQuasicoherent_isAffineOpen, lem:pullback_of_openImmersion_iso_restrict, lem:pushforward_isQuasicoherent}`.
- After: `{def:quot_pullback_app_isoTensor_baseMap, def:quot_canonical_basechange_map, ...}`.
- Correct: Lean file QuotScheme.lean L867 builds the Σ-pair from `tildeIso_of_isQuasicoherent_isAffineOpen`/`pullback_tildeIso` and references `pullback_app_isoTensor_baseMap` (the lower-level base map), not the high-level final iso. The high-level iso is built FROM this Σ-pair through `thm:quot_pullback_app_isoTensor_baseMap_isBaseChange`, confirming the cycle direction.

**5. `Picard_SheafOverEquivalence.tex` — `def:over_equiv_inverse_is_continuous` dropped all `\uses`.**
- Before: `\uses{def:sheafofmodules_over_equivalence}`.
- After: no `\uses` annotation.
- Correct: The inverse-leg continuity is proved by `infer_instance` from the `IsDenseSubsite ⇒ IsContinuous` priority instance on the site equivalence's inverse leg (Lean body is one line). It does not reference the sheaf-of-modules `overEquivalence`; rather, the `overEquivalence` is built FROM this continuity as a prerequisite. The removed edge reversed the dependency direction.
- The empty-annotation form is correct (no `\uses{}` placeholder, which would itself be malformed per the NOTE).

**6. `Cohomology_CechHigherDirectImage.tex` — `lem:push_pull_functor` statement `\uses` removed `def:cech_nerve`.**
- Before: `{def:push_pull_obj, def:push_pull_map, lem:push_pull_unit_mate, lem:push_pull_transport_cancel, def:cech_nerve}`.
- After: `{def:push_pull_obj, def:push_pull_map, lem:push_pull_unit_mate, lem:push_pull_transport_cancel}`.
- Correct: `def:cech_nerve` has `\uses{def:cover_cech_nerve, lem:push_pull_functor}` (cech_nerve uses push_pull_functor). The functor laws `pushPullMap_id`/`pushPullMap_comp` (Lean L216/278) depend only on push-pull objects/maps and mate lemmas; `CechNerve` is not in their signatures. The removed edge was the back-edge of a cech_nerve ↔ push_pull_functor cycle.

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 2 `literal-ref` malformed_refs — **mathematician-protected; out of scope**

### blueprint/src/chapters/AbelianVarietyRigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex
- **complete**: true
- **correct**: true
- **notes**:
  - iter-283 correction verified: `lem:auslander_buchsbaum_formula_succ_pd` statement `\uses` is accurate and complete post-correction.

### blueprint/src/chapters/Albanese_CodimOneExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CoheightBridge.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
- **complete**: true
- **correct**: true
- **notes**:
  - iter-283 correction verified: `lem:push_pull_functor` statement `\uses` is accurate and complete post-correction.
  - Pre-existing soon item: `lem:push_pull_functor` carries two `\lean{}` pins (`pushPullMap_id` exists; `pushPullMap_comp` is a sorry stub). leandag reports `unmatched_lean` for `pushPullMap_comp`. The iter-264 NOTE inside the chapter documents this. No new action required.

### blueprint/src/chapters/Cohomology_FlatBaseChange.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex — complete + correct, no notes.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 9 `literal-ref` malformed_refs — **mathematician-protected; out of scope**

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex
- **complete**: true
- **correct**: true
- **notes**:
  - iter-283 correction verified: `def:pic_scheme` statement `\uses{def:has_pic_scheme}` is accurate and complete post-correction. The prose at L553–558 correctly explains the definitional order.

### blueprint/src/chapters/Picard_FlatteningStratification.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_IdentityComponent.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundleCoherence.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_QuotScheme.tex
- **complete**: true
- **correct**: true
- **notes**:
  - iter-283 correction verified: `def:pullback_app_isoTensor_sigma` `\uses` is accurate and complete post-correction; references `def:quot_pullback_app_isoTensor_baseMap` as the actual Lean-side dependency.

### blueprint/src/chapters/Picard_RelPicFunctor.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelativeSpec.tex
- **complete**: true
- **correct**: true
- **notes**:
  - iter-283 correction verified: `thm:relative_spec_univ` statement `\uses` is accurate and complete post-correction. `thm:relative_spec_base_change` at L368 confirms `\uses{thm:relative_spec_univ, ...}`, verifying the direction.

### blueprint/src/chapters/Picard_SheafOverEquivalence.tex
- **complete**: true
- **correct**: true
- **notes**:
  - iter-283 correction verified: `def:over_equiv_inverse_is_continuous` has no `\uses` annotation (correct; continuity is a Mathlib inference, not a blueprint-level dependency). Empty-annotation form is not used (the annotation is absent entirely, not `\uses{}`).

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OCofP.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 8 `math-delim` malformed_refs — **Route-C permanently paused; out of scope**

### blueprint/src/chapters/RiemannRoch_OcOfD.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 51 `literal-ref` malformed_refs — **Route-C permanently paused; out of scope**

### blueprint/src/chapters/RiemannRoch_RRFormula.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 43 `literal-ref` malformed_refs — **Route-C permanently paused; out of scope**

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 8 `math-delim` malformed_refs — **Route-C permanently paused; out of scope**

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 6 `math-delim` malformed_refs — **Route-C permanently paused; out of scope**

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/RigidityKbar.tex — complete + correct, no notes.

## Severity summary

Severity summary: HARD GATE CLEARS — no findings.

All 38 chapters: `complete: true`, `correct: true`. Zero `unknown_uses`, zero broken_refs, zero orphan chapters, zero new axiom_decls. The 127 `malformed_refs` are all in mathematician-protected or Route-C-paused chapters (out of scope per directive). The 54 isolated nodes are all `lean_aux` (pre-known, deferred). The single pre-existing `unmatched_lean` for `lem:push_pull_functor` / `pushPullMap_comp` (iter-264 documented) is informational only and does not gate any active prover route.

**Overall verdict**: All six iter-283 `\uses` corrections are verified accurate and complete — no genuine dependency edge was wrongly removed and the corrected sets contain no missing edges. The dependency graph is acyclic (`leanblueprint web` EXIT 0, `leandag build` 0 conflicts / 0 unknown_uses). No unstarted strategy phases lack blueprint coverage. 38 chapters audited, 0 must-fix findings, 0 unstarted-phase proposals.
