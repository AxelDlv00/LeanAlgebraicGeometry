# Recommendations for iter-259 (plan agent)

## CRITICAL / HIGH

### 1. Close the two shared-root consumer isos — they unblock BOTH critical-path lanes
`Picard/SheafOverEquivalence.lean` is the single highest-leverage file. With `overEquivalence` closed
axiom-clean, finishing its two remaining sorries unblocks the engine (`chartOverIso` already redirected)
AND the dual lane (`sliceDualTransport`/`dual_restrict_iso`/`exists_tensorObj_inverse`) at once. Both are
*mechanical finishes of in-file machinery*, NOT Mathlib gaps:
- **`unitOverIso` (L276, ONE leaf)** — closest to done. Construction complete, `IsIso (phiOver U)` proven,
  reflection chain done to one leaf: `IsIso` of the additive map underlying `(phiOver U).hom.app W`.
  Finish: extract `IsIso ((phiOver U).hom.app W)` from `hφ` (NatTrans component-iso) and map through
  `forget₂ RingCat AddCommGrpCat`. ~5–10 LOC. **Do this first.**
- **`restrictOverIso` (L235, full body)** — mirror of `restrictFunctorAdjCounitIso`
  (`Modules/Sheaf.lean:335`): `M.restrict U.ι` is itself a `pushforward` along `U.ι.opensFunctor`; compose
  with `pushforward φ` via `pushforwardComp (= Iso.refl)`, then `pushforwardNatIso` along the `eqToIso` of
  the two `Over U ⥤ Opens X` index functors (both `V ↦ V.left`). ~30–60 LOC.

Once both land: redirect/close `sliceDualTransport` in `DualInverse.lean` as a one-liner consumer
(localize `overEquivalence`'s `pushforward φ` functor to the presheaf `≃ₗ` at `V`), then `dual_restrict_iso`
Step-4 and `exists_tensorObj_inverse`. Verify whether the presheaf-vs-sheaf mismatch historically flagged
in `ts230-cbridge-outcome-ii` is dissolved by the new root (it is a genuine `SheafOfModules` equivalence
with a `pushforward φ` functor, unlike the old fixed-value-cat `overSliceSheafEquiv`); fallback = the
documented ~200 LOC sectionwise build.

### 2. D3′ `pullbackTensorMap_restrict` (TensorObjSubstrate.lean) was NOT worked this iter — re-dispatch
The plan listed D3′ Sq2b as objective #2, but **no edits and no task_result** were produced for
`TensorObjSubstrate.lean`. Prover capacity went to the shared root + the two held-file finishes instead.
The analogist recipe `analogies/d3sq2b258.md` (η→δ porting from the compiling `pullbackObjUnitToUnit_comp`)
is already prepared. Re-dispatch with that recipe — it is independent of the shared root and can run in
parallel with the consumer-iso lane (different file). **Watch the iter-257 race lesson: DualInverse imports
TensorObjSubstrate — keep DualInverse HELD while D3′ edits TensorObjSubstrate.**

## MEDIUM

### 3. Expand the `unitOverIso` blueprint sketch (soe258 MAJOR)
`Picard_SheafOverEquivalence.tex` gives the conceptual route for `unitOverIso` ("pushforward of unit is
unit, φ is an iso") but does NOT name the Lean API the proof actually needs:
`SheafOfModules.unitToPushforwardObjUnit`, its `_val_app_apply` sectionwise characterization, and the
`isIso_iff_of_reflects_iso` reflection chain (`forget → toPresheaf → NatTrans.isIso_iff_isIso_app`).
Dispatch a blueprint-writer to add these. (Not must-fix — the in-file planner block already names them, so
the prover is not blocked — but the chapter should match.)

### 4. Fix the stale DualInverse "WARM-CONTEXT WARNING" before the next prover reads it (auditor MAJOR)
`DualInverse.lean:287–315` (`dual_restrict_iso` outer planner strategy) still says "this is a genuine new
build, not a missing import" and points at the superseded iter-230 `overSliceSheafEquiv` C-wiring
diagnostic. Post-iter-258 the closing move is a one-liner consumer of `overEquivalence`. A prover reading
only that outer strategy (without `sliceDualTransport`'s body) would follow the wrong path. The file header
(L24–35) is correct; only the outer-strategy block is stale. This is a `.lean` comment (review cannot edit)
→ have the next plan/prover/refactor pass on `DualInverse` update it when the lane re-opens.

### 5. Cohomology blueprint structural bugs (blueprint-doctor) — separate engine lane
`Cohomology_CechHigherDirectImage.tex` `% archon:covers` a non-existent
`AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`, and has 5 broken `\ref{}` to undefined labels.
Not on this iter's critical path; fix the `covers` path (or create the file) + the cross-refs before any
prover is dispatched onto the Cohomology Čech lane.

## Reusable proof patterns discovered (also in PROJECT_STATUS Knowledge Base)
- **`↥↑U` vs `↥U` discrimination-tree fix**: state instances on the scheme-carrier form, `change`-convert
  to the subtype `↥U` before `infer_instance` (or `exact <project_instance>` by defeq).
- **`Functor.map_comp` on `forget₂`-composite functors**: `rw [← Functor.map_comp]` fails to combine
  `(X.ringCatSheaf.obj).map a ≫ … .map b`; use `erw` (X-leg first) OR peel `forget₂` via `change` then
  apply `Functor.map_comp` as a TERM. ALWAYS `.obj.map`, never `.val.map`.
- **`pushforwardPushforwardEquivalence`** is the canonical Mathlib idiom for lifting a site equivalence to
  a sheaf-of-modules equivalence; only the ring morphism `φ` is genuine content (continuity legs infer).

## Do NOT retry without a structural change
- The dual lane's ~200 LOC sectionwise `sliceDualTransport` build (subsumed by `overEquivalence`; the plan
  correctly pivoted away — do not re-prioritize it as a standalone build).
- `exists_tensorObj_inverse` (L715 TensorObjSubstrate) directly — gated on the consumer-iso chain above.
