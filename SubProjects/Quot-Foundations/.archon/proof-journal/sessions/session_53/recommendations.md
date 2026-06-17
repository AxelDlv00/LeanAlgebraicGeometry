# Recommendations — next plan iter (post iter-053)

## TOP (CRITICAL / HIGH — act first)

1. **[Prover, not review] Fix stale `genericFlatness` GAP-G1 comment** — `FlatteningStratification.lean:~2892-2900`. It claims G1 (`F|_W ≅ (Γ(F,W))~`) is "NOT yet available", but G1 closed axiom-clean at L2674 (`gf_qcoh_fintype_finite_sections`, iter-051). Review agent cannot edit `.lean`; route to the prover/refactor lane next iter. lean-auditor `iter053` major.

2. **GF `genericFlatness` is now a GEOMETRIC close, not algebraic — re-scope the lane accordingly.** The algebra gap (B1) is CLOSED. Remaining work is three scheme-theory pieces, all on top of the DONE `isLocalizedModule_basicOpen` + B1:
   - (a) cross-chart basic-open identity: `X.basicOpen g = X.basicOpen (res_{W→W∩W_j} g)` as the same `X.Opens` (or the `IsLocalizedModule` transport across the two charts) → assembles B2 `gf_section_localization_flat_descent` from two `isLocalizedModule_basicOpen` legs + `IsLocalizedModule.iso`;
   - (b) finite affine cover of `p⁻¹(U₀)` with `B_j` finite-type over `A` (quasi-compactness of `p`);
   - (c) covering arbitrary affine `W ≤ p⁻¹U` by basic opens `D(g) ⊆ W∩W_j` whose `g` span the unit ideal (quasi-compactness of `W`).
   Then the close rides `Module.flat_of_isLocalized_span`. **effort-break (b)/(c) into a covering sub-lemma + B2 before dispatching** — the prover flagged a single round at this geometric breadth as high churn-risk on a ~100 s/build file. Progress-critic deadline iter-055 for the close — feasible only if B2 lands next iter.

3. **GR-quot `functor` — one self-contained coherence lemma closes both law sorries.** Prove `pullbackObjUnitToUnit (𝟙 T).toRingCatSheafHom = ((pullbackId T).app unit).hom` (+ the `pullbackComp` analogue), then `pullbackFreeIso (𝟙) = (pullbackId).app (free _)` by coproduct-`ext` and both laws close term-mode (naturality already verified to apply). API: `Adjunction.homEquiv_unit` + `conjugateEquiv_pullbackId_hom` + `leftAdjointIdIso`. WARNING: `simp [pullbackId]` whnf-times-out — keep `pullbackId` opaque, navigate via the adjunction route (matches memory `quot-gap1-closed-opaque-immersion`). This is the cheapest GR win available and unblocks `functor` fully (closing a declaration sorry — GR has dropped 0 declaration-sorries for 2 iters now, watch for churn).

4. **SNAP — presheaf promotion is the make-or-break, dispatch as a dedicated lane.** Objectwise `isColimitCofork` is BUILT. Next: promote to `Cᵒᵖ⥤AddCommGrpCat` via `evaluationJointlyReflectsColimits` (build `actN`/`actM`/`projL` as natural transformations — each a naturality/restriction-compatibility proof), identify the apex with `(toPresheaf R₀).obj (P⊗_p Q)` via `PresheafOfModules.Monoidal.tensorObj_obj`, then close the crux `isIso_sheafification_whiskerRight_unit` via `(isIso_sheafification_map_iff).mpr` (`J.W` inverts the ℤ-whiskered rows: `W.monoidal` + `localIso_toPresheaf_map_unit`). Lone risk: confirm `GrothendieckTopology.W.monoidal` objectwise value is `U ↦ P(U)⊗_ℤ Q(U)`. effort-break this presheaf-promotion node first (several substeps, each its own API surface).

## MEDIUM — coverage debt (34 unmatched `lean_aux` nodes — planner must blueprint)

`archon dag-query unmatched` = 34, up from 7. Every Lean decl needs a tex entry. By file:

- **GrassmannianQuot (8 substantive + 1 private):** `Scheme.Modules.opensMap_final` (reusable: `Opens.map φ.base` Final for any scheme morphism), `…pullbackFreeIso`, `…pullback_isLocallyFreeOfRank`, `Grassmannian.RankQuotient` (+`.Rel`, `.rel_refl/symm/trans`, `rqSetoid`), `rqPullback`, `rqPullback_rel`. (`opensTopology` stays private — impl detail.) Add a `\lean{}`-anchored block per helper under the GrassmannianQuot chapter; also blueprint the `functor` law crux (`pullbackObjUnitToUnit (𝟙) = (pullbackId).app unit`) so the obstacle is visible, and note `functor : … ⥤ Type 1`.
- **SectionGradedRing (22):** all of `RelativeTensorCoequalizer.*` (headline `isColimitCofork`; supporting `actN/actM/actLmap/actRmap/projL/projL_surjective/projL_comp_act/aL/aR/piMor/piMor_epi/cofork/descHom/descMor/descFac/coeq_condition` + `_tmul`/`_apply` rfl-lemmas). Add `lem:relativeTensor_objectwise_coequalizer` (objectwise refinement) under `sec:sgr_tensor_powers`; relies on `TensorProduct.liftAddHom`, `Cofork.IsColimit.mk`, `ConcreteCategory.epi_of_surjective`. Also: the existing blueprint `\lean{}` hint names not-yet-existing `relativeTensorCoequalizerIso` (the deferred presheaf-level decl) — keep as a target node, no marker.

- **GR-quot blueprint `glue` signature gap (lvb major):** `def:scheme_modules_glue` promises restriction isos `ρ_i` as output but Lean `glue` returns only `D.glued.Modules`. Since `glue` body is still `sorry` and is Archon-original, the planner should reconcile the blueprint signature with the intended Lean output before the `glue` lane is dispatched (a `% NOTE` already records earlier C1/C2 divergences; add the `ρ_i` discrepancy).

## Blocked / do-NOT-retry without a structural change

- **FBC `_legs_conj` keystone — PARKED** (final kill-criterion hit; element-`ext` and monolithic-β dead). Off critical path; un-park when a lane frees or when GF+GR+SNAP all close.
- **GF stalk route (`SheafOfModules.stalk`)** — absent from Mathlib; do NOT retype G3.2/assembly through stalks. Source-span descent (above) is the replacement.
- **SNAP routes (b) `MonoidalClosed (PresheafOfModules R₀)` / (c) module-sheaf stalks** — both need absent infra; do NOT pursue. Only the coequalizer route is viable.
- **GF "purely-algebraic `gf_flat_locality_assembly` helper"** — verified to collapse into Mathlib's `Module.flat_of_isLocalized_span`; there is no algebraic helper left to add. Do not re-dispatch an algebraic intermediate.

## Reusable patterns (added to PROJECT_STATUS Knowledge Base)
- Source-localization preserves flatness over fixed base (`gf_flat_localizedModule_sameBase`).
- `opensMap_final` ⟹ general `f^* free ≅ free` for any scheme morphism.
- `TensorProduct.liftAddHom` as the abelian universal property → relative tensor as `AddCommGrpCat` coequalizer.
